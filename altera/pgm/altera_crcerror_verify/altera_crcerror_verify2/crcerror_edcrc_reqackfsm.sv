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
// File name: crcerror_reqackfsm.v
// 
//
// Development of REQ ACK FSM
//

module crcerror_edcrc_reqackfsm 
#(
                  parameter                  ACT_DONE = 1'b1 
)
(
	    		  input  logic                    clk,
    		      input  logic                    reset,					  
    		      input  logic                    req,
				  output logic                    req_p,
				  input  logic                    ack_done,
				  output logic                    ack,
				  output logic                    ack_p
                  );

   // ----------------------------------------------------------------------
   //  FSM State Declarations
   // ----------------------------------------------------------------------
     typedef enum logic [3:0] {
      RA_IDLE          = 4'd0  ,
      RA_ACTIVE        = 4'd1  

     } edcrc_reqackctrl_fsm;

    edcrc_reqackctrl_fsm      state; 
	edcrc_reqackctrl_fsm      next_state;
	 
	always @(posedge clk or posedge reset)
      begin
        if(reset) begin
            state <= RA_IDLE;
         end else begin
            state <= next_state;
         end
    end

    always_comb begin : edcrc_reqackctrl_fsm_1
     next_state = state;
	 
	  case (state)
     
        RA_IDLE:
            if(req) begin
                next_state = RA_ACTIVE;
			end else
                next_state = RA_IDLE;
	    RA_ACTIVE:
		    if ((ack_done&&!ACT_DONE)|| ACT_DONE) begin
				next_state = RA_IDLE;
			end else
				next_state = RA_ACTIVE;						
		default: begin
			next_state =  RA_IDLE;
        end
        endcase 
    end 
	 
	always @(reset or state)
     if (reset)
       begin 
	   	  ack = '0;	  
       end
     else
       begin
          case (state)
		    RA_IDLE: begin
			    ack = 1'b0;
				end
			RA_ACTIVE: begin
				ack = 1'b1;
				end			
            default: begin
            end 
          endcase
       end 

	assign req_p = (state==RA_IDLE) && (next_state==RA_ACTIVE);
    assign ack_p = (state==RA_ACTIVE) && (next_state==RA_IDLE);
	
	endmodule   
