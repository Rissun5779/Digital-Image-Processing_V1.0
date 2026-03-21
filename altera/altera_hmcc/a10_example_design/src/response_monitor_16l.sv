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


module response_monitor
(
 input               clk,
 input               rst_n,
// input                link_init_complete, 
 input logic         dp_rsp_valid,
 input logic         dp_rsp_sop,
 input logic         dp_rsp_eop,
 input logic [8:0]   dp_rsp_tag,
 input logic [2:0]   dp_rsp_size,
 input logic [5:0]   dp_rsp_cmd,
 input logic         dp_rsp_error,
 input logic [511:0] dp_rsp_data,
 output logic        response_error,
 output logic        responses_ok
 );

   enum {
      START = 1 << 0,
      TAG   = 1 << 1,
      ERROR = 1 << 2,
      SIZE_SOP_EOP  = 1 << 3,
      CMD   = 1 << 4,
      DATA0 = 1 << 5,
      DATA1 = 1 << 6,
      DATA2 = 1 << 7,
      DATA3 = 1 << 8,
      DATA4 = 1 << 9,
      DATA5 = 1 << 10,
      DATA6 = 1 << 11,
      DATA7 = 1 << 12,
      NEXT  = 1 << 13,
      FAIL  = 1 << 14,
      STOP  = 1 << 15} st_checks;
   
      localparam LAST_TRANSACTION = 8;

   typedef struct packed {
      logic       rsp_valid;
      logic [8:0] rsp_tag;
      logic [2:0] rsp_size;
      logic [5:0] rsp_cmd;
      logic       rsp_sop;
      logic       rsp_eop;
      logic       rsp_error;
      logic [511:0] rsp_data;
   } dp_response;


   dp_response expected_response;
   dp_response [15:0] actual_responses;
   dp_response actual_response;
   dp_response [0:15] expected_responses = '{ 
               //    valid tag   size    cmd     sop   eop   error data
                  '{ 1'b1, 9'd0, 3'b000, 6'h39, 1'b1, 1'b1, 1'b0, 512'h0 }, // Write 16 bytes
                  '{ 1'b1, 9'd1, 3'b000, 6'h39, 1'b1, 1'b1, 1'b0, 512'h0 }, // Write 32 bytes
                  '{ 1'b1, 9'd2, 3'b000, 6'h39, 1'b1, 1'b1, 1'b0, 512'h0 }, // Write 64 bytes
                  '{ 1'b1, 9'd3, 3'b000, 6'h39, 1'b1, 1'b1, 1'b0, 512'h0 }, // Write 128 bytes
                  '{ 1'b1, 9'd4, 3'b000, 6'h38, 1'b1, 1'b1, 1'b0, 512'h0123_0123__0123_0123___0123_0123__0123_0123 }, // Read 16 bytes
                  '{ 1'b1, 9'd5, 3'b001, 6'h38, 1'b1, 1'b1, 1'b0, 512'h4567_89AB__4567_89AB___4567_89AB__4567_89AB___4567_89AB__4567_89AB___4567_89AB__4567_89AB }, // Read 32 bytes
                  '{ 1'b1, 9'd6, 3'b011, 6'h38, 1'b1, 1'b1, 1'b0, 512'h0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF }, // Read 64 bytes
                  '{ 1'b1, 9'd7, 3'b111, 6'h38, 1'b1, 1'b0, 1'b0, 512'hFEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210___FEDC_BA98__7654_3210 }, // Read 128 bytes (1 of 2)
                  '{ 1'b1, 9'd7, 3'b111, 6'h38, 1'b0, 1'b1, 1'b0, 512'hDEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D }, // Read 128 bytes (2 of 2)
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }, // Not expected.
                  '{ 1'b0, 9'd0, 3'b000, 6'h00, 1'b0, 1'b0, 1'b0, 512'h0 }  // Not expected.
                                         };
   logic [15:0] expected_responses_used;
   logic [3:0]      response_index;
   logic [3:0]      corresponding_index;
   logic [3:0]      transaction;
   logic            check_responses;
   wire  [511:0]    data_out;

   m20k_2port received_rsp_data_mem (
      .data       ( dp_rsp_data     ),
      .wraddress  ( response_index  ),
      .rdaddress  ( transaction     ),
      .wren       ( dp_rsp_valid    ),
      .clock      ( clk             ),
      .q          ( data_out        )
   );
   
   always_ff @( posedge clk or negedge rst_n ) begin
      if( !rst_n ) begin
         response_error      <= 1'b0;
         responses_ok        <= 1'b0;
         response_index      <= 4'd0;
         transaction         <= 4'd0;
         corresponding_index <= 4'd0;
         check_responses     <= 1'b0;
         expected_responses_used <= 16'b0;
         st_checks           <= START;
         actual_response     <= 0;
         expected_response   <= 0;
         actual_responses    <= 0;
      end else begin
         // All flops keep their value by default.
         response_error      <= response_error;
         responses_ok        <= responses_ok;
         response_index      <= response_index;
         transaction         <= transaction;
         corresponding_index <= corresponding_index;
         check_responses     <= check_responses;
         st_checks           <= st_checks;
         
         
         // Capture responses.
         if( dp_rsp_valid ) begin
            actual_responses[response_index].rsp_valid <= dp_rsp_valid;
            actual_responses[response_index].rsp_tag   <= dp_rsp_tag;
            actual_responses[response_index].rsp_size  <= dp_rsp_size;
            actual_responses[response_index].rsp_cmd   <= dp_rsp_cmd;
            actual_responses[response_index].rsp_sop   <= dp_rsp_sop;
            actual_responses[response_index].rsp_eop   <= dp_rsp_eop;
            actual_responses[response_index].rsp_error <= dp_rsp_error;
            response_index <= response_index + 1'd1;
         end

         if( (response_index == LAST_TRANSACTION + 1) && transaction == 4'd0 ) begin
            check_responses <= 1'b1;
         end
         
         // Compare responses with expected values.
         case( st_checks )
            START: begin
               if( check_responses ) begin
                  actual_response.rsp_valid   <= 1'b1; // Always valid if we're checking it.
                  actual_response.rsp_tag     <= actual_responses[transaction].rsp_tag;
                  actual_response.rsp_size    <= actual_responses[transaction].rsp_size;
                  actual_response.rsp_cmd     <= actual_responses[transaction].rsp_cmd;
                  actual_response.rsp_sop     <= actual_responses[transaction].rsp_sop;
                  actual_response.rsp_eop     <= actual_responses[transaction].rsp_eop;
                  actual_response.rsp_error   <= actual_responses[transaction].rsp_error;
                  expected_response <= expected_responses[corresponding_index];
                  st_checks <= TAG;
               end
            end

            TAG:begin
               if( ~expected_responses_used[corresponding_index] &&
                   actual_response.rsp_tag == expected_response.rsp_tag ) begin
                  st_checks <= ERROR;
               end else if (corresponding_index == 15) begin
                  st_checks <= FAIL;   // No matching tag.
               end else begin
                  expected_response    <= expected_responses[corresponding_index+1];
                  corresponding_index  <= corresponding_index + 1'd1;
                  st_checks <= TAG;
               end
            end

            ERROR:begin
               if( actual_response.rsp_error == expected_response.rsp_error ) begin
                  // Not all data is needed until data comparison stage. Data transfer stage 1.
                  actual_response.rsp_data[127:0] <= data_out[127:0];
                  st_checks <= SIZE_SOP_EOP;
               end else begin
                  st_checks <= FAIL;
               end
            end
            
            SIZE_SOP_EOP:begin
               if( actual_response.rsp_size == expected_response.rsp_size &&
                   actual_response.rsp_sop  == expected_response.rsp_sop  &&
                   actual_response.rsp_eop  == expected_response.rsp_eop ) begin
                  // Data transfer stage 2.
                  actual_response.rsp_data[255:128] <= data_out[255:128];
                  st_checks <= CMD;
               end else begin
                  st_checks <= FAIL;
               end
            end
            
            CMD:begin
               if( actual_response.rsp_cmd  == expected_response.rsp_cmd ) begin
                  if( actual_response.rsp_cmd == 6'h38 ) begin // read
                     // Data transfer stage 3.
                     actual_response.rsp_data[383:256] <= data_out[383:256];
                     st_checks <= DATA0;
                  end else begin
                     st_checks <= NEXT;
                  end
               end else begin
                  st_checks <= FAIL;
               end
            end

            DATA0: begin
               if (actual_response.rsp_data[63:0] == expected_response.rsp_data[63:0] ) begin
                  // Data transfer stage 4. Data transfer done.
                  actual_response.rsp_data[511:384] <= data_out[511:384];
                  st_checks <= DATA1;
               end else begin
                  st_checks <= FAIL;
               end
            end

            DATA1: begin
               if( actual_response.rsp_data[127:64] == expected_response.rsp_data[127:64] ) begin
                  if( actual_response.rsp_size[0] ) begin
                     st_checks <= DATA2;
                  end else begin
                     st_checks <= NEXT;
                  end
               end else begin
                  st_checks <= FAIL;
               end             
            end

            DATA2: begin
               if (actual_response.rsp_data[191:128] == expected_response.rsp_data[191:128] ) begin
                  st_checks <= DATA3;
               end else begin
                  st_checks <= FAIL;
               end
            end
            

            DATA3: begin
               if( actual_response.rsp_data[255:192] == expected_response.rsp_data[255:192] ) begin
                  if( actual_response.rsp_size[1] ) begin
                     st_checks <= DATA4;
                  end else begin
                     st_checks <= NEXT;
                  end
               end else begin
                  st_checks <= FAIL;
               end             
            end
            
            DATA4: begin
               if( actual_response.rsp_data[319:256] == expected_response.rsp_data[319:256] ) begin
                  st_checks <= DATA5;
               end else begin
                  st_checks <= FAIL;
               end             
            end
            
            DATA5: begin
               if( actual_response.rsp_data[383:320] == expected_response.rsp_data[383:320] ) begin
                  st_checks <= DATA6;
               end else begin
                  st_checks <= FAIL;
               end             
            end

            DATA6: begin
               if( actual_response.rsp_data[447:384] == expected_response.rsp_data[447:384] ) begin
                  st_checks <= DATA7;
               end else begin
                  st_checks <= FAIL;
               end             
            end

            DATA7: begin
               if( actual_response.rsp_data[511:448] == expected_response.rsp_data[511:448] ) begin
                  st_checks <= NEXT;
               end else begin
                  st_checks <= FAIL;
               end             
            end
            
            NEXT: begin
               if( transaction == LAST_TRANSACTION )begin
                  st_checks   <= STOP;                       
               end else begin
                  // Indicate that this expected response matched an actual response.
                  expected_responses_used[corresponding_index] <= 1'b1;
                  transaction <= transaction + 1'd1;
                  corresponding_index <= 1'd0;
                  st_checks   <= START;
               end
            end

            FAIL: begin
               response_error <= 1'b1;
            end
            
            STOP: begin
               responses_ok <= 1'b1;
            end
         endcase
     
      end
   end
   
endmodule : response_monitor
