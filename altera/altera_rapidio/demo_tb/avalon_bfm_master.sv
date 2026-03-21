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

MODULE_NAME =  avalon_bfm_master.v
COMPANY =      Altera Corporation, Altera Ottawa Technology Center
WEB =          www.altera.com      www.altera.com/otc
EMAIL =        otc_technical\@altera.com

FUNCTIONAL_DESCRIPTION :

  Switch fabric Avalon Master behavioral model
    - burst read / write transactions

END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = \$Id: //acds/main/ip/rapidio/rio/hw/src/test/tb.demo/avalon_bfm_master.v#2 $ .

LEGAL :
Copyright 2003 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/

`define SINGLE    0
`define PIPELINED 1
`define BURST     2
`timescale 1ns / 1ps

module avalon_bfm_master #(
  parameter TRANSACTION       = `SINGLE,
  parameter ADDRESS_WIDTH     = 32,
  parameter READDATA_WIDTH    = 32,
  parameter WRITEDATA_WIDTH   = 32,
  parameter BYTEENABLE_WIDTH  =  8,
  parameter BURSTCOUNT_WIDTH  =  7
)
(
  clk,

  reset_n,

  chipselect,
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

  // burst signals
  burstcount,
  readerror,

  irq
);


// -------------------
// Input / output pins
// -------------------
input clk;
input reset_n;
output chipselect;
reg    chipselect;
output [ADDRESS_WIDTH-1:0] address;
reg    [ADDRESS_WIDTH-1:0] address;
output read;
reg    read;
input [READDATA_WIDTH-1:0] readdata;
output write;
reg    write;
output [WRITEDATA_WIDTH-1:0] writedata;
reg    [WRITEDATA_WIDTH-1:0] writedata;
output [BYTEENABLE_WIDTH-1:0] byteenable;
reg    [BYTEENABLE_WIDTH-1:0] byteenable;
input waitrequest;
input readdatavalid;
output [BURSTCOUNT_WIDTH-1:0] burstcount;
reg    [BURSTCOUNT_WIDTH-1:0] burstcount;
input readerror;
input irq;

// --------------------------
// Internal private interface
// --------------------------
reg int_chipselect;
reg [ADDRESS_WIDTH-1:0] int_address;
reg int_read;
reg int_write;
reg [WRITEDATA_WIDTH-1:0] int_writedata;
reg [BYTEENABLE_WIDTH-1:0] int_byteenable;
reg [BURSTCOUNT_WIDTH-1:0] int_burstcount;

 import hutil_pkg::*;


// --------------
// Initial reset
// --------------
initial begin
  int_chipselect  <= 'bx;
  int_address     <= 'bx;
  int_read        <= 'b0;
  int_write       <= 'b0;
  int_writedata   <= 'bx;
  int_byteenable  <= 'bx;
  int_burstcount  <= 'bx;
  read <= 'b0;
end

// ------------------------
// Input clk delayed for #1
// ------------------------
wire clk_delayed;
assign #1 clk_delayed = clk;

// ------------------------
// Avalon burst read/write
// ------------------------
integer rw_burstcount_tmp;

task rw_addr_data;
  input rw_rw;
  input [ADDRESS_WIDTH-1:0]    rw_addr;
  input [BYTEENABLE_WIDTH-1:0] rw_be;
  inout [WRITEDATA_WIDTH-1:0]  rw_data;
  input [BURSTCOUNT_WIDTH-1:0] rw_burstcount;
  begin
    // ---------------------------------
    // The address phase starts @negedge 
    // to allow subsequent transactions
    // ---------------------------------
    @(negedge clk_delayed);
      int_address    = rw_addr;
      int_byteenable = rw_be;

      if (TRANSACTION == `BURST) begin
        rw_burstcount_tmp = 0;
        int_burstcount = rw_burstcount;
        if (rw_burstcount !== 1) begin
          int_byteenable = -1;
        end
      end
      int_chipselect = 1;

    if (!rw_rw) begin // read
      int_read  =  1;

      if (waitrequest) begin
        while (waitrequest) begin
          @(posedge clk_delayed);
        end
      end
      else begin
        @(posedge clk_delayed);
          while (waitrequest) begin
            @(posedge clk_delayed);
          end
      end

      int_read       = 0;
      int_chipselect = 0;
      if (TRANSACTION == `SINGLE) begin
        rw_data = readdata;
      end
    end
    else begin // write
      int_write     = 1;
      int_writedata = rw_data;

      if (TRANSACTION != `BURST) begin
        @(posedge clk_delayed);
        while (waitrequest === 1) begin
          @(posedge clk_delayed);
        end
      end

      if (TRANSACTION == `BURST) begin
        rw_burstcount_tmp = rw_burstcount_tmp + 1;
        if (rw_burstcount_tmp == rw_burstcount) begin
          @(posedge clk_delayed);
            while (waitrequest) begin
              @(posedge clk_delayed);
            end
            int_write = 0;
        end
      end

      if (TRANSACTION != `BURST) begin
        int_write      = 0;
        int_chipselect = 0;
      end
    end
  end
