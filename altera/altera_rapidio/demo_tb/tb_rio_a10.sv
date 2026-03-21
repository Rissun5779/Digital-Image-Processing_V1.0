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


`timescale 10ps/1ps
`define SMALL 2'b00
`define LARGE 2'b01


module tb;

 import altera_rapidio_tb_var_functions::*;
 import verbosity_pkg::*;
 import avalon_utilities_pkg::*;
 import avalon_mm_pkg::*;
 import hutil_pkg::*;



//This tb is for Arria 10, not applicable to previous families. 

`define READ  1'b0
`define WRITE 1'b1

`define MIN_READ_BYTES      8
`define MAX_READ_BYTES      256
`define READ_BYTES          8
`define MIN_WRITTEN_BYTES   8
`define MAX_WRITTEN_BYTES   256
`define WRITTEN_BYTES       8
`define FIRST_DRBELL_REF_IO 40
`define LAST_DRBELL_REF_IO  96
`define DRBELL_GAP          8

// Avalon addresses
`define PROC_ELEMENT_FEATURES      17'h00010
`define BASE_DEVICE_ID             17'h00060
`define GENERAL_CONTROL            17'h0013C
`define PORT_STATUS                17'h00158

`define MAINTENANCE_INTERRUPT           17'h10080
`define MAINTENANCE_INTERRUPT_ENABLE    17'h10084
`define TX_MAINTENANCE_WINDOW_0_BASE    17'h10100
`define TX_MAINTENANCE_WINDOW_0_MASK    17'h10104
`define TX_MAINTENANCE_WINDOW_0_OFFSET  17'h10108
`define TX_MAINTENANCE_WINDOW_0_CONTROL 17'h1010C
`define TX_PORT_WRITE_CONTROL           17'h10200
`define TX_PORT_WRITE_BUFFER            17'h10210
`define RX_PORT_WRITE_CONTROL           17'h10250
`define RX_PORT_WRITE_STATUS            17'h10254
`define RX_PORT_WRITE_BUFFER            17'h10260

`define IO_MASTER_WINDOW_0_BASE    17'h10300
`define IO_MASTER_WINDOW_0_MASK    17'h10304
`define IO_MASTER_WINDOW_0_OFFSET  17'h10308
`define IO_SLAVE_WINDOW_0_BASE     17'h10400
`define IO_SLAVE_WINDOW_0_MASK     17'h10404
`define IO_SLAVE_WINDOW_0_OFFSET   17'h10408
`define IO_SLAVE_WINDOW_0_CONTROL  17'h1040C
`define IO_SLAVE_INTERRUPT         17'h10500
`define IO_SLAVE_INTERRUPT_ENABLE  17'h10504
`define IO_SLAVE_PENDING_NWRITE_RS 17'h10508

//IO transactions status
`define IO_SLAVE_AVALON_WRITE      17'h1050C
`define IO_SLAVE_RIO_REQ_WRITE     17'h10510

`define RX_TRANSPORT_CONTROL      17'h10600

`define DRBELL_RX_DOORBELL       32'h00000000
`define DRBELL_TX_DATA           32'h0000000C
`define DRBELL_TXCPL_CNTRL       32'h0000001C
`define DRBELL_TXCPL_STATUS      32'h00000018
`define DRBELL_TXCPL_DATA        32'h00000014
`define DRBELL_INTR_ENA          32'h00000020
`define DRBELL_INTR_STAT         32'h00000024

// Interrupts bits
`define NWRITE_RS_COMPLETED 4


//io slave macro definations
`define NWRITE     2'b00
`define NWRITE_R   2'b01
`define SWRITE     2'b10
`define NREAD      2'b11 //?? 

`define WAIT_FOR_INITIALIZE 2
`define SINGLE              0
`define PIPELINED           1
`define BURST               2


`define PROC_ELEMENT_FEATURES      17'h00010

//------------------------------------------------------------------
// End of register default value setting
//------------------------------------------------------------------
// Localparameter declaration
  // p_sysclk_PERIOD is in ps and since the timescale is based on 10ps/1ps, we are dividing the p_sysclk_PERIOD with 20 instead of 2 for half clock cycle's period value
  localparam SYSCLK_HALF_CYCLE_PERIOD = p_SYS_CLK_PERIOD / 20;
  localparam REF_CLK_HALF_CYCLE_PERIOD = REF_CLK_PERIOD / 20;
  localparam DIFF_32_IO_SLAVE_ADDRESS_WIDTH = 32 - IO_SLAVE_ADDRESS_WIDTH;
  localparam PORT_WRITE_PRESENT = ((p_MAINTENANCE_SLAVE == 1'b1) && ((p_TX_PORT_WRITE == 1'b1)|| (p_RX_PORT_WRITE == 1'b1)))? 1'b1 : 1'b0;
  localparam IO_DATAPATH_WIDTH = ((mode_selection == "SERIAL_1X")? 32 : 64);
  localparam ADAT_EMPTY_SIZE = ((mode_selection == "SERIAL_1X")? 3 : 2);
  localparam BEC_BYTEENABLE = ((mode_selection == "SERIAL_1X")? 3 : 7);
  localparam BYTEENABLE_WIDTH = (mode_selection == "SERIAL_1X")?  4 : 8 ;
  localparam BURSTCOUNT_WIDTH = (mode_selection == "SERIAL_1X")? 7: 6;
  localparam DEVICE_ID_WIDTH = (p_TRANSPORT_LARGE == 1'b1)? 16 : 8;
  localparam MAINTENANCE_ADDRESS_WIDTH = 26;
  localparam ADAT = ((mode_selection == "SERIAL_1X")? 32: 64);
  localparam NUMBER_OF_XCVR_CHANNELS = (mode_selection == "SERIAL_1X")? 1: ((mode_selection == "SERIAL_2X")? 2: 4);
  localparam XCVR_NUMBER_OF_BYTE  = ((mode_selection == "SERIAL_2X")? 4: 2);
  localparam ADAT_MTY_WIDTH = ((ADAT == 64)? 3 : 2);
  localparam ADAT_SIZE_WIDTH = ((ADAT == 64)? 6 : 7);
  localparam IOS_DESTINATION_ID_2 = (p_IO_SLAVE == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 32'hAAAA_0000 : 32'h00AA_0000) : ((p_TRANSPORT_LARGE == 1'b1)? 32'h5555_0000 : 32'h0055_0000);
  localparam IOS_DESTINATION_ID = (p_IO_SLAVE == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 32'h5555_0000 : 32'h0055_0000) : ((p_TRANSPORT_LARGE == 1'b1)? 32'hAAAA_0000 : 32'h00AA_0000); 
  localparam IOS_DESTINATION_ID_SWRITE_ENABLE = (p_IO_SLAVE == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 32'h5555_0002 : 32'h0055_0002) : ((p_TRANSPORT_LARGE == 1'b1)? 32'hAAAA_0002 : 32'h00AA_0002); 
  localparam IOS_DESTINATION_ID_NWRITE_ENABLE = (p_IO_SLAVE == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 32'h5555_0001 : 32'h0055_0001) : ((p_TRANSPORT_LARGE == 1'b1)? 32'hAAAA_0001 : 32'h00AA_0001); 
  localparam SISTER_MAINTENANCE_ADDRESS_WIDTH = 26;
  localparam DRBTX_DESTINATION_ID = (p_DRBELL_TX == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 16'h5555 : 16'h0055) : ((p_TRANSPORT_LARGE == 1'b1 )? 16'hAAAA : 16'h00AA);
  localparam DRBRX_DESTINATION_ID_PROM = (p_DRBELL_TX == 1'b1)? ((p_TRANSPORT_LARGE == 1'b1)? 16'hBBBB : 16'h00BB) : ((p_TRANSPORT_LARGE== 1'b1)? 16'h6666 : 16'h0066);
  localparam p_DRBELL = ((p_DRBELL_TX == 1'b1) || (p_DRBELL_RX == 1'b1))? 1'b1 : 1'b0;  
  localparam DRBELL_ADDRESS_WIDTH = 6;
  localparam p_IO_SLAVE_ADDRESS_LSB = ((ADAT == 64) ? 3 : 2);
  



//------------------------------------------------------------------
// TB Hookup
//------------------------------------------------------------------

/********************************/
/* RapidIO Line Interface       */
/********************************/
wire [NUMBER_OF_XCVR_CHANNELS - 1: 0] rd;
wire [NUMBER_OF_XCVR_CHANNELS - 1:0] td;
wire  [NUMBER_OF_XCVR_CHANNELS - 1:0] rx_is_lockedtodata;
/********************************/
/* User Interface               */
/********************************/
wire txclk; // Serial RapidIO output clock
wire rxclk; // Recovered Clock
reg reset_n; // Reset is async assert and sync deassert to sysclk
reg sister_reset_n; // Reset is async assert and sync deassert to sysclk
reg sysclk;  // Main system clock.
reg clk; // Transceiver reference clock.
wire [15:0] ef_ptr;
///////////////////////////////////////
// Input Output Master Logical Layer //
///////////////////////////////////////
/********************************/
/* Datapath Write Avalon Master */
/********************************/


wire io_m_wr_waitrequest;
wire io_m_wr_write;
wire [32-1:0] io_m_wr_address;
wire [32-1:0] io_m_wr_writedata;
wire [BYTEENABLE_WIDTH-1:0] io_m_wr_byteenable;
wire [BURSTCOUNT_WIDTH-1:0] io_m_wr_burstcount;
/********************************/
/* Datapath Read Avalon Master  */
/********************************/
//wire io_m_rd_clk;
wire io_m_rd_waitrequest;
wire io_m_rd_read;
wire [32-1:0] io_m_rd_address;
wire io_m_rd_readdatavalid;
wire io_m_rd_readerror;
wire [32-1:0] io_m_rd_readdata;
wire [BURSTCOUNT_WIDTH-1:0] io_m_rd_burstcount;
///////////////////////////////////////
// Input Output Slave Logical Layer  //
///////////////////////////////////////
/********************************/
/* Datapath Write Avalon Slave  */
/********************************/
//wire io_s_wr_clk;
wire io_s_wr_chipselect;
wire io_s_wr_waitrequest;
wire io_s_wr_write;
wire [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0] io_s_wr_address;
wire [p_IO_SLAVE_ADDRESS_LSB-1:0] io_s_wr_addr_unused_bits;
wire [IO_DATAPATH_WIDTH - 1:0] io_s_wr_writedata;
wire [BYTEENABLE_WIDTH-1:0] io_s_wr_byteenable;
wire [BURSTCOUNT_WIDTH-1:0] io_s_wr_burstcount;
/********************************/
/* Datapath Read Avalon Slave   */
/********************************/
//wire io_s_rd_clk;
wire io_s_rd_chipselect;
wire io_s_rd_waitrequest;
wire io_s_rd_read;
wire [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0] io_s_rd_address;
wire [p_IO_SLAVE_ADDRESS_LSB-1:0] io_s_rd_addr_unused_bits;
wire io_s_rd_readdatavalid;
wire [IO_DATAPATH_WIDTH-1:0] io_s_rd_readdata;
wire [BURSTCOUNT_WIDTH-1:0] io_s_rd_burstcount;
wire io_s_rd_readerror;

/////////////////////////////
// Doorbell Logical Layer  //
/////////////////////////////
/*********************/
/*  Avalon Slave     */
/*********************/
//wire drbell_s_clk;
wire drbell_s_chipselect;
wire drbell_s_waitrequest;
wire drbell_s_read;
wire drbell_s_write;
wire [DRBELL_ADDRESS_WIDTH-3:0] drbell_s_address;
wire [1:0] drbell_addr_unused_bits;
wire [31:0] drbell_s_writedata;
wire [31:0] drbell_s_readdata;
wire drbell_s_irq;


/********************************************************/
wire gen_tx_ready;
reg  gen_tx_valid;
reg  gen_tx_startofpacket;
reg  gen_tx_endofpacket;
reg  gen_tx_error;
reg  [ADAT_MTY_WIDTH-1:0] gen_tx_empty;
reg  [ADAT-1:0] gen_tx_data;
//wire [ADAT_SIZE_WIDTH-1:0] gen_txsize;
reg  gen_rx_ready;
wire gen_rx_valid;
wire gen_rx_startofpacket;
wire gen_rx_endofpacket;
wire [ADAT_MTY_WIDTH-1:0] gen_rx_empty;
wire [ADAT-1:0] gen_rx_data;
wire [ADAT_SIZE_WIDTH-1:0] gen_rx_size;

wire sister_gen_tx_ready;
reg  sister_gen_tx_valid;
reg  sister_gen_tx_startofpacket;
reg  sister_gen_tx_endofpacket;
reg  sister_gen_tx_error;
reg  [ADAT_MTY_WIDTH-1:0] sister_gen_tx_empty;
reg  [ADAT-1:0] sister_gen_tx_data;

reg  sister_gen_rx_ready;
wire sister_gen_rx_valid;
wire sister_gen_rx_startofpacket;
wire sister_gen_rx_endofpacket;
wire [ADAT_MTY_WIDTH-1:0] sister_gen_rx_empty;
wire [ADAT-1:0] sister_gen_rx_data;
wire [ADAT_SIZE_WIDTH-1:0] sister_gen_rx_size;



///////////////////////////////
// Maintenance Logical Layer //
///////////////////////////////
//wire mnt_m_clk; //
//wire mnt_s_clk; //
/*************************************/
/* Maintenance main Avalon Master    */
/*************************************/
wire mnt_m_waitrequest;
wire mnt_m_read;
wire mnt_m_write;
wire [31:0] mnt_m_address;
wire [31:0] mnt_m_writedata;
wire [31:0] mnt_m_readdata;
wire mnt_m_readdatavalid;
/*************************************/
/* Maintenance main Avalon Slave     */
/*************************************/
wire mnt_s_chipselect;
wire mnt_s_waitrequest;
wire mnt_s_read;
wire mnt_s_write;
wire [MAINTENANCE_ADDRESS_WIDTH-3:0] mnt_s_address;
wire [1:0] mnt_addr_unused_bits;
wire [31:0] mnt_s_writedata;
wire [31:0] mnt_s_readdata;
wire mnt_s_readdatavalid;
wire mnt_s_readerror;
/***********************************/
/* System Maintenance Avalon Slave */
/***********************************/
//wire sys_mnt_s_clk;
wire sys_mnt_s_chipselect;
wire sys_mnt_s_waitrequest;
wire sys_mnt_s_read;
wire sys_mnt_s_write;
wire [14:0] sys_mnt_s_address;
wire [1:0] sys_mnt_addr_unused_bits;
wire [31:0] sys_mnt_s_writedata;
wire [31:0] sys_mnt_s_readdata;
wire sys_mnt_s_irq;
wire rx_packet_dropped;


/********************************/
/* Other Miscellaneous Signals  */
/********************************/
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_errdetect; 
wire gxbpll_locked; 
wire [23:0] port_response_timeout;
wire port_error;
wire master_enable;

wire  output_enable; // ORed with Output Port Enable CSR
wire  input_enable;  // ORed with Input Port Enable CSR


// Physical Informative Signals
wire port_initialized;
wire [8:0] atxwlevel;
wire atxovf;
wire [9:0] arxwlevel;
wire buf_av0;
wire buf_av1;
wire buf_av2;
wire buf_av3;
wire packet_transmitted;
wire packet_cancelled;
wire packet_accepted;
wire packet_retry;
wire packet_not_accepted;
wire packet_crc_error;
wire symbol_error;
wire char_err;
wire multicast_event_rx;
reg  multicast_event_tx;
wire no_sync_indicator;

wire [6:0] txclk_timeout_prescaler;  // Port Link Timeout
wire [6:0] sysclk_timeout_prescaler; // Port Response Timeout

/**************************/
/* MegaWizard Set Signals */
/**************************/
// RX PHY3 Buffer Threshold Connect Inputs
wire [9:0] rx_threshold_0;
wire [9:0] rx_threshold_1;
wire [9:0] rx_threshold_2;
// MegaWizard Derived Connect Inputs
// CARs and CSRs Connect Inputs
wire [15:0] device_identifier;      // Device Identity
wire [15:0] device_vendor_id ;       // Devince Vendor Identity
wire [31:0] device_revision ;   // Device Revision Level
wire [15:0] assembly_id ;            // Assembly Identity
wire [15:0] assembly_vendor_id ;     // Assembly Vendor Identity
wire [15:0] assembly_revision ;      // Assembly Revision
wire [15:0] extended_features_ptr ;  // Extended Features Pointer
wire bridge_support;                    // Bridge Support
wire memory_access ;                     // Memory Access
wire processor_present ;                 // Processor Present
wire switch_support ;                    // Switch Support
wire [7:0] number_of_ports ;             // Number of Ports
wire [7:0] port_number ;                 // Port Number

reg gen_tx_ready_d1;
reg sister_gen_tx_ready_d1;

  always @ (posedge sysclk)begin
      sister_gen_tx_ready_d1 = sister_gen_tx_ready;
  end
  
  always @ (posedge sysclk)begin
      gen_tx_ready_d1 = gen_tx_ready;
  end

  task send_packet_avalon_st;
    input [1:0] prio;
    input [1:0] tt;
    input [3:0] ftype;
    input [8:0] payload_size; // Number of payload bytes
    integer i;
    import hutil_pkg::*;

    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg [7:0] data5;
    reg [7:0] data6;
    reg [7:0] data7;

    begin
      while( gen_tx_ready_d1 !== 1'b1 )  begin
         gen_tx_valid = 1'b0;
         @(negedge sysclk);
      end
      gen_tx_startofpacket = 1'b1;
      gen_tx_endofpacket   = 1'b0;
      gen_tx_error         = 1'b0;
      if (ADAT == 32 )  begin
      gen_tx_data          = {8'b00000_000,prio,tt,ftype,16'hBEEF}; // Header and DestinationID
      gen_tx_empty         = 2'b00;
      gen_tx_valid         = 1'b1;

      @(negedge sysclk);
      while( gen_tx_ready_d1 !== 1'b1 )begin
        gen_tx_valid = 1'b0;
        @(negedge sysclk);
      end
      gen_tx_valid         = 1'b1;
      gen_tx_startofpacket = 1'b0;
      gen_tx_data          = {16'hF00D,4'h0,4'h0,8'h00}; // SourceID, Transaction, Size/Status &  TID
     end else begin
      gen_tx_data  = {8'b00000_000,prio,tt,ftype,16'hBEEF, 16'hF00D,4'h0,4'h0,8'h00}; // Header and DestinationID, SourceID, Transaction, Size/Status &  TID
      gen_tx_empty = 3'b000;
      gen_tx_valid = 1'b1;
     end
     // End of ADAT == 32
     
      for( i = 0; i < payload_size; i = i + (ADAT/8) )begin
        @(negedge sysclk);
        gen_tx_startofpacket = 1'b0;
        while( gen_tx_ready_d1 !== 1'b1 )begin
          gen_tx_valid = 1'b0;
          @(negedge sysclk);
        end
        gen_tx_valid = 1'b1;
        data0 = 8'd0+i;
        data1 = i+1 >= payload_size ? 8'd0 : 8'd1+i;
        data2 = i+2 >= payload_size ? 8'd0 : 8'd2+i;
        data3 = i+3 >= payload_size ? 8'd0 : 8'd3+i;
        if( ADAT == 32 )  begin
            gen_tx_data = {data0,data1,data2,data3}; // Payload
        end else begin
            data4 = i+4 >= payload_size ? 8'd0 : 8'd4+i;
            data5 = i+5 >= payload_size ? 8'd0 : 8'd5+i;
            data6 = i+6 >= payload_size ? 8'd0 : 8'd6+i;
            data7 = i+7 >= payload_size ? 8'd0 : 8'd7+i;
            gen_tx_data = {data0,data1,data2,data3,data4,data5,data6,data7}; // Payload
        end
        
        if( i+(ADAT/8) >= payload_size )begin
          gen_tx_endofpacket = 1'b1;
          gen_tx_empty = ((ADAT/8)-payload_size)%(ADAT/8);          
        end 
      end      
      
      @(negedge sysclk);
      gen_tx_valid = 1'b0;
      donecheck("send_packet");
    end
  endtask

  task receive_packet_avalon_st;
    input [1:0] prio;
    input [1:0] tt;
    input [3:0] ftype;
    input [8:0] payload_size; // Number of payload bytes
    integer i,j;
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg [7:0] data5;
    reg [7:0] data6;
    reg [7:0] data7;
    
    import hutil_pkg::*;

    event check_task;
    begin
      @(negedge sysclk);
      gen_rx_ready = 1'b1;
      @(negedge sysclk);
      while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
      -> check_task;
      expect_1("gen_rx_startofpacket", 1'b1, gen_rx_startofpacket);
      expect_1("gen_rx_endofpacket",   1'b0, gen_rx_endofpacket);
      if (ADAT == 32 )  begin
          expect_n("gen_rx_empty", 2'b00, gen_rx_empty, 2);
          check("gen_rx_data", {8'bxxxxx_000,prio,tt,ftype,16'hBEEF}, gen_rx_data); // Header and DestinationID
          
          @(negedge sysclk);
          while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
          -> check_task;
          expect_1("gen_rx_startofpacket", 1'b0, gen_rx_startofpacket);
          check("gen_rx_data", {16'hF00D,4'h0,4'h0,8'h00}, gen_rx_data); // SourceID, Transaction, Size/Status &  TID
      end else begin
          expect_n("gen_rx_empty", 3'b000, gen_rx_empty, 3);
          // Header and DestinationID,SourceID, Transaction, Size/Status &  TID
          check("gen_rx_data", {8'bxxxxx_000,prio,tt,ftype,16'hBEEF,16'hF00D,4'h0,4'h0,8'h00}, gen_rx_data);
          
      end
      i = 0;
      while( i+(ADAT/8) <= payload_size )begin// Check payload words
        @(negedge sysclk);
        while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
        -> check_task;
        data0 = i;  
        data1 = i+1;
        data2 = i+2;
        data3 = i+3;
        if( ADAT == 32 )  begin
            check("gen_rx_data", {data0,data1,data2,data3}, gen_rx_data); // Payload
            expect_n("gen_rx_empty", 2'b00, gen_rx_empty, 2);
            expect_1("gen_rx_startofpacket", 1'b0, gen_rx_startofpacket);
        end else begin
            data4 = i+4;
            data5 = i+5;
            data6 = i+6;
            data7 = i+7;
            check("gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data); // Payload
            expect_n("gen_rx_empty", 3'b000, gen_rx_empty, 3);
            expect_1("gen_rx_startofpacket", 1'b0, gen_rx_startofpacket);
        end
          i = i + (ADAT/8);
      end

      // Last word(s)
      @(negedge sysclk);
      while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
      -> check_task;
      if( ADAT == 32 )  begin
      if( payload_size <= 72 )begin
        // This is eop word
        data0 = (payload_size%4 == 0) ? 8'hxx : i;     // Final CRC / Payload
        data1 = (payload_size%4 == 0) ? 8'hxx : i+1;   // Final CRC / Payload
        data2 = (payload_size%4 == 0) ? 8'h00 : 8'hxx; // Padding   / Final CRC
        data3 = (payload_size%4 == 0) ? 8'h00 : 8'hxx; // Padding   / Final CRC
        check("Short Last gen_rx_data", {data0,data1,data2,data3}, gen_rx_data);
        expect_1("Short Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
        expect_n("Short Last gen_rx_empty", 2'b00, gen_rx_empty, 2);
      end else /* payload_size > 72 */begin
        if( payload_size%4 == 2)begin
          // This is second to last word.
          data0 =                                 i;   // Always Payload
          data1 =                                 i+1; // Always Payload
          data2 = (payload_size%4 == 2) ? 8'hxx : i+2; // Final CRC / Payload
          data3 = (payload_size%4 == 2) ? 8'hxx : i+3; // Final CRC / Payload
          check("Long Second to last gen_rx_data", {data0,data1,data2,data3}, gen_rx_data);
          expect_1("Long Second to last gen_rx_endofpacket", 1'b0, gen_rx_endofpacket);
          expect_n("Long Second to last gen_rx_empty", 2'b00, gen_rx_empty, 2);
          @(negedge sysclk);
          while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
          -> check_task;
        end
        // This is last word.
        data0 = (payload_size%4 == 2) ? 8'h00 : 8'hxx; // All zeros / Final CRC
        data1 = (payload_size%4 == 2) ? 8'h00 : 8'hxx; // All zeros / Final CRC
        data2 =                         8'h00;         // Always zero.
        data3 =                         8'h00;         // Always zero.
        check("Long Last gen_rx_data", {data0,data1,data2,data3}, gen_rx_data);
        expect_1("Long Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
        expect_n("Long Last gen_rx_empty", 2'b10, gen_rx_empty, 2);
      end
      gen_rx_ready = 1'b0;
      end else begin
      if( payload_size <= 72 )begin
        case ( (payload_size%8)>>1 )
          0: begin
            data0 = 8'hxx;data1 = 8'hxx;data2 = 8'h00;data3 = 8'h00; // Final CRC / Padding
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'hxx;data7 = 8'hxx; // Don't Care/ Don't Care
            expect_n("gen_rx_empty", 3'b100, gen_rx_empty, 3);
          end
          1: begin
            data0 = i;    data1 = i+1;  data2 = 8'hxx;data3 = 8'hxx; // Payload   / Final CRC
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'hxx;data7 = 8'hxx; // Don't Care/ Don't Care
            expect_n("gen_rx_empty", 3'b100, gen_rx_empty, 3);
          end
          2: begin
            data0 = i;    data1 = i+1;  data2 = i+2;  data3 = i+3;    // Payload   / Payload
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'h00;data7 = 8'h00;  // Final CRC / Padding
            expect_n("gen_rx_empty", 3'b000, gen_rx_empty, 3);
          end
          3: begin
            data0 = i;    data1 = i+1;  data2 = i+2;  data3 = i+3;    // Payload   / Payload
            data4 = i+4;  data5 = i+5;  data6 = 8'hxx;data7 = 8'hxx;  // Payload   / Final CRC
            expect_n("gen_rx_empty", 3'b000, gen_rx_empty, 3);
          end
        endcase
      end else begin
        case ( (payload_size%8)>>1 )
          0: begin
            data0 = 8'hxx;
            data1 = 8'hxx;  
            data2 = 8'h00;
            data3 = 8'h00;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data);
            expect_n("gen_rx_empty", 3'b110, gen_rx_empty, 3);
            expect_1("Long Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
          end
          1: begin
            data0 = i;
            data1 = i+1;  
            data2 = 8'hxx;
            data3 = 8'hxx;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data);
            expect_n("gen_rx_empty", 3'b010, gen_rx_empty, 3);
            expect_1("Long Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
          end
          2: begin
            data0 = i;
            data1 = i+1;  
            data2 = i+2;
            data3 = i+3;
            data4 = 8'hxx;
            data5 = 8'hxx;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data);
            expect_n("gen_rx_empty", 3'b010, gen_rx_empty, 3);
            expect_1("Long Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
          end
          3: begin
            // This is second to last word.
            data0 = i;
            data1 = i+1;  
            data2 = i+2;
            data3 = i+3;
            data4 = i+4;
            data5 = i+5;
            data6 = 8'hxx;
            data7 = 8'hxx;
            check("Last gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data);
            expect_n("gen_rx_empty", 3'b000, gen_rx_empty, 3);
            expect_1("Long Last gen_rx_endofpacket", 1'b0, gen_rx_endofpacket);
            @(negedge sysclk);
            while( gen_rx_valid !== 1'b1 ) @(negedge sysclk);
            -> check_task;    
            // This is last word.
            data0 = 8'h00;
            data1 = 8'h00;  
            data2 = 8'h00;
            data3 = 8'h00;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, gen_rx_data);
            expect_n("gen_rx_empty", 3'b110, gen_rx_empty, 3);
            expect_1("Long Last gen_rx_endofpacket", 1'b1, gen_rx_endofpacket);
         end
        endcase
      end
      gen_rx_ready = 1'b0;
    end
      @(negedge sysclk);
      gen_rx_ready = 1'b0;
      donecheck("receive_packet");
    end
  endtask
  
   task sister_send_packet_avalon_st;
    input [1:0] prio;
    input [1:0] tt;
    input [3:0] ftype;
    input [8:0] payload_size; // Number of payload bytes
    integer i;
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg [7:0] data5;
    reg [7:0] data6;
    reg [7:0] data7;
    import hutil_pkg::*;

    
    begin
      while( sister_gen_tx_ready_d1 !== 1'b1 )  begin
         sister_gen_tx_valid = 1'b0;
         @(negedge sysclk);
      end
      sister_gen_tx_startofpacket = 1'b1;
      sister_gen_tx_endofpacket   = 1'b0;
      sister_gen_tx_error         = 1'b0;
      if( ADAT == 32 ) begin
          sister_gen_tx_data          = {8'b00000_000,prio,tt,ftype,16'hBEEF}; // Header and DestinationID
          sister_gen_tx_empty         = 2'b00;
          sister_gen_tx_valid         = 1'b1;
    
          @(negedge sysclk);
          while( sister_gen_tx_ready_d1 !== 1'b1 )begin
            sister_gen_tx_valid = 1'b0;
            @(negedge sysclk);
          end
          sister_gen_tx_valid         = 1'b1;
          sister_gen_tx_startofpacket = 1'b0;
          sister_gen_tx_data          = {16'hF00D,4'h0,4'h0,8'h00}; // SourceID, Transaction, Size/Status &  TID
      end else begin
          sister_gen_tx_data  = {8'b00000_000,prio,tt,ftype,16'hBEEF, 16'hF00D,4'h0,4'h0,8'h00}; // Header and DestinationID, SourceID, Transaction, Size/Status &  TID
          sister_gen_tx_empty = 3'b000;
          sister_gen_tx_valid = 1'b1;
      end
      
      for( i = 0; i < payload_size; i = i + (ADAT/8) )begin
        @(negedge sysclk);
        sister_gen_tx_startofpacket = 1'b0;
        while( sister_gen_tx_ready_d1 !== 1'b1 )begin
          sister_gen_tx_valid = 1'b0;
          @(negedge sysclk);
        end
        sister_gen_tx_valid = 1'b1;
        data0 = 8'd0+i;
        data1 = i+1 >= payload_size ? 8'd0 : 8'd1+i;
        data2 = i+2 >= payload_size ? 8'd0 : 8'd2+i;
        data3 = i+3 >= payload_size ? 8'd0 : 8'd3+i;
        if( ADAT == 32 ) begin
            sister_gen_tx_data = {data0,data1,data2,data3}; // Payload
        end else begin
            data4 = i+4 >= payload_size ? 8'd0 : 8'd4+i;
            data5 = i+5 >= payload_size ? 8'd0 : 8'd5+i;
            data6 = i+6 >= payload_size ? 8'd0 : 8'd6+i;
            data7 = i+7 >= payload_size ? 8'd0 : 8'd7+i;
            sister_gen_tx_data = {data0,data1,data2,data3,data4,data5,data6,data7}; // Payload
        end
        
        if( i+(ADAT/8) >= payload_size )begin
          sister_gen_tx_endofpacket = 1'b1;
          sister_gen_tx_empty = ((ADAT/8)-payload_size)%(ADAT/8);          
        end 
      end      
      
      @(negedge sysclk);
      sister_gen_tx_valid = 1'b0;
      donecheck("sister_send_packet");
    end
  endtask

  task sister_receive_packet_avalon_st;
    input [1:0] prio;
    input [1:0] tt;
    input [3:0] ftype;
    input [8:0] payload_size; // Number of payload bytes
    integer i,j;
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg [7:0] data5;
    reg [7:0] data6;
    reg [7:0] data7;
    import hutil_pkg::*;


    event check_task;
    begin
//      wait( sister_arxdav === 1'b1 );
      @(negedge sysclk);
      sister_gen_rx_ready = 1'b1;
      @(negedge sysclk);
      while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
      -> check_task;
      expect_1("sister_gen_rx_startofpacket", 1'b1, sister_gen_rx_startofpacket);
      expect_1("sister_gen_rx_endofpacket",   1'b0, sister_gen_rx_endofpacket);
//    expect_1("sister_gen_rx_error",         1'b0, sister_gen_rx_error);
      if( ADAT == 32 ) begin
      expect_n("sister_gen_rx_empty", 2'b00, sister_gen_rx_empty, 2);
      check("sister_gen_rx_data", {8'bxxxxx_000,prio,tt,ftype,16'hBEEF}, sister_gen_rx_data); // Header and DestinationID
      
      @(negedge sysclk);
      while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
      -> check_task;
      expect_1("sister_gen_rx_startofpacket", 1'b0, sister_gen_rx_startofpacket);
      check("sister_gen_rx_data", {16'hF00D,4'h0,4'h0,8'h00}, sister_gen_rx_data); // SourceID, Transaction, Size/Status &  TID
      end else begin
      expect_n("sister_gen_rx_empty", 3'b000, sister_gen_rx_empty, 3);
      // Header and DestinationID,SourceID, Transaction, Size/Status &  TID
      check("sister_gen_rx_data", {8'bxxxxx_000,prio,tt,ftype,16'hBEEF,16'hF00D,4'h0,4'h0,8'h00}, sister_gen_rx_data);
      
      end
      
      i = 0;
      while( i+(ADAT/8) <= payload_size )begin// Check payload words
        @(negedge sysclk);
        while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
        -> check_task;
        data0 = i;  
        data1 = i+1;
        data2 = i+2;
        data3 = i+3;
        if( ADAT == 32 ) begin
        check("sister_gen_rx_data", {data0,data1,data2,data3}, sister_gen_rx_data); // Payload
        expect_n("sister_gen_rx_empty", 2'b00, sister_gen_rx_empty, 2);
        expect_1("sister_gen_rx_startofpacket", 1'b0, sister_gen_rx_startofpacket);
        end else begin
        data4 = i+4;
        data5 = i+5;
        data6 = i+6;
        data7 = i+7;
        check("sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data); // Payload
        expect_n("sister_gen_rx_empty", 3'b000, sister_gen_rx_empty, 3);
        expect_1("sister_gen_rx_startofpacket", 1'b0, sister_gen_rx_startofpacket);
        end
          i = i + (ADAT/8);
      end

      // Last word(s)
      @(negedge sysclk);
      while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
      -> check_task;
      if( ADAT == 32 ) begin
      if( payload_size <= 72 )begin
        // This is eop word
        data0 = (payload_size%4 == 0) ? 8'hxx : i;     // Final CRC / Payload
        data1 = (payload_size%4 == 0) ? 8'hxx : i+1;   // Final CRC / Payload
        data2 = (payload_size%4 == 0) ? 8'h00 : 8'hxx; // Padding   / Final CRC
        data3 = (payload_size%4 == 0) ? 8'h00 : 8'hxx; // Padding   / Final CRC
        check("Short Last sister_gen_rx_data", {data0,data1,data2,data3}, sister_gen_rx_data);
        expect_1("Short Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
        expect_n("Short Last sister_gen_rx_empty", 2'b00, sister_gen_rx_empty, 2);
      end else /* payload_size > 72 */begin
        if( payload_size%4 == 2)begin
          // This is second to last word.
          data0 =                                 i;   // Always Payload
          data1 =                                 i+1; // Always Payload
          data2 = (payload_size%4 == 2) ? 8'hxx : i+2; // Final CRC / Payload
          data3 = (payload_size%4 == 2) ? 8'hxx : i+3; // Final CRC / Payload
          check("Long Second to last sister_gen_rx_data", {data0,data1,data2,data3}, sister_gen_rx_data);
          expect_1("Long Second to last sister_gen_rx_endofpacket", 1'b0, sister_gen_rx_endofpacket);
          expect_n("Long Second to last sister_gen_rx_empty", 2'b00, sister_gen_rx_empty, 2);
          @(negedge sysclk);
          while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
          -> check_task;
        end
        // This is last word.
        data0 = (payload_size%4 == 2) ? 8'h00 : 8'hxx; // All zeros / Final CRC
        data1 = (payload_size%4 == 2) ? 8'h00 : 8'hxx; // All zeros / Final CRC
        data2 =                         8'h00;         // Always zero.
        data3 =                         8'h00;         // Always zero.
        check("Long Last sister_gen_rx_data", {data0,data1,data2,data3}, sister_gen_rx_data);
        expect_1("Long Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
        expect_n("Long Last sister_gen_rx_empty", 2'b10, sister_gen_rx_empty, 2);
      end
      sister_gen_rx_ready = 1'b0;
end else begin
      if( payload_size <= 72 )begin
        case ( (payload_size%8)>>1 )
          0: begin
            data0 = 8'hxx;data1 = 8'hxx;data2 = 8'h00;data3 = 8'h00; // Final CRC / Padding
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'hxx;data7 = 8'hxx; // Don't Care/ Don't Care
            expect_n("sister_gen_rx_empty", 3'b100, sister_gen_rx_empty, 3);
          end
          1: begin
            data0 = i;    data1 = i+1;  data2 = 8'hxx;data3 = 8'hxx; // Payload   / Final CRC
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'hxx;data7 = 8'hxx; // Don't Care/ Don't Care
            expect_n("sister_gen_rx_empty", 3'b100, sister_gen_rx_empty, 3);
          end
          2: begin
            data0 = i;    data1 = i+1;  data2 = i+2;  data3 = i+3;    // Payload   / Payload
            data4 = 8'hxx;data5 = 8'hxx;data6 = 8'h00;data7 = 8'h00;  // Final CRC / Padding
            expect_n("sister_gen_rx_empty", 3'b000, sister_gen_rx_empty, 3);
          end
          3: begin
            data0 = i;    data1 = i+1;  data2 = i+2;  data3 = i+3;    // Payload   / Payload
            data4 = i+4;  data5 = i+5;  data6 = 8'hxx;data7 = 8'hxx;  // Payload   / Final CRC
            expect_n("sister_gen_rx_empty", 3'b000, sister_gen_rx_empty, 3);
          end
        endcase
      end else begin
        case ( (payload_size%8)>>1 )
          0: begin
            data0 = 8'hxx;
            data1 = 8'hxx;  
            data2 = 8'h00;
            data3 = 8'h00;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data);
            expect_n("sister_gen_rx_empty", 3'b110, sister_gen_rx_empty, 3);
            expect_1("Long Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
          end
          1: begin
            data0 = i;
            data1 = i+1;  
            data2 = 8'hxx;
            data3 = 8'hxx;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data);
            expect_n("sister_gen_rx_empty", 3'b010, sister_gen_rx_empty, 3);
            expect_1("Long Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
          end
          2: begin
            data0 = i;
            data1 = i+1;  
            data2 = i+2;
            data3 = i+3;
            data4 = 8'hxx;
            data5 = 8'hxx;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data);
            expect_n("sister_gen_rx_empty", 3'b010, sister_gen_rx_empty, 3);
            expect_1("Long Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
          end
          3: begin
            // This is second to last word.
            data0 = i;
            data1 = i+1;  
            data2 = i+2;
            data3 = i+3;
            data4 = i+4;
            data5 = i+5;
            data6 = 8'hxx;
            data7 = 8'hxx;
            check("Last sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data);
            expect_n("sister_gen_rx_empty", 3'b000, sister_gen_rx_empty, 3);
            expect_1("Long Last sister_gen_rx_endofpacket", 1'b0, sister_gen_rx_endofpacket);
            @(negedge sysclk);
            while( sister_gen_rx_valid !== 1'b1 ) @(negedge sysclk);
            -> check_task;    
            // This is last word.
            data0 = 8'h00;
            data1 = 8'h00;  
            data2 = 8'h00;
            data3 = 8'h00;
            data4 = 8'h00;
            data5 = 8'h00;
            data6 = 8'h00;
            data7 = 8'h00;
            check("Last sister_gen_rx_data", {data0,data1,data2,data3,data4,data5,data6,data7}, sister_gen_rx_data);
            expect_n("sister_gen_rx_empty", 3'b110, sister_gen_rx_empty, 3);
            expect_1("Long Last sister_gen_rx_endofpacket", 1'b1, sister_gen_rx_endofpacket);
         end
        endcase
      end
      sister_gen_rx_ready = 1'b0;
end
      @(negedge sysclk);
      sister_gen_rx_ready = 1'b0;
      donecheck("sister_receive_packet");
    end
  endtask


// ----------------------------------------
// DUT Avalon Slave IF / Avalon Master BFMs
// ----------------------------------------
// DUT I/O Avalon Slave Read
avalon_bfm_master #( .TRANSACTION      ( `BURST               )
                    ,.ADDRESS_WIDTH    ( 32                   )
                    ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                    ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                    ,.BYTEENABLE_WIDTH (BYTEENABLE_WIDTH     )
                    ,.BURSTCOUNT_WIDTH (BURSTCOUNT_WIDTH     )
                    ) bfm_io_read_master (
 .clk             (sysclk)
,.reset_n         (reset_n)
,.chipselect      (io_s_rd_chipselect)
,.address         ({io_s_rd_address,io_s_rd_addr_unused_bits})
,.read            (io_s_rd_read)
,.readdata        (io_s_rd_readdata)
,.write           ()
,.writedata       ()
,.byteenable      ()
,.waitrequest     (io_s_rd_waitrequest)
,.readdatavalid   (io_s_rd_readdatavalid)
,.burstcount      (io_s_rd_burstcount)
,.readerror       (io_s_rd_readerror)
,.irq             ()
);

