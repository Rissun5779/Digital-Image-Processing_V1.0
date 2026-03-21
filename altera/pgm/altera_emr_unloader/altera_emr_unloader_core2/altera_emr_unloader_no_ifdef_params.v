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


// ******************************************************************************************************************************** 
//   File name: altera_emr_unloader.v
// 
//   This module is used to interface to the EMR atom, shifting the serial data
//   out of the EMR user register.  When the shifting is complete, the data is
//   available on the emr output, and the emr_valid output is toggled.  
//   If a new error is reported by the EDC before the previous error has
//   been loaded into shift register, the EMR_error output will be asserted
//   as an indication of lost EMR data. 
//   	
//   Mechanism to read out the content of user update register:
//    1. Drive the SHIFTnLD signal low.
//    2. Wait at least two EDCLK cycles.
//    3. Clock CLK for one rising edge to load the contents of the user update register to the user shift register.
//    4. Drive the SHIFTnLD signal high.
//    5. Clock CLK 30 cycles to read out 30 bits of the error location information.
//    6. Clock CLK 16 cycles more to read out the syndrome of the error.
//
//   This module includes two sources & probes instances:
//    1. "EMR" probes the current contents of the unloaded EMR data, and allows it to be overwritten.
//    2. "CRCE" probes the crcerror output from the EMR block, and allows an error to be injected.
//   


