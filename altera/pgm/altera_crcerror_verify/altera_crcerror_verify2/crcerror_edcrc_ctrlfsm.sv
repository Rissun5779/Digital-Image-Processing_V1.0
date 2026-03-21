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
// File name: crcerror_ctrlfsm.v
// 
//
// Development of EDCRC Control FSM
//

module crcerror_edcrc_ctrlfsm #(
                  parameter            MAX_FAIL_COUNT = 6,
				  parameter                  ERR_TYPE = 2'b10,
                  parameter             FRAME_TYPE_EN = 1'b1, 
				  parameter                FRAME_TYPE = 1'b1, 
				  parameter               FRAME_WIDTH = 14,
                  parameter            SYNDROME_WIDTH = 16,
                  parameter          FAIL_COUNT_WIDTH = 3  				  
)
(
                  //   Clock and Reset
				  input  logic                    reset, 
				  input  logic                    inclk,
				  //   Frame Interface
				  input  logic[FRAME_WIDTH-1:0]   frame,
				  input  logic[SYNDROME_WIDTH-1:0]segment,
				  input  logic                    crcerror_in,
				  output logic                    crcerror_out,
                  //   Control Signals
				  input  logic                    emr_done,
				  input  logic                    crc_cycle_done,
				  input  logic                    mt30d,
				  input  logic                    frame_wtb, 
				  input  logic [FRAME_WIDTH-1:0]  frame_diff,
				  input  logic [FAIL_COUNT_WIDTH-1:0] fail_count,
				  input  logic                    clr_error_found,
				  //   Previous Register matching
				  input  logic                    previous_error,
				  input  logic                    rd_segment_done,
				  output logic                    wr_segment, 
				  output logic                    rd_segment, 
				  output logic                    error_found, 
				  input  logic                    curr_prev_row_match,				  
				  //   Cache Interface
				  input   logic                   rd_cache_done,
				  input   logic                   cache_full,
				  output  logic                   rd_cache,
				  output  logic                   wr_cache,
				  input   logic                   cache_match,
				  //   TYPE Error Interface
				  input  logic                    error_frame_is_no_shift_frame,
				  input  logic[1:0]               error_type,
				  //   Error State
				  output logic[3:0]               edcrc_ctrlfsm_state,
				  output logic[3:0]               edcrc_ctrlfsm_next_state
                  );

    logic                        frame_type;
	logic                        error_found_set;
	reg                          error_found_reg;
	logic                        frame_done;
	logic                        rd_done;
    logic                        emr_done_p;
	reg                          emr_done_int;
	reg                          emr_done_r;
	
    assign frame_type = ~error_frame_is_no_shift_frame;

	
   //  ----------------------------------------------------------------------
   //   FSM State Declarations
   //  ----------------------------------------------------------------------
     
	 typedef enum logic [3:0] {
      CF_IDLE          = 4'd0  ,
      CF_WR_CACHE      = 4'd7  ,
      CF_WAIT_DONE     = 4'd8  ,
	  CF_ERROR         = 4'd9  ,
	  CF_WAIT_IDLE     = 4'd10  ,
	  CF_SF_RD_CACHE   = 4'd1  ,
	  CF_SF_STORE      = 4'd2  ,
	  CF_SF_CHECK      = 4'd3  ,
	  CF_SF_REG_CHECK  = 4'd4 ,
      CF_SF_CCHECK     = 4'd5 ,
	  CF_SF_CNT_CHECK  = 4'd6 ,
	  CF_NSF_RD_CACHE  = 4'd11 ,
	  CF_NSF_CHECK     = 4'd12 ,
	  CF_NSF_CNT_CHECK = 4'd13 
     } edcrc_ctrl_fsm;
    
    edcrc_ctrl_fsm      state; 
	edcrc_ctrl_fsm      next_state;
	 
	always @(posedge inclk or posedge reset)
      begin
        if(reset) begin
            state <= CF_IDLE;
         end else begin
            state <= next_state;
         end
    end

    always_comb begin : edcrc_ctrl_fsm_1
     next_state = state;
	 
	  case (state)
      
        CF_IDLE:
            if(crcerror_in && emr_done_int) begin
			    if (FRAME_TYPE_EN) begin 
				    if ((error_type==ERR_TYPE) && FRAME_TYPE && frame_type) 
					    next_state = CF_SF_RD_CACHE;
				    else if ((error_type==ERR_TYPE) && !FRAME_TYPE && !frame_type) 
					    next_state = CF_NSF_RD_CACHE;
					else 
					    next_state = CF_IDLE; 
                    end						
				else 
		            if (frame_type) 
                        next_state = CF_SF_RD_CACHE;
				    else 
                        next_state = CF_NSF_RD_CACHE;
			end else 
                next_state = CF_IDLE;
        // SF Exclusive
	    CF_SF_RD_CACHE:
		    if (rd_done) begin
		        if(cache_match)
				    next_state = CF_WAIT_IDLE;
			    else if (!cache_match && !previous_error)
				    next_state = CF_SF_STORE;
			    else 
				    next_state = CF_SF_CHECK;
			end	else
			    	next_state = CF_SF_RD_CACHE;
		CF_SF_STORE:
				next_state = CF_IDLE;

		CF_SF_CHECK:
		    if(frame_diff> 6) 
				next_state = CF_SF_REG_CHECK;
			else
				next_state = CF_SF_CNT_CHECK;
		
		CF_SF_REG_CHECK:
		    if (frame_wtb && curr_prev_row_match)
			    next_state = CF_SF_CCHECK;
			else 
			    next_state = CF_SF_CNT_CHECK;
				
			
        CF_SF_CCHECK:
			if (cache_full)
				next_state = CF_ERROR;
			else if(rd_segment_done) 
			    next_state = CF_WR_CACHE;
			else 
			    next_state = CF_SF_CCHECK;

		CF_SF_CNT_CHECK:
		    if(fail_count< MAX_FAIL_COUNT) 
				next_state = CF_WAIT_DONE;
			else
				next_state = CF_ERROR;

		// NSF Exclusive
	    CF_NSF_RD_CACHE:
		    if (rd_cache_done) begin 
			    if(cache_match)
				    next_state = CF_WAIT_IDLE;
			    else if (!mt30d) 
				    next_state = CF_NSF_CHECK;	
			    else 
			        next_state = CF_NSF_CNT_CHECK;
            end else
  			        next_state = CF_NSF_RD_CACHE;               			
		CF_NSF_CHECK:
		    if(!cache_full)
				next_state = CF_WR_CACHE;
			else 
				next_state = CF_ERROR;
		
		CF_NSF_CNT_CHECK:
		    if(fail_count< MAX_FAIL_COUNT) 
				next_state = CF_WAIT_DONE;
			else 
				next_state = CF_ERROR;	
		
        // NSF ends
		CF_WAIT_IDLE:
			if(frame_done)
				next_state = CF_IDLE;			
		    else next_state = CF_WAIT_IDLE;
				
		// WRITE READ ERROR
        CF_WR_CACHE:
				next_state = CF_IDLE;

		CF_WAIT_DONE:		
			if(frame_done) 
				next_state = CF_IDLE;
			else
				next_state = CF_WAIT_DONE;

		CF_ERROR:
		    if(frame_done) 
				next_state = CF_IDLE;
			else
				next_state = CF_ERROR;
								
		default: begin
			next_state =  CF_IDLE;
        end
    endcase 
