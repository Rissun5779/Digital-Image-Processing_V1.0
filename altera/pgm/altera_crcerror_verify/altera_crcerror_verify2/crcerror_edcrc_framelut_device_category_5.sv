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

		   if (frame_in <=  829) begin framelut_addr_start =    0; framelut_addr_end =  829; end	
	  else if (frame_in <= 1358) begin framelut_addr_start =  830; framelut_addr_end = 1358; end
	  else if (frame_in <= 1963) begin framelut_addr_start = 1359; framelut_addr_end = 1963; end
	  else if (frame_in <= 2619) begin framelut_addr_start = 1964; framelut_addr_end = 2619; end
	  else if (frame_in <= 3103) begin framelut_addr_start = 2620; framelut_addr_end = 3103; end
	  else if (frame_in <= 3768) begin framelut_addr_start = 3104; framelut_addr_end = 3768; end
	  else if (frame_in <= 4373) begin framelut_addr_start = 3769; framelut_addr_end = 4373; end
	  else if (frame_in <= 5038) begin framelut_addr_start = 4374; framelut_addr_end = 5038; end
	  else if (frame_in <= 5522) begin framelut_addr_start = 5039; framelut_addr_end = 5522; end
	  else if (frame_in <= 6173) begin framelut_addr_start = 5023; framelut_addr_end = 6173; end
	  else if (frame_in <= 6843) begin framelut_addr_start = 6174; framelut_addr_end = 6843; end
	  else if (frame_in <= 7448) begin framelut_addr_start = 6844; framelut_addr_end = 7448; end
	  else if (frame_in <= 8234) begin framelut_addr_start = 7449; framelut_addr_end = 8234; end
	  else if (frame_in <= 9020) begin framelut_addr_start = 8235; framelut_addr_end = 9020; end
	  else if (frame_in <= 9671) begin framelut_addr_start = 9021; framelut_addr_end = 9671; end
	  else if (frame_in <=10276) begin framelut_addr_start = 9672; framelut_addr_end =10276; end
	  else if (frame_in <=10946) begin framelut_addr_start =10277; framelut_addr_end =10946; end
	  else if (frame_in <=11551) begin framelut_addr_start =10947; framelut_addr_end =11551; end
	  else if (frame_in <=11959) begin framelut_addr_start =11552; framelut_addr_end =11959; end
	  else if (frame_in <=12443) begin framelut_addr_start =11960; framelut_addr_end =12443; end
	  else if (frame_in <=13048) begin framelut_addr_start =12444; framelut_addr_end =13048; end
	  else if (frame_in <=13713) begin framelut_addr_start =13049; framelut_addr_end =13713; end
	  else if (frame_in <=14378) begin framelut_addr_start =13714; framelut_addr_end =14378; end
	  else if (frame_in <=14988) begin framelut_addr_start =14379; framelut_addr_end =14988; end	 
	  else if (frame_in <=15517) begin framelut_addr_start =14989; framelut_addr_end =15517; end
	  else if (frame_in <=16355) begin framelut_addr_start =15518; framelut_addr_end =16355; end	
    
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