module altera_emr_unloader (
	clk,
	reset,
	emr_read,
	emr,
	emr_valid,
	emr_error,
    crcerror_core,
    crcerror_pin,

	crcerror_endoffullchip
);
	parameter device_family = "Stratix V";
	parameter enable_virtual_jtag = 0;
	parameter emr_reg_width = 7'd67;
	parameter error_clock_divisor = 2;
	parameter error_delay_cycles = 0;
	parameter clock_from_int_oscillator = 0;
	parameter clock_frequency = 100;
	
	// Delay to wait for a least two EDCLK cycles for Shift Register load
	// with minimal measured internal oscillator frequency 78 MHz 
	localparam shiftnld_delay = clock_from_int_oscillator ? 4*error_clock_divisor : (((2*error_clock_divisor*clock_frequency)/78) + 2);

	input clk;
	input reset;
	input emr_read;
	
	output [emr_reg_width-1:0] emr;
	output emr_valid;
	output emr_error;
	output crcerror_core;
    output crcerror_pin;
	
	output crcerror_endoffullchip;

	reg shiftnld;
	wire crcerror_wire;
	wire inject_error;
	reg crcerror_sync1 = 0;
	reg crcerror_sync = 0;
	wire is_crcerror = inject_error | crcerror_sync;
	wire crcerror_pulse;
	
	(* keep *) reg [15:0] reset_reg = 16'hFFFF;
	always @(posedge clk) begin
		reset_reg[15:0] <= {reset_reg[14:0],1'b0};
	end
	
	wire reset_wire;
	assign reset_wire = reset | reset_reg[15];
	
	always @(posedge clk or posedge reset_wire) begin
		if (reset_wire) crcerror_sync1 <= 1'b0;
		else if (crcerror_wire)	crcerror_sync1 <= 1'b1;
		else crcerror_sync1 <= 1'b0;
	end
	
	always @(posedge clk or posedge reset_wire) begin
		if (reset_wire) crcerror_sync <= 1'b0;
		else if (crcerror_sync1) crcerror_sync <= 1'b1;
		else crcerror_sync <= 1'b0;
	end

	// EMR data is available on positive edge of CRCERROR signal
	emr_unloader_oneshot crcerror_oneshot (.in(is_crcerror), .out(crcerror_pulse), .clk(clk), .reset(reset_wire));
		
	reg emr_clk;
    wire regout;
    
	crcblock_atom emr_atom (
			.inclk(emr_clk),
			.shiftnld(shiftnld),
			.regout(regout),
			.crcerror(crcerror_wire),
			.endofedfullchip(crcerror_endoffullchip) 
		);
	defparam
		emr_atom.device_family = device_family,	
		emr_atom.error_delay_cycles = error_delay_cycles,
		emr_atom.error_clock_divisor = error_clock_divisor;
        
    assign crcerror_pin = crcerror_wire;

	wire emrread_pulse;
	emr_unloader_oneshot emrread_oneshot (.in(emr_read), .out(emrread_pulse), .clk(clk), .reset(reset_wire));
	
	reg [4:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [4:0] next_state;
	localparam STATE_WAIT			= 5'd0;
	localparam STATE_WAIT_HIGH		= 5'd1;
	localparam STATE_WAIT_HIGH_DUMMY= 5'd2;
	localparam STATE_LOAD 			= 5'd3;
	localparam STATE_SHIFTSTART		= 5'd4;
	localparam STATE_CLOCKLOW  		= 5'd5;
	localparam STATE_CLOCKHIGH 		= 5'd6;
	localparam STATE_VALID			= 5'd7;

	reg [emr_reg_width-1:0] emr_reg;
	wire [emr_reg_width-1:0] emr_reg_source;
	reg counter_enable;
	reg counter_set;
	reg [13:0] counter_value;
	wire counter_done;
	reg valid_reg;

	reg pending_read;
	reg pending_read_clear;
	reg complete_read;

	generate
		if (enable_virtual_jtag) begin: emr_enable_virtual_jtag
			emr_source_probe #(.width(emr_reg_width),.instance_id("EMR")) emr_probe (.probe(emr_reg), .source(emr_reg_source));
			emr_source_probe #(.width(1),.instance_id("CRCE")) crc_error_probe (.probe(is_crcerror), .source(inject_error));
		end
		else
		begin
			assign emr_reg_source = {emr_reg_width{1'bX}};
			assign inject_error = 1'b0;
		end
	endgenerate

	// State machine:
	//	  WAIT:        idle state, holds until crcerror pulse
	//	  LOAD:        asserts shiftnld low, holds for counter cycles
	//	  SHIFTSTART:  asserts shiftnld low, shifts first bit
	//	  CLOCKLOW:    emr_clk low
	//	  CLOCKHIGH:   emr_clk high, loops to SHIFTSTART 'emr_reg_width' times, then goes to READY
	//	  VALID:       asserts emr_valid output, holds until next crcerror pulse
	//
	always @(current_state or crcerror_pulse or counter_done or emr_reg or emrread_pulse or pending_read)
		begin
			valid_reg = 1'b0;
			emr_clk = 1'b0;
			counter_set = 1'b0;
			counter_value = 8'b0;
			counter_enable = 1'b0;
			shiftnld = 1'b1;
			next_state = current_state;
			pending_read_clear = 1'b0;
			complete_read = 1'b0;
			case (current_state)
			STATE_WAIT:
				begin
					complete_read = 1'b1;
					counter_set = 1'b1;
					counter_value = shiftnld_delay[13:0];
					if (crcerror_pulse || emrread_pulse || pending_read)
						next_state = STATE_WAIT_HIGH;
				end
			STATE_WAIT_HIGH:
				begin
					counter_enable = 1'b1;
					pending_read_clear = 1'b1;
					if (counter_done)
						next_state = STATE_WAIT_HIGH_DUMMY;
				end
			STATE_WAIT_HIGH_DUMMY:
				begin
					counter_set = 1'b1;
					counter_value = shiftnld_delay[13:0];
						next_state = STATE_LOAD;
				end
			STATE_LOAD:
				begin
					counter_enable = 1'b1;
					shiftnld = 1'b0;
					if (counter_done)
						next_state = STATE_SHIFTSTART;
				end
			STATE_SHIFTSTART:
				begin
					shiftnld = 1'b0;
                    counter_value = {7'b0, emr_reg_width[6:0]} - 14'd1;
					counter_set = 1'b1;
					emr_clk = 1'b1;
					next_state = STATE_CLOCKLOW;
				end
			STATE_CLOCKLOW:
				begin
					counter_enable = 1'b1;
					next_state = STATE_CLOCKHIGH;
				end
			STATE_CLOCKHIGH:
				begin
					emr_clk = 1'b1;
					if (counter_done)
						next_state = STATE_VALID;
					else
						next_state = STATE_CLOCKLOW;
				end
			STATE_VALID:
				begin
					counter_set = 1'b1;
					counter_value = 14'd1;
					valid_reg = 1'b1;
					next_state = STATE_WAIT;
				end
			default:
				begin
					next_state = STATE_WAIT;
				end
			endcase
		end
	
	always @(posedge clk or posedge reset_wire)
	begin
		if (reset_wire)
		begin
			current_state   <= STATE_WAIT;
			emr_reg         <= {emr_reg_width{1'b0}};
		end
		else
		begin
			current_state   <= next_state;
			if (emr_clk && ~inject_error)
				emr_reg[emr_reg_width-1:0]  <= {regout, emr_reg[emr_reg_width-1:1]};
			else if (emr_clk && inject_error)
				emr_reg[emr_reg_width-1:0]  <= emr_reg_source[emr_reg_width-1:0];
		end
	end
	
	reg error_reg;
	always @(posedge reset_wire or posedge clk)
	begin
		if (reset_wire)
			error_reg   <= 1'b0;
		else if (crcerror_pulse || emrread_pulse)
			error_reg   <= pending_read ? 1'b1 : 1'b0;
		else if (crcerror_sync)
			error_reg   <= 1'b0;
	end

	always @(posedge reset_wire or posedge clk)
	begin
		if (reset_wire)
            pending_read    <= 1'b0;
		else if (pending_read_clear)
            pending_read    <= 1'b0;
		else if (crcerror_pulse || emrread_pulse)
            pending_read    <= ~complete_read;
	end

	wire [13:0] counter_q;
	lpm_counter #(.lpm_width(14), .lpm_direction("DOWN")) counter(
		.clock(clk),
		.cnt_en(counter_enable),
		.sload(counter_set),
		.data(counter_value),
		.q(counter_q)
	);
	
	assign counter_done = (counter_q == 14'b0);
	assign emr_valid = valid_reg;
	assign emr_error = error_reg;
	assign emr = emr_reg;
	assign crcerror_core = is_crcerror;
endmodule

module crcblock_atom (
	inclk,
	crcerror,
	regout,
	shiftnld,
	endofedfullchip		
	);
	
	parameter device_family = "Stratix V";
	parameter error_clock_divisor = 2;
	parameter error_delay_cycles = 0;

	input wire inclk;
	input wire shiftnld;
	
	output wire crcerror;
	output wire regout;
	output wire endofedfullchip;		

	generate
		if  ( (device_family == "Arria II GZ") ||
		      (device_family == "Arria II GX") ||
		      (device_family == "Stratix IV") ) begin: generate_crcblock_atom
			stratixiv_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror)
				);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end
		else if (device_family == "Arria V") begin: generate_crcblock_atom
			arriav_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror),
					.endofedfullchip(endofedfullchip) 
				);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end
		else if (device_family == "Cyclone V") begin: generate_crcblock_atom
			cyclonev_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror),
					.endofedfullchip(endofedfullchip) 
				);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end
		else if (device_family == "Stratix V") begin: generate_crcblock_atom
			stratixv_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror),
					.endofedfullchip(endofedfullchip) 
			);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end		
        else if (device_family == "Arria V GZ") begin: generate_crcblock_atom
			arriavgz_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror),
					.endofedfullchip(endofedfullchip) 
			);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end	
		else begin: generate_crcblock_atom
			twentynm_crcblock emr_atom (
					.clk(inclk),
					.shiftnld(shiftnld),
					.regout(regout),
					.crcerror(crcerror),
					.endofedfullchip(endofedfullchip) 
				);
			defparam
				emr_atom.error_delay = error_delay_cycles,
				emr_atom.oscillator_divider = error_clock_divisor;
		end
	endgenerate			