end 
	 
    always @(rd_segment or wr_cache or rd_cache or crcerror_out or state) begin

		  rd_segment      = '0;
		  wr_cache        = '0;
		  rd_cache        = '0;
		  crcerror_out    = '0;		  

          case (state)
		    CF_IDLE: begin
			    wr_cache   = 1'b0;
				crcerror_out = 1'b0;
				end
			CF_WAIT_DONE: begin	
				rd_segment = 1'b0;
				end
			CF_SF_RD_CACHE: begin
			    rd_segment = 1'b1;
				rd_cache = 1'b1;
			    end
			CF_NSF_RD_CACHE:
				rd_cache = 1'b1;
			CF_WR_CACHE: begin
				wr_cache = 1'b1;
				rd_segment = 1'b0;
				end
        	CF_SF_STORE: begin
				rd_segment = 1'b0;
				rd_cache   = 1'b0; 
			    end
			CF_SF_CHECK: begin
				rd_segment = 1'b0;
                rd_cache   = 1'b0; 
				end
			CF_SF_CCHECK:
				rd_segment = 1'b1;
			CF_ERROR: begin
                crcerror_out = 1'b1;
                rd_segment   = 1'b0;
                end
		    CF_WAIT_IDLE: begin
                rd_cache   = 1'b0;
				rd_segment = 1'b0;
                end
            CF_NSF_CHECK:
				rd_cache   = 1'b0; 
            CF_NSF_CNT_CHECK:
				rd_cache   = 1'b0; 
            default: begin
            end 
          endcase 

       end 
	
// Combi Logics
     assign wr_segment = (state=='d2) | ((state=='d4) & (next_state=='d6));	 
	assign error_found_set = ((state=='d1) & ((next_state=='d2) | (next_state=='d3))) |
                             ((state=='d11) & (next_state=='d13));				 

	always @ (posedge inclk or posedge reset) begin
	    if (reset) begin
		    error_found_reg <= 1'b0;
	    end else if (clr_error_found) begin
	        error_found_reg <= 1'b0;
	    end else if (error_found_set) begin
            error_found_reg <= 1'b1;
		end
	end 
	
	always @ (posedge inclk or posedge reset) begin
	    if (reset) begin
		    emr_done_int <= 1'b0;
	    end else if (frame_done) begin
	        emr_done_int <= 1'b0;
	    end else if (emr_done_p) begin
            emr_done_int <= 1'b1;
		end
	end 
	
	always @(posedge inclk or posedge reset) begin
      if(reset) begin
	    emr_done_r <= 1'b0;   
      end else begin
		emr_done_r <= emr_done;
      end
    end
    // Posedge detect for emr_done_int
	assign emr_done_p = emr_done & ~emr_done_r; 
	assign rd_done = FRAME_TYPE? (rd_cache_done & rd_segment_done):rd_cache_done;
	assign frame_done = ~crcerror_in;
	assign edcrc_ctrlfsm_state = state;
	assign edcrc_ctrlfsm_next_state = next_state;
	assign error_found = error_found_reg;
	
endmodule   