// DUT I/O Avalon Slave Write
avalon_bfm_master #(  .TRANSACTION      ( `BURST               )
                     ,.ADDRESS_WIDTH    ( 32                   )
                     ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                     ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                     ,.BYTEENABLE_WIDTH (BYTEENABLE_WIDTH     )
                     ,.BURSTCOUNT_WIDTH (BURSTCOUNT_WIDTH     )
                      ) bfm_io_write_master (
 .clk             (sysclk)
,.reset_n         (reset_n)
,.chipselect      (io_s_wr_chipselect)
,.address         ({io_s_wr_address,io_s_wr_addr_unused_bits})
,.read            ()
,.readdata        ()
,.write           (io_s_wr_write)
,.writedata       (io_s_wr_writedata)
,.byteenable      (io_s_wr_byteenable)
,.waitrequest     (io_s_wr_waitrequest)
,.readdatavalid   ()
,.burstcount      (io_s_wr_burstcount)
,.readerror       ()
,.irq             ()
);



// ----------------------------------------
// DUT Avalon Master IF / Avalon Slave BFMs
// ----------------------------------------
// DUT I/O Avalon Master Read
avalon_bfm_slave #(  .TRANSACTION       ( `BURST               )
                     ,.ADDRESS_WIDTH    ( 32                   )
                     ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                     ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                     ,.BYTEENABLE_WIDTH ( BYTEENABLE_WIDTH    )
                     ,.BURSTCOUNT_WIDTH ( BURSTCOUNT_WIDTH    )
                     ) bfm_io_read_slave (
 .clk             (sysclk)
,.reset           (reset_n)
,.address         (io_m_rd_address)
,.read            (io_m_rd_read)
,.readdata        (io_m_rd_readdata)
,.write           ()
,.writedata       ()
,.byteenable      ()
,.waitrequest     (io_m_rd_waitrequest)
,.readdatavalid   (io_m_rd_readdatavalid)
,.readerror       (io_m_rd_readerror)
,.burstcount      (io_m_rd_burstcount)

);

// DUT I/O Avalon Master Write
avalon_bfm_slave #(  .TRANSACTION      ( `BURST ) 
                    ,.ADDRESS_WIDTH    ( 32                   )
                    ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                    ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                    ,.BYTEENABLE_WIDTH ( BYTEENABLE_WIDTH )
                    ,.BURSTCOUNT_WIDTH ( BURSTCOUNT_WIDTH )
                     ) bfm_io_write_slave (
 .clk             (sysclk)
,.reset           (reset_n)
,.address         (io_m_wr_address)
,.read            ()
,.readdata        ()
,.write           (io_m_wr_write)
,.writedata       (io_m_wr_writedata)
,.byteenable      (io_m_wr_byteenable)
,.waitrequest     (io_m_wr_waitrequest)
,.readdatavalid   ()
,.readerror       ()
,.burstcount      (io_m_wr_burstcount)
);

// DUT Concentrator Avalon Slave 
avalon_bfm_master #( .TRANSACTION   (`SINGLE)
                    ,.ADDRESS_WIDTH      (17) 
                     ) bfm_cnt_master (
 .clk             (sysclk)
,.reset_n         (reset_n)
,.chipselect      (sys_mnt_s_chipselect)
,.address         ({sys_mnt_s_address, sys_mnt_addr_unused_bits})
,.read            (sys_mnt_s_read)
,.readdata        (sys_mnt_s_readdata)
,.write           (sys_mnt_s_write)
,.writedata       (sys_mnt_s_writedata)
,.byteenable      ()
,.waitrequest     (sys_mnt_s_waitrequest)
,.readdatavalid   ()
,.burstcount      ()
,.readerror       ()
,.irq             (sys_mnt_s_irq)
);

// DUT Maintenance  Avalon Master
avalon_bfm_slave #(.TRANSACTION(`PIPELINED)) bfm_mnt_slave (
 .clk             (sysclk)
,.reset           (reset_n)
,.address         (mnt_m_address)
,.read            (mnt_m_read)
,.readdata        (mnt_m_readdata)
,.write           (mnt_m_write)
,.writedata       (mnt_m_writedata)
,.byteenable      ()
,.waitrequest     (mnt_m_waitrequest)
,.readdatavalid   (mnt_m_readdatavalid)
,.readerror       ()
,.burstcount      ()
);

// DUT Maintenance Avalon Slave 
avalon_bfm_master #( .TRANSACTION   ( `SINGLE )
                    ,.ADDRESS_WIDTH ( 26      ) 
) bfm_mnt_master (
 .clk             (sysclk)
,.reset_n         (reset_n)
,.chipselect      (mnt_s_chipselect)
,.address         ({mnt_s_address, mnt_addr_unused_bits})
,.read            (mnt_s_read)
,.readdata        (mnt_s_readdata)
,.write           (mnt_s_write)
,.writedata       (mnt_s_writedata)
,.byteenable      ()
,.waitrequest     (mnt_s_waitrequest)
,.readdatavalid   (mnt_s_readdatavalid)
,.burstcount      ()
,.readerror       (mnt_s_readerror)
,.irq             ()
);


// ----------------------------------------
// DUT Avalon Slave IF / Avalon Master BFMs
// ----------------------------------------
// DUT Doorbell Avalon Slave
avalon_bfm_master #(  .TRANSACTION      ( `SINGLE           )
                     ,.ADDRESS_WIDTH    ( DRBELL_ADDRESS_WIDTH )
                     ,.READDATA_WIDTH   ( 32                )
                     ,.WRITEDATA_WIDTH  ( 32                )
//                   ,.BYTEENABLE_WIDTH ( `BYTEENABLE_WIDTH )
//                   ,.BURSTCOUNT_WIDTH ( `BURSTCOUNT_WIDTH )
                      ) bfm_drbell_s_master (
 .clk             (sysclk)
,.reset_n         (reset_n)
,.chipselect      (drbell_s_chipselect)
,.address         ({drbell_s_address, drbell_addr_unused_bits})
,.read            (drbell_s_read)
,.readdata        (drbell_s_readdata)
,.write           (drbell_s_write)
,.writedata       (drbell_s_writedata)
,.byteenable      ()
,.waitrequest     (drbell_s_waitrequest)
,.readdatavalid   ()
,.burstcount      ()
,.readerror       ()
,.irq             (drbell_s_irq)
);

 