endmodule

module emr_source_probe (
	probe,
	source
	);

	parameter width = 1;
	input [width-1:0] probe;
	output [width-1:0] source;
	
	parameter instance_id = "NONE";

	altsource_probe altsource_probe_component (
							.probe (probe),
							.source (source)
							);
	defparam
	altsource_probe_component.enable_metastability = "NO",
	altsource_probe_component.instance_id = instance_id,
	altsource_probe_component.probe_width = width,
	altsource_probe_component.sld_auto_instance_index = "YES",
	altsource_probe_component.sld_instance_index = 0,
	altsource_probe_component.source_initial_value = "0",
	altsource_probe_component.source_width = width;
endmodule

module emr_unloader_oneshot (
	clk,
	reset,
	in,
	out
	);

	parameter use_posedge = 1;

	input clk;
	input reset;
	input in;
	output out;

	reg last /* synthesis preserve */;
	always @(posedge clk or posedge reset)
	begin
		if (reset)
			last <= 1'b0;
		else
			last <= in;
	end
	generate
		if  (use_posedge) begin: generate_pulse
			// generate pulse on raising edge
			assign out = ~last && in;
		end
		else begin: generate_pulse
			// generate pulse on falling edge
			assign out = ~in && last;
		end
	endgenerate			

	
endmodule

