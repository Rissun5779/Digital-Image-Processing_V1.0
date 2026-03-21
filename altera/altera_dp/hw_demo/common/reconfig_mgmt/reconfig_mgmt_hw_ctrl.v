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


// (C) 2001-2013 Altera Corporation. All rights reserved.
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


// *********************************************************************
//
// reconfig_mgmt_hw_ctrl.v
// 
// Description
// This module is responsible for generating the control signals to 
// reconfigure the following:
// XCVR TX channel - VOD, Pre-emphasis, select the PLL reference clock, 
//                   reprogram the Tx PLL counters, CGB divider,TX output
//                   slew rate, and VCM driver output
// XCVR RX channel - Select the PLL reference clock, reprogram the 
//                   CDR counters to change the datarate, and the 
//                   eye monitor settings
// 
// XCVR channels attached. 
//
// It uses a high-level FSM to loop over all the channels and settings
// It uses a low-level reconfig_mgmt_write module to generate the actual
// commands
//
// This will start a reconfig when the start_reconfig input is pulsed or
// if any of the data inputs change.
// 
// *********************************************************************

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none

module reconfig_mgmt_hw_ctrl #(
	parameter      DEVICE_FAMILY = "Stratix V",
	parameter[3:0] RX_LANES = 4,
	parameter[3:0] TX_LANES = 4,
	parameter[3:0] TX_PLLS = 4
)(
	input wire clk,								// This should be the same 100MHz clock driving the reconfig controller
	input wire reset,							// This should be the same reset driving the reconfig controller

	input wire rx_reconfig_req,					// high pulse starts reconfig with the values defined below
	input wire [1:0] rx_link_rate,
	output reg rx_reconfig_ack,					// Acknowledge the reconfig request to clear flag
	output reg rx_reconfig_busy,				// hold high while reconfig taking plance

	input wire tx_reconfig_req,					// high pulse starts reconfig with the values defined below
	input wire [1:0] tx_link_rate,
	output reg tx_reconfig_ack,					// Acknowledge the reconfig request to clear flag
	output reg tx_reconfig_busy,				// hold high while reconfig taking plance

	input wire tx_analog_reconfig_req,			// high pulse starts reconfig with the values defined below
	input wire [(TX_LANES*2)-1:0] vod,			// Each lane can have it's own 6-bit VOD, using DP encoding & translating
	input wire [(TX_LANES*2)-1:0] emp,			// Each lane can have it's own 5-bit pre-emphasis, using DP encoding & translating
	output reg tx_analog_reconfig_ack,			// Acknowledge the reconfig request to clear flag
	output reg tx_analog_reconfig_busy,			// hold high while reconfig taking plance

	output wire [6:0] mgmt_address,				// connect to reconfig_mgmt_address of reconfig controller
	output wire [31:0] mgmt_writedata,			// connect to reconfig_mgmt_writedata of reconfig controller
	output wire mgmt_write,						// connect to reconfig_mgmt_write of reconfig controller
	input wire mgmt_waitrequest,				// connect to reconfig_mgmt_waitrequest of reconfig controller
	input wire reconfig_busy					// connect to reconfig_busy of reconfig controller
);

	wire [(TX_LANES*6)-1:0] vod_mapped;		// These are the mapped values of vod & emp
	wire [(TX_LANES*5)-1:0] emp_mapped;		

	// Save the settings in local registers to avoid changing mid-configuration
	reg [1:0] rx_link_rate_reg;				
	reg [1:0] tx_link_rate_reg;				
	reg [(TX_LANES*6)-1:0] vod_reg;		
	reg [(TX_LANES*5)-1:0] emp_reg;

	reg start_single_reconfig;			// high pulse starts reconfig with the values defined below
	reg [6:0]	logical_ch_address;		// specifies address for the logical channel
	reg [3:0]	logical_ch_num;			// specifies which logical channel number
	reg [6:0]	feature_offset_address;	// specifies address for the feature offset
	reg [5:0]	feature_offset_val;		// specifies the offset feature value
	reg [6:0]	data_address;			// specifies address for the data offset
	reg [31:0]	data_val;				// specifies the offset data value
	reg [6:0]	cs_address;				// specifies address of control and status register
	reg			mif_mode_1;				//specifies if Mode 1 of the MIF streamer IP is used 
	reg			rx_reconfig;
	reg			tx_reconfig;
	reg			tx_analog_reconfig;

	// Instantiate the low-level module that generates the actual writes
	reconfig_mgmt_write reconfig_mgmt_write_inst(
		.clk(clk),								// Just connect to top-level port
		.reset(reset),							// Just connect to top-level port

		.start_reconfig(start_single_reconfig),		// These signals are setup by the high-level FSM
		.logical_ch_address(logical_ch_address),
		.logical_ch_num(logical_ch_num),
		.feature_offset_address(feature_offset_address),
		.feature_offset_val(feature_offset_val),
		.data_address(data_address),
		.data_val(data_val),
		.cs_address(cs_address),
		.mif_mode_1(mif_mode_1),

		.mgmt_address(mgmt_address),			// Just connect to top-level port
		.mgmt_writedata(mgmt_writedata),		// Just connect to top-level port
		.mgmt_write(mgmt_write),				// Just connect to top-level port
		.mgmt_waitrequest(mgmt_waitrequest),	// Just connect to top-level port
		.reconfig_busy(reconfig_busy)			// Just connect to top-level port
	);

	// MIF types
	localparam	DUPLEX	= 3'b000,
				CMU		= 3'b001,
				RX		= 3'b010,
				TX		= 3'b011,
				ATX		= 3'b100; 

	//Link rates
	localparam	RBR		= 2'b00,
				HBR		= 2'b01,
				HBR2	= 2'b10; 

	// State variables
	localparam 	IDLE					= 0,
				START_RECONFIG			= 1,
				WAIT_FOR_BUSY_HIGH		= 2,
				WAIT_FOR_BUSY_LOW		= 3,
				INCREMENT				= 4,
				END_RECONFIG			= 5;
								
	// Feature index
	//localparam	RX_REFCLK				= 0,
				localparam RX_MIF				 	= 0,
				VOD						= 1,
				EMP						= 2,
				TX_MIF					= 3,
				TX_PLL_MIF				= 4,
				MAX_FEATURE				= 5;

	// Constants for the addresses and values for better reading
	localparam	PMA_CHANNEL_ADDR		= 7'h08,
				PMA_CS_ADDR				= 7'h0A,
				PMA_FEATURE_ADDR		= 7'h0B,
				PMA_DATA_ADDR			= 7'h0C,
				VOD_FEATURE_VAL			= 5'h0,
				EMP_FEATURE_VAL			= 5'h2,
				PLL_CHANNEL_ADDR		= 7'h40,
				PLL_CS_ADDR				= 7'h42,
				PLL_FEATURE_ADDR		= 7'h43,
				PLL_DATA_ADDR			= 7'h44,
				REFCLK_FEATURE_VAL		= 6'h0,
				MIF_CHANNEL_ADDR	    = 7'h38,
				MIF_CS_ADDR				= 7'h3A,
				MIF_FEATURE_ADDR	    = 7'h3B,
				MIF_DATA_ADDR			= 7'h3C,
				REFCLK_VALUE_RBR        = 32'h0000_0000,
				REFCLK_VALUE_HBR        = 32'h0000_0001,
				REFCLK_VALUE_HBR2       = 32'h0000_0001;

	reg [2:0] state;
	reg [3:0] feature;

	// Generate analog mapping tables for each lane
	generate begin			
		genvar tx_lane;
		for (tx_lane=0; tx_lane < TX_LANES; tx_lane = tx_lane + 1) begin:lane
			dp_analog_mappings #(.DEVICE_FAMILY(DEVICE_FAMILY)) dp_analog_mappings_i(
				.in_vod		(vod[(tx_lane*2) +: 2]), 
				.in_emp		(emp[(tx_lane*2) +: 2]),
				.out_vod	(vod_mapped[(tx_lane*6) +: 6]), 
				.out_emp	(emp_mapped[(tx_lane*5) +: 5])
			);
		end // for
	end // generate
	endgenerate

	// Instantiate MIF mapping table 
	reg  [2:0]	mif_type;
	reg  [3:0]	mif_index;
	wire [5:0]	mif_offset;
	wire [15:0]	mif_value;
	wire		mif_done;

	dp_mif_mappings #(.DEVICE_FAMILY(DEVICE_FAMILY)) dp_mif_mappings_i(
		.mif_type(mif_type),
		.rx_link_rate(rx_link_rate_reg),  
		.tx_link_rate(tx_link_rate_reg), 
		.index(mif_index),
		.offset(mif_offset), 
		.value(mif_value),
		.done(mif_done)
	);	

	always @ (posedge clk or posedge reset) begin : STATE_REG
		if (reset) begin
			state <= IDLE;

			// Reset the input registers
			rx_link_rate_reg <= 2'b00; 
			tx_link_rate_reg <= 2'b00;
			vod_reg <= 0;
			emp_reg <= 0;

			// Reset the feature & write counters
			feature					<= RX_MIF;
			rx_reconfig				<= 1'b0;
			tx_reconfig				<= 1'b0;
			tx_analog_reconfig		<= 1'b0;

			// Reset the MIF type, index & done registers
			mif_type				<= RX;
			mif_index				<= 4'd0;

			// Reset all the registers feeding the low-level FSM
			start_single_reconfig	<= 1'h0;
			logical_ch_address 		<= 7'h0;
			logical_ch_num	 		<= 4'h0;
			feature_offset_address 	<= 7'h0;
			feature_offset_val	  	<= 6'h0;
			data_address			<= 7'h0;
			data_val 				<= 7'h0;
			cs_address				<= 7'h0;
			mif_mode_1		        <= 1'b0;

			// Reset the ack and busy signals
			rx_reconfig_ack			<= 1'b0;
			rx_reconfig_busy		<= 1'b0;
			tx_reconfig_ack			<= 1'b0;
			tx_reconfig_busy		<= 1'b0;
			tx_analog_reconfig_ack	<= 1'b0;
			tx_analog_reconfig_busy	<= 1'b0;
		end
		else
			case (state)
				IDLE:	
				begin
					// Reset the channel and feature counters and the start reconfig flag
					start_single_reconfig	<= 1'h0;
					logical_ch_num	 		<= 4'h0;
					feature					<= RX_MIF;
					rx_reconfig				<= 1'b0;
					tx_reconfig				<= 1'b0;
					tx_analog_reconfig		<= 1'b0;

					// Reset the MIF type, index & done registers
					mif_type				<= RX;
					mif_index				<= 4'd0;
					
					// Reset the ack and busy signals
					rx_reconfig_ack			<= 1'b0;
					rx_reconfig_busy		<= 1'b0;
					tx_reconfig_ack			<= 1'b0;
					tx_reconfig_busy		<= 1'b0;
					tx_analog_reconfig_ack	<= 1'b0;
					tx_analog_reconfig_busy	<= 1'b0;

					// Start a reconfig if requested, but only
					// support one reconfig at a time. The priority
					// is RX, TX and finally TX analog
					if (rx_reconfig_req) begin
						// Save all the input settings into local registers
						rx_link_rate_reg	<= rx_link_rate;

						// set the ack and busy flags
						rx_reconfig_ack		<= 1'b1;
						rx_reconfig_busy	<= 1'b1;

						// Set the logical channel and feature to do
						// the RX reconfigurations
						// RX channels are the first ones
						rx_reconfig			<= 1'b1;
						logical_ch_num 		<= 4'h0;
						feature				<= RX_MIF;
						state				<= START_RECONFIG;
					end
					else if (tx_reconfig_req) begin
						// Save all the input settings into local registers
						tx_link_rate_reg	<= tx_link_rate;

						// set the ack and busy flags
						tx_reconfig_ack		<= 1'b1;
						tx_reconfig_busy	<= 1'b1;

						// Set the logical channel and feature to do
						// the TX reconfigurations
						// TX channel is after RX
						tx_reconfig			<= 1'b1;
						logical_ch_num 		<= RX_LANES;
						feature				<= TX_MIF;
						mif_type			<= TX;
						state				<= START_RECONFIG;
					end
					else if (tx_analog_reconfig_req) begin
						// Save all the input settings into local registers
						vod_reg <= vod_mapped;
						emp_reg <= emp_mapped;

						// set the ack and busy flags
						tx_analog_reconfig_ack	<= 1'b1;
						tx_analog_reconfig_busy	<= 1'b1;

						// Set the logical channel and feature to do
						// the TX analog reconfigurations
						// TX channels start after RX channels
						tx_analog_reconfig	<= 1'b1;
						logical_ch_num 		<= RX_LANES;
						feature				<= VOD;
						state				<= START_RECONFIG;
					end
					else state				<= IDLE;
				end
			
				START_RECONFIG:
				begin
					// Reset the ack flags and set start_single_reconfig
					rx_reconfig_ack			<= 1'h0;
					tx_reconfig_ack			<= 1'h0;
					tx_analog_reconfig_ack	<= 1'h0;
					start_single_reconfig	<= 1'h1;

					// Setup the registers feeding the low-level FSM based on the channel and feature
					// The order is RX channels, TX channels, TX PLLs
					case (feature)

						RX_MIF:
						begin
							mif_mode_1	    		<= 1'b1;		
							logical_ch_address 		<= MIF_CHANNEL_ADDR;
							cs_address				<= MIF_CS_ADDR;		
							feature_offset_address 	<= MIF_FEATURE_ADDR;
							feature_offset_val	  	<= mif_offset;
							data_address		    <= MIF_DATA_ADDR;
							data_val				<= mif_value;
						end

						TX_MIF:
						begin
							mif_mode_1	    		<= 1'b1;		
							logical_ch_address 		<= MIF_CHANNEL_ADDR;
							cs_address				<= MIF_CS_ADDR;		
							feature_offset_address 	<= MIF_FEATURE_ADDR;
							feature_offset_val	  	<= mif_offset;
							data_address		    <= MIF_DATA_ADDR;
							data_val				<= mif_value;
						end


						TX_PLL_MIF:
						begin
							mif_mode_1	    		<= 1'b1;		
							logical_ch_address 		<= MIF_CHANNEL_ADDR;
							cs_address				<= MIF_CS_ADDR;		
							feature_offset_address 	<= MIF_FEATURE_ADDR;
							feature_offset_val	  	<= mif_offset;
							data_address		    <= MIF_DATA_ADDR;
							data_val				<= mif_value;
						end

						VOD:
						begin
							mif_mode_1				<= 1'b0;		
							logical_ch_address 		<= PMA_CHANNEL_ADDR;
							feature_offset_address 	<= PMA_FEATURE_ADDR;
							feature_offset_val	  	<= VOD_FEATURE_VAL;
							data_address			<= PMA_DATA_ADDR;
							data_val 				<= vod_reg[6*(logical_ch_num-RX_LANES) +: 6];
							cs_address				<= PMA_CS_ADDR;		
						end

						EMP:
						begin
							mif_mode_1				<= 1'b0;		
							logical_ch_address 		<= PMA_CHANNEL_ADDR;
							feature_offset_address 	<= PMA_FEATURE_ADDR;
							feature_offset_val	  	<= EMP_FEATURE_VAL;
							data_address			<= PMA_DATA_ADDR;
							data_val 				<= emp_reg[5*(logical_ch_num-RX_LANES) +: 5];
							cs_address				<= PMA_CS_ADDR;		
						end
					endcase

					state <= WAIT_FOR_BUSY_HIGH;
				end

				WAIT_FOR_BUSY_HIGH:
				begin
					// Clear the reconfig request
					start_single_reconfig	<= 1'h0;

					if (reconfig_busy) state <= WAIT_FOR_BUSY_LOW;
				end
		
				WAIT_FOR_BUSY_LOW:
					if (!reconfig_busy) state <= INCREMENT;
		
				INCREMENT:
					begin
						// Go to start another reconfig unless we
						// later decide this is the last write
						state <= START_RECONFIG;

						// Increment the channel and feature counters
						if (rx_reconfig) 
						begin 
							// For each logical RX channel, set
							// refclk & MIF values one after another
							case (feature)
								
								RX_MIF:
								begin
								 mif_type <= RX;
									// Check if this is the last mif value
									if (~mif_done)
									begin
										// Write the next MIF value
										mif_index	<= mif_index + 4'd1;
										feature		<= RX_MIF;
									end
									else
									begin
										mif_index	<= 4'd0;
										//feature		<= RX_MIF;

										// Check if this is the last
										// RX write
										if (logical_ch_num == (RX_LANES-1))
											state		<= END_RECONFIG;

										//Increment the logical_ch_num
										logical_ch_num <= logical_ch_num + 4'h1;
									end
								end
							endcase
						end // rx_reconfig
						else if (tx_reconfig)
						begin
							//Set TX MIF, TX ref clock and CMU MIF
							case (feature)
								TX_MIF:
								begin
									// Check if this is the last mif value
									if (~mif_done)
									begin
										// Write the next MIF value
										mif_index	<= mif_index + 4'd1;
										feature		<= TX_MIF;
									end
									else
									begin
										mif_index	<= 4'd0;

										// Last Tx channel write need to switch to TX refclk
										if (logical_ch_num == (RX_LANES + TX_LANES - 1))
											begin
											feature	<= TX_PLL_MIF;
											mif_type	<= CMU;
											end
										else
											feature	<= TX_MIF;

										logical_ch_num	<= logical_ch_num + 4'h1;
									end
								end


								TX_PLL_MIF:
								begin
									// Check if this is the last mif value
									if (~mif_done)
									begin
										// Write the next MIF value
										mif_index	<= mif_index + 4'd1;
										feature		<= TX_PLL_MIF;
									end
									else
									begin
										mif_index	<= 4'd0;
										//feature		<= TX_REFCLK;
										//feature <= TX_MIF;
   
										// See if this is the last channel
										if (logical_ch_num == (RX_LANES + TX_LANES + TX_PLLS -1))
											state		<= END_RECONFIG;

										logical_ch_num <= logical_ch_num + 4'h1;
									end
								end
							endcase
						end //tx_reconfig
						else if (tx_analog_reconfig)
						begin
							case (feature)
								// After VOD write EMP
								VOD:
									feature			<= EMP;
									
								// After EMP write VOD or quit
								EMP:
								begin
									feature			<= VOD;

									// See if this is the last TX channel
									if (logical_ch_num == (RX_LANES + TX_LANES - 1))
										state		<= END_RECONFIG;

									logical_ch_num	<= logical_ch_num + 4'h1;
								end
							endcase
						end // tx_analog_reconfig
					end //INCREMENT

				END_RECONFIG:
					begin
						// clear the busy flags & go to the IDLE state
						rx_reconfig_busy <= 1'b0;
						tx_reconfig_busy <= 1'b0;
						tx_analog_reconfig_busy <= 1'b0;

						state <= IDLE;
					end
				endcase
			end
endmodule
// synthesis translate_off
// synthesis translate_on

`default_nettype wire
