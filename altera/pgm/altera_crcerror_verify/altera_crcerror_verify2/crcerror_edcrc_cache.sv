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
// File name: crcerror_cache.v
// 
//
// Development of Cache Structure
//

module crcerror_edcrc_cache #(
			         parameter                 ERR_TYPE = 2'b01, 
                     parameter                MAX_COUNT = 16,
					 parameter               CACHE_TYPE = 1'b0,              
					 parameter              CACHE_WIDTH = CACHE_TYPE? 44:30, 
					 parameter              MATCH_LEVEL = 1'b1,   
					 parameter              ROLLOVER_EN = 1'b0  
					 )
(                 
                     input  logic                     clk,
                     input  logic                     reset,
					 input  logic[1:0]                error_type,
					 input  logic[CACHE_WIDTH-1:0]    emr_content, 
					 input  logic                     clr_started,
					 input                            wr_cache,  
					 input                            rd_cache,  
					 input                            rd_done_in,
					 output logic                     rd_done_out,
					 output logic                     match,      
					 output logic                     cache_full,
					 output logic                     cache_empty,
					 output logic [CACHE_WIDTH-1:0]   cache_dataout,
					 output logic                     started
);

function integer CLogB2_cache;
    input [31:0] Depth;
    integer i;
    begin
        i = Depth;        
        for(CLogB2_cache = 0; i > 0; CLogB2_cache = CLogB2_cache + 1)
            i = i >> 1;
    end
endfunction

localparam              CACHE_DEPTH = MAX_COUNT;
localparam                    WIDTH = CLogB2_cache(CACHE_DEPTH);

reg[WIDTH-1:0]                        depth; 
reg[CACHE_DEPTH-1:0]                   en; 
logic                                    error_type_mtch;
logic                                    rd_cache_vld;
logic                                    rd_cache_p;
reg [CACHE_DEPTH-1:0][CACHE_WIDTH-1:0]   cache_data;
reg [CACHE_WIDTH-1:0]                    cache_dataout_o;
reg                                      rd_done_out_o;
reg                                      match_o;
reg                                      started_reg;
// NC
logic ack_nc;
logic ack_p_nc;

// Write Cache
assign error_type_mtch = (error_type==ERR_TYPE);
   always @(posedge clk or posedge reset) begin
     if (reset)
       begin
          cache_data <=  '0;
		  depth      <=  '0;
		  started_reg<= 1'b0;
		  en         <= {CACHE_DEPTH{1'b0}};
       end       
     else if (wr_cache && error_type_mtch && (!cache_full || ROLLOVER_EN))
       begin
	   started_reg <= 1'b1;
	       if (WIDTH==1) begin 
		      cache_data[depth[WIDTH-1:0]] <= emr_content;   
		      depth     <= depth;
			  en        <= en;			  
		   end else begin
		      cache_data[depth[WIDTH-1:0]] <= emr_content;
		      depth     <= depth + 1'b1;
			  en        <= {en[CACHE_DEPTH-2:0], 1'b1}; 
		   end
	   end
	 else if (clr_started) begin
         started_reg <= 1'b0;
	 end else begin
	     depth <= depth;
		 en    <= en; 	 
	 end
    end
// Cache Full & Empty Condition
assign cache_full  =  (depth==CACHE_DEPTH);
assign cache_empty =  (depth=='0);

// Read / Compare Cache 
  crcerror_edcrc_reqackfsm
 #(			  
  .ACT_DONE(1'b1)
  )
  crcerror_edcrc_reqackfsm_component
 ( .clk(clk),
   .reset(reset),
   .req(rd_cache_vld), 
   .req_p(rd_cache_p), 
   .ack_done(1'b0), 
   .ack(ack_nc), 
   .ack_p(ack_p_nc) 
 ); 

   always @(posedge clk or posedge reset) begin
	 if (reset)
       begin
          match_o <=  '0;
		  rd_done_out_o <= 1'b0;
		  cache_dataout_o <= '0;
     end else if (!rd_cache_p) begin 
	      match_o <= '0;
		  rd_done_out_o <= 1'b0;
	 end else if (rd_cache_p && ROLLOVER_EN && (WIDTH==1)) begin
             if (cache_data[0]== emr_content) begin 
               match_o <= 1'b1;
			   cache_dataout_o <= emr_content;
			 end 
			 else cache_dataout_o <= cache_data[depth[WIDTH-1:0]]; 
         rd_done_out_o <= 1'b1;
	 end else if (rd_cache_p && !ROLLOVER_EN) begin
         for (int j=0; j<CACHE_DEPTH; j++) begin
             if ((cache_data[j]== emr_content)&&(en[j]==1'b1)) begin
               match_o <= 1'b1;
			   cache_dataout_o <= emr_content;
			 end 
		 end 
         rd_done_out_o <= 1'b1;
	   end 
	 else if (rd_done_in && MATCH_LEVEL)
	   begin
	     match_o <= 1'b0; 
	   end
   end

   assign   rd_cache_vld   = rd_cache && error_type_mtch; 
   assign   match          = match_o;
   assign   rd_done_out    = rd_done_out_o;		
   assign   cache_dataout  = cache_dataout_o;
   assign   started        = started_reg;

endmodule 