/**********************************************************************/
// NUMBER OF CHECKS
/**********************************************************************/
initial begin

    static int num_exp_chk_count = 3;

  #1;
       if( mode_selection == "SERIAL_1X" ) begin
            
          if ((p_IO_SLAVE == 1'b1)|| (p_IO_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 432 + 2 + 6 + 8;
          end
          if ((p_MAINTENANCE_SLAVE == 1'b1)|| (p_MAINTENANCE_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 8;
          end
          if (((p_TX_PORT_WRITE == 1'b1) || (p_RX_PORT_WRITE == 1'b1)) && (p_MAINTENANCE_SLAVE == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 11;
          end
          
          
          if ((p_DRBELL_TX == 1'b1) || (p_DRBELL_RX == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count  + 24;
          end
          
          if (p_READ_WRITE_ORDER) begin
              num_exp_chk_count = num_exp_chk_count  + 8;
          end
          
          if (p_DRBELL_WRITE_ORDER) begin
              num_exp_chk_count = num_exp_chk_count  + 159;
          end
                    
       end else begin
              
           if ((p_IO_SLAVE == 1'b1)|| (p_IO_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 428 + 2 + 6;
          end
          if ((p_MAINTENANCE_SLAVE == 1'b1) || (p_MAINTENANCE_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 8;
          end
          if (((p_TX_PORT_WRITE == 1'b1) || (p_RX_PORT_WRITE == 1'b1)) && (p_MAINTENANCE_SLAVE == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 11;
          end
          if ((p_DRBELL_TX == 1'b1) || (p_DRBELL_RX == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count  + 24;
          end
          
          if (p_READ_WRITE_ORDER) begin
              num_exp_chk_count = num_exp_chk_count  + 8;
          end
          
          if (p_DRBELL_WRITE_ORDER) begin
              num_exp_chk_count = num_exp_chk_count  + 159;
          end
       end

        if( (p_GENERIC_LOGICAL == 1'b1)) begin
            num_exp_chk_count = num_exp_chk_count + ((ADAT == 32) ? 250 : 250);   
        end
 
  num_exp_chk_count= num_exp_chk_count + 1; // For multicast-event symbol count check.
  err_limit = 5;
end



  //---------------------------------------------------------------------   
  // DUT top  instantiation
  //---------------------------------------------------------------------
  
  //Physical + Transport Layer
  //Logical Layer modules disabled, No Err Mgmt Extn
  //Pass Through enabled
  //Small Transport System
  altera_rapidio_top_with_reset_ctrl_pll
  #(
     .mode_selection(mode_selection),
     .p_TX_PORT_WRITE(p_TX_PORT_WRITE),
     .p_RX_PORT_WRITE(p_RX_PORT_WRITE),
     .p_DRBELL_TX(p_DRBELL_TX),
     .p_DRBELL_RX(p_DRBELL_RX),
     .p_TRANSPORT_LARGE(p_TRANSPORT_LARGE),
     .p_SEND_RESET_DEVICE(p_SEND_RESET_DEVICE),     
     .p_GENERIC_LOGICAL (p_GENERIC_LOGICAL),
     .p_IO_SLAVE_WIDTH(p_IO_SLAVE_WIDTH),
     .p_MAINTENANCE(p_MAINTENANCE),
     .p_IO_MASTER(p_IO_MASTER),
     .p_IO_SLAVE(p_IO_SLAVE),
     .p_timeout_enable(p_timeout_enable),
     .p_SOURCE_OPERATION_DATA_MESSAGE(p_SOURCE_OPERATION_DATA_MESSAGE),
     .p_DESTINATION_OPERATION_DATA_MESSAGE(p_DESTINATION_OPERATION_DATA_MESSAGE),
     .XCVR_RECONFIG(XCVR_RECONFIG)
  ) rio_inst 
  (
  
     //----------------------------
     // Control Signal Declarations
     //----------------------------
     .sysclk                             (sysclk),
     .reset_n                               (reset_n),
   
     // ----------------------
     // RapidIO Line Interface
     // ----------------------
     .rd                                  (rd), // input  [1-1:0]
     .td                                  (td), // output [1-1:0]
    // --------------
    // User Interface
    // --------------
    .clk                                 (clk), // input  // Reference Clock
    .txclk                               (txclk),    // output
    .rxclk                               (rxclk), // output // Recovered Clock
    
    // Registers 
    .ef_ptr                              (ef_ptr), // input [15:0]

    //////////////////////////////////////////////////////
    //////////////// INPUT OUTPUT MASTER LOGICAL LAYER ///
    //////////////////////////////////////////////////////
    //  ----------------------------
    // Datapath Write Avalon Master
    // ----------------------------
    .io_m_wr_waitrequest                 (io_m_wr_waitrequest), // input
    .io_m_wr_write                       (io_m_wr_write), // output
    .io_m_wr_address                     (io_m_wr_address), // output [32-1:0]
    .io_m_wr_writedata                   (io_m_wr_writedata), // output [32-1:0]
    .io_m_wr_byteenable                  (io_m_wr_byteenable), // output [BYTEENABLE_WIDTH-1:0] 
    .io_m_wr_burstcount                  (io_m_wr_burstcount), // output [BURSTCOUNT_WIDTH-1:0]
    // ---------------------------
    // Datapath Read Avalon Master
    // ---------------------------
    .io_m_rd_waitrequest                 (io_m_rd_waitrequest), // input
    .io_m_rd_read                        (io_m_rd_read), // output
    .io_m_rd_address                     (io_m_rd_address), // output [32-1:0]
    .io_m_rd_readdatavalid               (io_m_rd_readdatavalid), // input
    .io_m_rd_readerror                   (io_m_rd_readerror), // input
    .io_m_rd_readdata                    (io_m_rd_readdata), // input [32-1:0]
    .io_m_rd_burstcount                  (io_m_rd_burstcount), // output [BURSTCOUNT_WIDTH-1:0]
    //////////////////////////////////////////////////////
    ///////////////  INPUT OUTPUT SLAVE LOGICAL LAYER  ///
    //////////////////////////////////////////////////////
    // ---------------------------
    // Datapath Write Avalon Slave
    // ---------------------------
    .io_s_wr_chipselect                  (io_s_wr_chipselect), // input
    .io_s_wr_waitrequest                 (io_s_wr_waitrequest), // output
    .io_s_wr_write                       (io_s_wr_write), // input
    .io_s_wr_address                     (io_s_wr_address), // input [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0]
    .io_s_wr_writedata                   (io_s_wr_writedata), // input [32-1:0]
    .io_s_wr_byteenable                  (io_s_wr_byteenable), // input [ :0]
    .io_s_wr_burstcount                  (io_s_wr_burstcount), // input [BURSTCOUNT_WIDTH-1:0]
    // --------------------------
    // Datapath Read Avalon Slave
    // --------------------------
    .io_s_rd_chipselect                  (io_s_rd_chipselect), // input
    .io_s_rd_waitrequest                 (io_s_rd_waitrequest), // output
    .io_s_rd_read                        (io_s_rd_read), // input
    .io_s_rd_address                     (io_s_rd_address), // input [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0]
    .io_s_rd_readdatavalid               (io_s_rd_readdatavalid), // output
    .io_s_rd_readdata                    (io_s_rd_readdata), // output [32-1:0]
    .io_s_rd_burstcount                  (io_s_rd_burstcount), // input [BURSTCOUNT_WIDTH-1:0]
    .io_s_rd_readerror                   (io_s_rd_readerror), // output
    //////////////////////////////////////////////////////
    ///////////////// MAINTENANCE LOGICAL LAYER //////////
    //////////////////////////////////////////////////////
    // ------------------------------
    // Maintenance main Avalon Master
    // ------------------------------
    .mnt_m_waitrequest                   (mnt_m_waitrequest), // input
    .mnt_m_read                          (mnt_m_read), // output
    .mnt_m_write                         (mnt_m_write), // output
    .mnt_m_address                       (mnt_m_address), // output [31:0]
    .mnt_m_writedata                     (mnt_m_writedata), // output [31:0]
    .mnt_m_readdata                      (mnt_m_readdata), // input [31:0]
    .mnt_m_readdatavalid                 (mnt_m_readdatavalid), // input
    
    // -----------------------------
    // Maintenance main Avalon Slave
    // -----------------------------
    .mnt_s_chipselect                    (mnt_s_chipselect), // input
    .mnt_s_waitrequest                   (mnt_s_waitrequest), // output
    .mnt_s_read                          (mnt_s_read), // input
    .mnt_s_write                         (mnt_s_write), // input
    .mnt_s_address                       (mnt_s_address), // input [MAINTENANCE_ADDRESS_WIDTH-3:0]
    .mnt_s_writedata                     (mnt_s_writedata), // input [31:0]
    .mnt_s_readdata                      (mnt_s_readdata), // output [31:0]
    .mnt_s_readdatavalid                 (mnt_s_readdatavalid), // output
    .mnt_s_readerror                     (mnt_s_readerror), // output
    
    // -------------------------------
    // System Maintenance Avalon Slave
    // -------------------------------
    .sys_mnt_s_chipselect                (sys_mnt_s_chipselect), // input
    .sys_mnt_s_waitrequest               (sys_mnt_s_waitrequest), // output
    .sys_mnt_s_read                      (sys_mnt_s_read), // input
    .sys_mnt_s_write                     (sys_mnt_s_write), // input
    .sys_mnt_s_address                   (sys_mnt_s_address), // input [14:0]
    .sys_mnt_s_writedata                 (sys_mnt_s_writedata), // input [31:0]
    .sys_mnt_s_readdata                  (sys_mnt_s_readdata), // output [31:0]
    .sys_mnt_s_irq                       (sys_mnt_s_irq), // output
    . rx_packet_dropped                  (rx_packet_dropped), // output
    
    // Register Bits
    .output_enable                       (output_enable), // input // ORed with Output Port Enable CSR
    .input_enable                        (input_enable), // input // ORed with Input Port Enable CSR
    
    .master_enable                       (master_enable),
    .port_error                          (port_error),
    .port_response_timeout               (port_response_timeout),
    .rx_is_lockedtodata                  (rx_is_lockedtodata),

    
    //////////////////////////////////////////////////////
    ///////////////  DOORBELL LOGICAL LAYER  ///
    //////////////////////////////////////////////////////
    // ------------------------
    // Doorbell Avalon Slave
    // ------------------------
    .drbell_s_chipselect               (drbell_s_chipselect), // input
    .drbell_s_waitrequest              (drbell_s_waitrequest), // output
    .drbell_s_read                     (drbell_s_read), // input
    .drbell_s_write                    (drbell_s_write), // input
    .drbell_s_address                  (drbell_s_address), // input [DRBELL_ADDRESS_WIDTH-3:0]
    .drbell_s_writedata                (drbell_s_writedata), // input [31:0]
    .drbell_s_readdata                 (drbell_s_readdata), // output [31:0]
    .drbell_s_irq                        (drbell_s_irq), // output
    
    //////////////////////////////////////////////////////
    ////////////////// TRANSPORT LAYER ///////////////////
    //////////////////////////////////////////////////////
    // ---------------------------------------------------
    // Atlantic Interface for Generic Logical Layer Module
    // ---------------------------------------------------
    .gen_tx_ready                        (gen_tx_ready),         // output
    .gen_tx_valid                        (gen_tx_valid),         // input 
    .gen_tx_startofpacket                (gen_tx_startofpacket), // input
    .gen_tx_endofpacket                  (gen_tx_endofpacket),   // input
    .gen_tx_error                        (gen_tx_error),         // input
    .gen_tx_empty                        (gen_tx_empty),         // input [$mty_width-1:0]
    .gen_tx_data                         (gen_tx_data),          // input [$ADAT-1:0]
    //.gen_txsize                        (gen_txsize),           // input [$size_width-1:0]
    .gen_rx_ready                        (gen_rx_ready),         // input
    .gen_rx_valid                        (gen_rx_valid),         // output
    .gen_rx_startofpacket                (gen_rx_startofpacket), // output
    .gen_rx_endofpacket                  (gen_rx_endofpacket),   // output
    .gen_rx_empty                        (gen_rx_empty),         // output [$mty_width-1:0]
    .gen_rx_data                         (gen_rx_data),          // output [$ADAT-1:0]
    .gen_rx_size                         (gen_rx_size),          // output [$size_width-1:0]


    // ---------------------------
    // Other Miscellaneous Signals
    // ---------------------------
   
    .rx_errdetect                        (rx_errdetect), // output 
    .pll_locked                       (gxbpll_locked), // output // From ALTGXB Serializer

    // Physical Informative Signals
    .port_initialized                    (port_initialized), // output
    .atxwlevel                           (atxwlevel), // output [7-1:0]
    .atxovf                              (atxovf), // output
    .arxwlevel                           (arxwlevel), // output [6:0]
    .buf_av0                             (buf_av0), // output
    .buf_av1                             (buf_av1), // output
    .buf_av2                             (buf_av2), // output
    .buf_av3                             (buf_av3), // output
    .packet_transmitted                  (packet_transmitted), // output
    .packet_cancelled                    (packet_cancelled), // output
    .packet_accepted                     (packet_accepted), // output
    .packet_retry                        (packet_retry), // output
    .packet_not_accepted                 (packet_not_accepted), // output
    .packet_crc_error                    (packet_crc_error), // output
    .symbol_error                        (symbol_error), // output
    .char_err                            (char_err), // output
    .multicast_event_rx                  (multicast_event_rx ), // output
    .multicast_event_tx                  (multicast_event_tx ), // input        
    .no_sync_indicator                   (no_sync_indicator), // output
    
    // RX PHY3 Buffer Threshold Connect Inputs
    .rx_threshold_0                      (rx_threshold_0), // input [$rxbuf_addr_width:0]
    .rx_threshold_1                      (rx_threshold_1), // input [$rxbuf_addr_width:0]
    .rx_threshold_2                      (rx_threshold_2), // input [$rxbuf_addr_width:0]
    
    // CARs and CSRs Connect Inputs
    .device_identifier                   (device_identifier), // input [15:0] // Device Identity
    .device_vendor_id                    (device_vendor_id), // input [15:0] // Devince Vendor Identity
    .device_revision                     (device_revision), // input [31:0] // Device Revision Level
    .assembly_id                         (assembly_id), // input [15:0] // Assembly Identity
    .assembly_vendor_id                  (assembly_vendor_id), // input [15:0] // Assembly Vendor Identity
    .assembly_revision                   (assembly_revision), // input [15:0] // Assembly Revision
    .extended_features_ptr               (extended_features_ptr), // input [15:0] // Extended Features Pointer
    .bridge_support                      (bridge_support), // input // Bridge Support
    .memory_access                       (memory_access), // input // Memory Access
    .processor_present                   (processor_present), // input // Processor Present
    .switch_support                      (switch_support), // input // Switch Support
    .number_of_ports                     (number_of_ports), // input [7:0] // Number of Ports
    .port_number                         (port_number), // input [7:0] // Port Number

    .txclk_timeout_prescaler             (txclk_timeout_prescaler), // input [6:0] // Port Link Timeout
    .sysclk_timeout_prescaler            (sysclk_timeout_prescaler), // input [6:0] // Port Response Timeout

    //------------------
    // Error Management signals
    //------------------
    .error_detect_message_error_response     (1'd0),
    .error_detect_message_format_error       (1'd0),
    .error_detect_message_request_timeout    (1'd0),
    .error_capture_letter                    (2'd0),
    .error_capture_mbox                      (2'd0),
    .error_capture_msgseg_or_xmbox           (4'd0),
    .error_detect_illegal_transaction_decode (1'd0),
    .error_detect_illegal_transaction_target (1'd0),
    .error_detect_packet_response_timeout    (1'd0),
    .error_detect_unsolicited_response       (1'd0),
    .error_detect_unsupported_transaction    (1'd0),
    .error_capture_ftype                     (4'd0),
    .error_capture_ttype                     (4'd0),
    .error_capture_destination_id            (16'd0),
    .error_capture_source_id                 (16'd0),

    //------------------
    // Reconfig Signals
    //------------------
    .reconfig_clk       (1'b0),//(reconfig_clk),
    .reconfig_reset     (1'b0),//(reconfig_reset),
    .reconfig_write     ({LSIZE{1'b0}}),//(reconfig_write),
    .reconfig_read      ({LSIZE{1'b0}}),//(reconfig_read),
    .reconfig_address   ({LSIZE{10'b0}}),//(reconfig_address),
    .reconfig_writedata ({LSIZE{32'b0}}),//(reconfig_writedata),
    .reconfig_readdata    (),
    .reconfig_waitrequest ()
   
   
  );

//-----------------------------------------------------------------
// SISTER SRIO
//-----------------------------------------------------------------

// -------------------------
// -------------------------
// Sister RIO IP core wiring
// -------------------------
// -------------------------

////////////////////
// Physical layer //
////////////////////
/********************************/
/* RapidIO Line Interface       */
/********************************/
wire [NUMBER_OF_XCVR_CHANNELS -1 : 0] sister_rd;
wire [NUMBER_OF_XCVR_CHANNELS -1 : 0] sister_td;
/********************************/
/* User Interface               */
/********************************/
wire sister_txclk; // Serial RapidIO output clock
wire sister_rxclk; // Recovered Clock

wire [15:0] sister_ef_ptr;
///////////////////////////////////////
// Input Output Master Logical Layer //
///////////////////////////////////////
/********************************/
/* Datapath Write Avalon Master */
/********************************/
wire sister_io_m_wr_waitrequest;
wire sister_io_m_wr_write;
wire [31:0] sister_io_m_wr_address;
wire [IO_DATAPATH_WIDTH-1:0] sister_io_m_wr_writedata;
wire [BYTEENABLE_WIDTH-1:0] sister_io_m_wr_byteenable;
wire [BURSTCOUNT_WIDTH-1:0] sister_io_m_wr_burstcount;
/********************************/
/* Datapath Read Avalon Master  */
/********************************/
//wire sister_io_m_rd_clk;
wire sister_io_m_rd_waitrequest;
wire sister_io_m_rd_read;
wire [31:0] sister_io_m_rd_address;
wire sister_io_m_rd_readdatavalid;
wire sister_io_m_rd_readerror;
wire [IO_DATAPATH_WIDTH-1:0] sister_io_m_rd_readdata;
wire [BURSTCOUNT_WIDTH-1:0] sister_io_m_rd_burstcount;
///////////////////////////////////////
// Input Output Slave Logical Layer  //
///////////////////////////////////////
/********************************/
/* Datapath Write Avalon Slave  */
/********************************/
//wire sister_io_s_wr_clk;
wire sister_io_s_wr_chipselect;
wire sister_io_s_wr_waitrequest;
wire sister_io_s_wr_write;
wire [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0] sister_io_s_wr_address;
wire [p_IO_SLAVE_ADDRESS_LSB-1:0] sis_io_s_wr_addr_unused_bits;
wire [IO_DATAPATH_WIDTH-1:0] sister_io_s_wr_writedata;
wire [BYTEENABLE_WIDTH-1:0] sister_io_s_wr_byteenable;
wire [BURSTCOUNT_WIDTH-1:0] sister_io_s_wr_burstcount;
/********************************/
/* Datapath Read Avalon Slave   */
/********************************/
//wire sister_io_s_rd_clk;
wire sister_io_s_rd_chipselect;
wire sister_io_s_rd_waitrequest;
wire sister_io_s_rd_read;
wire [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0] sister_io_s_rd_address;
wire [p_IO_SLAVE_ADDRESS_LSB-1:0] sis_io_s_rd_addr_unused_bits;
wire sister_io_s_rd_readdatavalid;
wire [IO_DATAPATH_WIDTH-1:0] sister_io_s_rd_readdata;
wire [BURSTCOUNT_WIDTH-1:0] sister_io_s_rd_burstcount;
wire sister_io_s_rd_readerror;
///////////////////////////////
// Maintenance Logical Layer //
///////////////////////////////
//wire sister_mnt_m_clk; // 
//wire sister_mnt_s_clk; // 
/*************************************/
/* Maintenance main Avalon Master    */
/*************************************/
wire sister_mnt_m_waitrequest;
wire sister_mnt_m_read;
wire sister_mnt_m_write;
wire [31:0] sister_mnt_m_address;
wire [31:0] sister_mnt_m_writedata;
wire [31:0] sister_mnt_m_readdata;
wire sister_mnt_m_readdatavalid;
/*************************************/
/* Maintenance main Avalon Slave     */
/*************************************/
wire sister_mnt_s_chipselect;
wire sister_mnt_s_waitrequest;
wire sister_mnt_s_read;
wire sister_mnt_s_write;
wire [SISTER_MAINTENANCE_ADDRESS_WIDTH-3:0] sister_mnt_s_address;
wire [1:0] sister_mnt_addr_unused_bits;
wire [31:0] sister_mnt_s_writedata;
wire [31:0] sister_mnt_s_readdata;
wire sister_mnt_s_readdatavalid;
wire sister_mnt_s_readerror;
/***********************************/
/* System Maintenance Avalon Slave */
/***********************************/
wire sister_sys_mnt_s_chipselect;
wire sister_sys_mnt_s_waitrequest;
wire sister_sys_mnt_s_read;
wire sister_sys_mnt_s_write;
wire [14:0] sister_sys_mnt_s_address;
wire [1:0] sister_sys_mnt_addr_unused_bits;
wire [31:0] sister_sys_mnt_s_writedata;
wire [31:0] sister_sys_mnt_s_readdata;
wire sister_sys_mnt_s_irq;
wire sister_rx_packet_dropped;

//////////////////////////////////////
// Misc signals                     //
/////////////////////////////////////
wire sister_master_enable;
wire sister_port_error;
wire [23:0] sister_port_response_timeout;
wire [NUMBER_OF_XCVR_CHANNELS - 1 : 0] sister_rx_is_lockedtodata;

/////////////////////////////
// Doorbell Logical Layer  //
/////////////////////////////
/*********************/
/*  Avalon Slave     */
/*********************/
wire sister_drbell_s_chipselect;
wire sister_drbell_s_waitrequest;
wire sister_drbell_s_read;
wire sister_drbell_s_write;
wire [DRBELL_ADDRESS_WIDTH-3:0] sister_drbell_s_address;
wire [1:0] sister_drbell_addr_unused_bits;
wire [31:0] sister_drbell_s_writedata;
wire [31:0] sister_drbell_s_readdata;
wire sister_drbell_s_irq;

/********************************/
/* Other Miscellaneous Signals  */
/********************************/
// Register Bits
wire  sister_output_enable; // ORed with Output Port Enable CSR
wire  sister_input_enable;  // ORed with Input Port Enable CSR
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] sister_rx_errdetect; 
wire sister_gxbpll_locked; // From ALTGXB Serializer

// Physical Informative Signals
wire sister_port_initialized;
wire [8:0] sister_atxwlevel;
wire sister_atxovf;
wire [9:0] sister_arxwlevel;
wire sister_buf_av0;
wire sister_buf_av1;
wire sister_buf_av2;
wire sister_buf_av3;
wire sister_packet_transmitted;
wire sister_packet_cancelled;
wire sister_packet_accepted;
wire sister_packet_retry;
wire sister_packet_not_accepted;
wire sister_packet_crc_error;
wire sister_symbol_error;
wire sister_char_err;
wire sister_multicast_event_rx;
reg  sister_multicast_event_tx;
wire sister_no_sync_indicator;

wire [6:0] sister_txclk_timeout_prescaler;  // Port Link Timeout
wire [6:0] sister_sysclk_timeout_prescaler; // Port Response Timeout

/**************************/
/* MegaWizard Set Signals */
/**************************/
// RX PHY3 Buffer Threshold Connect Inputs
wire [9:0] sister_rx_threshold_0;
wire [9:0] sister_rx_threshold_1;
wire [9:0] sister_rx_threshold_2;
// MegaWizard Derived Connect Inputs
// CARs and CSRs Connect Inputs
wire [15:0] sister_device_identifier = 16'h0000;      // Device Identity
wire [15:0] sister_device_vendor_id = 16'h0000;       // Devince Vendor Identity
wire [31:0] sister_device_revision = 32'h0000_0000;   // Device Revision Level
wire [15:0] sister_assembly_id = 16'h0000;            // Assembly Identity
wire [15:0] sister_assembly_vendor_id = 16'h0000;     // Assembly Vendor Identity
wire [15:0] sister_assembly_revision = 16'h0000;      // Assembly Revision
wire [15:0] sister_extended_features_ptr = 16'h0000;  // Extended Features Pointer
wire sister_bridge_support = 1'b0;                    // Bridge Support
wire sister_memory_access = 1'b0;                     // Memory Access
wire sister_processor_present = 1'b0;                 // Processor Present
wire sister_switch_support = 1'b0;                    // Switch Support
wire [7:0] sister_number_of_ports = 8'd1;             // Number of Ports
wire [7:0] sister_port_number = 8'd0;                 // Port Number

assign rx_threshold_0 = 20;
assign rx_threshold_1 = 15;
assign rx_threshold_2 = 10;
assign input_enable = 1;
assign output_enable = 1;
assign ef_ptr = 0;

assign txclk_timeout_prescaler  = p_PRESCALER_VALUE;   // Port Link Timeout
assign sysclk_timeout_prescaler = p_PRESCALER_VALUE;  // Port Response Timeout


           
// ----------------------------------------
// SISTER Avalon Slave IF / Avalon Master BFMs
// ----------------------------------------
// SISTER Doorbell Avalon Slave
avalon_bfm_master #(  .TRANSACTION      ( `SINGLE           )
                     ,.ADDRESS_WIDTH    ( DRBELL_ADDRESS_WIDTH )
                     ,.READDATA_WIDTH   ( 32                )
                     ,.WRITEDATA_WIDTH  ( 32                )
//                   ,.BYTEENABLE_WIDTH ( `BYTEENABLE_WIDTH )
//                   ,.BURSTCOUNT_WIDTH ( `BURSTCOUNT_WIDTH )
                      ) sister_bfm_drbell_s_master (
 .clk             (sysclk)
,.reset_n         (sister_reset_n)
,.chipselect      (sister_drbell_s_chipselect)
,.address         ({sister_drbell_s_address, sister_drbell_addr_unused_bits})
,.read            (sister_drbell_s_read)
,.readdata        (sister_drbell_s_readdata)
,.write           (sister_drbell_s_write)
,.writedata       (sister_drbell_s_writedata)
,.byteenable      ()
,.waitrequest     (sister_drbell_s_waitrequest)
,.readdatavalid   ()
,.burstcount      ()
,.readerror       ()
,.irq             (sister_drbell_s_irq)
);




// ----------------------------------------
// Sister Avalon Slave IF / Avalon Master BFMs
// ----------------------------------------
// DUT I/O Avalon Slave Read
avalon_bfm_master #(  .TRANSACTION      ( `BURST               )
                     ,.ADDRESS_WIDTH    ( 32                   )
                     ,.READDATA_WIDTH   ( 32 )
                     ,.WRITEDATA_WIDTH  ( 32 )
                     ,.BYTEENABLE_WIDTH (BYTEENABLE_WIDTH     )
                     ,.BURSTCOUNT_WIDTH (BURSTCOUNT_WIDTH     )
                      ) sister_bfm_io_read_master (
 .clk             (sysclk)
,.reset_n         (sister_reset_n)
,.chipselect      (sister_io_s_rd_chipselect)
,.address         ({sister_io_s_rd_address,sis_io_s_rd_addr_unused_bits})
,.read            (sister_io_s_rd_read)
,.readdata        (sister_io_s_rd_readdata)
,.write           ()
,.writedata       ()
,.byteenable      ()
,.waitrequest     (sister_io_s_rd_waitrequest)
,.readdatavalid   (sister_io_s_rd_readdatavalid)
,.burstcount      (sister_io_s_rd_burstcount)
,.readerror       (sister_io_s_rd_readerror)
,.irq             ()
);

// Sister I/O Avalon Slave Write
avalon_bfm_master #(  .TRANSACTION      ( `BURST               )
                     ,.ADDRESS_WIDTH    ( 32                   )
                     ,.READDATA_WIDTH   ( 32 )
                     ,.WRITEDATA_WIDTH  ( 32 )
                     ,.BYTEENABLE_WIDTH (BYTEENABLE_WIDTH     )
                     ,.BURSTCOUNT_WIDTH (BURSTCOUNT_WIDTH     )
                     ) sister_bfm_io_write_master (
 .clk             (sysclk)
,.reset_n         (sister_reset_n)
,.chipselect      (sister_io_s_wr_chipselect)
,.address         ({sister_io_s_wr_address,sis_io_s_wr_addr_unused_bits})
,.read            ()
,.readdata        ()
,.write           (sister_io_s_wr_write)
,.writedata       (sister_io_s_wr_writedata)
,.byteenable      (sister_io_s_wr_byteenable)
,.waitrequest     (sister_io_s_wr_waitrequest)
,.readdatavalid   ()
,.burstcount      (sister_io_s_wr_burstcount)
,.readerror       ()
,.irq             ()
);


// ----------------------------------------
// Sister Avalon Master IF / Avalon Slave BFMs
// ----------------------------------------
// Syster I/O Avalon Master Read
avalon_bfm_slave #(  .TRANSACTION      ( `BURST               )
                    ,.ADDRESS_WIDTH    ( 32                   )
                    ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                    ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                    ,.BYTEENABLE_WIDTH ( BYTEENABLE_WIDTH    )
                    ,.BURSTCOUNT_WIDTH ( BURSTCOUNT_WIDTH    )
) sister_bfm_io_read_slave (
 .clk             (sysclk)
,.reset           (sister_reset_n)
,.address         (sister_io_m_rd_address)
,.read            (sister_io_m_rd_read)
,.readdata        (sister_io_m_rd_readdata)
,.write           ()
,.writedata       ()
,.byteenable      ()
,.waitrequest     (sister_io_m_rd_waitrequest)
,.readdatavalid   (sister_io_m_rd_readdatavalid)
,.readerror       (sister_io_m_rd_readerror)
,.burstcount      (sister_io_m_rd_burstcount)
);

// Sister I/O Avalon Master Write
avalon_bfm_slave #(  .TRANSACTION      ( `BURST               )
                    ,.ADDRESS_WIDTH    ( 32                   )
                    ,.READDATA_WIDTH   ( IO_DATAPATH_WIDTH )
                    ,.WRITEDATA_WIDTH  ( IO_DATAPATH_WIDTH )
                    ,.BYTEENABLE_WIDTH ( BYTEENABLE_WIDTH    )
                    ,.BURSTCOUNT_WIDTH ( BURSTCOUNT_WIDTH    )
                   ) sister_bfm_io_write_slave (
 .clk             (sysclk)
,.reset           (sister_reset_n)
,.address         (sister_io_m_wr_address)
,.read            ()
,.readdata        ()
,.write           (sister_io_m_wr_write)
,.writedata       (sister_io_m_wr_writedata)
,.byteenable      (sister_io_m_wr_byteenable)
,.waitrequest     (sister_io_m_wr_waitrequest)
,.readdatavalid   ()
,.readerror       ()
,.burstcount      (sister_io_m_wr_burstcount)
);

// DUT Concentrator Avalon Slave 
avalon_bfm_master #(.TRANSACTION    (`SINGLE)
                    ,.ADDRESS_WIDTH      (17) ) sister_bfm_cnt_master (
 .clk             (sysclk)
,.reset_n         (sister_reset_n)
,.chipselect      (sister_sys_mnt_s_chipselect)
,.address         ({sister_sys_mnt_s_address, sister_sys_mnt_addr_unused_bits})
,.read            (sister_sys_mnt_s_read)
,.readdata        (sister_sys_mnt_s_readdata)
,.write           (sister_sys_mnt_s_write)
,.writedata       (sister_sys_mnt_s_writedata)
,.byteenable      ()
,.waitrequest     (sister_sys_mnt_s_waitrequest)
,.readdatavalid   ()
,.burstcount      ()
,.readerror       ()
,.irq             (sister_sys_mnt_s_irq)
);

// DUT Maintenance  Avalon Master
avalon_bfm_slave #(.TRANSACTION(`PIPELINED)) sister_bfm_mnt_slave (
 .clk             (sysclk)
,.reset           (sister_reset_n)
,.address         (sister_mnt_m_address)
,.read            (sister_mnt_m_read)
,.readdata        (sister_mnt_m_readdata)
,.write           (sister_mnt_m_write)
,.writedata       (sister_mnt_m_writedata)
,.byteenable      ()
,.waitrequest     (sister_mnt_m_waitrequest)
,.readdatavalid   (sister_mnt_m_readdatavalid)
,.readerror       ()
,.burstcount      ()
);

// DUT Maintenance Avalon Slave
avalon_bfm_master #(  .TRANSACTION   ( `SINGLE )
                     ,.ADDRESS_WIDTH ( 26      )
                      ) sister_bfm_mnt_master (
 .clk             (sysclk)
,.reset_n           (sister_reset_n)
,.chipselect      (sister_mnt_s_chipselect)
,.address         ({sister_mnt_s_address, sister_mnt_addr_unused_bits})
,.read            (sister_mnt_s_read)
,.readdata        (sister_mnt_s_readdata)
,.write           (sister_mnt_s_write)
,.writedata       (sister_mnt_s_writedata)
,.byteenable      ()
,.waitrequest     (sister_mnt_s_waitrequest)
,.readdatavalid   (sister_mnt_s_readdatavalid)
,.burstcount      ()
,.readerror       (sister_mnt_s_readerror)
,.irq             ()
);

  //---------------------------------------------------------------------   
  // SISTER DUT Instantiation
  //---------------------------------------------------------------------
  
  
  altera_rapidio_top_with_reset_ctrl_pll
  #(
     .mode_selection(mode_selection),
     .p_TX_PORT_WRITE(p_TX_PORT_WRITE),
     .p_RX_PORT_WRITE(p_RX_PORT_WRITE),
     .p_DRBELL_TX(p_DRBELL_TX),
     .p_DRBELL_RX(p_DRBELL_RX),
     .p_TRANSPORT_LARGE(p_TRANSPORT_LARGE),
     .p_SEND_RESET_DEVICE(p_SEND_RESET_DEVICE),     
     .p_GENERIC_LOGICAL (p_GENERIC_LOGICAL),
     .p_IO_SLAVE_WIDTH(p_IO_SLAVE_WIDTH),
     .p_MAINTENANCE(p_MAINTENANCE),
     .p_IO_MASTER(p_IO_MASTER),
     .p_IO_SLAVE(p_IO_SLAVE),
     .p_timeout_enable(p_timeout_enable),
     .p_SOURCE_OPERATION_DATA_MESSAGE(p_SOURCE_OPERATION_DATA_MESSAGE),
     .p_DESTINATION_OPERATION_DATA_MESSAGE(p_DESTINATION_OPERATION_DATA_MESSAGE),
     .XCVR_RECONFIG(XCVR_RECONFIG)
  ) sis_rio_inst (       
     //----------------------------
     // Control Signal Declarations
     //----------------------------
     .sysclk                             (sysclk),
     .reset_n                               (sister_reset_n),
     // ----------------------
    // RapidIO Line Interface
    // ----------------------
    .rd                                  (sister_rd), // input  [1-1:0]
    .td                                  (sister_td), // output [1-1:0]
    // --------------
    // User Interface
    // --------------
    .clk                                 (clk), // input  // Reference Clock
    .txclk                               (sister_txclk),    // output
    .rxclk                               (sister_rxclk), // output // Recovered Clock
    // Registers
    .ef_ptr                              (sister_ef_ptr), // input [15:0]
    //////////////////////////////////////////////////////
    //////////////// INPUT OUTPUT MASTER LOGICAL LAYER ///
    //////////////////////////////////////////////////////
    // ----------------------------
    // Datapath Write Avalon Master
    // ----------------------------
    .io_m_wr_waitrequest                 (sister_io_m_wr_waitrequest), // input
    .io_m_wr_write                       (sister_io_m_wr_write), // output
    .io_m_wr_address                     (sister_io_m_wr_address), // output [32-1:0]
    .io_m_wr_writedata                   (sister_io_m_wr_writedata), // output [32-1:0]
    .io_m_wr_byteenable                  (sister_io_m_wr_byteenable), // output [ :0]
    .io_m_wr_burstcount                  (sister_io_m_wr_burstcount), // output [ :0]
    // ---------------------------
    // Datapath Read Avalon Master
    // ---------------------------
    .io_m_rd_waitrequest                 (sister_io_m_rd_waitrequest), // input
    .io_m_rd_read                        (sister_io_m_rd_read), // output
    .io_m_rd_address                     (sister_io_m_rd_address), // output [32-1:0]
    .io_m_rd_readdatavalid               (sister_io_m_rd_readdatavalid), // input
    .io_m_rd_readerror                   (sister_io_m_rd_readerror), // input
    .io_m_rd_readdata                    (sister_io_m_rd_readdata), // input [32-1:0]
    .io_m_rd_burstcount                  (sister_io_m_rd_burstcount), // output [ :0]
    //////////////////////////////////////////////////////
    ///////////////  INPUT OUTPUT SLAVE LOGICAL LAYER  ///
    //////////////////////////////////////////////////////
    // ---------------------------
    // Datapath Write Avalon Slave
    // ---------------------------
    .io_s_wr_chipselect                  (sister_io_s_wr_chipselect), // input
    .io_s_wr_waitrequest                 (sister_io_s_wr_waitrequest), // output
    .io_s_wr_write                       (sister_io_s_wr_write), // input
    .io_s_wr_address                     (sister_io_s_wr_address), // input [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0]
    .io_s_wr_writedata                   (sister_io_s_wr_writedata), // input [32-1:0]
    .io_s_wr_byteenable                  (sister_io_s_wr_byteenable), // input [ :0]
    .io_s_wr_burstcount                  (sister_io_s_wr_burstcount), // input [ :0]
    // --------------------------
    // Datapath Read Avalon Slave
    // --------------------------
    .io_s_rd_chipselect                  (sister_io_s_rd_chipselect), // input
    .io_s_rd_waitrequest                 (sister_io_s_rd_waitrequest), // output
    .io_s_rd_read                        (sister_io_s_rd_read), // input
    .io_s_rd_address                     (sister_io_s_rd_address), // input input [p_IO_SLAVE_WIDTH-p_IO_SLAVE_ADDRESS_LSB-1:0]
    .io_s_rd_readdatavalid               (sister_io_s_rd_readdatavalid), // output
    .io_s_rd_readdata                    (sister_io_s_rd_readdata), // output [32-1:0]
    .io_s_rd_burstcount                  (sister_io_s_rd_burstcount), // input [ :0]
    .io_s_rd_readerror                   (sister_io_s_rd_readerror), // output
    //////////////////////////////////////////////////////
    ///////////////// MAINTENANCE LOGICAL LAYER //////////
    //////////////////////////////////////////////////////
    // ------------------------------
    // Maintenance main Avalon Master
    // ------------------------------

    .mnt_m_waitrequest                   (sister_mnt_m_waitrequest), // input
    .mnt_m_read                          (sister_mnt_m_read), // output
    .mnt_m_write                         (sister_mnt_m_write), // output
    .mnt_m_address                       (sister_mnt_m_address), // output [31:0]
    .mnt_m_writedata                     (sister_mnt_m_writedata), // output [31:0]
    .mnt_m_readdata                      (sister_mnt_m_readdata), // input [31:0]
    .mnt_m_readdatavalid                 (sister_mnt_m_readdatavalid), // input

    // -----------------------------
    // Maintenance main Avalon Slave
    // -----------------------------
    .mnt_s_chipselect                    (sister_mnt_s_chipselect), // input
    .mnt_s_waitrequest                   (sister_mnt_s_waitrequest), // output
    .mnt_s_read                          (sister_mnt_s_read), // input
    .mnt_s_write                         (sister_mnt_s_write), // input
    .mnt_s_address                       (sister_mnt_s_address), // input [sister_MAINTENANCE_ADDRESS_WIDTH-3:0]
    .mnt_s_writedata                     (sister_mnt_s_writedata), // input [31:0]
    .mnt_s_readdata                      (sister_mnt_s_readdata), // output [31:0]
    .mnt_s_readdatavalid                 (sister_mnt_s_readdatavalid), // output
    .mnt_s_readerror                     (sister_mnt_s_readerror), // output
    // -------------------------------
    // System Maintenance Avalon Slave
    // -------------------------------
    .sys_mnt_s_chipselect                (sister_sys_mnt_s_chipselect), // input
    .sys_mnt_s_waitrequest               (sister_sys_mnt_s_waitrequest), // output
    .sys_mnt_s_read                      (sister_sys_mnt_s_read), // input
    .sys_mnt_s_write                     (sister_sys_mnt_s_write), // input
    .sys_mnt_s_address                   (sister_sys_mnt_s_address), // input [14:0]
    .sys_mnt_s_writedata                 (sister_sys_mnt_s_writedata), // input [31:0]
    .sys_mnt_s_readdata                  (sister_sys_mnt_s_readdata), // output [31:0]
    .sys_mnt_s_irq                       (sister_sys_mnt_s_irq), // output
    . rx_packet_dropped                  (sister_rx_packet_dropped), // output
    
    //////////////////////////////////////////////////////
    ///////////////  DOORBELL LOGICAL LAYER  ///
    //////////////////////////////////////////////////////
    // ------------------------
    // Doorbell Avalon Slave
    // ------------------------
    .drbell_s_chipselect               (sister_drbell_s_chipselect), // input
    .drbell_s_waitrequest              (sister_drbell_s_waitrequest), // output
    .drbell_s_read                     (sister_drbell_s_read), // input
    .drbell_s_write                    (sister_drbell_s_write), // input
    .drbell_s_address                  (sister_drbell_s_address), // input [DRBELL_ADDRESS_WIDTH-3:0]
    .drbell_s_writedata                (sister_drbell_s_writedata), // input [31:0]
    .drbell_s_readdata                 (sister_drbell_s_readdata), // output [31:0]
    .drbell_s_irq                      (sister_drbell_s_irq), // output
    
    //////////////////////////////////////////////////////
    ////////////////// TRANSPORT LAYER ///////////////////
    //////////////////////////////////////////////////////
    // ---------------------------------------------------
    // Avalon-ST Interface for Generic Logical Layer Module
    // ---------------------------------------------------
    .gen_tx_ready                        (sister_gen_tx_ready),         // output
    .gen_tx_valid                        (sister_gen_tx_valid),         // input 
    .gen_tx_startofpacket                (sister_gen_tx_startofpacket), // input
    .gen_tx_endofpacket                  (sister_gen_tx_endofpacket),   // input
    .gen_tx_error                        (sister_gen_tx_error),         // input
    .gen_tx_empty                        (sister_gen_tx_empty),         // input [$mty_width-1:0]
    .gen_tx_data                         (sister_gen_tx_data),          // input [$ADAT-1:0]
    .gen_rx_ready                        (sister_gen_rx_ready),         // input
    .gen_rx_valid                        (sister_gen_rx_valid),         // output
    .gen_rx_startofpacket                (sister_gen_rx_startofpacket), // output
    .gen_rx_endofpacket                  (sister_gen_rx_endofpacket),   // output
    .gen_rx_empty                        (sister_gen_rx_empty),         // output [$mty_width-1:0]
    .gen_rx_data                         (sister_gen_rx_data),          // output [$ADAT-1:0]
    .gen_rx_size                         (sister_gen_rx_size),          // output [$size_width-1:0]

    // ---------------------------
    // Other Miscellaneous Signals
    // ---------------------------
    // Register Bits
    .output_enable                       (sister_output_enable), // input // ORed with Output Port Enable CSR
    .input_enable                        (sister_input_enable), // input // ORed with Input Port Enable CSR
    .rx_errdetect                        (sister_rx_errdetect), // output [1*2-1:0]
    .pll_locked                       (sister_gxbpll_locked), // output // From ALTGXB Serializer
    
    .master_enable                       (sister_master_enable),
    .port_error                          (sister_port_error),
    .port_response_timeout               (sister_port_response_timeout),
    .rx_is_lockedtodata                  (sister_rx_is_lockedtodata),
      
    // Physical Informative Signals
    .port_initialized                    (sister_port_initialized), // output
    .atxwlevel                           (sister_atxwlevel), // output [7-1:0]
    .atxovf                              (sister_atxovf), // output
    .arxwlevel                           (sister_arxwlevel), // output [6:0]
    .buf_av0                             (sister_buf_av0), // output
    .buf_av1                             (sister_buf_av1), // output
    .buf_av2                             (sister_buf_av2), // output
    .buf_av3                             (sister_buf_av3), // output
    .packet_transmitted                  (sister_packet_transmitted), // output
    .packet_cancelled                    (sister_packet_cancelled), // output
    .packet_accepted                     (sister_packet_accepted), // output
    .packet_retry                        (sister_packet_retry), // output
    .packet_not_accepted                 (sister_packet_not_accepted), // output
    .packet_crc_error                    (sister_packet_crc_error), // output
    .symbol_error                        (sister_symbol_error), // output
    .char_err                            (sister_char_err), // output
    .multicast_event_rx                  (sister_multicast_event_rx ), // output
    .multicast_event_tx                  (sister_multicast_event_tx ), // input                                           
    .no_sync_indicator                   (sister_no_sync_indicator), // output
    // Prescalers should be connected wizard
    .txclk_timeout_prescaler             (sister_txclk_timeout_prescaler),  // input [6:0] // Port Link Timeout
    .sysclk_timeout_prescaler            (sister_sysclk_timeout_prescaler), // input [6:0] // Port Response Timeout
    // ----------------------
    // MegaWizard Set Signals
    // ----------------------
    // RX PHY3 Buffer Threshold Connect Inputs
    .rx_threshold_0                      (sister_rx_threshold_0), // input [6:0]
    .rx_threshold_1                      (sister_rx_threshold_1), // input [6:0]
    .rx_threshold_2                      (sister_rx_threshold_2), // input [6:0]
    // MegaWizard Derived Connect Inputs
    // CARs and CSRs Connect Inputs
    .device_identifier                   (sister_device_identifier), // input [15:0] // Device Identity
    .device_vendor_id                    (sister_device_vendor_id), // input [15:0] // Devince Vendor Identity
    .device_revision                     (sister_device_revision), // input [31:0] // Device Revision Level
    .assembly_id                         (sister_assembly_id), // input [15:0] // Assembly Identity
    .assembly_vendor_id                  (sister_assembly_vendor_id), // input [15:0] // Assembly Vendor Identity
    .assembly_revision                   (sister_assembly_revision), // input [15:0] // Assembly Revision
    .extended_features_ptr               (sister_extended_features_ptr), // input [15:0] // Extended Features Pointer
    .bridge_support                      (sister_bridge_support), // input // Bridge Support
    .memory_access                       (sister_memory_access), // input // Memory Access
    .processor_present                   (sister_processor_present), // input // Processor Present
    .switch_support                      (sister_switch_support), // input // Switch Support
    .number_of_ports                     (sister_number_of_ports), // input [7:0] // Number of Ports
    .port_number                         (sister_port_number), // input [7:0] // Port Number

    //------------------
    // Error Management signals
    //------------------
    .error_detect_message_error_response     (1'd0),
    .error_detect_message_format_error       (1'd0),
    .error_detect_message_request_timeout    (1'd0),
    .error_capture_letter                    (2'd0),
    .error_capture_mbox                      (2'd0),
    .error_capture_msgseg_or_xmbox           (4'd0),
    .error_detect_illegal_transaction_decode (1'd0),
    .error_detect_illegal_transaction_target (1'd0),
    .error_detect_packet_response_timeout    (1'd0),
    .error_detect_unsolicited_response       (1'd0),
    .error_detect_unsupported_transaction    (1'd0),
    .error_capture_ftype                     (4'd0),
    .error_capture_ttype                     (4'd0),
    .error_capture_destination_id            (16'd0),
    .error_capture_source_id                 (16'd0),

    //------------------
    // Reconfig Signals
    //------------------
    .reconfig_clk       (1'b0),//(sis_reconfig_clk),
    .reconfig_reset     (1'b0),//(sis_reconfig_reset),
    .reconfig_write     ({LSIZE{1'b0}}),//(sis_reconfig_write),
    .reconfig_read      ({LSIZE{1'b0}}),//(sis_reconfig_read),
    .reconfig_address   ({LSIZE{10'b0}}),//(sis_reconfig_address),
    .reconfig_writedata ({LSIZE{32'b0}}),//(sis_reconfig_writedata),
    .reconfig_readdata    (),
    .reconfig_waitrequest ()
    
    );
  
  
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////// DUT - Sister DUT Wire assignments ////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

assign rd          =                      sister_td;
assign sister_rd   =                             td;

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////// End of DUT - Sister DUT Wire assignments /////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
       


assign sister_txclk_timeout_prescaler  = 16;  // Port Link Timeout
assign sister_sysclk_timeout_prescaler = 16; // Port Response Timeout
assign sister_rx_threshold_0 = 20;
assign sister_rx_threshold_1 = 15;
assign sister_rx_threshold_2 = 10;
assign sister_input_enable = 1;
assign sister_output_enable = 1;
assign sister_ef_ptr = 0;




 
 //--------------------------------------------------------
 // End of TB Hookup
 //--------------------------------------------------------

 
 
 //---------------------------------------------------------------
 //Testbench starts 
 //---------------------------------------------------------------
 initial 
 begin
     $display("==================================================================================");
     $display("title      : tb_rio.demo");
     $display("description: demonstration testbench");
     $display("author     : Altera Corporation");
     $display("==================================================================================");
     $display("PURPOSE: Demonstrate basic functionality and provide hookup example.");
     $display("METHOD : Two Serial RapidIO core are connected through their RapidIO interfaces.  ");
     $display("         A few registers are written.");
     $display("         A few packets are exchanged.");
     $display("==================================================================================");
 end

 // clock generation
 initial 
 begin
    //Initializing with the number of checks we are going to perform here
    // The processing_element_features CAR value checking is turn on for all variants
    static int num_exp_chk_count = 3;
    static int init_done = 0;
    
    if( IO_DATAPATH_WIDTH == 32 ) begin

        if ((p_IO_SLAVE == 1'b1)|| (p_IO_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 432 + 2 + 6;
        end
        
        if ((p_MAINTENANCE_SLAVE == 1'b1) || (p_MAINTENANCE_MASTER== 1'b1)) begin
                  num_exp_chk_count = num_exp_chk_count + 8;
        end
        if (PORT_WRITE_PRESENT == 1'b1) begin
                  num_exp_chk_count = num_exp_chk_count  + 11;
        end
        
       if ((p_DRBELL_TX == 1'b1) || (p_DRBELL_RX == 1'b1)) begin
                 num_exp_chk_count = num_exp_chk_count  + 24;
        end
        
       if (p_DRBELL_WRITE_ORDER == 1'b1) begin
                 num_exp_chk_count = num_exp_chk_count + 159;
       end
       if (p_READ_WRITE_ORDER)  begin
                  num_exp_chk_count = num_exp_chk_count  + 8;
        end
           
    end else begin
    
      if ((p_IO_SLAVE == 1'b1)|| (p_IO_MASTER == 1'b1)) begin
                   num_exp_chk_count = num_exp_chk_count + 428 + 2 + 6;
        end
        
        if ((p_MAINTENANCE_SLAVE == 1'b1) || (p_MAINTENANCE_MASTER== 1'b1)) begin
                  num_exp_chk_count = num_exp_chk_count + 8;
        end
        if (PORT_WRITE_PRESENT == 1'b1) begin
                  num_exp_chk_count = num_exp_chk_count  + 11;
        end
        
       if ((p_DRBELL_TX == 1'b1) || (p_DRBELL_RX == 1'b1)) begin
                 num_exp_chk_count = num_exp_chk_count  + 24;
        end
        
       if (p_DRBELL_WRITE_ORDER == 1'b1) begin
                 num_exp_chk_count = num_exp_chk_count + 159;
       end
       if (p_READ_WRITE_ORDER)  begin
                  num_exp_chk_count = num_exp_chk_count  + 8;
        end
  
end
    
    if (p_GENERIC_LOGICAL == 1)
    begin
        num_exp_chk_count = 250 + num_exp_chk_count;
        
    end 
    

   // For multicast event
    num_exp_chk_count = num_exp_chk_count  + 1;
  
    exp_chk_cnt = num_exp_chk_count;
    init_done = init(num_exp_chk_count);
    set_verbosity(verbosity_pkg::VERBOSITY_ERROR);
    
       
 end
 
  initial
  begin
   sysclk = 1'b0;
   forever
   begin
       #SYSCLK_HALF_CYCLE_PERIOD;
        sysclk = !sysclk;
   end
  end

initial
begin
   clk = 1'b0;
   forever
   begin
   #REF_CLK_HALF_CYCLE_PERIOD;
   clk = !clk;
   end
end

/**********************************************************************/
// Internal Variables
/**********************************************************************/

   event send_multicast_event;
   
   reg [8:0] tsize; // Sent packet data payload size
   reg [8:0] rd_tsize; // Sent read packet requested payload size
   reg [8:0] rd_rsize; // Read packet data payload size
   reg [8:0] rsize; // Read packet data payload size
   reg [8:0] rx_rsize; // Received read packet data payload size
   reg [7:0] multicast_event_tx_count; //number of multicast-event control symbols 
   reg [7:0] sister_multicast_event_rx_count; //number of multicast-event control symbols received  by sister


   reg [8:0] expected_io_trans_count; //expected received IO trans
   reg [5:0]  n_tx;
   reg [5:0]  n_rx;
   reg [5:0]  last_io_in_queue;
   reg [5:0]  last_drbell_in_queue;
   reg [39:0] trans_order_tx_queue;
   reg [39:0] trans_order_rx_queue;
   reg        flush_trans_order_queue;
   reg [7:0]  io_s_wr_burstcount_counter;
   reg        avalon_trans_to_io;
   reg        drbell_s_waitrequest_reg;
   reg        avalon_trans_to_drbell;

   reg [7:0]  avalon_to_io_burstcount;
   reg [7:0]  avalon_to_io_burstcount_after_swrite;
   reg [8:0]  drbell_tsize; 
   reg [8:0]  drbell_tsize_after_swrite; 
   reg [6:0]  drbell_wr_burstcount;
   reg [6:0] drbell_wr_burstcount_after_swrite;
   reg [8:0]  drbell_rsize;
   reg [6:0]  drbell_rd_burstcount;
   reg [6:0]  drbell_rd_burstcount_after_swrite;
   reg [15:0] destination_id;
   reg [15:0] drbell_sis_dest_id;
   reg  [15:0] drbell_dest_id;
   
   
   reg [31:0] drbell_rx_expected_data;
   reg [31:0] drbell_rx_expected_data_after_swrite;
   reg [31:0] drbell_rx_rd_data;
   reg [8:0]  drbell_csize;
   reg [6:0]  drbell_cpl_burstcount;
   reg [31:0] drbell_cpl_expected_data;
   reg [31:0] drbell_cpl_rd_data;
   reg [31:0] io_int_stat;
   reg [31:0] io_avl_wr_reg_data;
   reg [31:0] io_rio_req_wr_reg_data;
   reg [31:0] io_avl_wr_expected_data;
   reg [31:0] io_rio_req_wr_expected_data;

   reg        rm_io_trans_fr_queue;
   reg        rm_io_trans_fr_queue_reg;
   reg        rm_last_io_trans_fr_queue;

   reg [/*BURSTCOUNT_WIDTH-1*/7:0] wr_index;
   reg [IO_DATAPATH_WIDTH-1:0] wr_data;
   reg [BYTEENABLE_WIDTH-1:0]    wr_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]    wr_burstcount;
   reg [31:0]                     wr_address;
   
   reg [BURSTCOUNT_WIDTH-1:0]    rd_index;
   reg [IO_DATAPATH_WIDTH-1:0] rd_data;
   reg [BYTEENABLE_WIDTH-1:0]    rd_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]    rd_burstcount;
   reg [31:0]                     rd_address;

   reg [/*BURSTCOUNT_WIDTH-1*/7:0]    rx_rd_index;
   reg [IO_DATAPATH_WIDTH-1:0] expected_rx_rd_data;
   reg [IO_DATAPATH_WIDTH-1:0] rx_rd_data;
   reg [BYTEENABLE_WIDTH-1:0]    rx_rd_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]    rx_rd_burstcount;
   reg [31:0]                     rx_rd_address;

   reg [/*BURSTCOUNT_WIDTH-1*/7:0] sister_wr_index;
   reg [IO_DATAPATH_WIDTH-1:0]   sister_wr_data;
   reg [BYTEENABLE_WIDTH-1:0]      sister_wr_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      sister_wr_burstcount;
   reg [31:0]                       sister_wr_address;
   
   reg [BURSTCOUNT_WIDTH-1:0]      sister_rd_word_number;
   reg [/*BURSTCOUNT_WIDTH-1*/7:0] sister_rd_index;
   reg [IO_DATAPATH_WIDTH-1:0]   sister_rd_data;
   reg [BYTEENABLE_WIDTH-1:0]      sister_rd_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      sister_rd_burstcount;
   reg [31:0]                       sister_rd_address;


   reg [/*BURSTCOUNT_WIDTH-1*/7:0] ios_wr_index;
   reg [IO_DATAPATH_WIDTH-1:0]   ios_wr_data;
   reg [BYTEENABLE_WIDTH-1:0]      ios_wr_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      ios_wr_burstcount;
   reg [31:0]                       ios_wr_address;

   reg [BURSTCOUNT_WIDTH-1:0]      ios_rd_word_number;
   reg [/*BURSTCOUNT_WIDTH-1*/7:0] ios_rd_index;
   reg [IO_DATAPATH_WIDTH-1:0]   ios_rd_data;
   reg [BYTEENABLE_WIDTH-1:0]      ios_rd_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      ios_rd_burstcount;
   reg [31:0]                       ios_rd_address;

   reg [/*BURSTCOUNT_WIDTH-1*/7:0] iom_wr_index;
   reg [IO_DATAPATH_WIDTH-1:0]   iom_wr_data;
   reg [BYTEENABLE_WIDTH-1:0]      iom_wr_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      iom_wr_burstcount;
   reg [31:0]                       iom_wr_address;

   reg [BURSTCOUNT_WIDTH-1:0]      iom_rd_word_number;
   reg [/*BURSTCOUNT_WIDTH-1*/7:0] iom_rd_index;
   reg [IO_DATAPATH_WIDTH-1:0]   iom_rd_data;
   reg [BYTEENABLE_WIDTH-1:0]      iom_rd_byteenable;
   reg [BURSTCOUNT_WIDTH-1:0]      iom_rd_burstcount;
   reg [31:0]                       iom_rd_address;


   reg [31:0]                     mnt_data;
   reg [31:0]                     read_data;
   reg [31:0]                     drbell_data;
   reg [31:0]                      drbell_data_after_swrite;
   reg [31:0]                     drb_status;
   reg [IO_DATAPATH_WIDTH-1:0] sent_wr_data;
   reg [IO_DATAPATH_WIDTH-1:0] expected_sister_rd_data;



   reg [DEVICE_ID_WIDTH - 1:0]  tx_dest_id;
   reg [7:0]  tx_rsrv1;
 
   reg [7:0]  tx_rsrv2;
   reg [1:0]  tx_prio;
   reg [3:0]  tx_size;
   reg        tx_rsrv3;
   reg        tx_pkt_ready;
   reg [16:0] tx_buffer_address;
   integer    i,j,k,m,n,p;
   reg [16:0] rx_buffer_address;
   reg [31:0] exp_mnt_data;
   reg [3:0]  exp_pktsize;

   reg [3:0] received_reads ;
   reg [3:0] received_writes ;
   reg [8:0] number_tx;
   reg [8:0] number_rx;
   reg [8:0] number_rx1;

/**********************************************************************/
// Read byteenables
/**********************************************************************/
   reg [3:0]                            bep_rdsize; // bep: Byte Enable Packet
   reg [127:0]                          bep_nread;
   reg [DEVICE_ID_WIDTH-1:0] bep_destination_id; 
   reg [DEVICE_ID_WIDTH-1:0] bep_source_id;
   reg [7:0]                            bep_transaction_id;
   reg [28:0]                           bep_address;
   reg                                  bep_wdptr;
   reg [1:0]                            bep_xamsbs;
   reg [ADAT_EMPTY_SIZE : 0 ]  bep_empty;

   integer                              bep_i;
   integer                              bep_i_max;
   integer                              bep_words;

   reg [BEC_BYTEENABLE  : 0 ]    bec_byteenable;
 
 
/**********************************************************************/
// MAINLINE
/**********************************************************************/

 initial 
 begin 
 
 if (p_GENERIC_LOGICAL == 1'b1) begin
  gen_tx_valid = 1'b0;
  gen_rx_ready = 1'b0;
  sister_gen_tx_valid = 1'b0;
  sister_gen_rx_ready = 1'b0;
 end
 // For Doorbell write order preservation which is default to true 
  if (p_DRBELL_WRITE_ORDER == 1'b1) begin
    expected_io_trans_count=`MAX_WRITTEN_BYTES/`WRITTEN_BYTES;
 end
    
    // Tie some inputs off
  multicast_event_tx = 1'b0;
  sister_multicast_event_tx = 1'b0;

// multicast 
  sister_multicast_event_rx_count = 0;
  multicast_event_tx_count =  ((p_IO_SLAVE == 1'b1)|| (p_IO_MASTER == 1'b1)) ? 8'd50 : 8'd15;

 // Generate reset pulse
    reset_n = 1'b0;
    sister_reset_n = 1'b0;
    #200000;
    reset_n = 1'b1;
    sister_reset_n = 1'b1;
    $display ("%0t Out of reset ...", $time);
   

 // Start testbench here
      fork
      begin
         wait ( port_initialized == 1 );
         $display ("%0t DUT Port initialized", $time);
      end
      begin
         wait ( sister_port_initialized == 1);
         $display ("%0t Sister Port initialized", $time);
      end
   join
// Wait for a potential reset link-request to come through before starting traffic.
   #5000; 
   fork
      begin
         if( !port_initialized )begin
            wait ( port_initialized == 1 );
            $display ("%0t DUT Port re-initialized", $time);
         end
      end
      begin
         if( !sister_port_initialized )begin
            wait ( sister_port_initialized == 1);
            $display ("%0t Sister Port re-initialized", $time);
         end
      end
   join
   
    // Let the value propagate to the register
  repeat(4)@(negedge sysclk);

  // Start sending multicast-event control symbols.
   -> send_multicast_event;

    // Check the processing_element_features CAR value
   bfm_cnt_master.rw_data       ( `READ, `PROC_ELEMENT_FEATURES, 4'hF, read_data, 1);
  if ( p_TRANSPORT_LARGE == 1'b1) begin
   check ("Validate processing_element_features CAR value",32'hX0000019,read_data);
  end else begin
   check ("Validate processing_element_features CAR value",32'hX0000009,read_data);
   end
   
   donecheck("Read processing_element_features CAR done");
   
/**********************************************************************/
// Base Device ID configuration
/**********************************************************************/
  if ( p_TRANSPORT_LARGE == 1'b1) begin
   // Set DUT/SISTER Base Device ID according to p_DISABLE_ID_CHECKING
     info("Checking promiscuous mode.");
     // Enable DUT promiscuous mode
     mnt_data = 32'h0000_0001;
     bfm_cnt_master.rw_addr_data ( `WRITE, `RX_TRANSPORT_CONTROL, 4'hF, mnt_data, 1 );
     // Enable SISTER promiscuous mode  
     mnt_data = 32'h0000_0001;
     sister_bfm_cnt_master.rw_addr_data ( `WRITE, `RX_TRANSPORT_CONTROL, 4'hF, mnt_data, 1 );
     // Set DUT Base Device ID to 16'hBBBB rather than 16'hAAAA
     mnt_data = 32'h0000_BBBB;
     bfm_cnt_master.rw_addr_data       ( `WRITE, `BASE_DEVICE_ID, 4'hF, mnt_data, 1);
     bfm_cnt_master.rw_data       ( `READ, `BASE_DEVICE_ID, 4'hF, read_data, 1);
     check ("Validate base_device_id CSR value",32'h00FFBBBB, read_data);
     donecheck("Read base_device_id CSR done");
     // Set sister Based Device ID to 16'h6666 rather than 16'h5555
     mnt_data = 32'h0000_6666;
     sister_bfm_cnt_master.rw_addr_data( `WRITE, `BASE_DEVICE_ID, 4'hF, mnt_data, 1 );
     sister_bfm_cnt_master.rw_data ( `READ, `BASE_DEVICE_ID, 4'hF, read_data, 1);
     check ("Validate SISTER base_device_id CSR value",32'h00FF6666,read_data);
     donecheck("Read SISTER base_device_id CSR done");
   
 end else begin
   // Set DUT/SISTER Base Device ID according to p_DISABLE_ID_CHECKING
    
     info("Checking promiscuous mode.");
     // Enable DUT promiscuous mode 
     mnt_data = 32'h0000_0001;
     bfm_cnt_master.rw_addr_data ( `WRITE, `RX_TRANSPORT_CONTROL, 4'hF, mnt_data, 1 );
     // Enable SISTER promiscuous mode 
     mnt_data = 32'h0000_0001;
     sister_bfm_cnt_master.rw_addr_data ( `WRITE, `RX_TRANSPORT_CONTROL, 4'hF, mnt_data, 1 );
     // Set DUT Base Device ID to 8'hBB rather than 8'hAA
     mnt_data = 32'h00BB_0000;
     bfm_cnt_master.rw_addr_data       ( `WRITE, `BASE_DEVICE_ID, 4'hF, mnt_data, 1);
     bfm_cnt_master.rw_data       ( `READ, `BASE_DEVICE_ID, 4'hF, read_data, 1);
     check ("Validate base_device_id CSR value",32'h00BB_FFFF, read_data);
     donecheck("Read base_device_id CSR done");
     // Set sister Based Device ID to 8'h66 rather than 8'h55 
     mnt_data = 32'h0066_0000;
     sister_bfm_cnt_master.rw_addr_data( `WRITE, `BASE_DEVICE_ID, 4'hF, mnt_data, 1 );
     sister_bfm_cnt_master.rw_data ( `READ, `BASE_DEVICE_ID, 4'hF, read_data, 1);
     check ("Validate SISTER base_device_id CSR value",32'h0066_FFFF,read_data);
     donecheck("Read SISTER base_device_id CSR done");
    
  end
  
  // Enable request packet generation
   mnt_data = 32'h6000_0000; // Host = 0, Master Enable = 1, Discovered = 1
   bfm_cnt_master.rw_addr_data       ( `WRITE, `GENERAL_CONTROL,           4'hF, mnt_data, 1 );

   // Enable Sister request packet generation
   mnt_data = 32'h6000_0000; // Host = 0, Master Enable = 1, Discovered = 1
   sister_bfm_cnt_master.rw_addr_data( `WRITE, `GENERAL_CONTROL,           4'hF, mnt_data, 1 );

/**********************************************************************/
// MNT Register configuration
/**********************************************************************/

   if ( (p_MAINTENANCE_SLAVE == 1'b1) && (p_TRANSPORT_LARGE == 1'b1) ) begin
       // DUT
       // Define one Tx Maintenance Avalon address mapping window that covers the whole address space
       // Set Destination ID = 16'hAAAA, Hop Count = 8'hFF
       mnt_data = 32'hAAAA_FF00;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       mnt_data = 32'h0000_0004;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate TX Maintenance Mapping Window and Control Register value",32'hAAAAFF00,read_data);
       donecheck("Read TX Maintenance Mapping Window and Control Register done");
       // Set Destination ID = 16'h5555, Hop Count = 8'hFF
       mnt_data = 32'h5555_FF00;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate TX Maintenance Mapping Window and Control Register value",32'h5555FF00,read_data);
       donecheck("Read TX Maintenance Mapping Window and Control Register done");
   end else if ((p_MAINTENANCE_SLAVE == 1'b1) && (p_TRANSPORT_LARGE == 1'b0)) begin
       // Set Destination ID = 8'hAA, Hop Count = 8'hFF
       mnt_data = 32'h00AA_FF00; 
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate TX Maintenance Mapping Window and Control Register value",32'h00AAFF00,read_data);
       donecheck("Read TX Maintenance Mapping Window and Control Register done");
       // Set Destination ID = 8'h55, Hop Count = 8'hFF
       mnt_data = 32'h0055_FF00; 
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       mnt_data = 32'h0000_0004;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate TX Maintenance Mapping Window and Control Register value",32'h0055FF00,read_data);
       donecheck("Read TX Maintenance Mapping Window and Control Register done");
    
   end
   // End of Mnt register configuration
   
  if( (p_MAINTENANCE_MASTER == 1'b1) && (p_MAINTENANCE_SLAVE == 1'b0) && (p_TRANSPORT_LARGE == 1'b1)) begin
       // SISTER
       // Define one Tx Maintenance Avalon address mapping window that covers the whole address space
       // Set Destination ID = 16'h5555, Hop Count = 8'hFF
       mnt_data = 32'h5555_FF00;
       sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       mnt_data = 32'h0000_0004;
       sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
       sister_bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate SISTER TX Maintenance Mapping Window and Control Register value",32'h5555FF00,read_data);
       donecheck("Read SISTER TX Maintenance Mapping Window and Control Register done");
       // Set Destination ID = 16'hAAAA, Hop Count = 8'hFF
       mnt_data = 32'hAAAA_FF00;
       sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
       sister_bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       check ("Validate SISTER TX Maintenance Mapping Window and Control Register value",32'hAAAAFF00,read_data);
       donecheck("Read SISTER TX Maintenance Mapping Window and Control Register done");
    end else if ( (p_MAINTENANCE_MASTER == 1'b1) && (p_MAINTENANCE_SLAVE == 1'b0) && (p_TRANSPORT_LARGE == 1'b0)) begin
        // Set Destination ID = 8'h55, Hop Count = 8'hFF
        mnt_data = 32'h0055_FF00; 
        sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
        sister_bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
        check ("Validate SISTER TX Maintenance Mapping Window and Control Register value",32'h0055FF00,read_data);
        donecheck("Read SISTER TX Maintenance Mapping Window and Control Register done");
        // Set Destination ID = 8'hAA, Hop Count = 8'hFF
        mnt_data = 32'h00AA_FF00; 
        sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
        mnt_data = 32'h0000_0004;
        sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_MAINTENANCE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
        sister_bfm_cnt_master.rw_data       ( `READ, `TX_MAINTENANCE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
        check ("Validate SISTER TX Maintenance Mapping Window and Control Register value",32'h00AAFF00,read_data);
        donecheck("Read SISTER TX Maintenance Mapping Window and Control Register done");
    end

/**********************************************************************/
// IO Registers configuration
/**********************************************************************/

    if ( (p_IO_SLAVE == 1'b1) || (p_IO_MASTER == 1'b1)) begin
       // Define one Avalon address mapping window that covers the whole Avalon address space and enable it #1
       mnt_data = IOS_DESTINATION_ID_2;

       if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
            bfm_cnt_master.rw_data       ( `READ, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
            sister_bfm_cnt_master.rw_data       ( `READ, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       end
       check ("Validate IO Slave Window and Control Register value 1",IOS_DESTINATION_ID_2, read_data);
       donecheck("Read IO Slave Window and Control Register value 1 done");
       // Define one Avalon address mapping window that covers the whole Avalon address space and enable it #2
       mnt_data = IOS_DESTINATION_ID;
       if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
            bfm_cnt_master.rw_data       ( `READ, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
            sister_bfm_cnt_master.rw_data       ( `READ, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, read_data, 1);
       end
       check ("Validate IO Slave Window and Control Register value 2",IOS_DESTINATION_ID, read_data);
       donecheck("Read IO Slave Window and Control Register value 2 done");
       
       mnt_data = 32'h0000_0004;
       
       if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
       end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );
       end
            // Enable interrupts.
       mnt_data = 32'h0000_000F;
       
       if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
            bfm_cnt_master.rw_data     ( `READ,  `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
       end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
            sister_bfm_cnt_master.rw_data     ( `READ,  `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
       end
       
       check ("Check interrupt_enable", 32'h0000_000F, mnt_data);
       // Define one RapidIO address mapping window in the sister IO Master that covers the whole RapidIO address space and enable it
       mnt_data = 32'h0000_0004;
       
       if (p_IO_SLAVE == 1'b1) begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_MASTER_WINDOW_0_MASK,   4'hF, mnt_data, 1 );
       end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_MASTER_WINDOW_0_MASK,   4'hF, mnt_data, 1 );
       end
    end
    
/**********************************************************************/
// MNT Transactions
/**********************************************************************/
if( p_MAINTENANCE_SLAVE == 1'b1) begin

   info ("Verify Maintenance Slave DUT to Master SISTER");
  fork
    begin
      // Send maintenance write request packets
      // write request 1
      @(negedge sysclk);
      wr_address[25:0] = 26'hAB_CDE0;
      wr_data = 32'h7654_3210;
      bfm_mnt_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, wr_data, wr_burstcount );
      // write request 2
      wr_address[25:0] = 26'h98_7654;
      wr_data = 32'hFEDC_BA98;
      bfm_mnt_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, wr_data, wr_burstcount );

      // Send maintenance read request packets
      // read request 1
      rd_address[25:0] = 26'hAB_CDE0;
      bfm_mnt_master.rw_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
      check ("Check valid read data",32'h7654_3210,rd_data);
      donecheck("Check DUT Maintenance read request data 1");
      // read request 2
      rd_address[25:0] = 26'h98_7654;
      bfm_mnt_master.rw_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
      check ("Check valid read data",32'hFEDC_BA98,rd_data);
      donecheck("Check DUT Maintenance read request data 2");
    end
    begin
      // Check write 1 address and data
      @(posedge sister_bfm_mnt_slave.writedata_received);
      sister_rd_index = 0;
      sister_bfm_mnt_slave.read_writedata(sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_burstcount, sister_rd_byteenable );
      expect_n("Check valid write address", 26'hAB_CDE0,sister_rd_address, 26);
      check ("Check valid write data",  32'h76543210, sister_rd_data);
      donecheck("Check SISTER Maintenance write request address 1");
      // Check write 2 address and data
      @(posedge sister_bfm_mnt_slave.writedata_received);
      sister_rd_index = 0;
      sister_bfm_mnt_slave.read_writedata(sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_burstcount, sister_rd_byteenable );
      expect_n("Check valid write address", 26'h98_7654,sister_rd_address, 26);
      check ("Check valid write data",  32'hFEDC_BA98, sister_rd_data);
      donecheck("Check SISTER Maintenance write request address 2");
    end
    begin
      // Check read 1 address and return data
      @(posedge sister_bfm_mnt_slave.readdata_requested );
      sister_wr_index = 0;
      sister_wr_burstcount =  1;
      sister_wr_data = 32'h76543210 ;
      sister_bfm_mnt_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
      expect_n ("Check valid read address", 26'hAB_CDE0, sister_wr_address, 26);
      donecheck("Check SISTER Maintenance read request address 1");
      // Check read 2 address and return data
      @(posedge sister_bfm_mnt_slave.readdata_requested );
      sister_wr_index = 0;
      sister_wr_burstcount =  1;
      sister_wr_data = 32'hFEDCBA98 ;
      sister_bfm_mnt_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
      expect_n ("Check valid read address", 26'h98_7654, sister_wr_address, 26);
      donecheck("Check SISTER Maintenance read request address 2");
    end
  join
end

  
// End of Mnt Transactions

//***********************************************************************
//Port Write Transactions
//***********************************************************************
 if ((p_TX_PORT_WRITE == 1'b1) && (PORT_WRITE_PRESENT == 1'b1))  begin
/**********************************************************************/
// Port Write Transactions
/**********************************************************************/
   info ("Verify Tx Port-Write DUT to Rx Port-write SISTER");
   // Test port write transactions
   // Send port write packets of single word, 1,2,.. 8 double-words from DUT
   // Verify them from Sister
  if (p_TRANSPORT_LARGE == 1'b1) begin
       //Set TX Port Write Control to 16'hAAAA
       mnt_data = 32'hAAAA_0000;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_PORT_WRITE_CONTROL, 4'hF, read_data, 1);
       check ("Validate DUT TX Port Write Control value",32'hAAAA_0000,read_data);
       donecheck("Read DUT TX Port Write Control done");
       //Set TX Port Write Control to 16'h5555
       mnt_data = 32'h5555_0000;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_PORT_WRITE_CONTROL, 4'hF, read_data, 1);
       check ("Validate DUT TX Port Write Control value",32'h5555_0000,read_data);
       donecheck("Read DUT TX Port Write Control done");
   end else begin
       //Set TX Port Write Control to 8'hAA
       mnt_data = 32'h00AA_0000;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_PORT_WRITE_CONTROL, 4'hF, read_data, 1);
       check ("Validate DUT TX Port Write Control value",32'h00AA_0000,read_data);
       donecheck("Read DUT TX Port Write Control done");
       //Set TX Port Write Control to 8'h55
       mnt_data = 32'h0055_0000;
       bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
       bfm_cnt_master.rw_data       ( `READ, `TX_PORT_WRITE_CONTROL, 4'hF, read_data, 1);
       check ("Validate DUT TX Port Write Control value",32'h0055_0000,read_data);
       donecheck("Read DUT TX Port Write Control done");
    end
   // enable Rx packet stored interrupt
   mnt_data = 32'h10;
   sister_bfm_cnt_master.rw_addr_data( `WRITE, `MAINTENANCE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
   // enable Rx port write
   mnt_data = 32'h1;
   sister_bfm_cnt_master.rw_addr_data( `WRITE, `RX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
   fork
      // Tx port write
      begin
      // Set up Tx port write control register constants
      if (p_TRANSPORT_LARGE == 1'b1)  begin
        tx_dest_id = 16'h5555;
      end else begin
          tx_rsrv1 = 8'h0;
          tx_dest_id = 8'h55;
      end
      tx_rsrv2 = 8'h0;
      tx_prio = 2'b00;
      tx_size = 4'h0;
      tx_rsrv3 = 1'b0;
      tx_pkt_ready = 1'b1;
      // Write Tx port write data
      for (i = 0; i < 9; i = i + 1) begin
         
         wait (sister_sys_mnt_s_irq === 1'b0); // Make sure sister rio buffer is read and cleared
         // Set up Tx port write payload
         if (i == 0) begin
            mnt_data = 32'h0102_0304;
            bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_BUFFER, 4'hF, mnt_data, 1 );
         end else begin
            k = 2*i; // double-word count
            for (j = 0; j < k ; j = j + 1) begin
               mnt_data[31:24] = i + 4*j + 1;
               mnt_data[23:16] = i + 4*j + 2;
               mnt_data[15:8]  = i + 4*j + 3;
               mnt_data[7:0]   = i + 4*j + 4;
               tx_buffer_address = `TX_PORT_WRITE_BUFFER + 4*j;
               bfm_cnt_master.rw_addr_data       ( `WRITE, tx_buffer_address, 4'hF, mnt_data, 1 );
            end
         end
         // Set up Tx port write control register
         tx_size = i;
        if (p_TRANSPORT_LARGE == 1'b1) begin
         mnt_data = {tx_dest_id,tx_rsrv2,tx_prio,tx_size,tx_rsrv3,tx_pkt_ready};
        end else begin
         mnt_data = {tx_rsrv1,tx_dest_id,tx_rsrv2,tx_prio,tx_size,tx_rsrv3,tx_pkt_ready};
        end
         bfm_cnt_master.rw_addr_data       ( `WRITE, `TX_PORT_WRITE_CONTROL, 4'hF, mnt_data, 1 );
         $display ("%0t: Sent DUT port write packet %0d", $time, i);
         //wait (tb.sister_rio.sys_mnt_s_irq === 1'b1);
         wait (sister_sys_mnt_s_irq === 1'b1);
      end // for
      end
      // Rx port write
      begin
      for (m = 0; m < 9; m = m + 1) begin
         //wait (tb.sister_rio.sys_mnt_s_irq === 1'b1);
         wait (sister_sys_mnt_s_irq === 1'b1);
         info ("Sister RIO system interrupt asserted");
         sister_bfm_cnt_master.rw_addr_data( `READ, `MAINTENANCE_INTERRUPT, 4'hF, mnt_data, 1 );
         check ("Check Rx port write stored interrupt", 32'h10, mnt_data);
         $display ("%0t: Received port write packet %0d", $time, m);
         // Check Rx port write data
         if (m == 0) begin
            sister_bfm_cnt_master.rw_addr_data( `READ, `RX_PORT_WRITE_BUFFER, 4'hF, mnt_data, 1 );
            check ("Check Rx port write data", 32'h0102_0304, mnt_data);
         end else begin
            p = 2*m;
            for (n = 0; n < p ; n = n + 1) begin
               exp_mnt_data[31:24] = m + 4*n + 1;
               exp_mnt_data[23:16] = m + 4*n + 2;
               exp_mnt_data[15:8]  = m + 4*n + 3;
               exp_mnt_data[7:0]   = m + 4*n + 4;
               rx_buffer_address = `RX_PORT_WRITE_BUFFER + 4*n;
               sister_bfm_cnt_master.rw_addr_data( `READ, rx_buffer_address, 4'hF, mnt_data, 1 );
               check ("Check Rx port write data", exp_mnt_data, mnt_data);
            end
         end
         // Check Rx port status
         sister_bfm_cnt_master.rw_addr_data( `READ, `RX_PORT_WRITE_STATUS, 4'hF, mnt_data, 1 );
         // Payload size [5:2] should be zero
         exp_pktsize = m;
         check ("Check Rx port write status", {26'h0, exp_pktsize,2'b00}, mnt_data);
         // Write 1 to clear interrupt
         mnt_data = 32'h10;
         sister_bfm_cnt_master.rw_addr_data( `WRITE, `MAINTENANCE_INTERRUPT, 4'hF, mnt_data, 1 );
         sister_bfm_cnt_master.rw_addr_data( `READ, `MAINTENANCE_INTERRUPT, 4'hF, mnt_data, 1 );
         check ("Check Rx port write stored interrupt clear", 32'h0, mnt_data);
         //wait (tb.sister_rio.sys_mnt_s_irq === 1'b0);
         wait (sister_sys_mnt_s_irq === 1'b0);
         donecheck("");
      end // for
      end
   join

end
// End of Port Write transactions

//**********************************************************************************************************************
// IO Master/ IO Slave Transactions
//**********************************************************************************************************************
if ( (p_IO_SLAVE == 1'b1) || (p_IO_MASTER == 1'b1)) begin
/**********************************************************************/
// IO and Doorbell Transactions with Write Order Preservation
/**********************************************************************/
   // Requests sent from IO Slave to IO Master.
   // Test SWRITE transactions.
   wr_byteenable = ~{{BYTEENABLE_WIDTH}{1'b0}};
    mnt_data = IOS_DESTINATION_ID_SWRITE_ENABLE; // Destination ID = 8'h${IOS_DESTINATION_ID}, SWRITE_ENABLE = 1, NWRITE_R_ENABLE = 0
   
   if (p_IO_SLAVE == 1'b1) begin
        bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
   end else begin
        sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
   end
   

   if (p_DRBELL_WRITE_ORDER == 1'b1) begin
       // configure the DRBELL registers
       drbell_data = 32'h0000_000F;
       bfm_drbell_s_master.rw_addr_data              ( `WRITE, `DRBELL_INTR_ENA, 4'hF, drbell_data, 1 );
       bfm_drbell_s_master.rw_addr_data              ( `WRITE, `DRBELL_TXCPL_CNTRL, 4'hF, drbell_data, 1 );
       sister_bfm_drbell_s_master.rw_addr_data       ( `WRITE, `DRBELL_INTR_ENA, 4'hF, drbell_data, 1 );
       sister_bfm_drbell_s_master.rw_addr_data       ( `WRITE, `DRBELL_TXCPL_CNTRL, 4'hF, drbell_data, 1 );
    
       // Let the value propagate to the register
       repeat(10)@(negedge sysclk);
   
   end

   fork
      begin
         // Send SWRITE requests
         for( tsize = `MIN_WRITTEN_BYTES; tsize <= `MAX_WRITTEN_BYTES; tsize = tsize + `WRITTEN_BYTES )begin
            wr_burstcount = tsize / (IO_DATAPATH_WIDTH/8);

            if (p_DRBELL_WRITE_ORDER == 1'b1) begin
                avalon_to_io_burstcount_after_swrite = wr_burstcount;
            end

            for( wr_index = 0; wr_index < wr_burstcount ; wr_index = wr_index + 1 )begin
            
            if ( (IO_DATAPATH_WIDTH == 32) ) begin
               sent_wr_data = {tsize[7:0],16'h5432, wr_index};
            end else begin
               sent_wr_data = {tsize[7:0],16'hDCBA, wr_index, 24'h765432, wr_index};
            end
               wr_address = {{3{tsize[7:0]}}, 8'h00};
               if( wr_index == 0 )begin
                   if (p_IO_SLAVE == 1'b1) begin
                        bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                   end else begin
                        sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                   end
               end else begin
                    if (p_IO_SLAVE == 1'b1) begin
                        bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                    end else begin
                         sister_bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                    end
               end
            end
            donecheck(" Started SWRITE request on IO Slave Avalon");
         end
      end

      begin
         // Check received SWRITE requests 
         for( rsize = `MIN_WRITTEN_BYTES; rsize <= `MAX_WRITTEN_BYTES; rsize = rsize + `WRITTEN_BYTES)begin
            sister_rd_burstcount = rsize / (IO_DATAPATH_WIDTH/8);
            $display("Expecting SWRITE rsize = %d", rsize);
            $display("sister_rd_burstcount = %d", sister_rd_burstcount );
            // Expect to receive the written packets
            if (p_IO_SLAVE == 1'b1) begin
                @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
             end else begin
                @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
             end
            #1;
            if (p_IO_SLAVE == 1'b1) begin
                donecheck(" sister_bfm_io_write_slave.writedata_received");
            end else begin
                donecheck(" bfm_io_write_slave.writedata_received");
            end
            
            for( sister_rd_index = 0; sister_rd_index < sister_rd_burstcount; sister_rd_index = sister_rd_index + 1 )begin
                if( IO_DATAPATH_WIDTH == 32 ) begin
                    expected_sister_rd_data = {rsize[7:0], 16'h5432, sister_rd_index};
                end else begin
                    expected_sister_rd_data = {rsize[7:0], 16'hDCBA, sister_rd_index, 24'h765432, sister_rd_index};
                end
                
                if (p_IO_SLAVE == 1'b1) begin
                    sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
                end else begin 
                    bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
                end                
                if( IO_DATAPATH_WIDTH == 32 ) begin
                    check ("Check data being written",expected_sister_rd_data, sister_rd_data);
                end else begin
                    check ("Check MSB of data being written",expected_sister_rd_data[63:32], sister_rd_data[63:32]);
                    check ("Check LSB of data being written",expected_sister_rd_data[31:0],  sister_rd_data[31:0]);
                end
               
                info("Checked an s-written word.");
            end
            donecheck(" Received and processed SWRITE request packet in Avalon Master");
         end
      end


      // Received IO at SISTER
      begin
        if (p_DRBELL_WRITE_ORDER == 1'b1) begin
            repeat (expected_io_trans_count) begin
              @ (posedge sister_io_m_wr_write);
              info ("IO transaction is recorded in the Transaction Order Rx Queue.");
              trans_order_rx_queue[n_rx]=0;
              n_rx = n_rx + 1; 
            end
        end
        // End of DRBELL_WRITE_ORDER
      end

      begin
        if (p_DRBELL_WRITE_ORDER == 1'b1) begin
            // Send DOORBELL one clock after SWRITE transaction
            info ("Verify the doorbell operation -- DUT Sends doorbell to sister");
            drbell_dest_id = DRBTX_DESTINATION_ID;
    
            for( drbell_tsize_after_swrite = `FIRST_DRBELL_REF_IO; drbell_tsize_after_swrite<= `LAST_DRBELL_REF_IO; drbell_tsize_after_swrite= drbell_tsize_after_swrite+ `DRBELL_GAP )begin
               drbell_wr_burstcount_after_swrite = drbell_tsize_after_swrite/ (IO_DATAPATH_WIDTH/8);
               wait ( avalon_to_io_burstcount_after_swrite == drbell_wr_burstcount_after_swrite) begin
                  drbell_data_after_swrite={drbell_dest_id, 2'b00, drbell_wr_burstcount_after_swrite, drbell_wr_burstcount_after_swrite};
                  bfm_drbell_s_master.rw_addr_data ( `WRITE, `DRBELL_TX_DATA, 4'hF, drbell_data_after_swrite, 1);
              end
            end
            // End of for loop
        end
        // End of DRBELL_WRITE_ORDER
      end

      begin
         if (p_DRBELL_WRITE_ORDER == 1'b1) begin
            // Check received DOORBELL at SISTER
            for( drbell_rsize = `FIRST_DRBELL_REF_IO; drbell_rsize <= `LAST_DRBELL_REF_IO; drbell_rsize = drbell_rsize + `DRBELL_GAP )begin
               drbell_rd_burstcount_after_swrite= drbell_rsize/(IO_DATAPATH_WIDTH/8);
               drbell_sis_dest_id = DRBRX_DESTINATION_ID_PROM;
       
                @(negedge sysclk);
                wait ( sister_drbell_s_irq == 1) begin 
                //@@ # the data take times to be written into register aft IRQ, thus, insert the
                //@@ # interval before reading
                  repeat(10)@(negedge sysclk); 
                  drbell_rx_expected_data_after_swrite={drbell_sis_dest_id,2'b00,drbell_rd_burstcount_after_swrite,drbell_rd_burstcount_after_swrite};
                  sister_bfm_drbell_s_master.rw_data( `READ, `DRBELL_RX_DOORBELL, 4'hF, drbell_rx_rd_data, 1 );
                  while (drbell_rx_rd_data !== drbell_rx_expected_data_after_swrite) begin
                    repeat(5)@(negedge sysclk); 
                    sister_bfm_drbell_s_master.rw_data( `READ, `DRBELL_RX_DOORBELL, 4'hF, drbell_rx_rd_data, 1 );
                  end
                  info ("DOORBELL transaction is recorded in the Transaction Order Rx Queue.");
                  @(negedge sysclk);
                  trans_order_rx_queue[n_rx]=1;
                  n_rx = n_rx + 1; 
                  donecheck("Checked Doorbell reception at SISTER Rx Doorbell.");
                end
            end
            // End of for loop
    
            // Check completed DOORBELL at DUT
            for( drbell_csize = `FIRST_DRBELL_REF_IO; drbell_csize <= `LAST_DRBELL_REF_IO; drbell_csize = drbell_csize + `DRBELL_GAP )begin
               drbell_cpl_burstcount= drbell_csize/ (IO_DATAPATH_WIDTH/8);
               @(negedge sysclk);
               wait ( drbell_s_irq == 1) begin
                repeat(10)@(negedge sysclk); //interval before reading again
                drbell_cpl_expected_data={{DRBTX_DESTINATION_ID},2'b00,drbell_cpl_burstcount,drbell_cpl_burstcount};
                bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_STATUS, 4'hF, drb_status, 1 );
                check ("Validate TX Doorbell Completion Status Register value",32'h00000000,drb_status);
                donecheck("Read TX Doorbell Completion Status Register done");
                bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_DATA, 4'hF,drbell_cpl_rd_data, 1 );
                while (drbell_cpl_rd_data !== drbell_cpl_expected_data) begin
                  repeat(5)@(negedge sysclk); //interval before reading again
                  bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_DATA, 4'hF, drbell_cpl_rd_data, 1 );
                end
                donecheck("Checked DUT Doorbell completion register.");
              end
           end
           // End of for loop
        end
        // End of DRBELL_WRITE_ORDER
     end



   join

   // Start of Doorbell Write Order
   
   if (p_DRBELL_WRITE_ORDER == 1'b1) begin
   write_order_check ("Validate write order preservation 1",trans_order_tx_queue[39:0],trans_order_rx_queue[39:0]);
   donecheck("Write order preservation validation 1 done");
   @(posedge sysclk);
   flush_trans_order_queue = 1;

/************************************************************************/
// IO Err Injection & Doorbell Transactions with Write Order Preservation
/************************************************************************/
   repeat (10)@(negedge sysclk);
  
   // Read and store the write order registers' values
   io_avl_wr_reg_data = 32'h0000_0000;
   io_rio_req_wr_reg_data = 32'h0000_0000;
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_AVALON_WRITE, 4'hF, io_avl_wr_reg_data, 1 );
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_RIO_REQ_WRITE, 4'hF, io_rio_req_wr_reg_data, 1 );

   // Make sure the no defined error is reported previously. 
   io_int_stat = 32'h0000_0000; 
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, io_int_stat, 1 );
   check ("IO defined error is reported.", 32'h00000000,  io_int_stat );
   donecheck("IO Slave Interrupt status is checked.");

   // Set all encompassing window for NWRITE_R requests generation
   mnt_data = 32'h5555_0001; 
   bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
      
   repeat (10)@(negedge sysclk);
   // Write single burstcount IO Avalon transaction with invalid byteenable
   wr_address = 32'h0000_0000;
   if (BYTEENABLE_WIDTH == 4) begin
        wr_byteenable = ~ 4'h6;
   end else begin
        wr_byteenable = ~ 8'h6;
   end
   if( IO_DATAPATH_WIDTH == 64 ) begin
        sent_wr_data = 64'h0000_DCBA_9876_5432;
   end else begin
        sent_wr_data = 32'h0000_DCBA;
   end
   wr_burstcount = 1;
   bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
  
   info("Started invalid byteenable NWRITE_R transaction on DUT IO Slave Avalon");
   repeat (10)@(negedge sysclk);
   // Read the IO Slave Avalon Write Transaction Register
   io_avl_wr_expected_data = io_avl_wr_reg_data + 1;
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_AVALON_WRITE, 4'hF, io_avl_wr_reg_data, 1 );
   check ("IO Slave Avalon Write Transaction Register value is not as expected.", io_avl_wr_expected_data, io_avl_wr_reg_data );
   donecheck("IO Slave Avalon Write Transaction Register is checked.");

   repeat (10)@(negedge sysclk);
   // Read the IO Slave RapidIO Request Write Transaction
   io_rio_req_wr_expected_data = io_rio_req_wr_reg_data + 1;
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_RIO_REQ_WRITE, 4'hF, io_rio_req_wr_reg_data, 1 );
   check ("IO Slave RapidIO Request Write Transaction Register values is not as expected.", io_rio_req_wr_expected_data, io_rio_req_wr_reg_data );
   donecheck("IO Slave RapidIO Request Write Transaction Register is checked.");
          
   // Expected the IO Slave to report INVALID_WRITE_BYTEENABLE error
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, io_int_stat, 1 );
   check ("IO Slave interrupt status indicates other error.", 32'h0000_0008,  io_int_stat);
   donecheck("IO Slave Interrupt status is checked.");

   // Drop the INVALID_WRITE_BYTEENABLE transaction from trans_tx_write_queue
   if(io_int_stat==32'h00000008) begin
      rm_io_trans_fr_queue=1;
   end

   // Clear the IO_SLAVE_INTERRUPT
   repeat (2)@(negedge sysclk);
   mnt_data=4'hF;
   bfm_cnt_master.rw_addr_data( `WRITE,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
   rm_io_trans_fr_queue=0;
   bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, io_int_stat, 1 );
   check ("IO Slave interrupt status indicates other error.", 32'h0000_0000,  io_int_stat);
   donecheck("IO Slave Interrupt status is cleared. ");
    
   // Set the base address to be 0x1200_000
   mnt_data = 32'h1200_0000;
   bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_BASE,    4'hF, mnt_data, 1 );

   // Set the mask to be 0xFF00_0004
   mnt_data = 32'hFF00_0004;
   bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );

   fork
     begin
       // Send 32 NWRITE_R with WRITE_OUT_OF_BOUNDS address
       @(negedge sysclk);
       wr_byteenable = ~ {{BYTEENABLE_WIDTH}{1'b0}};
       for( tsize = `MIN_WRITTEN_BYTES; tsize <= `MAX_WRITTEN_BYTES; tsize = tsize + `WRITTEN_BYTES )begin
           wr_burstcount = tsize / (IO_DATAPATH_WIDTH/8);
           avalon_to_io_burstcount = wr_burstcount;
           for( wr_index = 0; wr_index < wr_burstcount ; wr_index = wr_index + 1 )begin
        if( IO_DATAPATH_WIDTH == 32 ) begin
            sent_wr_data = {tsize[7:0],16'h5432, wr_index};
        end else begin
            sent_wr_data = {tsize[7:0],16'hDCBA, wr_index, 24'h765432, wr_index};
        end        
            wr_address = {8'h00, {2{tsize[7:0]}}, 8'h00};
            if( wr_index == 0 )begin
                if (p_IO_SLAVE == 1'b1) begin
                    bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                end else begin
                    sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                end
            end else begin
                if (p_IO_SLAVE == 1'b1) begin
                    bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                 end else begin 
                    sister_bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                 end
            end
          end
          $display("wr_address %x; burscount: %x",wr_address,wr_burstcount);
          info(" Started WRITE_OUT_OF_BOUND nwrite_r transaction on DUT IO Slave Avalon");
         
          repeat (2)@(negedge sysclk);
          // Read the IO Slave Avalon Write Transaction Register
          io_avl_wr_expected_data = io_avl_wr_reg_data + 1;
          bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_AVALON_WRITE, 4'hF, io_avl_wr_reg_data, 1 );

          check ("IO Slave Avalon Write Transaction Register value is not as expected.", io_avl_wr_expected_data, io_avl_wr_reg_data );
          donecheck("IO Slave Avalon Write Transaction Register is checked.");

          // Read the IO Slave RapidIO Request Write Transaction
          io_rio_req_wr_expected_data = io_rio_req_wr_reg_data + 1;
          bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_RIO_REQ_WRITE, 4'hF, io_rio_req_wr_reg_data, 1 );
          check ("IO Slave RapidIO Request Write Transaction Register values is not as expected.", io_rio_req_wr_expected_data, io_rio_req_wr_reg_data );
          donecheck("IO Slave RapidIO Request Write Transaction Register is checked.");
          
          // Expected the IO Slave to report WRITE_OUT_OF_BOUNDS error
          bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, io_int_stat, 1 );
          check ("IO Slave interrupt status indicates other error.", 32'h0000_0002,  io_int_stat);
          donecheck("IO Slave Interrupt status is checked.");
        
          // Drop the OUT_OF_BOUND NWRITE_R transaction from trans_tx_write_queue
          if(io_int_stat==32'h00000002) begin
            rm_io_trans_fr_queue=1;
          end
        
          // Clear the IO_SLAVE_INTERRUPT
          repeat (2)@(negedge sysclk);
          mnt_data=4'hF;
          bfm_cnt_master.rw_addr_data( `WRITE,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
          rm_io_trans_fr_queue=0;
          bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, io_int_stat, 1 );
          check ("IO Slave interrupt status indicates other error.", 32'h0000_0000,  io_int_stat);
          donecheck("IO Slave Interrupt status is cleared. ");
        end
      end  

      begin
        // Send DOORBELL one clock after NWRITE_R transaction
        info ("Verify the doorbell operation -- DUT Sends doorbell to sister");
        for( drbell_tsize = `FIRST_DRBELL_REF_IO; drbell_tsize <= `LAST_DRBELL_REF_IO; drbell_tsize = drbell_tsize + `DRBELL_GAP )begin
           drbell_wr_burstcount = drbell_tsize / (IO_DATAPATH_WIDTH/8);
           wait ( avalon_to_io_burstcount == drbell_wr_burstcount ) begin
              drbell_data={DRBTX_DESTINATION_ID, 2'b00, drbell_wr_burstcount, drbell_wr_burstcount};
              bfm_drbell_s_master.rw_addr_data ( `WRITE, `DRBELL_TX_DATA, 4'hF, drbell_data, 1);
          end
        end
      end

      begin
        // Check received DOORBELL at SISTER
        for( drbell_rsize = `FIRST_DRBELL_REF_IO; drbell_rsize <= `LAST_DRBELL_REF_IO; drbell_rsize = drbell_rsize + `DRBELL_GAP )begin
           drbell_rd_burstcount= drbell_rsize/(IO_DATAPATH_WIDTH/8);
           destination_id = DRBRX_DESTINATION_ID_PROM;
            @(negedge sysclk);
            wait ( sister_drbell_s_irq == 1) begin 
            //@@ # the data take times to be written into register aft IRQ, thus, insert the
            //@@ # interval before reading
              repeat(10)@(negedge sysclk); 
              drbell_rx_expected_data={destination_id,2'b00,drbell_rd_burstcount,drbell_rd_burstcount};
              sister_bfm_drbell_s_master.rw_data( `READ, `DRBELL_RX_DOORBELL, 4'hF, drbell_rx_rd_data, 1 );
              while (drbell_rx_rd_data !== drbell_rx_expected_data) begin
                repeat(5)@(negedge sysclk); 
                sister_bfm_drbell_s_master.rw_data( `READ, `DRBELL_RX_DOORBELL, 4'hF, drbell_rx_rd_data, 1 );
              end
              info ("DOORBELL transaction is recorded in the Transaction Order Rx Queue.");
              @(negedge sysclk);
              trans_order_rx_queue[n_rx]=1;
              n_rx = n_rx + 1; 
              donecheck("Checked Doorbell reception at SISTER Rx Doorbell.");
            end
         end

        // Check completed DOORBELL at DUT
        for( drbell_csize = `FIRST_DRBELL_REF_IO; drbell_csize <= `LAST_DRBELL_REF_IO; drbell_csize = drbell_csize + `DRBELL_GAP )begin
           drbell_cpl_burstcount= drbell_csize/ (IO_DATAPATH_WIDTH/8);
           @(negedge sysclk);
           wait ( drbell_s_irq == 1) begin
            repeat(10)@(negedge sysclk); //interval before reading again
            drbell_cpl_expected_data={{DRBTX_DESTINATION_ID},2'b00,drbell_cpl_burstcount,drbell_cpl_burstcount};
            bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_STATUS, 4'hF, drb_status, 1 );
            check ("Validate TX Doorbell Completion Status Register value",32'h00000000,drb_status);
            donecheck("Read TX Doorbell Completion Status Register done");
            bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_DATA, 4'hF,drbell_cpl_rd_data, 1 );
            while (drbell_cpl_rd_data !== drbell_cpl_expected_data) begin
              repeat(5)@(negedge sysclk); //interval before reading again
              bfm_drbell_s_master.rw_data( `READ, `DRBELL_TXCPL_DATA, 4'hF, drbell_cpl_rd_data, 1 );
            end
            donecheck("Checked DUT Doorbell completion register.");
          end
        end
     end
   join

   write_order_check ("Validate write order preservation 2",trans_order_tx_queue[39:0],trans_order_rx_queue[39:0]);
   donecheck("Write order preservation validation 2 done");
   @(posedge sysclk);
   flush_trans_order_queue = 1;

  // Set the base address to be 0x1200_000
   mnt_data = 32'h0000_0000;
   bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_BASE,    4'hF, mnt_data, 1 );

   // Set the mask to be 0xFF00_0004
   mnt_data = 32'h0000_0004;
   bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_MASK,    4'hF, mnt_data, 1 );

   end
// End of Door Bell write order

   fork
     begin
      // Send a few NWRITE_R request packets and test pending NWRITE_R register and NWRITE_R completion interrupt
      // Check that there are no pending NWRITE_Rs
      if (p_IO_SLAVE == 1'b1 ) begin
            bfm_cnt_master.rw_addr_data( `READ, `IO_SLAVE_PENDING_NWRITE_RS, 4'hF, mnt_data, 1 );
      end else begin
            sister_bfm_cnt_master.rw_addr_data( `READ, `IO_SLAVE_PENDING_NWRITE_RS, 4'hF, mnt_data, 1 );
      end
      
      check ("Check that there are no pending NWRITE_Rs.", 32'h0, mnt_data);
      donecheck("Check that there are no pending NWRITE_Rs");

      // Check that the NWRITE_RS_COMPLETED interrupt is not set.
      if (p_IO_SLAVE == 1'b1) begin
        bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      end else begin
        sister_bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      end
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt not set.", 1'b0,  mnt_data[`NWRITE_RS_COMPLETED] );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is not set.");

      // Enable NWRITE_RS_COMPLETED interrupts
      mnt_data =  mnt_data | (1 << `NWRITE_RS_COMPLETED);
      if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
      end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT_ENABLE, 4'hF, mnt_data, 1 );
      end

      // Set all encompassing window for NWRITE_R requests generation
      mnt_data = IOS_DESTINATION_ID_NWRITE_ENABLE; // Destination ID = 8'h${IOS_DESTINATION_ID}, SWRITE_ENABLE = 0, NWRITE_R_ENABLE = 1
      
      if (p_IO_SLAVE == 1'b1) begin
            bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
      end else begin
            sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
      end

      wr_address = 32'hABCD_EF08;
      if( IO_DATAPATH_WIDTH == 64 ) begin
          @(negedge sysclk);
          // Check 32-bit wide writes
          //Send LSWord
          wr_burstcount = 1;
          sent_wr_data = {64'hFFFF_FFFF_7654_3210};
          if (p_IO_SLAVE == 1'b1) begin
                bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b0000_1111, sent_wr_data, wr_burstcount );
          end else begin
                sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b0000_1111, sent_wr_data, wr_burstcount );
          end
          donecheck(" Started nwrite_r transaction on DUT IO Slave Avalon");
    
          @(negedge sysclk);
          //Send MSWord
          sent_wr_data = {64'h7654_3210_FFFF_FFFF};
          
          if (p_IO_SLAVE == 1'b1) begin
                bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b1111_0000, sent_wr_data, wr_burstcount );
          end else begin
                sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b1111_0000, sent_wr_data, wr_burstcount );
          end
          donecheck(" Started nwrite_r transaction on DUT IO Slave Avalon");
      end
      
      @(negedge sysclk);
      wr_byteenable = ~{{BYTEENABLE_WIDTH}{1'b0}};
      if( IO_DATAPATH_WIDTH == 32 )  begin
          wr_burstcount = 1;
          // Even address bit 2
          sent_wr_data = {8'h00,16'h5432, 8'h08};
          wr_address = 32'hDEAD_BEE8;
          if (p_IO_SLAVE == 1'b1) begin
                bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
          end else begin
                sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
          end
          donecheck(" Started single word burst nwrite_r transaction on DUT IO Slave Avalon");
          // Odd address bit 2
          sent_wr_data = {8'h00,16'h5432, 8'h0C};
          wr_address = 32'hDEAD_BEEC;
           if (p_IO_SLAVE == 1'b1) begin
                bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
          end else begin
                sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
          end
          donecheck(" Started single word burst nwrite_r transaction on DUT IO Slave Avalon");
     end
     
      for( tsize = `MIN_WRITTEN_BYTES; tsize <= `MAX_WRITTEN_BYTES; tsize = tsize + `WRITTEN_BYTES )begin
         wr_burstcount = tsize / (IO_DATAPATH_WIDTH/8);
         for( wr_index = 0; wr_index < wr_burstcount ; wr_index = wr_index + 1 )begin
         if( IO_DATAPATH_WIDTH == 32 ) begin
            sent_wr_data = {tsize[7:0],16'h5432, wr_index};
        end else begin
            sent_wr_data = {tsize[7:0],16'hDCBA, wr_index, 24'h765432, wr_index};
        end        
            wr_address = {{3{tsize[7:0]}}, 8'h00};
            if( wr_index == 0 )begin
               if (p_IO_SLAVE == 1'b1) begin
			bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
	       end else begin
			sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
               end
            end else begin
		if (p_IO_SLAVE == 1'b1) begin
                	bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                end else begin
			sister_bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
		end
            end
         end
         donecheck(" Started nwrite_r transaction on DUT IO Slave Avalon");
       end

      // Send a few NWRITE request packets
      mnt_data = IOS_DESTINATION_ID; // Destination ID = 8'h${IOS_DESTINATION_ID}, SWRITE_ENABLE = 0, NWRITE_R_ENABLE = 0
	if (p_IO_SLAVE == 1'b1) begin
		bfm_cnt_master.rw_addr_data       ( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
        end else begin
		sister_bfm_cnt_master.rw_addr_data       ( `WRITE, `IO_SLAVE_WINDOW_0_CONTROL, 4'hF, mnt_data, 1 );
        end

      wr_address = 32'hABCD_EF08;
      if( IO_DATAPATH_WIDTH == 64 ) begin
      @(negedge sysclk);
      // Check 32-bit wide writes
      //Send LSWord
      wr_burstcount = 1;
      sent_wr_data = {64'hFFFF_FFFF_7654_3210};
      if (p_IO_SLAVE == 1'b1) begin
	bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b0000_1111, sent_wr_data, wr_burstcount );
      end else begin
        sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b0000_1111, sent_wr_data, wr_burstcount );
      end
      donecheck(" Started nwrite transaction on DUT IO Slave Avalon");

      @(negedge sysclk);
      //Send MSWord
      sent_wr_data = {64'h7654_3210_FFFF_FFFF};
      if (p_IO_SLAVE == 1'b1) begin
	bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b1111_0000, sent_wr_data, wr_burstcount );
      end else begin
        sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, 8'b1111_0000, sent_wr_data, wr_burstcount );
      end
      donecheck(" Started nwrite transaction on DUT IO Slave Avalon");
      end
      // End of IO_DATAPATH_WIDTH == 64

      @(negedge sysclk);
      wr_byteenable = ~ {{BYTEENABLE_WIDTH}{1'b0}};
      if( IO_DATAPATH_WIDTH == 32 ) begin
      wr_burstcount = 1;
      // Even address bit 2
      sent_wr_data = {8'h00,16'h5432, 8'h08};
      wr_address = 32'hDEAD_BEE8;
      if (p_IO_SLAVE == 1'b1) begin
	bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
      end else begin
         sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
      end
      donecheck(" Started single word burst nwrite transaction on DUT IO Slave Avalon");
      // Odd address bit 2
      sent_wr_data = {8'h00,16'h5432, 8'h0C};
      wr_address = 32'hDEAD_BEEC;
      if (p_IO_SLAVE == 1'b1) begin
          bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
      end else begin
          sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
      end
      donecheck(" Started single word burst nwrite transaction on DUT IO Slave Avalon");
      end
      // End of IO_DATAPATH_WIDTH == 32
      for( tsize = `MIN_WRITTEN_BYTES; tsize <= `MAX_WRITTEN_BYTES; tsize = tsize + `WRITTEN_BYTES )begin
         wr_burstcount = tsize / (IO_DATAPATH_WIDTH/8);
         for( wr_index = 0; wr_index < wr_burstcount ; wr_index = wr_index + 1 )begin
       if( IO_DATAPATH_WIDTH == 32 ) begin
            sent_wr_data = {tsize[7:0],16'h5432, wr_index};
       end else begin
            sent_wr_data = {tsize[7:0],16'hDCBA, wr_index, 24'h765432, wr_index};
       end        
            wr_address = {{3{tsize[7:0]}}, 8'h00};
            if( wr_index == 0 )begin
	       if (p_IO_SLAVE == 1'b1) begin
                   bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
               end else begin
                   sister_bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
               end
	    end else begin
               if (p_IO_SLAVE == 1'b1) begin
                   bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
               end else begin
                   sister_bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
               end
            end
         end
         donecheck(" Started nwrite transaction on DUT IO Slave Avalon");
       end

    end // fork begin

    begin

      // Receive the NWRITE_R request packets
      if( IO_DATAPATH_WIDTH == 64 ) begin
      // Check 32-bit wide writes
      // Check LSWord
      if (p_IO_SLAVE == 1'b1) begin
          @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
          #1;    
          donecheck(" sister_bfm_io_write_slave.writedata_received");
      end else begin
          @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
          #1;
          donecheck(" bfm_io_write_slave.writedata_received");
      end
     
      sister_rd_burstcount = 1;
      sister_rd_index = 0;
      if (p_IO_SLAVE == 1'b1) begin
         sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
         bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end
      expected_sister_rd_data = 64'hxxxx_xxxx_7654_3210;
      check ("Check LSB of data being written",expected_sister_rd_data[31:0],  sister_rd_data[31:0]);
      donecheck(" Received and processed NWRITE_R packet in sister Avalon Master");

      // Check MSWord
      if (p_IO_SLAVE == 1'b1) begin
         @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end else begin
          @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end
      #1;
      
      if (p_IO_SLAVE == 1'b1) begin
          donecheck(" sister_bfm_io_write_slave.writedata_received");
          sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
          donecheck(" bfm_io_write_slave.writedata_received");
         bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end
      expected_sister_rd_data = 64'h7654_3210_xxxx_xxxx;
      check ("Check MSB of data being nwritten_r",expected_sister_rd_data[63:32], sister_rd_data[63:32]);
      donecheck(" Received and processed NWRITE_R packet in sister Avalon Master");
      end
      // End of IO_DATAPATH_WIDTH == 64

      if( IO_DATAPATH_WIDTH == 32 ) begin
      // Even address bit 2
      if (p_IO_SLAVE == 1'b1) begin
           @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end else begin
           @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end
      #1;
      
      expected_sister_rd_data = {8'h00, 16'h5432, 8'h08};
      if (p_IO_SLAVE == 1'b1) begin
          donecheck(" sister_bfm_io_write_slave.writedata_received");
          sister_bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
          donecheck(" bfm_io_write_slave.writedata_received");
          bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end
      check ("Check data being nwritten_r",expected_sister_rd_data, sister_rd_data);
      info("Checked a single word burst nwritten_r word.");
      donecheck(" Received and processed NWRITE_R packet in sister Avalon Master");
      // Odd address bit 2
      if (p_IO_SLAVE == 1'b1) begin
          @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end else begin
          @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      end
      #1;
      
      expected_sister_rd_data = {8'h00, 16'h5432, 8'h0C};
      
      if (p_IO_SLAVE == 1'b1) begin
         donecheck(" sister_bfm_io_write_slave.writedata_received");
         sister_bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
         donecheck(" bfm_io_write_slave.writedata_received");
         bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end      
      check ("Check data being nwritten_r",expected_sister_rd_data, sister_rd_data);
      info("Checked a single word burst nwritten_r word.");
      donecheck(" Received and processed NWRITE_R packet in sister Avalon Master");
      end
      // END of IO_DATAPATH_WIDTH == 32
      for( rsize = `MIN_WRITTEN_BYTES; rsize <= `MAX_WRITTEN_BYTES; rsize = rsize + `WRITTEN_BYTES)begin
         sister_rd_burstcount = rsize / (IO_DATAPATH_WIDTH/8);
         $display("Expecting NWRITE_R rsize = %d", rsize);
         $display("sister_rd_burstcount = %d", sister_rd_burstcount );
         // Expect to receive the nwritten_r packets
         if (p_IO_SLAVE == 1'b1) begin
             @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         end else begin
              @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         end
         #1;
         if (p_IO_SLAVE == 1'b1) begin
              donecheck(" sister_bfm_io_write_slave.writedata_received");
         end else begin
              donecheck(" bfm_io_write_slave.writedata_received");
         end 
        for( sister_rd_index = 0; sister_rd_index < sister_rd_burstcount; sister_rd_index = sister_rd_index + 1 )begin
	if( IO_DATAPATH_WIDTH == 32 ) begin
            expected_sister_rd_data = {rsize[7:0], 16'h5432, sister_rd_index};
	end else begin
            expected_sister_rd_data = {rsize[7:0], 16'hDCBA, sister_rd_index, 24'h765432, sister_rd_index};
	end
            if (p_IO_SLAVE == 1'b1) begin
                sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
            end else begin
                bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
            end
	if( IO_DATAPATH_WIDTH == 32 ) begin
            check ("Check data being nwritten_r",expected_sister_rd_data, sister_rd_data);
        end else begin
            check ("Check MSB of data being nwritten_r",expected_sister_rd_data[63:32], sister_rd_data[63:32]);
            check ("Check LSB of data being nwritten_r",expected_sister_rd_data[31:0],  sister_rd_data[31:0]);
         end
         info("Checked a nwritten_r word.");
         end
         donecheck(" Received and processed NWRITE_R packet in sister Avalon Master");
      end

      // Receive the NWRITE request packets
      if( IO_DATAPATH_WIDTH == 64 ) begin
      // Check 32-bit wide writes
      // Check LSWord
      sister_rd_burstcount = 1;
      sister_rd_index = 0;
      if (p_IO_SLAVE == 1'b1) begin
          @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
          #1;
          donecheck(" sister_bfm_io_write_slave.nwritedata_received");
          sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
           @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
          #1;
          donecheck(" bfm_io_write_slave.nwritedata_received");
          bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end

      expected_sister_rd_data = 64'hxxxx_xxxx_7654_3210;
      check ("Check LSB of data being nwritten",expected_sister_rd_data[31:0],  sister_rd_data[31:0]);
      donecheck(" Received and processed NWRITE packet in sister Avalon Master");

      // Check MSWord
      if (p_IO_SLAVE == 1'b1) begin
         @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         #1;
         donecheck(" sister_bfm_io_write_slave.nwritedata_received");
          sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
            @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         #1;
         donecheck(" bfm_io_write_slave.nwritedata_received");
          bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end
      
      expected_sister_rd_data = 64'h7654_3210_xxxx_xxxx;
      check ("Check MSB of data being nwritten",expected_sister_rd_data[63:32], sister_rd_data[63:32]);
      donecheck(" Received and processed NWRITE packet in sister Avalon Master");
      end
      // End of IO_DATAPATH_WIDTH == 64

      if( IO_DATAPATH_WIDTH == 32 ) begin
      // Even address bit 2
      if (p_IO_SLAVE == 1'b1) begin
         @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      	#1;
      	donecheck(" sister_bfm_io_write_slave.writedata_received");
      	expected_sister_rd_data = {8'h00, 16'h5432, 8'h08};
      	sister_bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
	 @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
        #1;
        donecheck(" bfm_io_write_slave.writedata_received");
        expected_sister_rd_data = {8'h00, 16'h5432, 8'h08};
        bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end

      check ("Check data being written",expected_sister_rd_data, sister_rd_data);
      info("Checked a single word burst nwritten word.");
      donecheck(" Received and processed NWRITE packet in sister Avalon Master");
      // Odd address bit 2
      if (p_IO_SLAVE == 1'b1)  begin
        @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      	#1;
      	donecheck(" sister_bfm_io_write_slave.writedata_received");
      	expected_sister_rd_data = {8'h00, 16'h5432, 8'h0C};
      	sister_bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
      end else begin
      	@(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
      	#1;
      	donecheck(" bfm_io_write_slave.writedata_received");
      	expected_sister_rd_data = {8'h00, 16'h5432, 8'h0C};
      	bfm_io_write_slave.read_writedata( 0, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );

      end      

      check ("Check data being nwritten",expected_sister_rd_data, sister_rd_data);
      info("Checked a single word burst nwritten word.");
      donecheck(" Received and processed NWRITE packet in sister Avalon Master");
      end
      // End of IO_DATAPATH_WIDTH == 32
      for( rsize = `MIN_WRITTEN_BYTES; rsize <= `MAX_WRITTEN_BYTES; rsize = rsize + `WRITTEN_BYTES)begin
         sister_rd_burstcount = rsize / (IO_DATAPATH_WIDTH/8);
         $display("rsize = %d", rsize);
         $display("sister_rd_burstcount = %d", sister_rd_burstcount );
         // Expect to receive the nwritten packets
        if (p_IO_SLAVE == 1'b1) begin
         @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         #1;
         donecheck(" sister_bfm_io_write_slave.writedata_received");
        end else begin
         @(negedge sysclk); while( !bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
         #1;
         donecheck(" bfm_io_write_slave.writedata_received");
        end
         for( sister_rd_index = 0; sister_rd_index < sister_rd_burstcount; sister_rd_index = sister_rd_index + 1 )begin
          if( IO_DATAPATH_WIDTH == 32 ) begin
            expected_sister_rd_data = {rsize[7:0], 16'h5432, sister_rd_index};
          end else begin
            expected_sister_rd_data = {rsize[7:0], 16'hDCBA, sister_rd_index, 24'h765432, sister_rd_index};
          end
          if (p_IO_SLAVE == 1'b1) begin
            sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
          end else begin        
            bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
	  end
	  if( IO_DATAPATH_WIDTH == 32 ) begin
            check ("Check data being nwritten",expected_sister_rd_data, sister_rd_data);
	  end else begin
            check ("Check MSB of data being nwritten",expected_sister_rd_data[63:32], sister_rd_data[63:32]);
            check ("Check LSB of data being nwritten",expected_sister_rd_data[31:0],  sister_rd_data[31:0]);
	  end
          info("Checked a nwritten word.");
         end
         
	donecheck(" Received and processed NWRITE packet in sister Avalon Master");
      
       end

    end // fork branch

    begin
      // Send a few read request packets
      @(negedge sysclk);
      rd_byteenable = ~ {{BYTEENABLE_WIDTH}{1'b0}};
      rd_address = 32'h7654_3210;
      if( IO_DATAPATH_WIDTH == 32 ) begin
      rd_burstcount = 1;
      if (p_IO_SLAVE == 1'b1) begin
          bfm_io_read_master.rw_addr_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
      end else begin
          sister_bfm_io_read_master.rw_addr_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
      end
      donecheck(" Started read transaction on DUT IO Slave Avalon");
      end
      // End of IO_DATPATH_WIDTH  == 32
      for( rd_tsize = `MIN_READ_BYTES; rd_tsize <= `MAX_READ_BYTES; rd_tsize = rd_tsize + `READ_BYTES )begin
         rd_burstcount = rd_tsize / (IO_DATAPATH_WIDTH/8);
         // Avalon transaction
         if (p_IO_SLAVE == 1'b1) begin
            bfm_io_read_master.rw_addr_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
         end else begin
            sister_bfm_io_read_master.rw_addr_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
         end
         donecheck(" Started read transaction on DUT IO Slave Avalon");
         $display("rd_tsize = %d", rd_tsize);
      end
   end // fork branch

   begin
      // Receive and check received data.
      rx_rd_address = 32'bx;
      rx_rd_byteenable = {{BYTEENABLE_WIDTH}{1'bx}};
      if( IO_DATAPATH_WIDTH == 32 ) begin
      rx_rd_burstcount = 1;
      expected_rx_rd_data = 32'hABBA_CDDC;
      if (p_IO_SLAVE == 1'b1) begin
         bfm_io_read_master.rw_data( `READ, rx_rd_address, rx_rd_byteenable, rx_rd_data, rx_rd_burstcount );
      end else begin
         sister_bfm_io_read_master.rw_data( `READ, rx_rd_address, rx_rd_byteenable, rx_rd_data, rx_rd_burstcount );
      end
      check ("Check returned read data.",expected_rx_rd_data[31:0], rx_rd_data[31:0]);
      info("Checked a read word.");
      donecheck(" Completed read transaction on DUT IO Slave Avalon");
      end
      //End of IO_DATAPATH_WIDTH == 32
      for( rx_rsize = `MIN_READ_BYTES; rx_rsize <= `MAX_READ_BYTES; rx_rsize = rx_rsize + `READ_BYTES )begin
         rx_rd_burstcount = rx_rsize / (IO_DATAPATH_WIDTH/8);
         for( rx_rd_index = 0; rx_rd_index < rx_rd_burstcount; rx_rd_index = rx_rd_index + 1 )begin
         if( IO_DATAPATH_WIDTH == 32 ) begin
            expected_rx_rd_data = { 24'hCCDDEE, rx_rd_index };
         end else begin
            expected_rx_rd_data = { 24'h8899AA, rx_rd_index, 24'hCCDDEE, rx_rd_index };
         end
          
         if (p_IO_SLAVE == 1'b1) begin
            bfm_io_read_master.rw_data( `READ, rx_rd_address, rx_rd_byteenable, rx_rd_data, rx_rd_burstcount );
         end else begin
            sister_bfm_io_read_master.rw_data( `READ, rx_rd_address, rx_rd_byteenable, rx_rd_data, rx_rd_burstcount );
         end
         if( IO_DATAPATH_WIDTH == 32 ) begin
            check ("Check returned read data.",expected_rx_rd_data[31:0], rx_rd_data[31:0]);
         end else begin
            check ("Check MSB of returned read data.",expected_rx_rd_data[63:32], rx_rd_data[63:32]);
            check ("Check LSB of returned read data.",expected_rx_rd_data[31:0],  rx_rd_data[31:0]);
         end
          info("Checked a read word.");
         end
         donecheck(" Completed read transaction on DUT IO Slave Avalon");
         $display("rx_rsize = %d", rx_rsize);
       end

    end // fork branch

    begin
      // Receive the read request packets
      if (p_IO_SLAVE == 1'b1) begin
         sister_bfm_io_read_slave.readerror = 1'b0;
      end else begin
         bfm_io_read_slave.readerror = 1'b0;
      end

      if( IO_DATAPATH_WIDTH == 32 ) begin
         if (p_IO_SLAVE == 1'b1) begin
            @( posedge sister_bfm_io_read_slave.readdata_requested );
            donecheck(" sister_bfm_io_read_slave.readdata_requested");
            sister_wr_burstcount =  1;
            sister_wr_data = 32'hABBA_CDDC;
            sister_wr_index =  0;
            sister_wr_address = 24'bx;
            sister_bfm_io_read_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
      end else begin
               @( posedge bfm_io_read_slave.readdata_requested );
               donecheck(" bfm_io_read_slave.readdata_requested");
               sister_wr_burstcount =  1;
               sister_wr_data = 32'hABBA_CDDC;
               sister_wr_index =  0;
               sister_wr_address = 24'bx;
               bfm_io_read_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
      end 
     donecheck(" Got NREAD request packet from sister IO Master Avalon");
     end
      // End of IO_DATAPATH_WIDTH == 32
      for( rd_rsize = `MIN_READ_BYTES; rd_rsize <= `MAX_READ_BYTES; rd_rsize = rd_rsize + `READ_BYTES )begin
         // Expect to receive the NREAD request packets
         if (p_IO_SLAVE == 1'b1)  begin
            @( posedge sister_bfm_io_read_slave.readdata_requested );
            donecheck(" sister_bfm_io_read_slave.readdata_requested");
         end else begin
            @(posedge bfm_io_read_slave.readdata_requested );
            donecheck(" bfm_io_read_slave.readdata_requested");
         end

         sister_wr_burstcount =  rd_rsize/(IO_DATAPATH_WIDTH/8);
         for( sister_wr_index =  0; sister_wr_index < sister_wr_burstcount; sister_wr_index = sister_wr_index + 1 )begin
         if( IO_DATAPATH_WIDTH == 32 ) begin
            sister_wr_data = { 24'hCCDDEE, sister_wr_index };
         end else begin
            sister_wr_data = { 24'h8899AA, sister_wr_index, 24'hCCDDEE, sister_wr_index };
         end
            // In zero time
         if (p_IO_SLAVE == 1'b1) begin
            sister_bfm_io_read_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
         end else begin
            bfm_io_read_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );            
         end

         end
         donecheck(" Got NREAD request packet from sister IO Master Avalon");
         $display("rd_rsize = %d", rd_rsize);
      end
   end // fork branch

  join

   if (p_IO_SLAVE == 1'b1) begin
   // Check that the NWRITE_RS_COMPLETED interrupt is asserted
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is asserted.", 1'b1,   sys_mnt_s_irq );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is asserted.");
      bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is set.", 1'b1,  mnt_data[`NWRITE_RS_COMPLETED] );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is set.");
                                                     
   // Clear the NWRITE_RS_COMPLETED interrupt
      mnt_data =  mnt_data | (1 << `NWRITE_RS_COMPLETED);
      bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );

   // Check that the NWRITE_RS_COMPLETED interrupt is not asserted
      bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is not set.", 1'b0,  mnt_data[`NWRITE_RS_COMPLETED] );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is not set.");
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is not asserted.", 1'b0,  sys_mnt_s_irq );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is not asserted.");
   end else begin
      // Check that the NWRITE_RS_COMPLETED interrupt is asserted
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is asserted.", 1'b1,   sister_sys_mnt_s_irq );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is asserted.");
      sister_bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is set.", 1'b1,  mnt_data[`NWRITE_RS_COMPLETED] );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is set.");

   // Clear the NWRITE_RS_COMPLETED interrupt
      mnt_data =  mnt_data | (1 << `NWRITE_RS_COMPLETED);
      sister_bfm_cnt_master.rw_addr_data( `WRITE, `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );

   // Check that the NWRITE_RS_COMPLETED interrupt is not asserted
      sister_bfm_cnt_master.rw_addr_data( `READ,  `IO_SLAVE_INTERRUPT, 4'hF, mnt_data, 1 );
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is not set.", 1'b0,  mnt_data[`NWRITE_RS_COMPLETED] );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is not set.");
      expect_1 ("Check that the NWRITE_RS_COMPLETED interrupt is not asserted.", 1'b0,  sister_sys_mnt_s_irq );
      donecheck("Check that the NWRITE_RS_COMPLETED interrupt is not asserted.");
   end
   
 

end
// End of IO transactions



  if (p_GENERIC_LOGICAL == 1'b1)  begin
/**********************************************************************/
// Pass-Through Port Transactions
/**********************************************************************/
  // Test generic passthrough port
  fork
    begin
      // Send a few type 9 (data streaming) packets with the other transport type 
      // This shows that the Avalon-ST pass-through port can be used for unsupported packet types or for the other transport type.
      @(negedge sysclk);
      for( tsize = 8; tsize <= 256; tsize = tsize + 2)begin
        if (p_TRANSPORT_LARGE == 1'b1) begin
            send_packet_avalon_st (2'b00,   // prio
                           2'b00, // tt (opposite transport type on purpose)
                           4'b1001, // ftype
                           tsize    // number of payload bytes
                           );
        end else begin
             send_packet_avalon_st (2'b00,   // prio
                           2'b01, // tt (opposite transport type on purpose)
                           4'b1001, // ftype
                           tsize    // number of payload bytes
                           );
        end
      end
      info("Verify generic passthrough port -- all packets sent.");
    end
    begin
      // Receive the packets
      for( rsize = 8; rsize <= 256; rsize = rsize + 2)begin
         if (p_TRANSPORT_LARGE == 1'b1) begin
            sister_receive_packet_avalon_st (2'b00,   // prio
                              2'b00, // tt (opposite transport type on purpose)
                              4'b1001, // ftype
                              rsize    // number of payload bytes
                              );
         end else begin
             sister_receive_packet_avalon_st (2'b00,   // prio
                          2'b01, // tt (opposite transport type on purpose)
                          4'b1001, // ftype
                          rsize    // number of payload bytes
                          );
         end
      end
      info("Verify generic passthrough port -- all packets received.");
    end
  join
  
end
// End of PASSTHROUGH transactions

if ( (p_IO_SLAVE  == 1'b1) && (p_READ_WRITE_ORDER == 1'b1))  begin
   wr_byteenable = ~4'd0;
   rd_byteenable = ~4'h0;
   rd_address = 32'h0;

   wr_address = 32'h0;

      @(negedge sysclk);
      wr_byteenable = ~4'h0;
      if (ADAT == 32) begin
          wr_burstcount = 64;
          sister_rd_burstcount = 64;
          sister_wr_data=32'hAAAAAAAA;
      end else begin
          wr_burstcount = 32;
          sister_rd_burstcount = 32;
          sister_wr_data=64'hAAAAAAAA_AAAAAAAA;
      end

      rd_burstcount = 1;
      sister_rd_index=0;
      
      sister_wr_burstcount=1;
      sister_wr_address=0;
      sister_wr_index=1;
      received_writes = 0;
      received_reads = 0;
      
      repeat (10) @(negedge sysclk);
     
fork
     begin
      for( number_tx = 0; number_tx < 8; number_tx = number_tx + 1 )begin
      fork
      
      begin
            @(posedge sysclk);
            bfm_io_read_master.rw_addr_data( `READ, rd_address, rd_byteenable, rd_data, rd_burstcount );
            info("Started read - read write order ");
          end
    
          begin
             for( wr_index = 0; wr_index < wr_burstcount ; wr_index = wr_index + 1 )begin
                if (ADAT == 32) begin
                    sent_wr_data = {number_tx[7:0],16'h5432, wr_index};
                end else begin
                    sent_wr_data = {number_tx[7:0],48'h9876_5432_AAAA, wr_index};
                end
                if( wr_index == 0 )begin
                  bfm_io_write_master.rw_addr_data( `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                  info("Started write - read write order ");
                end else begin
                  bfm_io_write_master.rw_data(      `WRITE, wr_address, wr_byteenable, sent_wr_data, wr_burstcount );
                end 
             end
             wr_address = wr_address + 32'h100;
             
          end
    
          join
    end
    // End for for number_of_tx increment
    end

  begin
      for( number_rx = 0; number_rx < 8; number_rx = number_rx + 1 )begin

       @(negedge sysclk); while( !sister_bfm_io_write_slave.writedata_received )begin @(negedge sysclk); end
        received_writes = received_writes + 1 ;
        #1;
         for( sister_rd_index = 0; sister_rd_index < sister_rd_burstcount ; sister_rd_index = sister_rd_index + 1 )begin
           if (ADAT == 32) begin
            expected_sister_rd_data = {number_rx[7:0], 16'h5432, sister_rd_index};
           end else begin
            expected_sister_rd_data = {number_rx[7:0], 48'h9876_5432_AAAA, sister_rd_index};
           end
            sister_bfm_io_write_slave.read_writedata( sister_rd_index, sister_rd_address, sister_rd_data, sister_rd_word_number, sister_rd_byteenable );
            check ("Check data being written - read write order",expected_sister_rd_data, sister_rd_data);
            info("Checked a written word. - read write order");
         end

       end
  end

  begin
      for( number_rx1 = 0; number_rx1 < 8; number_rx1 = number_rx1 + 1 )begin

          @( posedge sister_bfm_io_read_slave.readdata_requested );
        received_reads = received_reads + 1;
        if( (received_writes < received_reads) && sister_bfm_io_read_slave.readdata_requested) begin 
                error("Read write order transaction violated.");
        end
        if( ((received_writes==received_reads)) && sister_bfm_io_read_slave.readdata_requested) begin 
                donecheck("Read write order transaction preserved correctly.");
        end
      // Receive the read request packets
      sister_bfm_io_read_slave.readerror = 1'b0;
      sister_wr_burstcount =  1;
      sister_wr_index =  0;
      sister_wr_address = 24'bx;
         sister_wr_burstcount = 1;
       if (ADAT == 32) begin
            sister_wr_data = { 24'hCCDDEE, sister_wr_index };
       end else begin
            sister_wr_data = {48'h9876_5432_AAAA, sister_wr_index };
       end
            // In zero time
            sister_bfm_io_read_slave.write_readdata( sister_wr_index, sister_wr_address, sister_wr_data, sister_wr_burstcount );
  
            end
      end

join

end
// End of IO_SLAVE and READ_WRITE_ORDER

  //Wait for completion of multicast-event control symbols
   wait( sister_multicast_event_rx_count == multicast_event_tx_count + 10 );
   // Trigger counting of received multicast event control symbols
   -> send_multicast_event;
   @(negedge sysclk);
   @(negedge sysclk);
  exit;
     
end
 // End of initial block
 
 
/***********************************************************************/
// Always block for write order 
/***********************************************************************/
always @ (posedge sysclk or negedge reset_n) begin

  //initial value  
  if (!reset_n) begin
    n_tx <= 1'b0;
    trans_order_tx_queue <= 32'h0;
    n_rx <= 1'b0;
    trans_order_rx_queue <= 32'h0;
    flush_trans_order_queue <= 1'b0;
    io_s_wr_burstcount_counter <= 8'h0;
    avalon_trans_to_io <= 1'b0;
    drbell_s_waitrequest_reg <= 1'b0;
    avalon_trans_to_drbell <= 1'b0;
    rm_io_trans_fr_queue <= 1'b0;
    rm_io_trans_fr_queue_reg <= 1'b0;
    rm_last_io_trans_fr_queue <= 1'b0;
  end

  //Queue flushing is reruired 
  if (flush_trans_order_queue) begin
    n_tx <= 1'b0;
    trans_order_tx_queue <= 32'h0;
    n_rx <= 1'b0;
    trans_order_rx_queue <= 32'h0;
    flush_trans_order_queue <= 1'b0;
    rm_io_trans_fr_queue_reg <= 1'b0;
    rm_last_io_trans_fr_queue <= 1'b0;
  end

  // Recognize individual IO packets by decrementing the counter
  if (!avalon_trans_to_io && io_s_wr_write && io_s_wr_chipselect && !io_s_wr_waitrequest) begin
    io_s_wr_burstcount_counter <= io_s_wr_burstcount - 1'b1;
//  #the following if is for io_s_wr_burstcount == 01
    if ((io_s_wr_burstcount_counter-1'b1) == (6'h00)) begin
      avalon_trans_to_io <= 1'b0;
    end else begin
      avalon_trans_to_io <= 1'b1;
    end
   end else if (avalon_trans_to_io && io_s_wr_write && io_s_wr_chipselect && !io_s_wr_waitrequest) begin
     io_s_wr_burstcount_counter <= io_s_wr_burstcount_counter - 1;
     if ((io_s_wr_burstcount_counter-1'b1) == (6'h00)) begin
      avalon_trans_to_io <= 1'b0;
     end else begin
      avalon_trans_to_io <= 1'b1;
    end
  end else if (io_s_wr_burstcount_counter == 6'h00) begin
      avalon_trans_to_io <= 1'b0;
  end
   
  // Recognize individual Doorbell Write request by the falling edge of waitrequest and its address
  drbell_s_waitrequest_reg <= drbell_s_waitrequest;
  // avalon_trans_to_drbell is for debugging purpose
  avalon_trans_to_drbell = ((!drbell_s_waitrequest & drbell_s_waitrequest_reg) && (drbell_s_address == 4'h3));

  // Recognize the IO trans removal  from the queue with the rising edge of rm_io_trans_fr_queue
  rm_io_trans_fr_queue_reg <= rm_io_trans_fr_queue;
  rm_last_io_trans_fr_queue <= !rm_io_trans_fr_queue_reg & rm_io_trans_fr_queue;

  // Store the trasmitting sequence into the Tx queue
  if (rm_last_io_trans_fr_queue) begin
     if (!(n_tx == 6'h00)) begin
      n_tx <= n_tx - 1'b1;
// # 1. if the last transaction is IO and it is requested to be removed from the queue, the n_tx is
// # reduced by 1 but the trans_order_tx_queue will not have any additional
// # operation as IO is recorded as 0.
// # 2. if the last transaction is DRBELL and the previous IO transaction is
// # asked to be removed from the queue, the following shifting is required. 
      if (last_drbell_in_queue>last_io_in_queue) begin
        trans_order_tx_queue[n_tx-2] <= 1;
        trans_order_tx_queue[n_tx-1] <= 0;
      end
    end
  end else if ((!avalon_trans_to_io && io_s_wr_write && io_s_wr_chipselect && !io_s_wr_waitrequest) 
  && ((!drbell_s_waitrequest && drbell_s_waitrequest_reg) && (drbell_s_address == 4'h3))) begin
    trans_order_tx_queue[n_tx] <= 0;
    last_io_in_queue <= n_tx;
    trans_order_tx_queue[n_tx+1] <= 1;
    last_drbell_in_queue <= n_tx+1;
    n_tx <= n_tx + 2;
  end else if (!avalon_trans_to_io && io_s_wr_write && io_s_wr_chipselect && !io_s_wr_waitrequest) begin
    trans_order_tx_queue[n_tx] <= 0;
    last_io_in_queue <= n_tx;
    n_tx <= n_tx + 1;
  end else if ((!drbell_s_waitrequest && drbell_s_waitrequest_reg) && (drbell_s_address == 4'h3)) begin
    trans_order_tx_queue[n_tx] <= 1;
    last_drbell_in_queue <= n_tx;
    n_tx <= n_tx + 1;
  end
end

 
/**********************************************************************/
// Multicast Event
/**********************************************************************/
// Asynchronously send and receive multicast-event control symbols
reg       sister_previous_multicast_event_rx;
initial begin
  // Wait for indication from main test body to start sending multicast-event control symbols.
  @ send_multicast_event;

  fork
  // Send multicast-event control symbols
      begin

      if ((p_GENERIC_LOGICAL == 1'b1) || (p_MAINTENANCE_SLAVE == 1'b1) || (p_TX_PORT_WRITE == 1'b1) || (p_RX_PORT_WRITE == 1'b1) || (p_DRBELL == 1) || (p_IO_MASTER == 1'b1) || (p_IO_SLAVE== 1'b1)) begin           
        // Wait for first packet to go out to make sure we are allowed sending multicast-event control symbols
            @( posedge packet_transmitted );
      end
                repeat( 10 ) begin
                   // Test minimum multicast-event spacing.
                   repeat( 10 ) @(negedge txclk);
                   multicast_event_tx = ~multicast_event_tx;
                   info("DUT transmitting a multicast-event control symbol.");
                end
                repeat( multicast_event_tx_count ) begin
                   repeat( 100 ) @(negedge txclk);
                   multicast_event_tx = ~multicast_event_tx;
                   info("DUT transmitting a multicast-event control symbol.");
                end
    
                // Wait for indication from main test body to count the received multicast-event control symbols.
                @ send_multicast_event;
                expect_n ( "Number multicast_event control symbols received by the sister.", multicast_event_tx_count + 10, sister_multicast_event_rx_count, 8 );
                donecheck( "Checked number of multicast-event control symbols received by the sister." );
           end

             //Receive multicast-event control symbols
            begin
                forever begin
                   sister_previous_multicast_event_rx = sister_multicast_event_rx;
                   wait( sister_multicast_event_rx != sister_previous_multicast_event_rx );
                   sister_multicast_event_rx_count = sister_multicast_event_rx_count + 1 ;
                   info("Sister received a multicast-event control symbol.");
                end
           end
      
   join

end
// End of Multicast Event
 

 // watchdog... 
`ifdef WATCHTIME
`else
`define WATCHTIME 800us
`endif
initial begin
//  $dumpvars(0,tb_rio);
  $display("WATCHTIME = %D",`WATCHTIME);
  # `WATCHTIME;
  error("Watchdog: watchdog timer expired");
  err_cnt++;
  exit;
end

   
endmodule
