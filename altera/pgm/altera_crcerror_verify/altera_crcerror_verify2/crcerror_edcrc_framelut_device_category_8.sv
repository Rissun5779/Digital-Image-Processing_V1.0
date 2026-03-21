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

		   if (frame_in <=  708) begin framelut_addr_start =    0; framelut_addr_end = 708; end	
	  else if (frame_in <= 1116) begin framelut_addr_start =  709; framelut_addr_end = 1116; end
	  else if (frame_in <= 1786) begin framelut_addr_start = 1117; framelut_addr_end = 1786; end
	  else if (frame_in <= 2270) begin framelut_addr_start = 1787; framelut_addr_end = 2270; end
	  else if (frame_in <= 2935) begin framelut_addr_start = 2271; framelut_addr_end = 2935; end
	  else if (frame_in <= 3721) begin framelut_addr_start = 2936; framelut_addr_end = 3721; end
	  else if (frame_in <= 4134) begin framelut_addr_start = 3722; framelut_addr_end = 4134; end
	  else if (frame_in <= 4920) begin framelut_addr_start = 4135; framelut_addr_end = 4920; end
	  else if (frame_in <= 5706) begin framelut_addr_start = 4921; framelut_addr_end = 5706; end
	  else if (frame_in <= 6114) begin framelut_addr_start = 5707; framelut_addr_end = 6114; end
	  else if (frame_in <= 6905) begin framelut_addr_start = 6115; framelut_addr_end = 6905; end
	  else if (frame_in <= 7570) begin framelut_addr_start = 6906; framelut_addr_end = 7570; end
	  else if (frame_in <= 8054) begin framelut_addr_start = 7571; framelut_addr_end = 8054; end
	  else if (frame_in <= 8719) begin framelut_addr_start = 8055; framelut_addr_end = 8719; end
	  else if (frame_in <= 9132) begin framelut_addr_start = 8720; framelut_addr_end = 9132; end
	  else if (frame_in <= 9849) begin framelut_addr_start = 9133; framelut_addr_end = 9849; end	  
    
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

