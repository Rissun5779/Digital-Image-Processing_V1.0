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
// File name: crcerror_verify_core.v
//  	The ccrcerror_verify_core module checks for false
//  	failure conditions before passing on the error to the pin
//   

module crcerror_verify_core (
  inclk
, reset
, emr_in
, emr_done
, emr_reg_en
, crcerror_in
, crcerror_out
, emr_reg_raw	
, emr_valid		
, emr_out
);


input inclk;
input reset;
input emr_in;
input emr_done;
input emr_reg_en;
input crcerror_in;
output crcerror_out;
output [45:0] emr_reg_raw;
output emr_valid;
output [45:0] emr_out;


parameter ED_CYCLE_TIME_DIV256 = -1;
parameter CRC_DIVISOR = -1;
parameter INCLK_FREQ = -1;

// Ceil of the log base 2
function integer CLogB2;
    input [31:0] Depth;
    integer i;
    begin
        i = Depth;        
        for(CLogB2 = 0; i > 0; CLogB2 = CLogB2 + 1)
            i = i >> 1;
    end
endfunction

parameter MAX_COUNT = ((ED_CYCLE_TIME_DIV256*CRC_DIVISOR*INCLK_FREQ)/256)+(((ED_CYCLE_TIME_DIV256*CRC_DIVISOR*INCLK_FREQ)%256)==0?0:1);
parameter MAX_COUNT_WIDTH = CLogB2(MAX_COUNT);

parameter     DAYS = 2;
parameter COUNT_1M = 195000;
parameter COUNT_1M_NSF = 1300;
parameter COUNT_1M_WIDTH = CLogB2(COUNT_1M);
parameter COUNT_1M_WIDTH_NSF = CLogB2(COUNT_1M_NSF);
parameter integer NUM_ERROR_TYPE = 3;
parameter integer MAX_FAIL_COUNT_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{5,5,5,5,5,5};

	parameter bit[1:0]        ERR_TYPE_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{2'b11,2'b10,2'b01,2'b11,2'b10,2'b01};
	parameter bit           CACHE_TYPE_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{1'b0,1'b0,1'b0,1'b1,1'b1,1'b1};
    parameter bit           FRAME_TYPE_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{1'b0,1'b0,1'b0,1'b1,1'b1,1'b1};
    parameter integer      CACHE_WIDTH_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{30,30,30,44,44,44}; 
    parameter integer      CACHE_DEPTH_ALL[(NUM_ERROR_TYPE*2)-1:0] = '{5,5,5,16,16,16};
    localparam                    MAX_COUNT_DAYS = (((INCLK_FREQ * 60 * 60 * 24 * DAYS)/ (2**20))+
                                                   (((INCLK_FREQ * 60 * 60 * 24 * DAYS)% (2**20))==0?0:1)); 
	localparam              MAX_COUNT_WIDTH_DAYS = CLogB2(MAX_COUNT_DAYS);
	localparam                     FRAME_TYPE_EN = 1'b1; 
    localparam                        FRAME_TYPE = 1'b1; 
	localparam                        CACHE_TYPE = 1'b1;              
	localparam                       CACHE_WIDTH = CACHE_TYPE? 44:30; 
    localparam                       CACHE_DEPTH = FRAME_TYPE? 16: 5;
    localparam                    SYNDROME_WIDTH = 16;
    localparam                       FRAME_WIDTH = 14;
	localparam                  FAIL_COUNT_WIDTH = 3; 	
	localparam                         REG_WIDTH = SYNDROME_WIDTH + FRAME_WIDTH; 
	localparam                     SEGMENT_DEPTH = 1;
	localparam                      SEGMENT_TYPE = 1'b1; 
    localparam                           FLOP_EN = 1'b1; 
	
reg [MAX_COUNT_WIDTH-1:0] cycle_count;
reg [COUNT_1M_WIDTH-1:0] counter_1m;
reg [45:0] emr_reg;

wire [1:0] error_type;
wire crc_cycle_done;
wire reset_prev_error; 

