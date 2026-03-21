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


// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


/*
i2c master module, supporting 32 bit sub address and 32 bit data registers

i2c_32sub.v
 
 
Written by Rod McInnis June 17, 2013
$Rev: 181 $:     Revision of last commit
$Author: rmcinnis $:  Author of last commit
$Date: 2013-06-13 14:43:32 -0700 (Thu, 13 Jun 2013) $:    Date of last commit

*/

// modified by jseo : include header file and timescale
// Customized for HMC design example by AA.
// - removed load_register and registers_loaded
// - fixed mixed blocking/ non-blocking assignments.


`timescale 1ps/1ps

`define I2C32_ADDR_WIDTH               8
`define I2C32_CSR_ADDR                 00 
`define I2C32_SLV_ADDR_ADDR            04
`define I2C32_CLK_DIV_ADDR             08   // only 16 bits useable
`define I2C32_SUB_ADDR_ADDR            0C
`define I2C32_XMIT_DATA                10
`define I2C32_READ_DATA_ADDR           14
`define I2C32_CLK_STRETCH_MAX_ADDR     18
//`define I2C32_HMCC_CSR_ADDR            40
  
`define   I2C32_XFR_SIZE_WIDTH   3
`define   I2C32_SUBA_SIZE_WIDTH  3
  
`define   I2C32_BUSY_BIT        31
`define   I2C32_DONE_BIT        30
`define   I2C32_ANACK_BIT       29
`define   I2C32_DNACK_BIT       28
`define   I2C32_ARB_LOST_BIT    27
`define   I2C32_SUBA_SIZE_MSB   14
`define   I2C32_SUBA_SIZE_LSB   12

`define   I2C32_10BIT_BIT        8
`define   I2C32_CLK_STRETCH_BIT  7
`define   I2C32_XFR_SIZE_MSB     6
`define   I2C32_XFR_SIZE_LSB     4

`define   I2C32_READ             3
`define   I2C32_STOP             2
`define   I2C32_START            1
`define   I2C32_GO_BIT           0


module i2c_32sub 
#(
  parameter DEVICE_FAMILY = "Arria 10",
  parameter CLK_FREQ = 50 // clk frequency in Megahertz
  )
   (
    input wire [7:0]  address,
    input wire [31:0] write_data,
    input wire        write,
    input wire        read,
    output reg [31:0] read_data,
    output wire       busy,
    output wire       nack,
    
//  input             load_registers,
//  output reg        registers_loaded,
   
    inout wire        sda,
    inout wire        scl,
   
    input wire        reset,
    input wire        clk
    );
  
   reg                scl_out;
   reg                sda_out;
   wire               sda_in/* = sda*/;
   wire               scl_in/* = scl*/;
//   assign scl = scl_out ? 1'bz : 1'b0;  // open drain, only drives to 0
//   assign sda = sda_out ? 1'bz : 1'b0;
   
   //  **************************************************************************
   //
   //    CSR stuff
   //
   //  **************************************************************************
   
   
   reg [31:0]         csr_reg, clk_div_reg, sub_addr_reg, i2c_xmit_data, i2c_rcv_data;
   reg                addr_nack, data_nack;
   reg                i2c_go_flag;
   reg                arb_lost;
   reg [3:0]          bit_cnt;   // counts the bits, could go up to ten for 10 bit address mode
   reg [2:0]          byte_cnt;  // counts the bytes of data
   reg [15:0]         slv_addr;
   
   reg [31:0]         clk_stretch_cnt;  // measures how long the clock takes to rise
   reg [31:0]         clk_rise_max       ;
   reg                clk_stretch_trigger;
   reg [4:0]          sig_tap_clk_cnt;
   
// reg                addr_2nd_byte;  // indicates we are on the second byte of device address
   reg                xfr_running, i2c_done;
   
   reg [7:0]          shift_out_reg;
   
   wire [`I2C32_SUBA_SIZE_WIDTH-1:0] sub_addr_size = csr_reg[`I2C32_SUBA_SIZE_MSB:`I2C32_SUBA_SIZE_LSB];
   wire                              ena10bit_addr = csr_reg[`I2C32_10BIT_BIT];
   wire [`I2C32_XFR_SIZE_WIDTH-1:0]  xfr_size      = csr_reg[`I2C32_XFR_SIZE_MSB: `I2C32_XFR_SIZE_LSB];
   wire                              i2c_read      = csr_reg[`I2C32_READ];
   wire                              start_flag    = csr_reg[`I2C32_START];
   wire                              stop_flag     = csr_reg[`I2C32_STOP];
   
   assign busy = xfr_running | i2c_go_flag;
   assign nack = addr_nack | data_nack;
 
   reg [31:0]                        csr_reg_read;
   always @(*) begin
      csr_reg_read = csr_reg;   // default
      csr_reg_read[`I2C32_BUSY_BIT]                           = busy;
      csr_reg_read[`I2C32_DONE_BIT]                           = i2c_done;
      csr_reg_read[`I2C32_ANACK_BIT]                          = addr_nack;
      csr_reg_read[`I2C32_DNACK_BIT]                          = data_nack;
      
      csr_reg_read[`I2C32_ARB_LOST_BIT]                       = arb_lost;
      csr_reg_read[15]                                        = sig_tap_clk_cnt[4];
      csr_reg_read[`I2C32_SUBA_SIZE_MSB:`I2C32_SUBA_SIZE_LSB] = sub_addr_size;
      csr_reg_read[`I2C32_10BIT_BIT]                          = ena10bit_addr;
      csr_reg_read[`I2C32_CLK_STRETCH_BIT]                    = clk_stretch_trigger;  // this was just to keep the gate eater from removing this - signal Tap
      csr_reg_read[`I2C32_XFR_SIZE_MSB :`I2C32_XFR_SIZE_LSB]  = xfr_size;
      csr_reg_read[`I2C32_READ]                               = i2c_read;
      csr_reg_read[`I2C32_START]                              = start_flag;
      csr_reg_read[`I2C32_STOP]                               = stop_flag;
      csr_reg_read[`I2C32_GO_BIT]                             = i2c_go_flag;
   end // of always

  
   always @(posedge clk or posedge reset) begin
  
      if (reset) begin
