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


//-------------------------------------------------------------------
// Filename    : byte_order.v
//
// Description : performs byte ordering for x2 and x4 width modes.
// First look for an align byte (as specified by user) and 
// determine its byte position in the pld_pcs interface data. Next, based
// on the byte position, add pad characters and declare byte ordering done
// Algorithm borrowed from Stratix II GX handbook description of byte ordering
// block
//
// Accounts for all x2 and x4 cases for the following PLD/PCS and PMA/PCS combinations:
//
//  ---------------------------------------------------------------------------------
//     pld  |                             pma-pcs width                             |     
//     pcs  -------------------------------------------------------------------------
//    width |       8         |       10        |       16        |       20        |
//  ---------------------------------------------------------------------------------  
//     8    |      x1         |      x1         |       -         |       -         |        
//          |                 |     8b/10b      |                 |                 |
//  ---------------------------------------------------------------------------------
//     10   |      -          |      x1         |       -         |       -         |        
//          |                 |                 |                 |                 |
//  ---------------------------------------------------------------------------------
//     16   |      x2         |      x2         |       x1        |       x1        |        
//          |                 |     8b/10b      |                 |      8b/10b     |
//  ---------------------------------------------------------------------------------
//     20   |      -          |      x2         |       -         |       x1        |        
//          |                 |                 |                 |                 |
//  ---------------------------------------------------------------------------------
//     32   |      x4         |      x4         |       x2        |       x2        |        
//          |                 |     8b/10b      |                 |      8b/10b     |
//  ---------------------------------------------------------------------------------
//     40   |      -          |      x4         |       -         |       x2        |        
//          |                 |                 |                 |                 |
//  ---------------------------------------------------------------------------------
// e.g. expected data
//
// time --------------------------->
// msb->  bc | bc | 2e | 16 | 33
// lsb->  1c | 1c | 7f | 7f | c3
// depending on byte serializer reset, some lsb bytes may spill over to
// the next word. assume data is always filled LSB to MSB. This may result
// in a pattern as follows:
//
// time --------------------------->
// msb->  1c | 1c | 7f | 7f | c3
// lsb->  bc | bc | bc | 2e | 16 ...
//        W0   W1   W2   W3   W4
//
// the issue is fixed as follows:
// a. moving msb of W0 to lsb of W1 and 
// b. moving lsb of W1 to msb of W1