wire[SYNDROME_WIDTH-1:0]                   error_syndrome;
wire[FRAME_WIDTH-1:0]                      error_frame;
wire [FRAME_WIDTH-1:0]                     framelut_addr_start;
wire [FRAME_WIDTH-1:0]                     framelut_addr_end;
wire[(SYNDROME_WIDTH+(FRAME_WIDTH*2))-1:0] emr_content_sf; 
wire[(SYNDROME_WIDTH+FRAME_WIDTH)-1:0]     emr_content_nsf; 
wire[(NUM_ERROR_TYPE*2)-1:0]               clr_error_found;
wire[(NUM_ERROR_TYPE*2)-1:0]               sfctrl_crcerror_out;
wire[(NUM_ERROR_TYPE*2)-1:0]               report_failure;
wire[(NUM_ERROR_TYPE*2)-1:0]               report_failure_ncf;
wire                                       any_report_failure;
wire                                       any_report_failure_ncf;
wire                                       any_report_failure_lvl;
wire                                       any_report_failure_p;
reg                                        any_report_failure_lvl_r;
wire                                       crcerror_out_pre1;
reg                                        crcerror_out_reg;
reg  [45:0]                                emr_out_reg;
wire[MAX_COUNT_WIDTH_DAYS-1:0]             days;
wire                                       mt30d;
wire[(NUM_ERROR_TYPE*2)-1:0]               cache_full;
wire                                       sf_cache_full;
wire                                       nsf_cache_full;
wire                                       cache_full_vld;
wire[45:0]                                 cache_full_seu;
wire[45:0]                                 emr_reg_vld;

wire error_frame_is_no_shift_frame;
wire [13:0] no_shift_frame1;
wire [13:0] no_shift_frame2;
wire [13:0] no_shift_frame3;
wire [13:0] no_shift_frame4;
wire [13:0] no_shift_frame5;
wire [13:0] no_shift_frame6;
wire [13:0] no_shift_frame7;
wire [13:0] no_shift_frame8;
wire [13:0] no_shift_frame9;
wire [13:0] no_shift_frame10;
wire [13:0] no_shift_frame11;
wire [13:0] no_shift_frame12;
wire [13:0] no_shift_frame13;
wire [13:0] no_shift_frame14;
wire [13:0] no_shift_frame15;
wire [13:0] no_shift_frame16;
wire [13:0] no_shift_frame17;
wire [13:0] no_shift_frame18;
wire [13:0] no_shift_frame19;
wire [13:0] no_shift_frame20;
wire [13:0] no_shift_frame21;
wire [13:0] no_shift_frame22; 
wire [13:0] no_shift_frame23;
wire [13:0] no_shift_frame24; 
wire [13:0] no_shift_frame25;

    assign no_shift_frame1 = 14'h2e9;
    assign no_shift_frame2 = 14'h2ea;
    assign no_shift_frame3 = 14'h2eb;
    assign no_shift_frame4 = 14'h1054;
    assign no_shift_frame5 = 14'h1055;
    assign no_shift_frame6 = 14'h1056;
    assign no_shift_frame7 = 14'h1398;
    assign no_shift_frame8 = 14'h1399;
    assign no_shift_frame9 = 14'h139a;
    assign no_shift_frame10 = 14'h139a;
    assign no_shift_frame11 = 14'h139a;
    assign no_shift_frame12 = 14'h139a;
    assign no_shift_frame13 = 14'h139a;
    assign no_shift_frame14 = 14'h139a;
    assign no_shift_frame15 = 14'h139a;
    assign no_shift_frame16 = 14'h139a;
    assign no_shift_frame17 = 14'h139a;
    assign no_shift_frame18 = 14'h139a;
    assign no_shift_frame19 = 14'h139a;
    assign no_shift_frame20 = 14'h139a;
    assign no_shift_frame21 = 14'h139a;
    assign no_shift_frame22 = 14'h139a; 
    assign no_shift_frame23 = 14'h139a;
    assign no_shift_frame24 = 14'h139a; 
    assign no_shift_frame25 = 14'h139a;

assign emr_reg_raw [45:0] = emr_reg [45:0];
assign emr_valid = emr_done;

always @(posedge reset or posedge inclk) begin
    if(reset) begin
        emr_reg <= 46'b0;
    end
    else if (emr_done == 1'b0 && emr_reg_en == 1'b1) begin
        emr_reg[45:0] <= {emr_in, emr_reg[45:1]};
    end
	else if (reset_prev_error) emr_reg <= 46'b0; 
	
