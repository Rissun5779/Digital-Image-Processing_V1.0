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


module request_generator
#(
  parameter [8:0]    TAG_OFFSET = 9'd0,
  parameter          ADDRESS_OFFSET = 0
) (
 input                clk,
 input                rst_n,
 input                link_init_complete, 
 input                dp_req_ready,
 output logic         dp_req_sop,
 output logic         dp_req_eop,
 output logic [8:0]   dp_req_tag,
 output logic [2:0]   dp_req_cube,
 output logic [33:0]  dp_req_addr,
 output logic [5:0]   dp_req_cmd,
 output logic [255:0] dp_req_data,
 output logic         dp_req_valid,
 output logic         requests_ok
    );

   assign dp_req_cube = 3'b000;

   logic [4:0]        transaction;
   
   always_ff @( posedge clk or negedge rst_n ) begin
      if( !rst_n ) begin
         dp_req_sop   <=   1'b0;
         dp_req_eop   <=   1'b0;
         dp_req_cmd   <=   6'b0;
         dp_req_tag   <=   9'd0;
//       dp_req_cube  <=   3'd0;
         dp_req_addr  <=  34'h0;
         dp_req_data  <= 256'h0;
         dp_req_valid <=   1'b0;
         requests_ok  <=   1'b0;
         transaction  <= 5'd0;
      end else begin
         dp_req_cmd   <= dp_req_cmd;
         dp_req_tag   <= dp_req_tag;
//       dp_req_cube  <= dp_req_cube;
         dp_req_addr  <= dp_req_addr;
         dp_req_data  <= dp_req_data;
         dp_req_valid <= dp_req_valid;
         requests_ok  <= requests_ok;
         transaction  <= transaction;
         
         if( link_init_complete && !requests_ok && dp_req_ready ) begin
            transaction  <= transaction + 1'd1;
            
            case ( transaction )
               0: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b01000;   // Write16B
                  dp_req_tag   <=   9'd0 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h000 + ADDRESS_OFFSET;
                  dp_req_data  <= 256'h0123_0123__0123_0123___0123_0123__0123_0123;
                  dp_req_valid <=   1'b1;
               end
               
               1: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               2: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b001001;   // Write32B
                  dp_req_tag   <=   9'd1 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h100 + ADDRESS_OFFSET;
                  dp_req_data  <= 256'h4567_89AB__4567_89AB___4567_89AB__4567_89AB___4567_89AB__4567_89AB___4567_89AB__4567_89AB;
                  dp_req_valid <=   1'b1;
               end
               
               3: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               4: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b0;
                  dp_req_cmd   <=   6'b001011;   // Write64B
                  dp_req_tag   <=   9'd2 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h200 + ADDRESS_OFFSET;
                  // First 32B
                  dp_req_data  <= 256'h0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF___0123_4567__89AB_CDEF;
                  dp_req_valid <=   1'b1;
               end
               
               5: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b1;
                  // Last 32B
                  dp_req_data  <= 256'hFDEC_BA98__7654_3210___FEDC_BA98__7654_3210___FDEC_BA98__7654_3210___FEDC_BA98__7654_3210;
                  dp_req_valid <=   1'b1;
               end

               6: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               7: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b0;
                  dp_req_cmd   <=   6'b001111;   // Write128B
                  dp_req_tag   <=   9'd3 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h300 + ADDRESS_OFFSET;
                  // First 32B
                  dp_req_data  <= 256'h0246_8ACE__1357_9BDF___0246_8ACE__1357_9BDF___0246_8ACE__1357_9BDF___0246_8ACE__1357_9BDF;
                  dp_req_valid <=   1'b1;
               end
               
               8: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  // Next 32B
                  dp_req_data  <= 256'hFDB0_7531__ECA8_6420___FDB0_7531__ECA8_6420___FDB0_7531__ECA8_6420___FDB0_7531__ECA8_6420;
                  dp_req_valid <=   1'b1;
               end
               
               9: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  // Next 32B
                  dp_req_data  <= 256'hDEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D___DEAD_BEEF__1337_F00D;
                  dp_req_valid <=   1'b1;
               end
               
               10: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b1;
                  // Last 32B
                  dp_req_data  <= 256'h0ECE_2014__0175_ECE1___0ECE_2014__0175_ECE1___0ECE_2014__0175_ECE1___0ECE_2014__0175_ECE1;
                  dp_req_valid <=   1'b1;
               end
               
               11: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               12: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b110000;   // Read16B
                  dp_req_tag   <=   9'd4 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h000 + ADDRESS_OFFSET;
                  dp_req_valid <=   1'b1;
               end
               
               13: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               14: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b110001;   // Read32B
                  dp_req_tag   <=   9'd5 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h100 + ADDRESS_OFFSET;
                  dp_req_valid <=   1'b1;
               end
               
               15: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               16: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b110011;   // Read64B
                  dp_req_tag   <=   9'd6 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h200 + ADDRESS_OFFSET;
                  dp_req_valid <=   1'b1;
               end
               
               17: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
               end
               
               18: begin
                  dp_req_sop   <=   1'b1;
                  dp_req_eop   <=   1'b1;
                  dp_req_cmd   <=   6'b110111;   // Read128B
                  dp_req_tag   <=   9'd7 + TAG_OFFSET; 
                  dp_req_addr  <=  34'h300 + ADDRESS_OFFSET;
                  dp_req_valid <=   1'b1;
               end
               
               19: begin
                  dp_req_sop   <=   1'b0;
                  dp_req_eop   <=   1'b0;
                  dp_req_valid <=   1'b0;
                  requests_ok  <= 1'b1;
               end
               
            endcase
         end     
      end
   end
   
endmodule : request_generator
