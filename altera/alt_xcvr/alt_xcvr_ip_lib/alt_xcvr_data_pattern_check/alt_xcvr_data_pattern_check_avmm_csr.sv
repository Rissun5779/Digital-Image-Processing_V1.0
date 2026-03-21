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

//-------------------------------------------------------------------
// Filename    : alt_xcvr_data_pattern_check_avmm_csr.sv
//
// Description : The register interface module of Data Pattern Checker. For further 
// information, please see the FD
//
// Supported Number of Registers = Up to 16 registers with -- data width
//
// Authors     : Baturay Turkmen
// Date        : July, 7, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_data_pattern_check_avmm_csr #(
  parameter DATA_WIDTH         = 16,       //1-128
  parameter ERROR_WIDTH        = 8,        //4-32
  parameter PATTERN_ADDR_WIDTH = 4         //4-32
)
(
  // avmm signals
  input                                   avmm_clk,
  input                                   avmm_reset,
  input  [PATTERN_ADDR_WIDTH-1:0]         avmm_address,
  input  [31:0]                           avmm_writedata,
  input                                   avmm_write,
  input                                   avmm_read,
  output reg [31:0]                       avmm_readdata, //\TODO init?
  output                                  avmm_waitrequest,
  
  //register outputs for the mux to choose as the inputs of the data pattern generator
  
  input   [ERROR_WIDTH-1:0]               num_dealignment_avmm,
  input   [ERROR_WIDTH-1:0]               num_accumulated_error_avmm,
  input                                   is_data_locked_avmm,
  
  output                                  reset_avmm,
  output                                  enable_avmm,
  output  [PATTERN_ADDR_WIDTH-1:0]        pattern_avmm,
  output  [DATA_WIDTH-1:0]                ext_data_pattern_avmm,
  output  [DATA_WIDTH-1:0]                data_in_avmm,
  output  [15:0]                          register_control_or_avmm
);

// Import package with parameters for the soft addresses 
  import      alt_xcvr_data_pattern_check_avmm_h::*;

//registers 
  reg                            reset_reg               = RESET_INITIAL;
  reg                            enable_reg              = ENABLE_INITIAL;
  reg  [PATTERN_ADDR_WIDTH-1:0]  pattern_reg             = PATTERN_INITIAL;
  
  reg  [31:0]                    ext_data_pattern_reg0   = EXT_DATA_PATTERN_INITIAL;
  reg  [31:0]                    ext_data_pattern_reg1   = EXT_DATA_PATTERN_INITIAL;
  reg  [31:0]                    ext_data_pattern_reg2   = EXT_DATA_PATTERN_INITIAL;
  reg  [31:0]                    ext_data_pattern_reg3   = EXT_DATA_PATTERN_INITIAL;
  
  reg  [31:0]                    data_in_reg0            = DATA_IN_INITIAL;
  reg  [31:0]                    data_in_reg1            = DATA_IN_INITIAL;
  reg  [31:0]                    data_in_reg2            = DATA_IN_INITIAL;
  reg  [31:0]                    data_in_reg3            = DATA_IN_INITIAL;
  
  reg  [ERROR_WIDTH-1:0]         num_accumulated_error_reg;//\TODO init
  reg  [ERROR_WIDTH-1:0]         num_dealignment_reg;//\TODO init
  reg                            is_data_locked_reg;//\TODO init
  
  reg  [15:0]                    register_control_or_reg = REGISTER_CONTROL_OR_INITIAL;
  reg                            avmm_valid;//\TODO init

  wire [127:0]                   ext_data_pattern_temp;
  wire [127:0]                   data_in_temp;

  assign  ext_data_pattern_temp     =  {ext_data_pattern_reg3, ext_data_pattern_reg2, ext_data_pattern_reg1, ext_data_pattern_reg0};
  assign  data_in_temp              =  {data_in_reg3, data_in_reg2, data_in_reg1, data_in_reg0};
  
  assign  reset_avmm                = reset_reg;
  assign  enable_avmm               = enable_reg;
  assign  pattern_avmm              = pattern_reg;
  assign  ext_data_pattern_avmm     = ext_data_pattern_temp[DATA_WIDTH-1:0];
  assign  data_in_avmm              = data_in_temp[DATA_WIDTH-1:0];
  assign  register_control_or_avmm  = register_control_or_reg;
   
  
/**********************************************************************/
//generate waitrequest
/**********************************************************************/
assign avmm_waitrequest =  (~avmm_valid & avmm_read);