end

// Frame Lookup Table
    crcerror_edcrc_framelut #(
        .FRAME_WIDTH(FRAME_WIDTH),
		.FLOP_EN(FLOP_EN)
    )
    crcerror_edcrc_framelut_component (
	    .inclk               (inclk),
		.reset               (reset),
        .frame_in            (error_frame),
        .framelut_addr_start (framelut_addr_start),
	    .framelut_addr_end   (framelut_addr_end),
	    .frame_lut_entry  () 
    );
	
assign reset_prev_error = | clr_error_found[(NUM_ERROR_TYPE*2)-1:0];
assign any_report_failure = | report_failure[(NUM_ERROR_TYPE*2)-1:0];
assign any_report_failure_ncf = | report_failure_ncf[(NUM_ERROR_TYPE*2)-1:0];
assign sf_cache_full = |cache_full[NUM_ERROR_TYPE-1:0];
assign nsf_cache_full = |cache_full[(NUM_ERROR_TYPE*2)-1:NUM_ERROR_TYPE];
assign cache_full_vld = error_frame_is_no_shift_frame? nsf_cache_full: (~sf_cache_full);
// cache_full_vld -0 Normal Frame, 1 No-Shift Frame 				  
assign cache_full_seu = {42'h3FCAC3F011F, 1'b0, cache_full_vld, error_type[1:0]};
						  
assign error_syndrome[15:0] = emr_reg[45:30];
assign error_frame[13:0] = emr_reg[29:16];
assign error_type[1:0] = emr_reg[1:0];

	assign emr_content_sf  = {error_syndrome, framelut_addr_end, framelut_addr_start};
	assign emr_content_nsf = {error_syndrome, error_frame};			  
	genvar err_type;
    generate
    for (err_type=0; err_type<(NUM_ERROR_TYPE*2); err_type=err_type+1) begin : edcrc_ctrl_inst
    crcerror_edcrc_sfctrl
    #(
      .NUM_ERROR_TYPE(NUM_ERROR_TYPE),
	  .ROW_WIDTH(14),
      .ERR_TYPE(ERR_TYPE_ALL[err_type]),
	  .FRAME_TYPE_EN(FRAME_TYPE_EN),
	  .FRAME_TYPE(FRAME_TYPE_ALL[err_type]),
	  .CACHE_TYPE(CACHE_TYPE_ALL[err_type]),
	  .CACHE_WIDTH(CACHE_WIDTH_ALL[err_type]),
	  .CACHE_DEPTH(CACHE_DEPTH_ALL[err_type]),
      .MAX_FAIL_COUNT(MAX_FAIL_COUNT_ALL[err_type]),	  
      .SYNDROME_WIDTH(SYNDROME_WIDTH),
      .FRAME_WIDTH(FRAME_WIDTH),
	  .FAIL_COUNT_WIDTH(FAIL_COUNT_WIDTH)
    )
    crcerror_edcrc_sfctrl_component
    ( .reset(reset),
	  .inclk(inclk),
	  .frame(error_frame),
	  .segment(error_syndrome),
	  .crcerror_in(crcerror_in),
	  .emr_content(CACHE_TYPE_ALL[err_type]?emr_content_sf:emr_content_nsf),
	  .framelut_addr_end(framelut_addr_end),
	  .sfctrl_crcerror_out(sfctrl_crcerror_out[err_type]),
	  .emr_done(emr_done),
	  .error_frame_is_no_shift_frame(error_frame_is_no_shift_frame),
      .error_type(error_type),
	  .sfctrl_ctrlfsm_state(),
	  .sfctrl_ctrlfsm_next_state(),
	  .clr_error_found(clr_error_found[err_type]),
	  .report_failure(report_failure[err_type]), 
	  .report_failure_ncf(report_failure_ncf[err_type]),
	  .cache_full(cache_full[err_type]),
	  .crc_cycle_done(crc_cycle_done),
	  .mt30d(mt30d)
    );	  
        end
    endgenerate

