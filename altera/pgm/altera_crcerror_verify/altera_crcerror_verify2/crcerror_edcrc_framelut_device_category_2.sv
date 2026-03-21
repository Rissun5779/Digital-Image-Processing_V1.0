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
// File name: crcerror_framelut.v
// Frame Boundary Lookup Table
// 

module crcerror_edcrc_framelut #(
			         parameter              FRAME_WIDTH = 14,  
					 parameter                  FLOP_EN = 1'b1
					 )
(                    
                     input  logic                         inclk,
					 input  logic                         reset,
					 input  logic[FRAME_WIDTH-1:0]        frame_in,     
					 output logic[FRAME_WIDTH-1:0]        framelut_addr_start,   
					 output logic[FRAME_WIDTH-1:0]        framelut_addr_end,      
					 output logic[(FRAME_WIDTH*2)-1:0]    frame_lut_entry
					 
);

logic[FRAME_WIDTH-1:0]        framelut_addr_start_i;   
logic[FRAME_WIDTH-1:0]        framelut_addr_end_i;     

function logic [(FRAME_WIDTH*2)-1:0] FRAME_LUT(
    input  logic [FRAME_WIDTH-1:0] frame_in,
	output logic [FRAME_WIDTH-1:0] framelut_addr_start,
	output logic [FRAME_WIDTH-1:0] framelut_addr_end);

	begin
	  framelut_addr_start = '0;
	  framelut_addr_end   = '0;

		   if (frame_in <=  753) begin framelut_addr_start =    0; framelut_addr_end =  753;  end
	  else if (frame_in <= 1237) begin framelut_addr_start =  754; framelut_addr_end = 1237; end
	  else if (frame_in <= 2195) begin framelut_addr_start = 1238; framelut_addr_end = 2195; end
	  else if (frame_in <= 3283) begin framelut_addr_start = 2196; framelut_addr_end = 3283; end
	  else if (frame_in <= 4114) begin framelut_addr_start = 3284; framelut_addr_end = 4114; end
	  else if (frame_in <= 4784) begin framelut_addr_start = 4115; framelut_addr_end = 4784; end
	  else if (frame_in <= 5494) begin framelut_addr_start = 4785; framelut_addr_end = 5494; end
	  else if (frame_in <= 6204) begin framelut_addr_start = 5495; framelut_addr_end = 6204; end
	  else if (frame_in <= 6869) begin framelut_addr_start = 6205; framelut_addr_end = 6869; end
	  else if (frame_in <= 7705) begin framelut_addr_start = 6870; framelut_addr_end = 7705; end	
	  else if (frame_in <= 8598) begin framelut_addr_start = 7706; framelut_addr_end = 8598; end	
	  else if (frame_in <= 9308) begin framelut_addr_start = 8599; framelut_addr_end = 9308; end	
	  else if (frame_in <= 9978) begin framelut_addr_start = 9309; framelut_addr_end = 9978; end	
	  else if (frame_in <=10740) begin framelut_addr_start = 9979; framelut_addr_end = 10740; end		  
    
	  return {framelut_addr_end, framelut_addr_start};
    end
endfunction

    always_comb  begin : frame_lut
    frame_lut_entry = FRAME_LUT(frame_in[FRAME_WIDTH-1:0], framelut_addr_start_i[FRAME_WIDTH-1:0], framelut_addr_end_i[FRAME_WIDTH-1:0]);
    end : frame_lut
	
	generate if (FLOP_EN==1) begin : flop_framelut
		crcerror_edcrc_genflp #(
        .WIDTH(FRAME_WIDTH)
        )
        edcrc_addr_start_flp( 
        .clk(inclk),
		.reset(reset),
		.in(framelut_addr_start_i),
		.inflp(framelut_addr_start)
        );	 
		crcerror_edcrc_genflp #(
        .WIDTH(FRAME_WIDTH)
        )
        edcrc_addr_end_flp( 
        .clk(inclk),
		.reset(reset),
		.in(framelut_addr_end_i),
		.inflp(framelut_addr_end)
        );	 
        end 
        else begin
	      assign framelut_addr_start =  framelut_addr_start_i;
		  assign framelut_addr_end =  framelut_addr_end_i;
        end	
	endgenerate

endmodule 

