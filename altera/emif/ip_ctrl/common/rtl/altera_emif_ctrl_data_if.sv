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


//////////////////////////////////////////////////////////////////////////////
// The data interface module controls the Avalon interface by accepting
// requests when the controller is ready, and putting the Avalon bus into a
// wait state when the controller is busy by deasserting 'avl_ready'.  This
// module also breaks Avalon bursts into individual memory requests by
// generating sequential addresses for each beat of the burst.
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module altera_emif_ctrl_data_if # (
   // Avalon interface parameters
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH     = 1,
   parameter PORT_CTRL_AMM_BCOUNT_WIDTH      = 1,
   parameter PORT_CTRL_AMM_BYTEEN_WIDTH      = 1,
   parameter PORT_CTRL_AMM_DATA_WIDTH        = 1,
   
   parameter PORT_CTRL_BEATADDER_WIDTH       = 1,
   parameter CTRL_BE_EN                      = 1,
   parameter CTRL_BL                         = 1,
   parameter PROTOCOL_ENUM                   = ""
) (
   // Clock and reset interface
   input    logic                                     clk,
   input    logic                                     reset_n,
   
   // PHY initialization and calibration status
   input    logic                                     init_complete,
   input    logic                                     init_fail,
   output   logic                                     local_init_done,
   
   // Avalon data slave interface
   output   logic                                     avl_ready,
   input    logic                                     avl_write_req,
   input    logic                                     avl_read_req,
   input    logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   avl_addr,
   input    logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]    avl_size,
   input    logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]    avl_be,
   input    logic [PORT_CTRL_AMM_DATA_WIDTH-1:0]      avl_wdata,
   output   logic                                     avl_rdata_valid,
   output   logic [PORT_CTRL_AMM_DATA_WIDTH-1:0]      avl_rdata,

   // User interface module signals
   // CMD0 registered signals
   output   logic                                     cmd0_write_req,
   output   logic                                     cmd0_read_req,
   output   logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   cmd0_addr,
   output   logic                                     cmd0_addr_can_merge,
   
   // CMD1 registered signals
   output   logic                                     cmd1_write_req,
   output   logic                                     cmd1_read_req,
   output   logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   cmd1_addr,
   output   logic                                     cmd1_addr_can_merge,
   output   logic [PORT_CTRL_AMM_DATA_WIDTH-1:0]      cmd1_wdata,
   output   logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]    cmd1_be,
   output   logic                                     wdata_valid,
   output   logic [PORT_CTRL_AMM_DATA_WIDTH-1:0]      wdata,
   output   logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]    be,
   input    logic                                     rdata_valid,
   input    logic [PORT_CTRL_AMM_DATA_WIDTH-1:0]      rdata,

   // Write or read command issued by the state machine
   input    logic                                     pop_req
);

   // FSM states
   enum int unsigned {
      RESET_STATE,
      INIT,
      NORMAL,
      WRITE_BURST,
      READ_BURST
   } state;

   // CMD1 registered signals
   reg [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]   beats_left;
   logic                                  next_cmd1_addr_can_merge;

   // Wires
   wire                                   avl_valid;
   wire                                   cmd0_valid;
   wire                                   cmd1_valid;
   wire                                   shift_cmd1_to_cmd0;

   // burst_addr is the address of the current pending command with the beat addrress masked out
   // beat_addr is the beat address of the current pending command
   wire    [PORT_CTRL_AMM_ADDRESS_WIDTH-PORT_CTRL_BEATADDER_WIDTH-1:0]  avl_burst_addr;
   wire    [PORT_CTRL_BEATADDER_WIDTH-1:0]                              avl_beat_addr;
   wire    [PORT_CTRL_AMM_ADDRESS_WIDTH-PORT_CTRL_BEATADDER_WIDTH-1:0]  last_valid_burst_addr;
   wire    [PORT_CTRL_BEATADDER_WIDTH-1:0]                              last_valid_beat_addr;

   reg                                                                  last_valid_write_req;
   reg                                                                  last_valid_read_req;
   reg     [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]                            last_valid_addr;

   assign local_init_done           = init_complete & ~init_fail;
   
   generate
      // Command valid
      if (PROTOCOL_ENUM == "PROTOCOL_QDR2" || PROTOCOL_ENUM == "PROTOCOL_RLD2")
         assign cmd1_valid = cmd1_write_req ^ cmd1_read_req;
      
      if (CTRL_BL > 1)
      begin
         assign avl_burst_addr            = avl_addr[PORT_CTRL_AMM_ADDRESS_WIDTH-1:PORT_CTRL_BEATADDER_WIDTH];
         assign avl_beat_addr             = avl_addr[PORT_CTRL_BEATADDER_WIDTH-1:0];
         assign last_valid_burst_addr     = last_valid_addr[PORT_CTRL_AMM_ADDRESS_WIDTH-1:PORT_CTRL_BEATADDER_WIDTH];
         assign last_valid_beat_addr      = last_valid_addr[PORT_CTRL_BEATADDER_WIDTH-1:0];
         
         assign avl_valid = avl_write_req ^ avl_read_req;
      end
      else
         assign avl_valid = '0;

      if (PROTOCOL_ENUM == "PROTOCOL_RLD2")
      begin
         assign cmd0_valid = cmd0_write_req ^ cmd0_read_req;
         assign shift_cmd1_to_cmd0 = ~cmd0_valid | pop_req;
      end
      else
      begin
         assign shift_cmd1_to_cmd0 = '0;
      end

      // Connect Avalon signals
      assign avl_rdata_valid = rdata_valid && init_complete;
      assign avl_rdata = rdata;
      if (PROTOCOL_ENUM == "PROTOCOL_QDR2")
      begin
         assign avl_ready = (reset_n) & (state == NORMAL | state == WRITE_BURST) & ~(cmd1_valid & ~pop_req) & (local_init_done);
         assign wdata_valid = '0;
         assign wdata = '0;
         assign be = '0;
      end
      else if (PROTOCOL_ENUM == "PROTOCOL_RLD2")
      begin
         assign avl_ready = (reset_n) & (state == NORMAL | state == WRITE_BURST) & ~(cmd1_valid & cmd0_valid & ~pop_req) & (local_init_done);
         assign wdata_valid = avl_ready & avl_write_req & ~avl_read_req;
         assign wdata = avl_wdata;
         
         if (CTRL_BE_EN != 0)
            assign be = avl_be;
         else
            assign be = '0;
      end
      else
      begin
         assign avl_ready = 1'b1;
         assign wdata_valid = '0;
         assign wdata = '0;
         assign be = '0;
      end

      if (CTRL_BL > 1)
      begin
         always_comb
         begin
            case (state)
               RESET_STATE:
                   next_cmd1_addr_can_merge <= (avl_write_req == last_valid_write_req) &
                                               (avl_read_req == last_valid_read_req) &
                                               (avl_burst_addr == last_valid_burst_addr) &
                                               (avl_beat_addr > last_valid_beat_addr);
                INIT:
                   next_cmd1_addr_can_merge <= (avl_write_req == last_valid_write_req) &
                                               (avl_read_req == last_valid_read_req) &
                                               (avl_burst_addr == last_valid_burst_addr) &
                                               (avl_beat_addr > last_valid_beat_addr);
                NORMAL:
                   next_cmd1_addr_can_merge <= (avl_write_req == last_valid_write_req) &
                                               (avl_read_req == last_valid_read_req) &
                                               (avl_burst_addr == last_valid_burst_addr) &
                                               (avl_beat_addr > last_valid_beat_addr);
                WRITE_BURST:
                   next_cmd1_addr_can_merge <= ~(&cmd1_addr[PORT_CTRL_BEATADDER_WIDTH-1:0]);
                READ_BURST:
                   next_cmd1_addr_can_merge <= ~(&cmd1_addr[PORT_CTRL_BEATADDER_WIDTH-1:0]);
            endcase
         end
      end
      else
         assign next_cmd1_addr_can_merge = '0;

      if (PROTOCOL_ENUM == "PROTOCOL_RLD2")
      begin
         // Shift cmd1 to cmd0
         always_ff @(posedge clk, negedge reset_n)
         begin
            if (!reset_n)
            begin
               cmd0_write_req <= '0;
               cmd0_read_req <= '0;
               cmd0_addr <= '0;
               cmd0_addr_can_merge <= '0;
            end
            else
            begin
               if (shift_cmd1_to_cmd0)
               begin
                  cmd0_write_req <= cmd1_write_req;
                  cmd0_read_req <= cmd1_read_req;
                  cmd0_addr <= cmd1_addr;
                  cmd0_addr_can_merge <= cmd1_addr_can_merge;
               end
            end
         end
      end
      else 
      begin
         assign cmd0_write_req = '0;
         assign cmd0_read_req = '0;
         assign cmd0_addr = '0;
         assign cmd0_addr_can_merge = '0;
      end
   endgenerate

   // Avalon signal capturing state machine
   always_ff @(posedge clk, negedge reset_n)
   begin
      if (!reset_n) begin
         state <= RESET_STATE;
         cmd1_write_req <= '0;
         cmd1_read_req <= '0;
         cmd1_addr <= '0;
         cmd1_addr_can_merge <= '0;
         beats_left <= '0;
         
         if (CTRL_BL > 1)
         begin
            last_valid_write_req <= '0;
            last_valid_read_req <= '0;
            last_valid_addr <= '0;
         end
      end
      else
      begin

         state <= state;
         cmd1_write_req <= cmd1_write_req;
         cmd1_read_req <= cmd1_read_req;
         cmd1_addr <= cmd1_addr;
         cmd1_addr_can_merge <= cmd1_addr_can_merge;
         beats_left <= beats_left;
         
         if (CTRL_BL > 1)
         begin
            last_valid_write_req <= last_valid_write_req;
            last_valid_read_req <= last_valid_read_req;
            last_valid_addr <= last_valid_addr;
         end

         case (state)
            RESET_STATE:
               begin
                  state <= INIT;
               end

            INIT:
               begin
                  cmd1_addr <= '0;
                  cmd1_wdata <= '0;
                  cmd1_be <= '0;
                  beats_left <= '0;

                  if (CTRL_BL > 1)
                     last_valid_addr <= {PORT_CTRL_AMM_ADDRESS_WIDTH{1'b1}};
                  
                  if (local_init_done)
                     state <= NORMAL;
               end
            NORMAL:
               // Capture the request from the Avalon interface
               if (avl_ready)
               begin
                  cmd1_write_req <= avl_write_req;
                  cmd1_read_req <= avl_read_req;
                  cmd1_addr <= avl_addr;

                  // Merging is not possible with a burst length of 1
                  if (CTRL_BL == 1)
                     cmd1_addr_can_merge <= 1'b0;
                  else
                     cmd1_addr_can_merge <= next_cmd1_addr_can_merge;
                  beats_left <= avl_size;
                  
                  if (PROTOCOL_ENUM == "PROTOCOL_QDR2")
                  begin
                     cmd1_wdata <= avl_wdata;
                     if (CTRL_BE_EN != 0)
                        cmd1_be <= avl_be;
                  end

                  if (CTRL_BL > 1)
                  begin
                     if (avl_valid)
                     begin
                        last_valid_write_req <= avl_write_req;
                        last_valid_read_req <= avl_read_req;
                        last_valid_addr <= avl_addr;
                     end
                  end
                  
                  if (avl_size > 1)
                  begin
                     if (avl_write_req && !avl_read_req)
                        state <= WRITE_BURST;
                     else if (avl_read_req && !avl_write_req)
                        state <= READ_BURST;
                  end
               end

            WRITE_BURST:
               // Capture the request from the Avalon interface and
               // increment the address for the current write burst
               if (avl_ready)
               begin
                  cmd1_write_req <= avl_write_req;
                  cmd1_read_req <= avl_read_req;
                  
                  if (PROTOCOL_ENUM == "PROTOCOL_QDR2")
                  begin
                     cmd1_wdata <= avl_wdata;
                     if (CTRL_BE_EN != 0)
                        cmd1_be <= avl_be;
                  end

                  if (avl_write_req && !avl_read_req)
                  begin
                     cmd1_addr <= cmd1_addr + 1'b1;

                     // Merging is not possible with a burst length of 1
                     if (CTRL_BL == 1)
                        cmd1_addr_can_merge <= 1'b0;
                     else
                        cmd1_addr_can_merge <= next_cmd1_addr_can_merge;
                     beats_left <= beats_left - 1'b1;

                     if (CTRL_BL > 1)
                     begin
                        last_valid_write_req <= avl_write_req;
                        last_valid_read_req <= avl_read_req;
                        last_valid_addr <= cmd1_addr + 1'b1;
                     end
                     
                     if (beats_left == 2)
                         state <= NORMAL;
                  end
               end

            READ_BURST:
               // Issue read request with incrementing address for current read burst
               if ((PROTOCOL_ENUM == "PROTOCOL_RLD2" && shift_cmd1_to_cmd0) || (PROTOCOL_ENUM == "PROTOCOL_DDR2" && pop_req) || (PROTOCOL_ENUM == "PROTOCOL_QDR2" && pop_req))
               begin
                  cmd1_write_req <= '0;
                  cmd1_read_req <= 1'b1;
                  cmd1_addr <= cmd1_addr + 1'b1;

                  // Merging is not possible with a burst length of 1
                  if (CTRL_BL == 1)
                     cmd1_addr_can_merge <= 1'b0;
                  else
                     cmd1_addr_can_merge <= next_cmd1_addr_can_merge;
                  beats_left <= beats_left - 1'b1;

                  if (CTRL_BL > 1)
                  begin
                     last_valid_write_req <= '0;
                     last_valid_read_req <= 1'b1;
                     last_valid_addr <= cmd1_addr + 1'b1;
                  end
                  
                  if (beats_left == 2)
                     state <= NORMAL;
               end
         endcase
      end
   end


   // Simulation assertions
   // synthesis translate_off
   always_ff @(posedge clk)
   begin
      if (reset_n)
      begin
         assert (!(avl_write_req && avl_read_req)) else $error ("Illegal Avalon input");
      end
   end
   // synthesis translate_on

endmodule