assign error_frame_is_no_shift_frame =( 
	error_frame == no_shift_frame1 || 
	error_frame == no_shift_frame2 || 
	error_frame == no_shift_frame3 || 
	error_frame == no_shift_frame4 || 
	error_frame == no_shift_frame5 || 
	error_frame == no_shift_frame6 || 
	error_frame == no_shift_frame7 ||
	error_frame == no_shift_frame8 ||
	error_frame == no_shift_frame9 ||
	error_frame == no_shift_frame10 ||
	error_frame == no_shift_frame11 ||
	error_frame == no_shift_frame12 ||
	error_frame == no_shift_frame13 ||
	error_frame == no_shift_frame14 ||
	error_frame == no_shift_frame15 ||
	error_frame == no_shift_frame16 ||
	error_frame == no_shift_frame17 ||
	error_frame == no_shift_frame18 ||
	error_frame == no_shift_frame19 ||
	error_frame == no_shift_frame20 ||
	error_frame == no_shift_frame21 ||
	error_frame == no_shift_frame22 ||
	error_frame == no_shift_frame23 ||
	error_frame == no_shift_frame24 ||
	error_frame == no_shift_frame25);

assign crcerror_out_pre1 = |sfctrl_crcerror_out[(NUM_ERROR_TYPE*2)-1:0];
assign crc_cycle_done = (cycle_count>=MAX_COUNT && counter_1m>=COUNT_1M-1);

// intermittent errorcheck
//  Initialize fail_count, false_error and real_error to 0
//  Initialize counter C to 0
//  Whenever CRCERROR occurs, 
//  Whenever C reaches Max ED cycle time
//  Reset counter C to 0
//  If false_error == 1, increment fail_count 
//  If false_error == 0, reset fail_count to 0
//  If fail_count > 5, set real_error to 1
 
    // Days counter for  no-shift frames  
		crcerror_edcrc_counter 
	    #(
          .INCLK_FREQ(INCLK_FREQ),
		  .DAYS(DAYS),
		  .MAX_COUNT_DAYS(MAX_COUNT_DAYS),
		  .COUNT_1M(COUNT_1M_NSF),
		  .COUNT_1M_WIDTH(COUNT_1M_WIDTH_NSF),
		  .MAX_COUNT_WIDTH(MAX_COUNT_WIDTH_DAYS),
		  .DAYS_ENABLE(1'b1)
        )
        crcerror_edcrc_counter_component(
        .clk(inclk),
		.reset(reset),
        .count_up(1'b1), 
	    .counter_value(days),
		.done(mt30d)
        );	  

always @(posedge reset or posedge inclk) begin
    if (reset) begin
        cycle_count <= 0;
        counter_1m <= 0;
    end else if (crc_cycle_done) begin
        cycle_count <= 0;
        counter_1m <= 0;
    end else if (counter_1m>=COUNT_1M-1) begin
        cycle_count <= cycle_count + 1'b1;
        counter_1m <= 0;
    end else 
        counter_1m <= counter_1m + 1'b1;
end

// Only Flag the first detected error location and never deassert until reset happens
assign any_report_failure_lvl = any_report_failure && crcerror_in;
assign   any_report_failure_p = any_report_failure_lvl & ~any_report_failure_lvl_r;  
assign                emr_out = emr_out_reg;
assign           crcerror_out = crcerror_out_reg;

always @(posedge inclk or posedge reset) begin
    if(reset) begin
	    emr_out_reg <= 46'h0;
    end else if(any_report_failure_p) begin
	    emr_out_reg <= emr_reg_vld;
    end else begin
	    emr_out_reg <= emr_out_reg;
    end
end

// report_failure only asserts when Error cycle > 5 & cache_full
// cache_full[i]	report_failure[i]
//	  0			1- Normal Error
//	  1			0- Cache full Error
//	  1			1- Report Normal error
assign emr_reg_vld = any_report_failure_ncf? emr_reg:
                                             cache_full_seu;

always @(posedge inclk or posedge reset) begin
    if(reset) begin
	    any_report_failure_lvl_r <= 1'b0;
                crcerror_out_reg <= 1'b0;			   
    end else begin
		any_report_failure_lvl_r <= any_report_failure_lvl;
                crcerror_out_reg <= crcerror_out_pre1;
    end
end

endmodule   
