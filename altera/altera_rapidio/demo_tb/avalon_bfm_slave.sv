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


/*
******************************************************

MODULE_NAME =  avalon_bfm_slave.v
COMPANY =      Altera Corporation, Altera Ottawa Technology Center
WEB =          www.altera.com      www.altera.com/otc
EMAIL =        otc_technical\@altera.com

FUNCTIONAL_DESCRIPTION :

  Avalon Slave Switch fabric behavioral model

END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = \$Id\$

LEGAL :
Copyright 2003 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/

`define SINGLE    0
`define PIPELINED 1
`define BURST     2
`timescale 1ns / 1ps

module avalon_bfm_slave #(
  parameter TRANSACTION       = `SINGLE,
  parameter ADDRESS_WIDTH     = 32,
  parameter READDATA_WIDTH    = 32,
  parameter WRITEDATA_WIDTH   = 32,
  parameter BYTEENABLE_WIDTH  =  8,
  parameter BURSTCOUNT_WIDTH  =  7
                          )
(
  clk,

  reset,

  address,
  read,
  readdata,
  write,
  writedata,
  byteenable,

  // wait-state signals
  waitrequest,

  // pipeline signals
  readdatavalid,
  readerror,

  // burst signals
  burstcount
);

// -------------------
// Input / output pins
// -------------------
input clk;
input reset;
input [ADDRESS_WIDTH-1:0] address;
input read;
output [READDATA_WIDTH-1:0] readdata;
reg    [READDATA_WIDTH-1:0] readdata;
input write;
input [WRITEDATA_WIDTH-1:0] writedata;
input [BYTEENABLE_WIDTH-1:0] byteenable;
output waitrequest;
reg    waitrequest;
output readdatavalid;
reg    readdatavalid;
output readerror;
reg    readerror;
input [BURSTCOUNT_WIDTH-1:0] burstcount;

// --------------------------
// Internal private interface
// --------------------------
reg int_waitrequest;
reg int_readdatavalid;

// ------------------------
// Avalon burst read/write
// ------------------------
reg [READDATA_WIDTH-1:0] vera_readdata [1023:0]; // data populated externally (Vera)
reg first_vera_readdata; // SINGLE mode: flags that very first data are not received yet
integer vera_readdata_pipelined_cnt; // PIPELINED mode: counts number of pending piplined transactions

reg writedata_received; // flags that burst write from DUT Master is done
reg readdata_requested; // flags that burst of data is requested from Slave BFM (Vera)

// sampled data from Avalon bus
reg [ADDRESS_WIDTH-1:0]    dut_address;
reg [BURSTCOUNT_WIDTH-1:0] dut_burstcount;
reg [WRITEDATA_WIDTH-1:0]  dut_writedata [1023:0];
reg [BYTEENABLE_WIDTH-1:0] dut_byteenable;

integer burstcount_cnt; // temporary burst counter

// state machine variable
reg [1:0] state;
parameter st_idle  = 2'h0,
          st_write = 2'h1,
          st_read  = 2'h2;


// tmp variable (PIPELINED mode)
integer i;

// ------------------
// Delayed clk for #1
// ------------------
wire clk_delayed;
assign #2 clk_delayed = clk;

always @(posedge clk_delayed) begin
  // TODO delete #1; this is to fix race condition
  #1;

  // Randomize waitrequest and readdatavalid assertions.
  int_waitrequest = 0 /*$random*/;
  int_readdatavalid = 1 /*$random*/;

  readdatavalid = 0;

  if (TRANSACTION == `PIPELINED) begin
    if (int_readdatavalid == 1 && vera_readdata_pipelined_cnt != 0) begin
      readdata      = vera_readdata[0];
      readdatavalid = 1;

      if (vera_readdata_pipelined_cnt != 0) begin
        for (i=0; i<vera_readdata_pipelined_cnt-1; i=i+1) begin
          vera_readdata[i] = vera_readdata[i+1];
        end
        vera_readdata[i] = 'bx;
      end
      vera_readdata_pipelined_cnt = vera_readdata_pipelined_cnt - 1;
    end
    else begin
      readdatavalid = 0;
    end
  end
  
  writedata_received = 0;
  readdata_requested = 0;

  case (state)
    st_idle: begin
      state = st_idle;

      burstcount_cnt = 0;
      // -----
      // WRITE
      // -----
      if (write === 1 && read !== 1) begin
        if (!waitrequest) begin
          // initial sample of Avalon bus
          dut_address    = address;
          dut_byteenable = byteenable;
          dut_writedata[burstcount_cnt] = writedata;

          burstcount_cnt = 1;
          if (TRANSACTION == `BURST) begin
            dut_burstcount = burstcount;
            if (dut_burstcount == 1) begin
              writedata_received = 1;
            end
          end
          else begin // SINGLE, PIPELINED
            dut_burstcount     = 1; 
            writedata_received = 1;
          end

          if (burstcount_cnt != dut_burstcount) begin
            state = st_write;
          end
        end
      end
      // -----
      // READ
      // -----
      else if (read === 1 && write !== 1) begin

        if (!waitrequest) begin
          readdata_requested = 1;

          // initial sample of Avalon bus
          dut_address = address;

          if (TRANSACTION == `SINGLE) begin
            if (!first_vera_readdata) begin
              dut_address = address;
              readdata    = vera_readdata[0];
            end
            else begin
              waitrequest         = 1;
              first_vera_readdata = 0;
            end
          end

          if (TRANSACTION == `BURST) begin
            dut_burstcount = burstcount;
            state = st_read;
          end
        end
      end
      // ----------------------------
      // non-legal read/write values
      // ----------------------------
      else if (read === 1 && write === 1) begin 
        $display("%m: Warning Avalon-MM master, time: %0t, read and write are asserted at the same time.", $time);
      end
      // -------------
      // no read/write
      // -------------
      else begin
      end
    end //st_idle
      
    // -----------------------
    // Burst read/write states
    // -----------------------
    st_write: begin
      if (!waitrequest && write === 1) begin
        dut_writedata[burstcount_cnt] = writedata;
        burstcount_cnt = burstcount_cnt + 1;

        if (burstcount_cnt == dut_burstcount) begin
          // we reached the last data in the burst
          //state = st_write_end;
          writedata_received  = 1;
          state = st_idle;
        end
      end
    end //st_write

    st_read: begin
       if( read === 1 )begin
          int_waitrequest = 1; // Override random value.
          waitrequest = 1; // Override random value.
       end
      if (int_readdatavalid) begin
        readdatavalid  = 1;
        readdata       = vera_readdata[burstcount_cnt];
        burstcount_cnt = burstcount_cnt + 1;

        if (burstcount_cnt == dut_burstcount) begin
          state = st_idle;
        end
      end
    end //st_read

    //default: begin
    //  state = st_idle;
    //end
  endcase

