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


// ******************************************************************************************************************************** 
//   File name: altera_emr_unloader.v
// 
//   This module is used to interface to the EMR atom, shifting the serial data
//   out of the EMR user register.  When the shifting is complete, the data is
//   available on the emr output, and the emr_valid output is toggled.  
//   If a new error is reported by the EDC before the previous error has
//   been loaded into shift register, the EMR_error output will be asserted
//   as an indication of lost EMR data. 
//   	
//   Mechanism to read out the content of user update register:
//    1. Drive the SHIFTnLD signal low.
//    2. Wait at least two EDCLK cycles.
//    3. Clock CLK for one rising edge to load the contents of the user update register to the user shift register.
//    4. Drive the SHIFTnLD signal high.
//    5. Clock CLK 2 cycles to read out information of the status of column check bits update and the reserved bit.
//    6. Clock CLK 50 cycles more to read out information of the Horizontal error correction.
//    7. Clock CLK 26 cycles more to read out information of the Vertical error correction.
//
//   This module includes two sources & probes instances:
//    1. "EMR" probes the current contents of the unloaded EMR data, and allows it to be overwritten.
//    2. "CRCE" probes the crcerror output from the EMR block, and allows an error to be injected.
//   

// Circuitry full cycle time table
`include "emr_unloader_define.iv"

module altera_emr_unloader (
	clk,
	reset,
	emr_read,
	emr,
	emr_valid,
	emr_error,
	crcerror_pin,
	crcerror_core,
	crcerror_endoffullchip
);
    parameter device_family             = "Arria 10";
    parameter enable_virtual_jtag       = 0;
    parameter emr_reg_width             = 7'd119;           
    parameter error_clock_divisor       = 2;
    parameter error_delay_cycles        = 0;
    parameter clock_from_int_oscillator = 0;
    parameter clock_frequency           = 100;
    parameter clock_cp_frequency        = 0;                

    parameter INTENDED_DEVICE   = `EMR_UNLOADER_DEVICE;
    parameter INTOSC_FREQUENCY  = `AEU_INTOSC_FREQUENCY;    
    
    input clk;
    input reset;
    input emr_read;
	
    output [emr_reg_width-1:0] emr;
    output emr_valid;
    output emr_error;
    output crcerror_core;
    output crcerror_pin;
    output crcerror_endoffullchip;

    localparam EMR_ACT_WIDTH = 7'd78;
    
    localparam clk_diff = (clock_frequency%INTOSC_FREQUENCY == 0) ? (clock_frequency/INTOSC_FREQUENCY) : ((clock_frequency/INTOSC_FREQUENCY)+1);
    localparam freq_const = clock_from_int_oscillator ? (error_clock_divisor) : (error_clock_divisor*clk_diff);
    
    // Delay to wait for a least two EDCLK cycles for Shift Register load
    localparam SHIFTNLD_DELAY = (2*freq_const) + 4;
    
    // Number of ED circuitry cycles to read back erroneous frame and calculate EDCRC for HEC 
    localparam error_location_cycles = get_hec_cycles(1'b0);
    
    // Delay to wait for a second raising edge in case of the correctable error is
    // correctable_timeout + frame_number EDCLK cycles. If second pulse has not detected 
    // during this time then it was a fake error that can be safely ignored. 
    localparam correctable_timeout = (error_location_cycles*freq_const) + 4;
    
    // It takes (SHIFTNLD_DELAY+EMR_ACT_WIDTH)*2 clock cycles to upload EMR to get frame number
    localparam correctable_timeout_adjusted = correctable_timeout - 2*(SHIFTNLD_DELAY+EMR_ACT_WIDTH) + 2;

    // Location of Vertical Error Correction frame info in EMR 
    localparam vec_frame_loc = 7'd62;
    localparam vec_frame_width = 7'd16;
  
    localparam OPREG_DELAY = 11'd712;

    reg [4:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
    reg [4:0] next_state;
    localparam STATE_INIT                   = 5'h10;
    localparam STATE_SET_OP_COUNT           = 5'h11;
    localparam STATE_SHIFT_LAST_FRAME       = 5'h12;
    localparam STATE_STORE_CHKBIT_FRAME     = 5'h13;
    localparam STATE_ERROR                  = 5'h1F;
    localparam STATE_WAIT                   = 5'h00;
    localparam STATE_SET_LOAD               = 5'h01;
    localparam STATE_WAIT_LOAD              = 5'h02;
    localparam STATE_LOAD                   = 5'h03;
    localparam STATE_SHIFTSTART             = 5'h04;
    localparam STATE_CLOCKLOW               = 5'h05;
    localparam STATE_CLOCKHIGH              = 5'h06;
    localparam STATE_PRE_CHK_EMR            = 5'h07;
    localparam STATE_CHK_EMR                = 5'h08;
    localparam STATE_WAIT_HEC_SET           = 5'h09;
    localparam STATE_WAIT_HEC_POS           = 5'h0A;
    localparam STATE_WAIT_HEC_NEG           = 5'h0B;
    localparam STATE_PRE_UPDATE             = 5'h0C;
    localparam STATE_STORE_PREV             = 5'h0D;
    localparam STATE_REPORT_UPDATE          = 5'h0E;
    localparam STATE_VALID                  = 5'h0F;

    reg     [EMR_ACT_WIDTH-1:0] emr_reg         /* synthesis keep */;
    reg     [EMR_ACT_WIDTH-1:0] emr_updt_reg;
    reg     [EMR_ACT_WIDTH-1:0] emr_prev_reg;
    wire    [EMR_ACT_WIDTH-1:0] emr_reg_source;
    
    wire [vec_frame_width-1:0] vec_frame;
    
    reg [15:0] col_check_bit_frame;
    reg complete_read;
    reg counter_enable;
    reg counter_set;
    reg [31:0] counter_value;
    reg crcerror_first;
    reg crcerror_first_clear;
    reg crcerror_first_set;
    reg crcerror_pos_latch;
    reg crcerror_pos_latch_clear;
    reg crcerror_sync = 0;
    reg crcerror_sync1 = 0;
    reg [3:0] crcerror_val;
    reg emr_clk;
    reg error_reg;
    reg inject_error_reg;
    reg op_shiftnld;
    reg pending_read;
    reg pending_read_clear;
    reg [15:0] reset_reg = 16'hFFFF /* synthesis keep */;
    reg shiftnld;
    reg single_pulse;
    reg valid_reg;
 
    wire counter_done;
    wire [31:0] counter_q;
    wire crcerror_pos_pulse;
    wire crcerror_pulse;
    wire crcerror_wire;
    wire emrread_pulse;
    wire hec_wait_done;
    wire inject_error;
    wire is_crcerror;
    wire op_regout;
    wire read_request;
    wire regout;
    wire reset_wire;
    wire [25:0] wait_cycle;
    
    twentynm_crcblock emr_atom (
        .clk(emr_clk),
        .shiftnld(shiftnld),
        .regout(regout),
        .crcerror(crcerror_wire),
        .endofedfullchip(crcerror_endoffullchip));
	defparam
		emr_atom.error_delay        = error_delay_cycles,
		emr_atom.oscillator_divider = error_clock_divisor;
    
    twentynm_opregblock opreg_atom (
        .clk(clk),
        .shiftnld(op_shiftnld),
        .regout(op_regout));

    generate
		if (enable_virtual_jtag) begin: emr_enable_virtual_jtag
			emr_source_probe #(.width(EMR_ACT_WIDTH),.instance_id("EMR")) emr_probe (.probe(emr_reg), .source(emr_reg_source));
			emr_source_probe #(.width(1),.instance_id("CRCE")) crc_error_probe (.probe(is_crcerror), .source(inject_error));
		end
		else begin
			assign emr_reg_source = {EMR_ACT_WIDTH{1'bX}};
			assign inject_error = 1'b0;
		end
	endgenerate

    always @(current_state or counter_done or crcerror_pulse or emrread_pulse or emr_error or crcerror_pos_latch or 
                hec_wait_done or crcerror_first or crcerror_val or emr_updt_reg or col_check_bit_frame)
        begin
            crcerror_first_clear        = 1'b0;
            crcerror_first_set          = 1'b0;
            crcerror_pos_latch_clear    = 1'b0;
            complete_read               = 1'b0;
            counter_enable              = 1'b0;
            counter_set                 = 1'b0;
            emr_clk                     = 1'b0;
            pending_read_clear          = 1'b0;
            shiftnld                    = 1'b1;
            valid_reg                   = 1'b0;
            next_state                  = current_state;
            
            case(current_state)
                STATE_INIT:
                begin
                    next_state = STATE_SET_OP_COUNT;
                end
                
                STATE_SET_OP_COUNT:
                begin
                    counter_set = 1'b1;
                    next_state = STATE_SHIFT_LAST_FRAME;
                end
                
                STATE_SHIFT_LAST_FRAME:
                begin
                    counter_enable = 1'b1;
                    if (counter_done)
                        next_state = STATE_STORE_CHKBIT_FRAME;
                end
                
                STATE_STORE_CHKBIT_FRAME:
                    next_state = STATE_WAIT;
                
                STATE_WAIT:
                begin
                    complete_read = 1'b1;
                    
                    if (col_check_bit_frame < 16'h2)
                        next_state = STATE_SET_OP_COUNT;
                    else if (crcerror_pulse) 
                    begin
                        crcerror_first_set = 1'b1;
                        next_state = STATE_SET_LOAD;
                    end
                    else if (emrread_pulse) 	
                        next_state = STATE_SET_LOAD;
                end
                
                STATE_SET_LOAD:
                begin
                    counter_set = 1'b1;
                    shiftnld = 1'b0;
                    pending_read_clear = crcerror_first ? 1'b0 : 1'b1;
                    next_state = STATE_WAIT_LOAD;
                end
                
                STATE_WAIT_LOAD:
                begin
                    counter_enable = 1'b1;
                    shiftnld = 1'b0;
                    if (counter_done)
                        next_state = STATE_LOAD;
                end
                
                STATE_LOAD:
                begin
                    emr_clk = 1'b1;
                    shiftnld = 1'b0;
                    next_state = STATE_SHIFTSTART;
                end
                
                STATE_SHIFTSTART:
                begin
                    counter_set = 1'b1;
                    next_state = STATE_CLOCKLOW;
                end
                
                STATE_CLOCKLOW:
                begin
                    counter_enable = 1'b1;
                    next_state = STATE_CLOCKHIGH;
                end
                
                STATE_CLOCKHIGH:
                begin
                    emr_clk = 1'b1;
                    if (counter_done)
                        next_state = crcerror_first ? STATE_PRE_CHK_EMR : STATE_PRE_UPDATE;
                    else
                        next_state = STATE_CLOCKLOW;
                end
                
                STATE_PRE_CHK_EMR:
                begin
                    crcerror_first_clear = 1'b1;
                    next_state = STATE_CHK_EMR;
                end
                
                STATE_CHK_EMR:
                begin
                    if (emr_error)
                        next_state = STATE_ERROR;
                    else if (crcerror_val > 4'h0 && crcerror_val < 4'h7)
                        next_state = STATE_PRE_UPDATE;
                    else if (crcerror_val > 4'h6) 
                        next_state = STATE_WAIT_HEC_SET;
                end
                
                STATE_WAIT_HEC_SET:
                begin
                    counter_set = 1'b1;
                    next_state = STATE_WAIT_HEC_POS;
                end
                
                STATE_WAIT_HEC_POS:
                begin
                    crcerror_pos_latch_clear = 1'b1;
                    counter_enable = 1'b1;
                    if (crcerror_pos_latch)
                        next_state = STATE_WAIT_HEC_NEG;
                    else if (hec_wait_done)
                        next_state = STATE_WAIT;
                end
                
                STATE_WAIT_HEC_NEG:
                begin
                    complete_read = 1'b1;
                    
                    if (crcerror_pulse)
                        next_state = STATE_SET_LOAD;
                end
                
                STATE_PRE_UPDATE:
                begin
                    next_state = STATE_STORE_PREV;
                end
                
                STATE_STORE_PREV:
                    next_state = STATE_REPORT_UPDATE;
                
                STATE_REPORT_UPDATE:
                begin
                    if (emr_error)
                        next_state = STATE_ERROR;
                    else 
                        next_state = STATE_VALID;
                end
                
                STATE_VALID:
                begin
                    valid_reg = 1'b1;
                    next_state = STATE_WAIT;
                end
                
                STATE_ERROR:
                begin
                    pending_read_clear = 1'b1;
                    next_state = STATE_WAIT;
                end
                
                default:
                    next_state = STATE_INIT;
            endcase
        end 

    always @(posedge clk or posedge reset_wire) begin
		if (reset_wire)
			current_state = STATE_INIT;
		else
			current_state = next_state;
	end

    
    always @(posedge clk) begin
        reset_reg[15:0] <= {reset_reg[14:0],1'b0};  
    end
    assign reset_wire = reset | reset_reg[15];

    always @(negedge clk or posedge reset_wire) begin
        if (reset_wire)
			op_shiftnld = 1'b1;
        else if (current_state == STATE_SET_OP_COUNT)
            op_shiftnld = 1'b0;
        else if (current_state == STATE_SHIFT_LAST_FRAME)
            op_shiftnld = 1'b1;
		else
            op_shiftnld = op_shiftnld;
	end
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire)
			col_check_bit_frame = 16'b0;
        else if (current_state == STATE_SET_OP_COUNT)       
            col_check_bit_frame[15:0] = 16'b0;
		else if (op_shiftnld && current_state == STATE_SHIFT_LAST_FRAME)                               
            col_check_bit_frame[15:0] = {op_regout, col_check_bit_frame[15:1]};
        else if (current_state == STATE_STORE_CHKBIT_FRAME) 
            col_check_bit_frame = col_check_bit_frame + 1'b1;
		else
            col_check_bit_frame = col_check_bit_frame;
	end

    always @(posedge clk or posedge reset_wire) begin
		if (reset_wire) 
            crcerror_sync1 <= 1'b0;
		else if (crcerror_wire)	
            crcerror_sync1 <= 1'b1;
		else 
            crcerror_sync1 <= 1'b0;
	end
    
    always @(posedge clk or posedge reset_wire) begin
		if (reset_wire) 
            crcerror_sync <= 1'b0;
		else if (crcerror_sync1) 
            crcerror_sync <= 1'b1;
		else 
            crcerror_sync <= 1'b0;
	end
    
    assign is_crcerror = inject_error | crcerror_sync;

    emr_unloader_oneshot #(.use_posedge(0)) crcerror_oneshot (.in(is_crcerror), .out(crcerror_pulse), .clk(clk), .reset(reset_wire));
    
    emr_unloader_oneshot crcerror_pos_oneshot (.in(is_crcerror), .out(crcerror_pos_pulse), .clk(clk), .reset(reset_wire));
    
    assign crcerror_pin = crcerror_wire;
    assign crcerror_core = is_crcerror;
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire) 
            crcerror_first = 1'b0;
		else if (crcerror_first_set)
			crcerror_first = 1'b1;
        else if (crcerror_first_clear)
			crcerror_first = 1'b0;
		else 
			crcerror_first = crcerror_first;
	end
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire) 
            crcerror_pos_latch = 1'b0;
		else if (crcerror_pos_pulse)
			crcerror_pos_latch = (current_state != STATE_WAIT);
        else if (crcerror_pos_latch_clear)
			crcerror_pos_latch = 1'b0;
		else 
			crcerror_pos_latch = crcerror_pos_latch;
	end
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire) 
            crcerror_val = 4'b0;
		else if (current_state == STATE_PRE_CHK_EMR)
			crcerror_val = crcerror_check(emr_reg, emr_prev_reg, col_check_bit_frame);
        else if (current_state == STATE_PRE_UPDATE)
			crcerror_val = 4'b0;
		else 
			crcerror_val = crcerror_val;
	end

    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire)
            emr_prev_reg = {EMR_ACT_WIDTH{1'b0}};
        else if (current_state == STATE_STORE_PREV)
            emr_prev_reg = emr_reg;
        else
            emr_prev_reg = emr_prev_reg;
	end
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire)
            emr_updt_reg = {EMR_ACT_WIDTH{1'b0}};
        else if (current_state == STATE_CHK_EMR)
            emr_updt_reg = {EMR_ACT_WIDTH{1'b0}};
        else if (current_state == STATE_PRE_UPDATE)
            emr_updt_reg = update_rpt(emr_reg, emr_prev_reg, col_check_bit_frame);   
        else
            emr_updt_reg = emr_updt_reg;
	end
    
    always @(negedge clk or posedge reset_wire) begin
        if (reset_wire)
            emr_reg = {EMR_ACT_WIDTH{1'b0}};
        else if (emr_clk) begin
            if (inject_error_reg)
                emr_reg = emr_reg_source;
            else
                emr_reg = {regout, emr_reg[EMR_ACT_WIDTH-1:1]};
		end
        else if (current_state == STATE_REPORT_UPDATE)
            emr_reg = emr_updt_reg;
        else
            emr_reg = emr_reg;
	end
    
    assign emr = {41'b0, emr_reg};
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire)
            inject_error_reg = 1'b0;
        else if (inject_error)
            inject_error_reg = 1'b1;
        else if (current_state == STATE_PRE_UPDATE)
            inject_error_reg = 1'b0;   
        else
            inject_error_reg = inject_error_reg;
	end
    
    assign emr_valid = valid_reg;
    
    always @(posedge clk or posedge reset_wire) begin
		if (reset_wire)
			error_reg = 1'b0;
		else if (valid_reg || crcerror_pos_pulse)
			error_reg = 1'b0;
		else if (read_request)
			error_reg = pending_read;
        else
            error_reg = error_reg;
	end
    
    assign emr_error = error_reg;
    
    emr_unloader_oneshot emrread_oneshot (.in(emr_read), .out(emrread_pulse), .clk(clk), .reset(reset_wire));
    assign read_request = crcerror_pulse || emrread_pulse;
    
    always @(posedge clk or posedge reset_wire) begin
		if (reset_wire)
			pending_read = 1'b0;
		else if (pending_read_clear)
			pending_read = 1'b0;
		else if (read_request)
			pending_read = ~complete_read;
        else
            pending_read = pending_read;
	end

    assign vec_frame = emr_reg[vec_frame_loc+vec_frame_width-1:vec_frame_loc];
    
    always @(posedge clk or posedge reset_wire) begin
        if (reset_wire)
			counter_value = 32'b0;
        else if (current_state == STATE_SET_OP_COUNT)       
            counter_value = OPREG_DELAY;
		else if (current_state == STATE_SET_LOAD)   
            counter_value = SHIFTNLD_DELAY;
        else if (current_state == STATE_SHIFTSTART) 
            counter_value = {25'b0, EMR_ACT_WIDTH[6:0]} - 14'd1;
        else if (current_state == STATE_WAIT_HEC_SET) 
            counter_value = wait_cycle + correctable_timeout_adjusted;
		else
            counter_value = counter_value;
	end
	
    lpm_counter #(
        .lpm_width(32), 
        .lpm_direction("UP"))
    counter(
        .clock(clk),
        .cnt_en(counter_enable),
        .aclr(reset_wire),
        .sclr(counter_set),
        .q(counter_q));
	assign counter_done = (counter_q == counter_value);
    assign hec_wait_done = (counter_q > counter_value - 32'd2);
    
    lpm_mult #(
            .lpm_hint("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"), 
            .lpm_representation("UNSIGNED"), 
            .lpm_type("LPM_MULT"), 
            .lpm_widtha(16), 
            .lpm_widthb(10), 
            .lpm_widthp(26))
        lpm_mult_component(
            .dataa (vec_frame),
            .datab (freq_const[9:0]),
            .result (wait_cycle),
            .aclr (1'b0),
            .clken (1'b1),
            .clock (1'b0),
            .sclr (1'b0),
            .sum (1'b0)
        );
    
// Arria 10 EDCRC circuitry Slow Detection constant time in cycles
//Function to select appropriate wait time between falling edge of first CRCERROR pulse (VEC) 
function [15:0] get_hec_cycles;
    input dummy;
    begin
        if(INTENDED_DEVICE == "NIGHTFURY5"
            || INTENDED_DEVICE == "NIGHTFURY5ES2"
            || INTENDED_DEVICE == "10AX115"
            || INTENDED_DEVICE == "10AX090"
            || INTENDED_DEVICE == "10AT115"
            || INTENDED_DEVICE == "10AT090"
            || INTENDED_DEVICE == "10AX115ES2"
            || INTENDED_DEVICE == "10AT115ES2")
                    get_hec_cycles = `AEU_HEC_CYCLES_5;
		else if(INTENDED_DEVICE == "NIGHTFURY4" 
                || INTENDED_DEVICE == "NIGHTFURY4ES"
                || INTENDED_DEVICE == "10AS066"
                || INTENDED_DEVICE == "10AS057"
                || INTENDED_DEVICE == "10AX066"
                || INTENDED_DEVICE == "10AX057"
                || INTENDED_DEVICE == "10AS066ES"
                || INTENDED_DEVICE == "10AX066ES")
                    get_hec_cycles = `AEU_HEC_CYCLES_4;
		else if(INTENDED_DEVICE == "NIGHTFURY3" 
                || INTENDED_DEVICE == "10AS048"
                || INTENDED_DEVICE == "10AX048")
                    get_hec_cycles = `AEU_HEC_CYCLES_3;
		else if(INTENDED_DEVICE == "NIGHTFURY2" 
                || INTENDED_DEVICE == "10AS032"
                || INTENDED_DEVICE == "10AS027"
                || INTENDED_DEVICE == "10AX032"
                || INTENDED_DEVICE == "10AX027")
                    get_hec_cycles = `AEU_HEC_CYCLES_2;
		else if(INTENDED_DEVICE == "NIGHTFURY1" 
                || INTENDED_DEVICE == "10AS022"
                || INTENDED_DEVICE == "10AS016"
                || INTENDED_DEVICE == "10AX022"
                || INTENDED_DEVICE == "10AX016")
                    get_hec_cycles = `AEU_HEC_CYCLES_1;
        else
            get_hec_cycles = `AEU_HEC_CYCLES_5;
    end	
endfunction

function [3:0] crcerror_check;
    input [EMR_ACT_WIDTH-1:0]  emr_data;
    input [EMR_ACT_WIDTH-1:0]  emr_prev_data;
    input [15:0] col_check_bit_frame;
    
    reg col_check_bit;
    reg [49:0] h_fields;
    reg [2:0] h_type;
    reg [4:0] h_bit;
    reg [25:0] v_fields;
    reg [2:0] v_type;
    reg [4:0] v_quad;
    reg [1:0] v_dw;
    reg [15:0] v_frame_addr;
    
    reg [49:0] prev_h_fields;
    reg [25:0] prev_v_fields;

    begin
        crcerror_check = 4'h0;      
        
        col_check_bit = emr_data[0];
    
        h_fields    = emr_data[51:2];
        h_type      = emr_data[4:2];
        h_bit       = emr_data[9:5];
        
        v_fields        = emr_data[77:52];
        v_type          = emr_data[54:52];
        v_quad          = emr_data[59:55];
        v_dw            = emr_data[61:60];
        v_frame_addr    = emr_data[77:62];
        
        prev_h_fields   = emr_prev_data[51:2];
        prev_v_fields   = emr_prev_data[77:52];
        
                
        if (col_check_bit == 1'b1)
            crcerror_check = 4'h1;
        else if (v_fields == 26'b0 || 
                    v_frame_addr == col_check_bit_frame && h_fields != prev_h_fields && v_fields == prev_v_fields) begin
                if (h_type == 3'b111 ||                             
                        h_type == 3'b010 && h_bit == 5'b11111 ||    
                        h_type == 3'b011 && h_bit != 5'b11111)      
                    crcerror_check = 4'h2;
                else
                    crcerror_check = 4'h3;
        end
        else if (v_frame_addr == col_check_bit_frame && v_fields != prev_v_fields && h_fields == prev_h_fields) begin
            if (v_type == 3'b111 ||                             
                    v_type == 3'b010 && v_quad == 5'b11111 ||   
                    v_type == 3'b011 && v_quad != 5'b0)         
                crcerror_check = 4'h4;   
            else
                crcerror_check = 4'h5;
        end
        else if (v_type == 3'b111 ||                            
                    v_type == 3'b010 && v_quad == 5'b11111 ||   
                    v_type == 3'b011 && v_quad != 5'b0)         
                crcerror_check = 4'h6;   
        else if (h_type == 3'b111 ||                             
                    h_type == 3'b010 && h_bit == 5'b11111 ||    
                    h_type == 3'b011 && h_bit != 5'b11111)      
                crcerror_check = 4'h8;   
        else
            crcerror_check = 4'h9;  
    end
endfunction

function [EMR_ACT_WIDTH-1:0] update_rpt;
    input [EMR_ACT_WIDTH-1:0]  emr_data;
    input [EMR_ACT_WIDTH-1:0]  emr_prev_data;
    input [15:0] col_check_bit_frame;
    
    reg [3:0] crcerror_type;
    
    begin
        update_rpt = {EMR_ACT_WIDTH{1'b0}};      
        crcerror_type = crcerror_check(emr_data, emr_prev_data, col_check_bit_frame);
        
        if(crcerror_type == 4'h1)
            update_rpt = {emr_data[EMR_ACT_WIDTH-1:55],3'b111,emr_data[51:5],3'b111,emr_data[1:0]};     
        else if(crcerror_type == 4'h2)
            update_rpt = {{(EMR_ACT_WIDTH-52){1'b0}},emr_data[51:5],3'b111,emr_data[1:0]};                
        else if(crcerror_type == 4'h3)
            update_rpt = {{(EMR_ACT_WIDTH-52){1'b0}},emr_data[51:0]};                                     
        else if(crcerror_type == 4'h4 || crcerror_type == 4'h6) 
            update_rpt = {emr_data[EMR_ACT_WIDTH-1:55],3'b111,50'b0,emr_data[1:0]};                  
        else if(crcerror_type == 4'h5)
            update_rpt = {emr_data[EMR_ACT_WIDTH-1:52],50'b0,emr_data[1:0]};                         
        else if(crcerror_type == 4'h8)
            update_rpt = {emr_data[EMR_ACT_WIDTH-1:5],3'b111,emr_data[1:0]};                            
        else
            update_rpt = emr_data;
    end
endfunction
    
endmodule


module emr_source_probe (
    probe,
    source
    );

    parameter width = 1;
    parameter instance_id = "NONE";
    
    input [width-1:0] probe;
    output [width-1:0] source;

	altsource_probe altsource_probe_component (
        .probe (probe),
        .source (source));
	defparam
        altsource_probe_component.enable_metastability = "NO",
        altsource_probe_component.instance_id = instance_id,
        altsource_probe_component.probe_width = width,
        altsource_probe_component.sld_auto_instance_index = "YES",
        altsource_probe_component.sld_instance_index = 0,
        altsource_probe_component.source_initial_value = "0",
        altsource_probe_component.source_width = width;
        
endmodule


module emr_unloader_oneshot (
    clk,
    reset,
    in,
    out
    );

    parameter use_posedge = 1;

    input clk;
    input reset;
    input in;
    output out;

    reg last /* synthesis preserve */;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            last = 1'b0;
        else
            last = in;
    end
    
    generate
        if(use_posedge) begin: generate_pulse
            // generate pulse on raising edge
            assign out = ~last && in;
        end
        else begin: generate_pulse
            // generate pulse on falling edge
            assign out = ~in && last;
        end
    endgenerate		
	
endmodule