//
// Limitation  : -
//
// Authors     : dunnikri
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------
module byte_order #
(
    parameter ALIGN_BYTE    = 8'hbc,
	parameter PLD_PCS_WIDTH = 16,
	parameter PMA_PCS_WIDTH =  8,
	parameter SER_FACTOR    =  2
) (
	input  wire                                 clk,
	input  wire                                 reset,
	input  wire                                 start_byte_order,
	input  wire [PLD_PCS_WIDTH-1:0]             parallel_data_in,
	output reg  [PLD_PCS_WIDTH-1:0]             parallel_data_out,
	output reg									byte_order_aligned
);
    //calculate log2
    function integer log2;
        input integer number;
        begin
            log2=0;
            while(2**log2<number) begin
                log2=log2+1;
            end
        end
    endfunction // log2

	//localparams
    localparam NUM_STATES    = 3;
	localparam IDLE          = 0;
	localparam BYTE_ORDER    = 1;
	localparam DONE          = 2;
	localparam NUM_LANES     = SER_FACTOR;
	localparam BITS_PER_LANE = PLD_PCS_WIDTH/SER_FACTOR;
	                                             
	reg byte_order_aligned_next;
	
    //separate pld pcs data bus into byte lanes - lower lanes hold lower bits	
	wire [BITS_PER_LANE-1:0]         lane[NUM_LANES];
	genvar i;
	generate
	    for(i=0;i<NUM_LANES;i=i+1) begin:lanes
            assign lane[i] = parallel_data_in[BITS_PER_LANE*(i+1)-1:BITS_PER_LANE*i];
	    end
    endgenerate


    //find the lane that matches the lower byte or lower 10 bits (if 8b/10b=1)    
	wire [log2(PLD_PCS_WIDTH)-1:0]   match_bit_pos;
	reg  [log2(PLD_PCS_WIDTH)-1:0]   match_pos_sel;
	reg  [log2(PLD_PCS_WIDTH)-1:0]   match_pos_sel_next;
	wire                             lane_match_done;
	
	generate
        if(SER_FACTOR==2) begin
            assign match_bit_pos = (lane[0]==ALIGN_BYTE)? (BITS_PER_LANE*0):
                                   (lane[1]==ALIGN_BYTE)? (BITS_PER_LANE*1):
								                          {log2(NUM_LANES){1'bx}};

	        assign lane_match_done = (lane[0]==ALIGN_BYTE)|
			                         (lane[1]==ALIGN_BYTE);
		end

        if(SER_FACTOR==4) begin
            assign match_bit_pos = (lane[0]==ALIGN_BYTE)?  (BITS_PER_LANE*0):
                                   (lane[1]==ALIGN_BYTE)?  (BITS_PER_LANE*1):
                                   (lane[2]==ALIGN_BYTE)?  (BITS_PER_LANE*2):
                                   (lane[3]==ALIGN_BYTE)?  (BITS_PER_LANE*3):
								                           {log2(PLD_PCS_WIDTH){1'bx}};

	        assign lane_match_done = (lane[0]==ALIGN_BYTE)|
			                         (lane[1]==ALIGN_BYTE)|
									 (lane[2]==ALIGN_BYTE)|
									 (lane[3]==ALIGN_BYTE);
		end
    endgenerate

    //register incoming data for cycle to cycle comparisons
    reg  [PLD_PCS_WIDTH-1:0]     data_reg;
	wire [PLD_PCS_WIDTH-1:0]     ord_bytes;
	wire [PLD_PCS_WIDTH-1:0]     lo_bits;
	wire [PLD_PCS_WIDTH-1:0]     hi_bits;
	wire [PLD_PCS_WIDTH-1:0]     mask;
	wire [PLD_PCS_WIDTH-1:0]     pad_bits;
	    
	always@(posedge clk) begin
		data_reg          <= parallel_data_in;
		parallel_data_out <= ord_bytes;
	end

	//generate an ordering of data based on where the align byte was found
	assign mask      = ~0;
	
	assign pad_bits  = (PLD_PCS_WIDTH-match_pos_sel); 
	assign hi_bits   = (parallel_data_in<<pad_bits); //make room for lsb bits to be moved in
	assign lo_bits   = (data_reg>>(PLD_PCS_WIDTH-pad_bits));//fill in lsb bits from msb bits of prev word
	assign ord_bytes = hi_bits|lo_bits; 

	//byte ordering state machine (determine byte order complete)
    reg [log2(NUM_STATES)-1:0]  state;
    reg [log2(NUM_STATES)-1:0]  state_next;
	
	always@(*) begin
        state_next              = state;
		byte_order_aligned_next = byte_order_aligned;
		match_pos_sel_next      = match_pos_sel;

		case(state)
			IDLE: begin
				if(start_byte_order) begin 
					state_next = BYTE_ORDER;
				end
			end

			BYTE_ORDER: begin
				if(lane_match_done) begin
					match_pos_sel_next = match_bit_pos;
                    state_next = DONE;
				end
			end

			DONE: begin
				 if(!start_byte_order) begin
                     state_next = IDLE;
				 end
				 else begin
                     byte_order_aligned_next = 1;
				 end
			end
		endcase	
	end


	always@(posedge clk) begin
        if(reset) begin
            state              <= IDLE;
			byte_order_aligned <= 0;
			match_pos_sel      <= 0;
		end
		else begin
            state              <= state_next;
			byte_order_aligned <= byte_order_aligned_next;
			match_pos_sel      <= match_pos_sel_next;
		end
	end
endmodule