//       clk_div_reg   <= 32'hfa;  // 100 KHz default (half of period) @50 MHz input clock
         clk_div_reg   <= ( (CLK_FREQ * 1000000.0) / 400000.0 ) / 2.0 + 0.9999;  // Approx 400 KHz default (half period rounded up)
         sub_addr_reg  <= 32'h0; 
         i2c_xmit_data <= 32'h0; 
         i2c_go_flag   <= 1'b0;
         slv_addr      <= 16'h0;
         read_data    <= 32'h0;  
//       registers_loaded <= 1'b0;
        
         csr_reg       <= 32'h0;
         csr_reg[`I2C32_SUBA_SIZE_MSB:`I2C32_SUBA_SIZE_LSB] <=  `I2C32_SUBA_SIZE_WIDTH'h1;
         csr_reg[`I2C32_10BIT_BIT]                          <= 1'b0; 
         csr_reg[`I2C32_XFR_SIZE_MSB: `I2C32_XFR_SIZE_LSB]  <= `I2C32_XFR_SIZE_WIDTH'h1; 
         csr_reg[`I2C32_READ]                               <= 1'b0; 
         csr_reg[`I2C32_START]                              <= 1'b0; 
         csr_reg[`I2C32_STOP]                               <= 1'b0; 
      end else begin
    
         if (xfr_running) begin
            i2c_go_flag     <= 1'b0;
         end // of xfr_running
       
         // synthesis translate_off 
         if (write && xfr_running)
         $display ("  ***** ERROR:  WRITE to i2c with transfer in progress, address %h at time %0t", address, $time);
         // synthesis translate_on
       
         if (write && !xfr_running) begin
            case ({address, 2'b0})  // byte addresses instead of word
 

               `I2C32_ADDR_WIDTH'h`I2C32_CSR_ADDR :  begin     
                  csr_reg <= write_data;
                  if (write_data[`I2C32_GO_BIT] == 1'b1) begin 
                     i2c_go_flag <= 1'b1;
                  end
               end  // of state 
 
               `I2C32_ADDR_WIDTH'h`I2C32_SLV_ADDR_ADDR   : slv_addr[15:0] <= write_data[15:0];
                                  
               `I2C32_ADDR_WIDTH'h`I2C32_CLK_DIV_ADDR    : clk_div_reg <= write_data;
                                  
               `I2C32_ADDR_WIDTH'h`I2C32_SUB_ADDR_ADDR   : sub_addr_reg <= write_data;
 
               `I2C32_ADDR_WIDTH'h`I2C32_XMIT_DATA       : i2c_xmit_data <= write_data;

//             `I2C32_ADDR_WIDTH'h`I2C32_HMCC_CSR_ADDR   : registers_loaded <= write_data[1];
                                   
               default : begin
                  // synthesis translate_off 
                  $display ("  ***** ERROR:  Undefined address %h written at time %0t", address, $time);
                  // synthesis translate_on
               end // of default case
            endcase
      
       end // of  if write
 
         // read mux
         if ( read ) begin
            case ( {address, 2'b0} )  // byte addresses instead of word
        
               `I2C32_ADDR_WIDTH'h`I2C32_CSR_ADDR                 : read_data <= csr_reg_read;
        
               `I2C32_ADDR_WIDTH'h`I2C32_SLV_ADDR_ADDR            : read_data <= {6'h0, slv_addr[9:0]};
                                        
               `I2C32_ADDR_WIDTH'h`I2C32_CLK_DIV_ADDR             : read_data <= clk_div_reg;
        
               `I2C32_ADDR_WIDTH'h`I2C32_SUB_ADDR_ADDR            : read_data <= sub_addr_reg;
        
               `I2C32_ADDR_WIDTH'h`I2C32_XMIT_DATA                : read_data <= i2c_xmit_data;
        
               `I2C32_ADDR_WIDTH'h`I2C32_READ_DATA_ADDR           : read_data <= i2c_rcv_data;
                
               `I2C32_ADDR_WIDTH'h`I2C32_CLK_STRETCH_MAX_ADDR     : read_data <= clk_rise_max;     

//             `I2C32_ADDR_WIDTH'h`I2C32_HMCC_CSR_ADDR            : read_data <= {30'h0, registers_loaded, load_registers};
            default : begin
               // synthesis translate_off 
               read_data <= 32'hdeadbeef;
               $display ("  ***** ERROR:  Undefined address %h read at time %0t", address, $time);
               // synthesis translate_on
            end // of default case
            endcase
         end // of read 
     
      end // of not reset

   end // of always
  
  
   
   //  **************************************************************************
   //
   //    Clock stuff
   //
   //  **************************************************************************
   
   localparam CLK_ST_IDLE = 2'h0,
              CLK_ST_HIGH = 2'h1,
              CLK_ST_LOW  = 2'h2,
              CLK_ST_END  = 2'h3;
      
   reg tick;
   reg clk_rising, clk_falling;
   reg [15:0] tick_count;
// reg        high_tick;
  
   reg [1:0]  i2c_clock_state;
   reg        scl_in_filtered;
   reg [3:0]  scl_filter_count;
   reg        clock_idle;
   
  
   always @(posedge clk or posedge reset) begin
  
      if ( reset ) begin
         tick                <=  1'b0;
         tick_count          <= 1'b0;
         clk_rising          <= 1'b0;
         clk_falling         <= 1'b0;
         i2c_clock_state     <= 1'b0;
         scl_filter_count    <= 4'hF;
         scl_in_filtered     <= 1'b1;
         scl_out             <= 1'b1;
         clock_idle          <= 1'b0;
//       high_tick           <= 1'b0;
         clk_stretch_cnt     <= 32'h0;
         clk_rise_max        <= 32'h0;
         clk_stretch_trigger <= 1'b0;
         sig_tap_clk_cnt     <= 5'h0;
         
      end else begin
    
         sig_tap_clk_cnt <= sig_tap_clk_cnt + 5'h1;
    
         if ( scl_in_filtered == 1'b1 ) begin   // deglitch the clock input
            if ( scl_in == 1'b0 ) begin
               scl_filter_count <= scl_filter_count - 4'h1;
            end else begin 
               scl_filter_count <= 4'hf;
            end
            if ( scl_filter_count == 4'h0 ) begin
               scl_in_filtered <= 1'b0;
            end
         end else begin
            if ( scl_in == 1'b1 ) begin
               scl_filter_count <= scl_filter_count - 4'h1;
            end else begin 
               scl_filter_count <= 4'hf;
            end
            if ( scl_filter_count == 4'h0 ) begin
               scl_in_filtered <= 1'b1;
            end
      
         end // scl_filtered was 0

         case ( i2c_clock_state ) 
            CLK_ST_IDLE : begin
               if ( tick ) begin
                  scl_out     <= 1'b1;
               end
               clock_idle  <= 1'b1;
               clk_rising  <= 1'b0;
               clk_falling <= 1'b0;
               tick        <= 1'b0;
               
/*         
           if (i2c_go_flag) begin
              if (scl_in_filtered  == 1'b1) begin
                 if (tick_count == 16'h0) begin
                   tick <= 1'b1;
                   tick_count <= clk_div_reg[15:0];
                   i2c_clock_state <= CLK_ST_HIGH;
                  end
                 else begin
                    tick <= 1'b0;
                    tick_count <= tick_count - 16'h1;
                  end // of tick count == 0
               end // of scl_in_filtered
              else begin
                 tick_count <= clk_div_reg;
               end //  of not scl_in_filtered
              end // of i2c_go_flag
            else begin 
                tick_count <= clk_div_reg;
              end // not i2c_go_flag
*/
               if ( tick_count == 16'h0 ) begin
                  tick <= 1'b1;
               end
          //if (scl_in_filtered  == 1'b0) high_tick <= 1'b0;
          //else if (tick)                high_tick <= 1'b1;


               if ( tick_count == 16'h0 ) begin
                  tick_count <= clk_div_reg[15:0];
               end else begin
                  tick_count <= tick_count - 16'h1;
               end // of tick count == 0
          
               if ( tick && xfr_running ) begin
                  i2c_clock_state <= CLK_ST_HIGH;
               end else if( tick && i2c_go_flag && !sda_in ) begin
                  scl_out <= !scl_out;  // toggle the clock to release sda
                  clk_falling <= 1'b1;  // indicate the falling clock
               end
            end // case: CLK_ST_IDLE
            
            CLK_ST_HIGH : begin  // clock high for at least half a clock period
               clock_idle  <= 1'b0;
               clk_rising  <= 1'b0;
               clk_falling <= 1'b0;
               tick        <= 1'b0;
             
               if (clk_stretch_cnt > clk_rise_max) begin
                  clk_rise_max <= clk_stretch_cnt;
                  clk_stretch_trigger <= 1'b1;
               end else begin
                  clk_stretch_trigger <= 1'b0;
               end
               clk_stretch_cnt <= 32'h0; // Was this meant to be in the "else"?
             
               if ( i2c_done ) begin
                  i2c_clock_state <= CLK_ST_END;              
               end else begin
                  if ( tick_count == 16'h0 ) begin
                     scl_out <=  1'b0;                      // drive the clock low
                     if ( scl_in_filtered  == 1'b0 ) begin  // clock has to actually go low
                        tick <= 1'b1;
                        tick_count <= clk_div_reg[15:0];
                        clk_falling <= 1'b1;
                        i2c_clock_state <=  CLK_ST_LOW;
                     end // of scl_in_filtered <=  0
                  end else begin
                     tick_count <= tick_count - 16'h1;
                  end 
               end // else: !if(i2c_done)
                      
            end // case: CLK_ST_HIGH
                    
            CLK_ST_LOW : begin  // clock was high for at least the half period
               clock_idle  <= 1'b0;
               clk_rising  <= 1'b0;
               clk_falling <= 1'b0;
               tick        <= 1'b0;
               if ( tick_count == 16'h0 ) begin
                  scl_out <=  1'b1;                      // allow clock to be pulled high
                  if ( scl_in_filtered  == 1'b1 ) begin  // wait for it to actually go high
                     tick <= 1'b1;
                     tick_count <= clk_div_reg[15:0];
                     clk_rising <= 1'b1;
                     if ( i2c_done ) begin
                        i2c_clock_state <=  CLK_ST_END;
                     end else begin
                        i2c_clock_state <=  CLK_ST_HIGH;
                     end
                  end else begin // of scl_in_filtered high
                     clk_stretch_cnt <= clk_stretch_cnt + 32'h1;
                  end // scl_in wasn't high
               end else begin
                  tick_count <= tick_count - 16'h1;
               end // tick count wasn't 0
       
            end // case: CLK_ST_LOW        
        
            CLK_ST_END: begin
               clock_idle  <= 1'b0;
               scl_out     <= 1'b1;                  // allow clock to be pulled high
               clk_rising  <= 1'b0;
               clk_falling <= 1'b0;
               tick        <= 1'b0;
               if ( tick_count == 16'h0 ) begin
                  if ( scl_in_filtered  == 1'b1 ) begin       // wait for it to actually go high
                     tick            <= 1'b1;              // issue a tick
                     tick_count      <= clk_div_reg[15:0];
                     i2c_clock_state <=  CLK_ST_IDLE;      // return to idle
                  end // of scl_in_filtered high
               end else begin
                  tick_count <= tick_count - 16'h1;
               end // tick count wasn't 0
       
            end // case: CLK_ST_END
            
       endcase
          
      end // else: !if( reset )
      
   end // always @ (posedge clk or posedge reset)
 
    
   //  **************************************************************************
   //
   //    State Machine
   //
   //  **************************************************************************

   reg [3:0] i2c_state;
   localparam  I2C_ST_IDLE     = 4'h0 ,
               I2C_ST_START    = 4'h1 ,
               I2C_ST_ADDR     = 4'h2 ,
               I2C_ST_AACK     = 4'h3 ,
               I2C_ST_SUB      = 4'h4 ,
               I2C_ST_SUBACK   = 4'h5 ,
               I2C_ST_WRITE    = 4'h6 ,
               I2C_ST_WACK     = 4'h7 ,
               I2C_ST_READ     = 4'h8 ,
               I2C_ST_RACK     = 4'h9 ,
               I2C_ST_PRE_STOP = 4'ha ,
               I2C_ST_STOP     = 4'hb ,
               I2C_ST_ARB      = 4'hc ,
               I2C_ST_END      = 4'hd ;
 
   always @(posedge clk or posedge reset) begin
  
      if ( reset ) begin
         i2c_state     <= I2C_ST_IDLE;
         xfr_running   <= 1'b0;
         bit_cnt       <= 4'h0;
         byte_cnt      <= 3'h0;
         shift_out_reg <= 8'h0;
         addr_nack     <= 1'b0; 
         data_nack     <= 1'b0;
         arb_lost      <= 1'b0;
         i2c_done      <= 1'b0;
         i2c_rcv_data  <= 32'h0;
         sda_out       <= 1'b1;
         //addr_2nd_byte <= 1'b0;
      end else begin
      
         xfr_running   <= 1'b1;
      
         case ( i2c_state )
            I2C_ST_IDLE   : begin  
               //addr_2nd_byte <= 1'b0;
               xfr_running <= 1'b0;   // we aren't xfr_running in the idle state
               byte_cnt    <= xfr_size; 
               bit_cnt     <= 4'h8;
               if ( i2c_go_flag && tick ) begin
                  i2c_done      <= 1'b0;
                  addr_nack     <= 1'b0; 
                  data_nack     <= 1'b0;
                  arb_lost      <= 1'b0;
                  i2c_rcv_data  <= 32'h0;
                  if ( start_flag ) begin
                     i2c_state <= I2C_ST_START;
                  end else begin // no start flag == continuation of transfer
                     if ( i2c_read ) begin
                        i2c_state <= I2C_ST_READ;
                     end else begin
                        i2c_state <= I2C_ST_WRITE;
                        case ( xfr_size ) 
                           1: shift_out_reg <= i2c_xmit_data[7:0];
                           2: shift_out_reg <= i2c_xmit_data[15:8];
                           3: shift_out_reg <= i2c_xmit_data[23:16];
                           4: shift_out_reg <= i2c_xmit_data[31:24];
                           default:  shift_out_reg <= i2c_xmit_data[7:0];
                        endcase 
                     end
                  end
               end // of go & tick
            end // case: I2C_ST_IDLE
             
            I2C_ST_START  : begin  
               // clock could be high or low.  It will be high if we are starting
               // after a STOP, or low if we are restarting 
               xfr_running  <= xfr_running;   
               shift_out_reg <= {slv_addr[7:1],i2c_read}; // load up the i2c slave address
               bit_cnt <=  8;  // 8 bits of upper byte
                                
               if ( ena10bit_addr ) begin
                  byte_cnt <= 3'h2;
               end else begin
                  byte_cnt <= 3'h1;
               end               
                                 
               if ( clk_falling ) begin
                  sda_out <= 1'b1;  // if we had been driving it, we'll stop
               end           
               if ( tick  && scl_in_filtered && sda_in ) begin
                  sda_out   <= 1'b0;   // SDA going low when scl is high indicates start_flag condition
                  xfr_running <= 1'b1;
                  i2c_state <= I2C_ST_ADDR;
               end // of tick
            end // case: I2C_ST_START
                            
            I2C_ST_ADDR   : begin  
               
               if( clk_falling ) begin                   // data changes on the falling edge
                  sda_out <= shift_out_reg[7];             // drive out the MSB
                  shift_out_reg <= {shift_out_reg[6:0],1'b0};  // shift left
                  bit_cnt   <= bit_cnt - 4'h1;
               end // of clock falling
                              
               if( clk_rising ) begin                   // change states on the rising
                  
                  if ( sda_in != sda_out )  begin  // arbitration check
                     i2c_state <= I2C_ST_ARB;
                  end else if (bit_cnt == 4'h0) begin           // if that was the last bit
                     byte_cnt <= byte_cnt - 3'h1;
                     i2c_state <= I2C_ST_AACK;         // go to the read/write state
                  end // of bit count = 0
               end // of clk_rising
                              
            end // case: I2C_ST_ADDR
                             
            I2C_ST_AACK : begin  
               bit_cnt   <= 4'h8;
               if ( clk_falling ) begin
                  sda_out <=  1'b1;     //  allow sda to tristate
               end          
               case ( byte_cnt ) 
                  0: begin
                 
                     case (sub_addr_size) 
                        1:        shift_out_reg <= sub_addr_reg[7:0];
                        2:        shift_out_reg <= sub_addr_reg[15:8];
                        3:        shift_out_reg <= sub_addr_reg[23:16];
                        4:        shift_out_reg <= sub_addr_reg[31:24];
                        default : shift_out_reg <= sub_addr_reg[7:0];
                     endcase
                  end // of byte count = 0

                  1:              shift_out_reg <= slv_addr[15:8];

                  default:        shift_out_reg <= sub_addr_reg[7:0];
               endcase

                               
               if( clk_rising ) begin            // change states on the rising
                  if ( sda_in == 1'b0 ) begin     // data = 0 is an ACK

                     if ( byte_cnt == 3'h0 ) begin
                        if ( i2c_read ) begin
                           byte_cnt  <= xfr_size;          // 0 <=  4 bytes of read 
                        end else begin
                           byte_cnt  <= sub_addr_size;     // 0 = 4 bytes of sub address
                        end       
                        if ( i2c_read ) begin
                           i2c_state <= I2C_ST_READ;  // go to read state
                        end else begin
                           i2c_state <= I2C_ST_SUB;   // or on write, sub address                                  
                        end
                     end // of byte count = 0
                  end else begin                                    // it was a NACK, no response
                     addr_nack <= 1'b1;
                     i2c_state <= I2C_ST_PRE_STOP ;            // issue stop sequence
                  end // of nack
               end  // of clk_rising
               
            end // case: I2C_ST_AACK
                             
            I2C_ST_SUB    : begin  
                             
               if( clk_falling ) begin                   // data changes on the falling edge
                  sda_out       <= shift_out_reg[7];             // drive out the MSB
                  shift_out_reg <= {shift_out_reg[6:0],1'b0};  // shift left
                  bit_cnt       <= bit_cnt - 4'h1;
               end // of clock falling
                              
               if( clk_rising ) begin                   // change states on the rising
                  
                  if ( sda_in != sda_out )  begin  // arbitration check
                     i2c_state <= I2C_ST_ARB;
                  end else if ( bit_cnt == 4'h0 ) begin           // if that was the last bit
                     byte_cnt <= byte_cnt - 3'h1;
                     i2c_state <= I2C_ST_SUBACK;         // go to the read/write state
                  end // of bit count = 0
               end // of clk_rising
               
            end // case: I2C_ST_SUB
                             
            I2C_ST_SUBACK : begin  
               bit_cnt   <= 4'h8;
               if ( clk_falling ) begin
                  sda_out <=  1'b1;     //  allow sda to tristate
               end           
               case ( byte_cnt ) 
                  1:        shift_out_reg <= sub_addr_reg[7:0];
                  2:        shift_out_reg <= sub_addr_reg[15:8];
                  3:        shift_out_reg <= sub_addr_reg[23:16];
                  4:        shift_out_reg <= sub_addr_reg[31:24];
                  default:  shift_out_reg <= sub_addr_reg[7:0];
               endcase

                               
               if( clk_rising ) begin                            // change states on the rising
                  if ( sda_in == 1'b0 ) begin                     // data = 0 is an ACK
                                  
                     if ( byte_cnt == 3'h0 ) begin
                        byte_cnt <= xfr_size;              
                        case ( xfr_size ) 
                           1: shift_out_reg <= i2c_xmit_data[7:0];
                           2: shift_out_reg <= i2c_xmit_data[15:8];
                           3: shift_out_reg <= i2c_xmit_data[23:16];
                           4: shift_out_reg <= i2c_xmit_data[31:24];
                           default:  shift_out_reg <= i2c_xmit_data[7:0];
                        endcase  
                        if ( xfr_size == 3'h0 ) begin
                           if ( stop_flag ) begin
                              i2c_state <= I2C_ST_PRE_STOP;  
                           end else begin
                              i2c_state <= I2C_ST_END;   // typical for read-set index
                           end
                        end else begin
                           i2c_state <= I2C_ST_WRITE; // go to write state
                           end
                     end else begin
                        i2c_state <= I2C_ST_SUB;    // or more sub address                                  
                     end
                  end else begin // it was a NACK, no response
                     data_nack <= 1'b1;
                     i2c_state <= I2C_ST_PRE_STOP ;  // issue stop sequence
                  end // of nack
               end  // of clk_rising
               
            end // case: I2C_ST_SUBACK

            I2C_ST_WRITE  : begin  
               
               if(clk_falling) begin                          // data changes on the falling edge
                  sda_out <= shift_out_reg[7];                // drive out the MSB
                  shift_out_reg <= {shift_out_reg[6:0],1'b0}; // shift left
                  bit_cnt   <= bit_cnt - 4'h1;
               end // of clock falling
                              
               if(clk_rising) begin                   // change states on the rising
                  if (sda_in != sda_out)  begin         // arbitration check
                     i2c_state <= I2C_ST_ARB;
                  end else if (bit_cnt == 4'h0) begin         // if that was the last bit
                     byte_cnt <= byte_cnt - 3'h1;
                     i2c_state <= I2C_ST_WACK;       // go to the read/write state
                  end // of bit count = 0
               end // of clk_rising
                              
            end // case: I2C_ST_WRITE
                             
            I2C_ST_WACK   : begin  
               bit_cnt   <= 4'h8;
                              
               if (clk_falling) sda_out <=  1'b1;     //  allow sda to tristate

               case (byte_cnt) 
                  1: shift_out_reg <= i2c_xmit_data[7:0];
                  2: shift_out_reg <= i2c_xmit_data[15:8];
                  3: shift_out_reg <= i2c_xmit_data[23:16];
                  4: shift_out_reg <= i2c_xmit_data[31:24];
                  default:  shift_out_reg <= i2c_xmit_data[7:0];
               endcase

                               
               if(clk_rising) begin            // change states on the rising
                  if (sda_in == 1'b0) begin     // data = 0 is an ACK
                     if (byte_cnt == 3'h0) begin
                        if (stop_flag) begin 
                           i2c_state <= I2C_ST_PRE_STOP; // if stop seq is required
                           end else begin
                              i2c_state <= I2C_ST_END; // else go to idle
                           end
                     end else begin
                        i2c_state <= I2C_ST_WRITE;  // go to write state
                     end // of not end of byte count
                  end else begin // it was a NACK, no response
                     data_nack <= 1'b1;
                     i2c_state <= I2C_ST_PRE_STOP ;  // issue stop sequence
                  end // of nack
               end  // of clk_rising
               
            end // case: I2C_ST_WACK
            
            I2C_ST_READ   : begin  
               
               if (clk_falling) begin 
                  sda_out <= 1'b1;    // turn off sda out, after the ack
                  bit_cnt <= bit_cnt - 4'h1;
               end // of clock falling
                             
               if(clk_rising) begin                   // change states on the rising
                  i2c_rcv_data <=  {i2c_rcv_data[30:0],sda_in};  // shift a data bit in
                  if (bit_cnt == 4'h0) begin         // if that was the last bit
                     byte_cnt  <= byte_cnt - 3'h1;
                     i2c_state <= I2C_ST_RACK;       // go to the read/write state
                  end // of bit count = 0
               end // of clk_rising
                            
            end // case: I2C_ST_READ
            
            I2C_ST_RACK   : begin 
               bit_cnt   <= 4'h8;
                             
               if (clk_falling) begin
                  if ((byte_cnt != 3'h0) ||  !stop_flag) begin
                     sda_out <=  1'b0;  // only ack if there is more to do
                  end
               end // of clock falling
                              
               if (clk_rising) begin
                  if (byte_cnt == 0) begin
                     if (stop_flag) begin
                        i2c_state <= I2C_ST_PRE_STOP;  // byte count 0, stop needed
                     end else begin
                        i2c_state <= I2C_ST_END;   // byte count 0, more will come
                     end
                  end else begin
                     i2c_state <= I2C_ST_READ;  // byte count wasn't 0
                  end
               end // of clk_rising
            end // case: I2C_ST_RACK
                           
            I2C_ST_PRE_STOP   : begin   // we get here on a rising clock, need
                                        // allowing sda to go high creates stop
                                
               if (clk_falling) begin
                  sda_out    <= 1'b0;   // drive data low it can go high later
                  i2c_state <= I2C_ST_STOP;
               end // of clock falling

            end
            
            I2C_ST_STOP   : begin   // we get here on a rising clock, need
                                   // allowing sda to go high creates stop
                                
               if (clk_rising) begin
                  i2c_done   <= 1'b1;
               end // of clock rising
                                
//                                if ( tick && i2c_done ) begin
               if ( clock_idle ) begin
                  sda_out    <= 1'b1;
                  i2c_state  <= I2C_ST_IDLE;
               end // clock_idle
            end // case: I2C_ST_STOP
            
            I2C_ST_ARB   : begin  // arbitration was lost
               arb_lost  <= 1'b1;
               i2c_state <= I2C_ST_END;
            end
         
            I2C_ST_END   :   begin  // NON STOP cycles passes through here on way to idle
//                                  // we get here from clk_rising, so scl is high
                                    // scl needs to go low to release sda (from the ack)                                   
//                               if (clk_falling) begin
//                                  i2c_done   <= 1'b1;
//                                  sda_out    <= 1'b1;   // drive data low it can go high later
//                                end // of clock falling
 
               i2c_done   <= 1'b1;
                                
               if ( clock_idle ) begin
                  i2c_state  <= I2C_ST_IDLE;
               end // clock_idle
            end // case: I2C_ST_END
                              
            default:   begin  
               i2c_state  <= I2C_ST_IDLE;
            end // of default state

          endcase
    
      end // else: !if( reset )
    
   end // always @ (posedge clk or posedge reset)
generate
if ( DEVICE_FAMILY == "Arria 10" ) begin
	bidir_pin scl_pin (
		.din    (1'b0),
		.dout   (scl_in),
		.oe     (~scl_out),
		.pad_io (scl)
	);

	bidir_pin sda_pin (
		.din    (1'b0),
		.dout   (sda_in),
		.oe     (~sda_out),
		.pad_io (sda)
	);
end  
endgenerate
endmodule  
