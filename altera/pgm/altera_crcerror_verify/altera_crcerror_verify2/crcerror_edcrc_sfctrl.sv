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
// File name: crcerror_sfctrl.v
// 
//
// Development of EDCRC Frame Control
//

module crcerror_edcrc_sfctrl #(
                  //   TOP LEVEL
				  parameter            MAX_FAIL_COUNT = 6,
				  parameter            NUM_ERROR_TYPE = 3,
				  parameter                 ROW_WIDTH = 14, 
				  parameter                  ERR_TYPE = 2'b10,
                  //   EDCRC CTRLFSM Interface
                  parameter             FRAME_TYPE_EN = 1'b1, //Enable this if this component is parameterizable per frame type
				  parameter                FRAME_TYPE = 1'b1, 
				  parameter            SYNDROME_WIDTH = 16,
				  parameter               FRAME_WIDTH = 14,
				  parameter          FAIL_COUNT_WIDTH = 3, 
				  //   CACHE Interface       
				  parameter               CACHE_TYPE = 1'b1,              //1-shift frame 0-no shift frame
			      parameter              CACHE_WIDTH = CACHE_TYPE? 44:30, 
                  parameter              CACHE_DEPTH = FRAME_TYPE? 16: 5,
				  //   SEGMENT REG Interface
				  parameter                REG_WIDTH = SYNDROME_WIDTH + FRAME_WIDTH, //16+14
				  parameter            SEGMENT_DEPTH = 1,
				  parameter             SEGMENT_TYPE = 1'b1 
)
(
                  //   Clock and Reset
				  input  logic                    reset, 
				  input  logic                    inclk,
				  //   CRC_Check
				  input [CACHE_WIDTH-1:0]         emr_content,
                  input [FRAME_WIDTH-1:0]         framelut_addr_end,				  
				  //   Frame Interface
				  input  logic[FRAME_WIDTH-1:0]   frame,
				  input  logic[SYNDROME_WIDTH-1:0] segment, 
				  input  logic                    crcerror_in,
				  output logic                    sfctrl_crcerror_out,
                  //   Control Signals
				  input  logic                    emr_done,
				  input  logic                    crc_cycle_done,     
				  //   Previous Register matching
				  //   Cache Interface
	              output logic                    cache_full,
				  //   TYPE Error Interface
				  input  logic                    error_frame_is_no_shift_frame,
				  input  logic[1:0]               error_type,
				  //   Error State
				  output logic[3:0]               sfctrl_ctrlfsm_state,
				  output logic[3:0]               sfctrl_ctrlfsm_next_state,
				  //   CRC Check
				  output logic	                  clr_error_found,
				  output logic                    report_failure,
				  output logic                    report_failure_ncf,
				  //   NSF Logics
	              input  logic                    mt30d
                  );
				  
    // edcrc_ctrlfsm -> cache
	logic    rd_cache;
    logic    wr_cache;
	// edcrc_ctrlfsm -> segment
	logic    wr_segment; //Write current row and frame
	logic    rd_segment; 
    // Normal Frame only
	logic    curr_prev_row_match;	
	logic[REG_WIDTH-1:0]                        frame_dataout_vld;
	logic[REG_WIDTH-1:0]                        emr_content_reg;
	logic                	                    previous_error;
	logic                                       clr_previous_error;
	logic                                       error_found;
	reg[FAIL_COUNT_WIDTH-1:0]                   fail_count;
	reg                                         report_failure_reg;
	// Segments > cdcrc_ctrlfsm
	logic                                       segment_match;
	logic                                       segment_full;
	logic                                       segment_empty;
    logic                                       rd_segment_done; 
	logic                                       rd_cache_done; 
	logic                                       cache_match; 
	logic                                       cache_empty; 
	logic [REG_WIDTH-1:0]                       frame_dataout; 
	reg[FRAME_WIDTH-1:0]                        frame_prev;
	
	// This block needs to move out to CRC_Check
    logic                                       frame_lte_frame_prev;
    logic [FRAME_WIDTH-1:0]                     frame_diff;
	logic                                       frame_prev_store;
    logic                                       frame_prev_store_vld;
	logic                                       frame_wtb; 
   
    crcerror_edcrc_ctrlfsm
    #(
      .MAX_FAIL_COUNT(MAX_FAIL_COUNT),
	  .ERR_TYPE(ERR_TYPE),
	  .FRAME_TYPE_EN(FRAME_TYPE_EN),
      .FRAME_TYPE(FRAME_TYPE),
      .SYNDROME_WIDTH(SYNDROME_WIDTH),
      .FRAME_WIDTH(FRAME_WIDTH),
	  .FAIL_COUNT_WIDTH(FAIL_COUNT_WIDTH)
    )
    crcerror_edcrc_ctrlfsm_component
    ( .edcrc_ctrlfsm_state(sfctrl_ctrlfsm_state),
	  .edcrc_ctrlfsm_next_state(sfctrl_ctrlfsm_next_state),
	  .crcerror_out(sfctrl_crcerror_out),
	  .rd_segment_done(rd_segment_done),
	  .rd_cache_done(rd_cache_done),
	  .cache_full(cache_full),
	  .cache_match(cache_match),
      .previous_error(previous_error),
	  .curr_prev_row_match(curr_prev_row_match),
	  .mt30d(mt30d),
	  .error_found(error_found),
	  .fail_count(fail_count),
	  .frame_wtb(frame_wtb),
	  .error_type(error_type),
	  .crcerror_in(crcerror_in),
	  .*
    );
						 
		crcerror_edcrc_cache #(
        .ERR_TYPE(ERR_TYPE),
        .MAX_COUNT(CACHE_DEPTH),
        .CACHE_TYPE(CACHE_TYPE),
		.CACHE_WIDTH(CACHE_WIDTH),
		.MATCH_LEVEL(1'b0), 
		.ROLLOVER_EN(1'b0)  
        )
        crcerror_edcrc_cache_component (
        .clk(inclk),
		.reset(reset),
		.error_type(error_type),
		.emr_content(emr_content),
		.clr_started(clr_previous_error), 
		.rd_done_in (1'b1), 
        .rd_done_out(rd_cache_done),
	    .match      (cache_match),
	    .cache_full (cache_full),
	    .cache_empty(cache_empty),
		.cache_dataout(), 
		.started(), 
		.*
        );	  

	
    generate if (FRAME_TYPE==1) begin : edcrc_segment_sf 
		    crcerror_edcrc_cache #(
            .ERR_TYPE(ERR_TYPE),
            .MAX_COUNT(SEGMENT_DEPTH),
            .CACHE_TYPE(SEGMENT_TYPE),
			.CACHE_WIDTH(REG_WIDTH),
		    .MATCH_LEVEL(1'b0), 
			.ROLLOVER_EN(1'b1)  
            )
            crcerror_edcrc_cache_segment( 
            .clk(inclk),
			.emr_content(emr_content_reg),
			.clr_started(clr_previous_error),
			.rd_done_in (1'b1), 
            .rd_done_out(rd_segment_done),
	        .match      (segment_match),
	        .cache_full (segment_full),
	        .cache_empty(segment_empty),
	        .cache_dataout(frame_dataout),
			.wr_cache(wr_segment),
			.rd_cache(rd_segment),
			.started(previous_error), 
			.*
        );	 
        
        // Normal Frame - Register Only	
        assign emr_content_reg     = {segment,frame};
        
	end else begin 
			    assign rd_segment_done = 1'b0; 
				assign frame_dataout = {REG_WIDTH{1'b0}}; 
				assign previous_error = 1'b0;
        end 
	endgenerate
    
	assign frame_prev_store = frame_prev_store_vld & (error_type == ERR_TYPE);
	always @(posedge inclk or posedge reset) begin
            if(reset) begin
                frame_prev <= 'b0;
            end else if (frame_prev_store) begin
                frame_prev <= framelut_addr_end; 
            end
    end 
		  
	assign frame_lte_frame_prev = (frame>=frame_dataout_vld[FRAME_WIDTH-1:0]);
	assign frame_diff      = frame_lte_frame_prev? (frame - frame_dataout_vld[FRAME_WIDTH-1:0]):
                                                   (frame_dataout_vld[FRAME_WIDTH-1:0]-frame);
	// CF_SF_STORE OR CF_SF_REG_CHECK > CF_SF_CNT_CHECK
	assign frame_prev_store_vld = (sfctrl_ctrlfsm_state=='d2) | ((sfctrl_ctrlfsm_state=='d4) & (sfctrl_ctrlfsm_next_state=='d6));
	assign frame_dataout_vld = frame_dataout;

	// Syndrome <-> Frame for Register Match
	assign curr_prev_row_match = (frame_dataout_vld[REG_WIDTH-1:FRAME_WIDTH] == segment); //Reviewed 4- This is syndrome compare
    assign           frame_wtb = (frame_prev==framelut_addr_end); 
		
	// Error Block
	assign clr_previous_error = crc_cycle_done & ~error_found; //error_found will be cleared to 0
	assign clr_error_found = crc_cycle_done & error_found; 
	
	// Must clear first before count? No need as done is qual with only 1 other signal-error_found
	always @ (posedge inclk or posedge reset) begin
	    if (reset)
           begin
		       fail_count <= {FAIL_COUNT_WIDTH{1'b0}};
		   end
		// Count only before it reach the MAX value
		else if (crc_cycle_done && error_found && (fail_count < MAX_FAIL_COUNT)) begin
            fail_count  <= fail_count + {{(FAIL_COUNT_WIDTH-1){1'b0}}, 1'b1};
		    end
		// Once failure count reach Max, its becomes sticky and never cleard
	    else if (crc_cycle_done && (!error_found) && (!report_failure_reg)) begin
	        fail_count <= 0;
	    end
	end

	// Define report failure as a latch
	always @ (posedge inclk or posedge reset)
	    if (reset==1'b1)
		  report_failure_reg <= 1'b0;
		else if ((fail_count==MAX_FAIL_COUNT) && (sfctrl_ctrlfsm_state==4'd9))
		  report_failure_reg <= 1'b1;
	    else
		  report_failure_reg <= report_failure_reg;

    assign     report_failure = (((fail_count==MAX_FAIL_COUNT)|cache_full) & (sfctrl_ctrlfsm_state==4'd9));
	assign report_failure_ncf = ((fail_count==MAX_FAIL_COUNT) & (sfctrl_ctrlfsm_state==4'd9)); 
	
endmodule   
 