end


// -------------------------------------
// Tasks to read data from dut_writedata
// and write data to vera_readdata
// -------------------------------------
task read_writedata;
  input  [BURSTCOUNT_WIDTH-1:0] bc_cnt;
  output [ADDRESS_WIDTH-1:0]    ad;
  output [WRITEDATA_WIDTH-1:0]  wd;
  output [BURSTCOUNT_WIDTH-1:0] bc;
  output [BYTEENABLE_WIDTH-1:0] be;
  begin
    ad = dut_address;
    wd = dut_writedata[bc_cnt];
    bc = dut_burstcount;
    be = dut_byteenable;
  end
endtask

task write_readdata;
  input  [BURSTCOUNT_WIDTH-1:0] bc_cnt;
  output [ADDRESS_WIDTH-1:0]    ad;
  input  [READDATA_WIDTH-1:0]   rd;
  output [BURSTCOUNT_WIDTH-1:0] bc;
  begin
    ad = dut_address;

    if (TRANSACTION != `PIPELINED) begin
      vera_readdata[bc_cnt] = rd;
    end
    else begin
      vera_readdata[vera_readdata_pipelined_cnt] = rd;
      vera_readdata_pipelined_cnt = vera_readdata_pipelined_cnt + 1;
    end

    bc = dut_burstcount;
  end
endtask


// --------------
// Initial reset
// --------------
initial begin
  // Output signals
  int_waitrequest             <= 'b1;
  int_readdatavalid           <= 'b0;

  // Internal regs, counters, ...
  writedata_received          <= 0;
  readdata_requested          <= 0;
  first_vera_readdata         <= 1;
  state                        = st_idle;
  burstcount_cnt               = 0; 
  vera_readdata_pipelined_cnt  = 0;
end

// ----------
// Avalon bus
// ----------
always @(posedge clk_delayed or negedge reset) begin
  if (reset == 0) begin
    readdata                    <= 'bx;
    waitrequest                 <= 'b0;
    readdatavalid               <= 'b0;

    // Output signals
    int_readdatavalid           <= 'b1;
    int_waitrequest             <= 'b0;
    // Internal regs, counters, ...
    writedata_received          <= 0;
    readdata_requested          <= 0;
    first_vera_readdata         <= 1;
    state                       <= st_idle;
    burstcount_cnt               = 0; 
    vera_readdata_pipelined_cnt  = 0;
  end
  else begin
    waitrequest                 <= int_waitrequest;
  end
end

endmodule
