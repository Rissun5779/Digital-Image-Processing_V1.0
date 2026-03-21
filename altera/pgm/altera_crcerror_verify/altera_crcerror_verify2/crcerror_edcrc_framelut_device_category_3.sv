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

		   if (frame_in <=  753) begin framelut_addr_start =    0; framelut_addr_end =  753; end	
	  else if (frame_in <= 1479) begin framelut_addr_start =  754; framelut_addr_end = 1479; end
	  else if (frame_in <= 2270) begin framelut_addr_start = 1480; framelut_addr_end = 2270; end	  
	  else if (frame_in <= 3223) begin framelut_addr_start = 2271; framelut_addr_end = 3223; end	
      else if (frame_in <= 4116) begin framelut_addr_start = 3224; framelut_addr_end = 4116; end
	  else if (frame_in <= 4947) begin framelut_addr_start = 4117; framelut_addr_end = 4947; end
	  else if (frame_in <= 5496) begin framelut_addr_start = 4948; framelut_addr_end = 5496; end
	  else if (frame_in <= 5859) begin framelut_addr_start = 5497; framelut_addr_end = 5859; end
	  else if (frame_in <= 6569) begin framelut_addr_start = 5860; framelut_addr_end = 6569; end
	  else if (frame_in <= 7462) begin framelut_addr_start = 6570; framelut_addr_end = 7462; end
	  else if (frame_in <= 8369) begin framelut_addr_start = 7463; framelut_addr_end = 8369; end
	  else if (frame_in <= 9039) begin framelut_addr_start = 8370; framelut_addr_end = 9039; end
	  else if (frame_in <= 9749) begin framelut_addr_start = 9040; framelut_addr_end = 9749; end
	  else if (frame_in <=10233) begin framelut_addr_start = 9750; framelut_addr_end = 10233; end
	  else if (frame_in <=11186) begin framelut_addr_start =10234; framelut_addr_end = 11186; end
	  else if (frame_in <=11851) begin framelut_addr_start =11187; framelut_addr_end = 11851; end
	  else if (frame_in <=12582) begin framelut_addr_start =11852; framelut_addr_end = 12582; end
	  else if (frame_in <=13344) begin framelut_addr_start =12583; framelut_addr_end = 13344; end	  
    
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

