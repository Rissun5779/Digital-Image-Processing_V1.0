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


//This is a special test stage designed to test whether a failure is a read or a write failure
//during burst operations. A special test is needed for this since the traffic driver is limited
//in that for burst operations it cannot perform multiple read bursts to a single write burst and 
//correctly check the returned data.
//This is a 2 step test which first performs a set of write bursts, followed by a set of read bursts
//If there are no failures the test passes and completes
//Should there be failures, the address of the first is collected from the status checker, and 10
//consecutive single reads are performed from this address. As we are now performing single reads, the
//status checker can accurately report whether  a read or write failure is occurring.

module altera_emif_avl_tg_2_multiread_burst_test_stage #(
   parameter NUMBER_OF_DATA_GENERATORS    = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS = "",
   parameter DATA_PATTERN_LENGTH          = "",
   parameter MEM_ADDR_WIDTH               = ""
)(
   input                      clk,
   input                      rst,
   input                      enable,
   input                      amm_cfg_waitrequest,
   output logic [9:0]         amm_cfg_address,
   output logic [31:0]        amm_cfg_writedata,
   output logic               amm_cfg_write,
   output logic               amm_cfg_read,
   //bring in the failure report from the status checker, so that it can be used in multi step tests
   //with multiple runs of the traffic generator
   input                      stage_failure,
   input [MEM_ADDR_WIDTH-1:0] first_fail_addr,
   //output the final result at the end of all runs of the test stage
   output logic               traffic_gen_fail,
   output                     stage_complete

   );
   
   import avl_tg_defs::*;
   
   
   // Config states definition
   typedef enum int unsigned {
      INIT, INIT_2,
      DONE, DONE_1, TEST_IN_PROG,
      CFG1, CFG2, CFG3, CFG4, CFG5, CFG6, CFG7, CFG8, CFG9, CFG10, CFG11, CFG12, CFG13,
      CFG1_2, CFG2_2, CFG3_2, CFG4_2, CFG5_2, CFG6_2, CFG7_2, CFG8_2      
   } cfg_state_t;
   
   cfg_state_t state;
   logic [ceil_log2(NUMBER_OF_DATA_GENERATORS)-1:0] data_gen_cfg_cnt;
   logic [ceil_log2(NUMBER_OF_BYTE_EN_GENERATORS)-1:0] be_gen_cfg_cnt;
   
   //sequential outputs because we're lazy and now only need to drive values that change at each state
   always_ff @(posedge clk)
   begin
      if (rst) begin
         state            <= INIT;
         amm_cfg_write    <= 1'b0;
         amm_cfg_read     <= 1'b0;
         amm_cfg_address  <= 10'h0;
         amm_cfg_writedata <= 32'h0;
         traffic_gen_fail <= '0;
      end 
      else begin

         case (state)
            INIT:
            begin
               amm_cfg_write        <= 1'b0;
               amm_cfg_read         <= 1'b0;
               amm_cfg_address      <= 10'h0;
               amm_cfg_writedata    <= 32'h0;
               data_gen_cfg_cnt     <= '0;
               be_gen_cfg_cnt       <= '0;
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  state <= CFG1;
               end
            end
            
            //configuration command states --not all configurations might have an affect 
            
            //write addr generator        
            CFG1:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= 10'h0_3_1; //address gen mode
               amm_cfg_writedata  <= 32'h0; //1<=sequential, 0 = rand, 2= rand_seq, 3 = 1-hot 
               state              <= CFG2;
            end 
            
            //read address generator
            CFG2:
            begin
               amm_cfg_address    <= 10'h0_3_E; //address gen mode
               amm_cfg_writedata  <= 32'h0; //1<=sequential, 0 = rand, 2= rand_seq, 3 = 1-hot
               state              <= CFG3;
            end
            
            //data generators (seed)          
            CFG3:
            begin
               //configure remaining all data generators
                if (data_gen_cfg_cnt < NUMBER_OF_DATA_GENERATORS) begin
                  amm_cfg_address                              <= 10'h1_0_0 + data_gen_cfg_cnt;
                  amm_cfg_writedata[DATA_PATTERN_LENGTH-1:0]   <= data_gen_cfg_cnt;  //seed
                  data_gen_cfg_cnt                             <= data_gen_cfg_cnt + 1'b1;
               end 
               else begin
                  state              <= CFG4;
                  data_gen_cfg_cnt   <= '0;
               end
            end
            
            //data generators (mode) 
            CFG4:
            begin
               //configure remaining all data generators
                if (data_gen_cfg_cnt < NUMBER_OF_DATA_GENERATORS) begin
                  amm_cfg_address                              <= 10'h2_0_0 + data_gen_cfg_cnt;
                  amm_cfg_writedata[1:0]                       <= 2'b00 ;  //no inversion & prbs
                  data_gen_cfg_cnt                             <= data_gen_cfg_cnt + 1'b1;
               end 
               else begin
                  state              <= CFG5; 
                  data_gen_cfg_cnt   <= '0;
               end
            end
            
             //byte en generators (seed)
            CFG5:
            begin
               //configure remaining all be generators -> all enabled
               if (be_gen_cfg_cnt < NUMBER_OF_BYTE_EN_GENERATORS) begin
                  amm_cfg_address                            <= 10'h1_A_0 + be_gen_cfg_cnt;
                  amm_cfg_writedata[DATA_PATTERN_LENGTH-1:0] <= '1 ;  //seed
                  be_gen_cfg_cnt                             <= be_gen_cfg_cnt + 1'b1;
               end 
               else begin
                  state              <= CFG6;
                  be_gen_cfg_cnt     <= '0;
               end
            end
            
             //byte en generators (mode)
            CFG6:
            begin
               //configure remaining all be generators -> all enabled
               if (be_gen_cfg_cnt < NUMBER_OF_BYTE_EN_GENERATORS) begin
                  amm_cfg_address                            <= 10'h2_A_0 + be_gen_cfg_cnt;
                  amm_cfg_writedata[1:0]                     <= 2'b01 ;  //no inversion deterministic
                  be_gen_cfg_cnt                             <= be_gen_cfg_cnt + 1'b1;
               end 
               else begin 
                  state              <= CFG7;
                  be_gen_cfg_cnt     <= '0;
               end
            end
            
             //r/w generator
            CFG7:
            begin  
               amm_cfg_address   <= 10'h0_0_1; //loop count
               amm_cfg_writedata <= 1'b1;
               state             <= CFG8;
            end
            
            CFG8:
            begin  
               amm_cfg_address   <= 10'h0_0_2; //write count
               amm_cfg_writedata <= 32'h4;
               state             <= CFG9;
            end
            
            CFG9:
            begin  
               amm_cfg_address   <= 10'h0_0_3; //read count
               amm_cfg_writedata <= 32'h4;
               state             <= CFG10;
            end
            CFG10:
            begin  
               amm_cfg_address   <= 10'h0_0_4; //write rpt count
               amm_cfg_writedata <= 32'h1;
               state             <= CFG11;
            end
            CFG11:
            begin  
               amm_cfg_address   <= 10'h0_0_5; //read rpt count
               amm_cfg_writedata <= 32'h1;
               state             <= CFG12;
            end
            CFG12:
            begin  
               amm_cfg_address   <= 10'h0_0_6; //burst length
               amm_cfg_writedata <= 32'h3;
               state             <= CFG13;
            end
                        
            CFG13:
            begin  
               amm_cfg_address   <= 10'h0_0_0; //start
               amm_cfg_writedata <= 32'h2; //
               state             <= DONE_1;
            end  
            
            DONE_1:  //done issuing configurations, test running in progress
            begin  
               amm_cfg_write   <= 1'b0;
               state           <= INIT_2;               
            end
            
            INIT_2:
            begin
               data_gen_cfg_cnt    <= '0;
               be_gen_cfg_cnt      <= '0;
               // Standby until this stage is signaled to start

               if (~amm_cfg_waitrequest) begin //once all previous operations complete
                  if (stage_failure) begin 
                     state <= CFG1_2;  //failures, need to check if read or write
                  end
                  else begin
                     state <= DONE; //no failures
                  end     
               end
            end
            
              //configuration command states
            
            //read address generator
            CFG1_2:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= 10'h0_3_D; //seq start addr
               amm_cfg_writedata  <= first_fail_addr; //start addr
               state              <= CFG2_2;
            end
            CFG2_2:
            begin
               amm_cfg_address    <= 10'h0_3_E; //address gen mode
               amm_cfg_writedata  <= 32'h1; //1<=sequential, 0 = rand, 2= rand_seq, 3 = 1-hot
               state              <= CFG3_2;
            end
                        
             //r/w generator
             
             //loop count stays at 1
             
            CFG3_2:
            begin  
               amm_cfg_address   <= 10'h0_0_2; //write count
               amm_cfg_writedata <= 32'h0;
               state             <= CFG4_2;
            end
            CFG4_2:
            begin  
               amm_cfg_address   <= 10'h0_0_3; //read count
               amm_cfg_writedata <= 32'h1;
               state             <= CFG5_2;
            end
            
            //no burst -> single reads
            CFG5_2:
            begin  
               amm_cfg_address   <= 10'h0_0_6; //burst count
               amm_cfg_writedata <= 32'h1;
               state             <= CFG6_2;
            end
            
            CFG6_2:  //duplicate reads
            begin  
               amm_cfg_address   <= 10'h0_0_5; //read rpt count
               amm_cfg_writedata <= 32'ha;     //repeat the burst 10 times
               state             <= CFG7_2;
            end
            CFG7_2:
            begin  
               amm_cfg_address   <= 10'h0_0_0; //start
               amm_cfg_writedata <= 32'h2; //
               state             <= CFG8_2;
            end  
            
            CFG8_2: //extra cycle required during which the traffic generator starts and ready drops
            begin  
               amm_cfg_write     <= 1'b0;
               state             <= TEST_IN_PROG;
            end  

            TEST_IN_PROG:
            begin  
               amm_cfg_write   <= 1'b0;
               //wait until the whole test is completed running in the traffic generator
               //this makes sure we stay in this test STAGE the whole duration (for stage specific params)
               if (~amm_cfg_waitrequest) begin
                  state <= DONE;
                  //assign the overall failure result
                  //the status checker handles passes
                  //as well as whether a failure is read or write
                  traffic_gen_fail <= stage_failure;
               end
            end
            
            DONE:
            begin  
               state <= INIT;
            end

         endcase
      end
   end
   
   // Status outputs
   assign stage_complete = (state == DONE);
   
endmodule