/**********************************************************************/
// Read and Write 
/**********************************************************************/
always@(posedge avmm_clk or posedge avmm_reset) begin  

  if(avmm_reset) begin
         reset_reg                  <= RESET_INITIAL;
	 enable_reg                 <= ENABLE_INITIAL;
	 pattern_reg                <= PATTERN_INITIAL;
	 
	 ext_data_pattern_reg3      <= EXT_DATA_PATTERN_INITIAL;
	 ext_data_pattern_reg2      <= EXT_DATA_PATTERN_INITIAL;
	 ext_data_pattern_reg1      <= EXT_DATA_PATTERN_INITIAL;
	 ext_data_pattern_reg0      <= EXT_DATA_PATTERN_INITIAL;
	 
	 data_in_reg3               <= DATA_IN_INITIAL;
	 data_in_reg2               <= DATA_IN_INITIAL;
	 data_in_reg1               <= DATA_IN_INITIAL;
	 data_in_reg0               <= DATA_IN_INITIAL;
	 
	 register_control_or_reg    <= REGISTER_CONTROL_OR_INITIAL;
	 avmm_valid                 <= 1'b1;
	 avmm_readdata              <= 32'b0; 

    num_accumulated_error_reg  <= {ERROR_WIDTH{1'b0}};
	 num_dealignment_reg        <= {ERROR_WIDTH{1'b0}};
	 is_data_locked_reg         <= 1'b0;
	 
	 
  end
  
  else begin
  
	 num_dealignment_reg        <= num_dealignment_avmm;
	 is_data_locked_reg         <= is_data_locked_avmm;
    num_accumulated_error_reg  <= num_accumulated_error_avmm;
  
	
    if (avmm_read) begin
	    
		 avmm_valid    <= avmm_waitrequest;
		 
		 case(avmm_address)
			RESET_ADDRESS:                  avmm_readdata[0]                          <= reset_reg;
			ENABLE_ADDRESS:                 avmm_readdata[0]                          <= enable_reg;
			PATTERN_ADDRESS:                avmm_readdata[PATTERN_ADDR_WIDTH-1:0]     <= pattern_reg;
			
			EXT_DATA_PATTERN_ADDRESS0:      avmm_readdata                             <= ext_data_pattern_reg0;
			EXT_DATA_PATTERN_ADDRESS1:      avmm_readdata                             <= ext_data_pattern_reg1;
			EXT_DATA_PATTERN_ADDRESS2:      avmm_readdata                             <= ext_data_pattern_reg2;
			EXT_DATA_PATTERN_ADDRESS3:      avmm_readdata                             <= ext_data_pattern_reg3;
			
			DATA_IN_ADDRESS0:               avmm_readdata                             <= data_in_reg0;
			DATA_IN_ADDRESS1:               avmm_readdata                             <= data_in_reg1;
			DATA_IN_ADDRESS2:               avmm_readdata                             <= data_in_reg2;
			DATA_IN_ADDRESS3:               avmm_readdata                             <= data_in_reg3;
			
			IS_DATA_LOCKED_ADDRESS:         avmm_readdata[0]                          <= is_data_locked_reg;
			NUM_ACCUMULATED_ERROR_ADDRESS:  avmm_readdata[ERROR_WIDTH-1:0]            <= num_accumulated_error_reg;
			NUM_DEALIGNMENT_ADDRESS:        avmm_readdata[ERROR_WIDTH-1:0]            <= num_dealignment_reg;
			
			REGISTER_CONTROL_OR_ADDRESS:    avmm_readdata[15:0]                       <= register_control_or_reg;
			default:                        avmm_readdata                             <= 32'b0;
       endcase
	 end
	 else begin 
	    avmm_valid    <= 1'b0;
		 avmm_readdata <= 32'b0; 
	 end
	 
	 
	 if (avmm_write)  begin
	 	
		case(avmm_address)
			RESET_ADDRESS:                  reset_reg                 <= avmm_writedata[0];
			ENABLE_ADDRESS:                 enable_reg                <= avmm_writedata[0];
			PATTERN_ADDRESS:                pattern_reg               <= avmm_writedata[PATTERN_ADDR_WIDTH-1:0];
			
			EXT_DATA_PATTERN_ADDRESS0:      ext_data_pattern_reg0     <= avmm_writedata;
			EXT_DATA_PATTERN_ADDRESS1:      ext_data_pattern_reg1     <= avmm_writedata;
			EXT_DATA_PATTERN_ADDRESS2:      ext_data_pattern_reg2     <= avmm_writedata;
			EXT_DATA_PATTERN_ADDRESS3:      ext_data_pattern_reg3     <= avmm_writedata;
			
			DATA_IN_ADDRESS0:               data_in_reg0              <= avmm_writedata;
			DATA_IN_ADDRESS1:               data_in_reg1              <= avmm_writedata;
			DATA_IN_ADDRESS2:               data_in_reg2              <= avmm_writedata;
			DATA_IN_ADDRESS3:               data_in_reg3              <= avmm_writedata;
			
			REGISTER_CONTROL_OR_ADDRESS:    register_control_or_reg   <= avmm_writedata[15:0];
       endcase
	  end	 
  end
end

endmodule
  
  
