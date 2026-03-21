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
	  else if (frame_in <= 1721) begin framelut_addr_start = 1238; framelut_addr_end = 1721; end
	  else if (frame_in <= 2498) begin framelut_addr_start = 1722; framelut_addr_end = 2498; end
	  else if (frame_in <= 3405) begin framelut_addr_start = 2499; framelut_addr_end = 3405; end
	  else if (frame_in <= 4131) begin framelut_addr_start = 3406; framelut_addr_end = 4131; end
	  else if (frame_in <= 4841) begin framelut_addr_start = 4132; framelut_addr_end = 4841; end
	  else if (frame_in <= 5325) begin framelut_addr_start = 4842; framelut_addr_end = 5325; end
	  else if (frame_in <= 6237) begin framelut_addr_start = 5326; framelut_addr_end = 6237; end
	  else if (frame_in <= 7311) begin framelut_addr_start = 6238; framelut_addr_end = 7311; end
	  else if (frame_in <= 8021) begin framelut_addr_start = 7312; framelut_addr_end = 8021; end
	  else if (frame_in <= 8505) begin framelut_addr_start = 8022; framelut_addr_end = 8505; end
	  else if (frame_in <= 8989) begin framelut_addr_start = 8506; framelut_addr_end = 8989; end
	  else if (frame_in <= 9901) begin framelut_addr_start = 8890; framelut_addr_end = 9901; end
	  else if (frame_in <=10854) begin framelut_addr_start = 9902; framelut_addr_end =10854; end
	  else if (frame_in <=11580) begin framelut_addr_start =10855; framelut_addr_end =11580; end
	  else if (frame_in <=12245) begin framelut_addr_start =11581; framelut_addr_end =12245; end
	  else if (frame_in <=12896) begin framelut_addr_start =12246; framelut_addr_end =12896; end
	  else if (frame_in <=13627) begin framelut_addr_start =12897; framelut_addr_end =13627; end
	  else if (frame_in <=14510) begin framelut_addr_start =13628; framelut_addr_end =14510; end	  
    
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

