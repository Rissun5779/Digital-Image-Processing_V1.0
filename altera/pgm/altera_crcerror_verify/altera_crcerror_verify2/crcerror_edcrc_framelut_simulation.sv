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

		   if (frame_in <=  587) begin framelut_addr_start =    0; framelut_addr_end =  587; end	
	  else if (frame_in <= 1418) begin framelut_addr_start =  588; framelut_addr_end = 1418; end
	  else if (frame_in <= 2088) begin framelut_addr_start = 1419; framelut_addr_end = 2088; end
	  else if (frame_in <= 3055) begin framelut_addr_start = 2089; framelut_addr_end = 3055; end
	  else if (frame_in <= 4022) begin framelut_addr_start = 2056; framelut_addr_end = 4022; end
	  else if (frame_in <= 4430) begin framelut_addr_start = 4023; framelut_addr_end = 4430; end
	  else if (frame_in <= 5145) begin framelut_addr_start = 4431; framelut_addr_end = 5145; end
	  else if (frame_in <= 5741) begin framelut_addr_start = 5146; framelut_addr_end = 5741; end 
    
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