endtask

task rw_data;
  input rw_rw;
  input [ADDRESS_WIDTH-1:0]    rw_addr;
  input [BYTEENABLE_WIDTH-1:0] rw_be;
  inout [WRITEDATA_WIDTH-1:0]  rw_data;
  input [BURSTCOUNT_WIDTH-1:0] rw_burstcount;
  begin
    if (!rw_rw) begin // read
      @(posedge clk_delayed);
      if( TRANSACTION != `BURST ) begin
         int_address = rw_addr;
         int_read  = 1;
         int_write = 0;
         int_chipselect = 1;
         @(posedge clk_delayed);
         while (waitrequest === 1) begin
            @(posedge clk_delayed);
         end
         int_chipselect = 0;
         int_read = 0;
      end
      //int_read = 0;
      while (readdatavalid === 0) begin // Triple === so that unconnected (z) won't block
         @(posedge clk_delayed);
      end
      rw_data = readdata;
      rw_burstcount_tmp = rw_burstcount_tmp + 1;

    end
    else begin // write
      @(posedge clk_delayed);
      int_chipselect = 1;
      int_read  = 0;
      int_write = 1;

      while (waitrequest === 1) begin
        @(posedge clk_delayed);
      end

      int_writedata     = rw_data;
      rw_burstcount_tmp = rw_burstcount_tmp + 1;

      if (rw_burstcount_tmp == rw_burstcount) begin
        @(posedge clk_delayed);
          while (waitrequest) begin
            @(posedge clk_delayed);
          end
          int_write = 0;
      end

      if (rw_burstcount_tmp == rw_burstcount) begin
        int_chipselect = 0;
      end
    end
  end
endtask

// -----------------
// Sequential logic
// -----------------
always @(posedge clk or negedge reset_n) begin
  if (reset_n == 0) begin
    chipselect      <= 'b0;
    address         <= 'bx;
    read            <= 'b0;
    write           <= 'b0;
    writedata       <= 'bx;
    byteenable      <= 'bx;
    burstcount      <= 'bx;

    int_chipselect  <= 'b0;
    int_address     <= 'bx;
    int_read        <= 'b0;
    int_write       <= 'b0;
    int_writedata   <= 'bx;
    int_byteenable  <= 'bx;
    int_burstcount  <= 'bx;
   end
  else begin
    chipselect  <= int_chipselect;
    address     <= int_address;
    read        <= int_read;
    write       <= int_write;
    writedata   <= int_writedata;
    byteenable  <= int_byteenable;
    burstcount  <= int_burstcount;
  end
end

// convert airbus access to avalon transaction
task cpu_write;
input [ADDRESS_WIDTH-1:0] waddr;
input [WRITEDATA_WIDTH-1:0] wdata;
begin
   rw_data ( 1'b1,   // rw_rw
             waddr,   // rw_addr
             -1,     // rw_be
             wdata,   // rw_data
             1       // rw_burstcount
             );
end
endtask

reg [WRITEDATA_WIDTH-1:0] rdata;

task cpu_read;
input [ADDRESS_WIDTH-1:0] raddr;
input [WRITEDATA_WIDTH-1:0] exp_rdata;
begin
   rw_data ( 1'b0,   // rw_rw
             raddr,   // rw_addr
             -1,     // rw_be
             rdata,   // rw_data
             1       // rw_burstcount
             );
   check("rdata",exp_rdata, rdata);
   donecheck("");
end
endtask

task read_data;
  input [ADDRESS_WIDTH-1:0]    rw_addr;
  input [WRITEDATA_WIDTH-1:0]  exp_data;
  begin
      @(posedge clk_delayed);
      int_chipselect = 1;
      int_read = 1;
      int_address = rw_addr;
      @(posedge clk_delayed);
      while (waitrequest === 1) begin
        @(posedge clk_delayed);
      end

      int_chipselect = 0;
      int_read = 0;
      wait (readdatavalid == 1'b1);
      check("Avalon Read",exp_data,readdata);
      donecheck("");

  end
endtask

task read_send;
  input [ADDRESS_WIDTH-1:0]    rw_addr;
  begin
      @(posedge clk_delayed);
      int_chipselect = 1;
      int_read = 1;
      int_address = rw_addr;
      @(posedge clk_delayed);
      while (waitrequest === 1) begin
        @(posedge clk_delayed);
      end

      int_chipselect = 0;
      int_read = 0;
      donecheck("");
  end
endtask
task read_check;
  input [WRITEDATA_WIDTH-1:0]  exp_data;
  begin

      int_chipselect = 0;
      int_read = 0;
      @(posedge readdatavalid);
      check("Avalon Read",exp_data,readdata);
      donecheck("");

  end
endtask

endmodule
