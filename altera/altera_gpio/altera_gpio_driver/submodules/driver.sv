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


`timescale 1 ps / 1 ps

module driver(
	ck_fr,
	ck_hr,
	reset_n,
	data_oe_out,
	data_out,
	data_in,
	data_write,
	data_read,
	side_out,
	side_in,
	side_write,
	side_read,
	pad,
	aclr,
	aset,
	sclr,
	sset,
	cke
);
	parameter SIZE = 4;
	parameter RATE = 1;
	parameter WRITE_LATENCY = 0;
	parameter READ_LATENCY = 0;
	parameter TEST_MODE = "output";
	parameter BUS_WIDTH = 0;
	parameter USE_GND_VCC = "FALSE";
	parameter [SIZE*RATE-1:0] GND_VCC_BUS = 0;
	parameter OPEN_DRAIN = "false";
	parameter BUS_HOLD = "false";

	parameter ENABLE_OE = "false";

	localparam DUT_DATA_SIZE = SIZE * RATE;
	localparam DUT_OE_SIZE = (RATE == 4) ? SIZE * 2 : SIZE;
	localparam BUFFER_ADDRESS_SIZE = 5;

	//reset test parameters
	parameter TREF = 5000; //still dont know what this is.
	parameter ARESET_MODE = "none"; //none, clear, preset
	parameter SRESET_MODE = "none"; //none, clear, preset
	parameter ENABLE_CKE = "false";

	//Confirm whether reset tests are needed.
	localparam BOGUS_TEST = (ARESET_MODE == "none" && SRESET_MODE == "none" && ENABLE_CKE == "false");

	//reset test local params
	localparam ACLR_ACTIVE_VALUE = 1'b1;
	localparam SCLR_ACTIVE_VALUE = 1'b1;

	localparam ARESET_VALUE = (ARESET_MODE == "preset") ? 1'b1: 1'b0;
	localparam SRESET_VALUE = (SRESET_MODE == "preset") ? 1'b1: 1'b0; 

	localparam CHECK_DATA = 1'b0;
	localparam CHECK_PAD = 1'b1;


	// Clock / Reset interface
	input ck_fr;
	input ck_hr;
	input reset_n;

	// Dut interface
	output reg [DUT_OE_SIZE - 1 : 0] data_oe_out;
	output reg [DUT_DATA_SIZE - 1 : 0] data_out;
	input [DUT_DATA_SIZE - 1 : 0] data_in;
	output data_write;
	output reg data_read;

	// Side interface
	output reg [DUT_DATA_SIZE - 1 : 0] side_out;
	input [DUT_DATA_SIZE - 1 : 0] side_in;
	output reg side_write;
	output reg side_read;
    inout [SIZE - 1:0] pad;

    // Reset test interface
	output reg aclr;
	output reg aset;
	output reg sclr;
	output reg sset;
	output reg cke;

	reg [SIZE-1: 0] pad_internal;
	reg drive_pad;

	// GPIO input pad drive selector
	assign #1 pad = (drive_pad) ? pad_internal : {SIZE{1'bz}}; 

	reg data_write_int;

	reg [DUT_DATA_SIZE - 1 : 0] data;

	reg [DUT_DATA_SIZE - 1 : 0] buffer [0:(1 << BUFFER_ADDRESS_SIZE)];
	reg [BUFFER_ADDRESS_SIZE - 1 : 0] buffer_read_address;
	reg [BUFFER_ADDRESS_SIZE - 1 : 0] buffer_write_address;

	reg [DUT_DATA_SIZE - 1 : 0] random_data;

	wire ck_dut = (RATE == 1 || RATE == 2) ? ck_fr : ck_hr;
	wire ck_side = ck_fr;

	wire [DUT_DATA_SIZE-1:0] gnd_mask;
	wire [DUT_DATA_SIZE-1:0] vcc_mask;
	// Assign "random" gnds and vccs
	genvar i;
	generate
		for (i = 0; i < DUT_DATA_SIZE; i++) begin : gnd_vcc_loop
			if (USE_GND_VCC == "TRUE" && GND_VCC_BUS[i] == 1) begin
				assign gnd_mask[i] = (i%2);
				assign vcc_mask[i] = (i%2);
			end else begin
				assign gnd_mask[i] = 1;
				assign vcc_mask[i] = 0;
			end
		end
	endgenerate

	// Main Operation Sequence
	generate

		initial begin: test_main

            // Part I: Verify Combinational Signal Flow
			data <= 0;
			data_oe_out <= 0;
			data_out <= 0;
			data_write_int <= 0;
			data_read <= 0;
			side_out <= 0;
			side_write <= 0;
			side_read <= 0;
			buffer_write_address <= 0;
			cke <=1'b1;
			drive_pad <= 0;
			pad_internal <= 0;

			aclr <= ~ACLR_ACTIVE_VALUE;
			aset <= ~ACLR_ACTIVE_VALUE;
			sclr <= ~SCLR_ACTIVE_VALUE;
			sset <= ~SCLR_ACTIVE_VALUE;
			
			sleep(5);

			if(TEST_MODE == "output") begin
				sleep(5);
				write_burst_to_dut(4);
				sleep(5);
				read_burst_from_side(4);
				sleep(5);
				write_burst_to_side(2);
				sleep(5);
				read_burst_from_side(2);
			end
			else if(TEST_MODE == "input") begin
				sleep(5);
				write_burst_to_side(8);
				sleep(5);
				read_burst_from_dut(3);
				sleep(5);
				read_burst_from_side(2);
			end
			else begin // TEST_MODE == "bidir"
				sleep(5);
				write_burst_to_dut(4);
				sleep(5);
				read_burst_from_dut(3);
				sleep(5);
				write_burst_to_dut(3);
				sleep(5);
				read_burst_from_dut(4);
			end
	
			// Wait for transients to complete.
			sleep(20);
            // ========End of Part I:==========



            // Part II: Check Reset Signals Functionality
            if(~BOGUS_TEST) begin: test_reset
            data_oe_out <= 0;
            data_out <= 0;
            data_write_int <= 0;
            aclr <= ~ACLR_ACTIVE_VALUE;
            sset <= ~ACLR_ACTIVE_VALUE;
            sclr <= ~SCLR_ACTIVE_VALUE;
            sset <= ~SCLR_ACTIVE_VALUE;
            cke <=1'b1;
            drive_pad <=0;
            pad_internal <=0;
             
            //Output Test
            if(TEST_MODE == "output" || TEST_MODE == "bidir") begin
                release_pad_control();

                //Check areset
                if(ARESET_MODE == "clear" || ARESET_MODE == "preset") begin
                    set_data_value(~ARESET_VALUE);
                    sleep(20);
                    assert_aclr_and_check(CHECK_PAD, ARESET_VALUE);
                    sleep(20);
                end

                //Check sreset
                if(SRESET_MODE == "clear" || SRESET_MODE == "preset") begin
                    set_data_value(~SRESET_VALUE);
                    sleep(20);
                    assert_sclr_and_check(CHECK_PAD, SRESET_VALUE);
                end

                // Check CKE
                if(ENABLE_CKE == "true") begin
                    deassert_cke_and_check(CHECK_PAD);
                end
            end

            sleep(20);

            //Input Test
            if(TEST_MODE =="input" || TEST_MODE == "bidir") begin
                take_pad_control();

                // Check areset
                if(ARESET_MODE == "clear" || ARESET_MODE == "preset") begin
                    set_pad_value(~ARESET_VALUE);
                    sleep(20);
                    assert_aclr_and_check(CHECK_DATA,ARESET_VALUE);
                    sleep(20);
                end

                // Check sreset
                if(SRESET_MODE == "clear" || SRESET_MODE == "preset") begin
                    set_pad_value(~SRESET_VALUE);
                    sleep(20);
                    assert_sclr_and_check(CHECK_DATA, SRESET_VALUE);
                end

                // Check CKE
                if(ENABLE_CKE == "true") begin
                    deassert_cke_and_check(CHECK_DATA);
                end
            end

            // Add some additional time-intervals to give margin on waveform
            sleep(20);

            end 
            //=========End of Part II:=================

	    set_data_value(1'b0);
	    sleep(20);



            // Report total success and failures accumulated
			print_report_and_finish;
	end
	endgenerate

	// Data Read Latency
	wire data_read_int;
	latency_block #(
		.LATENCY(READ_LATENCY)
	) latency_block_data_read (
		.clk(ck_fr),
		.reset_n(reset_n),
		.D(data_read),
		.Y(data_read_int)
	);

	// Data Write Latency
	latency_block #(
		.LATENCY(WRITE_LATENCY)
	) latency_block_data_write (
		.clk(ck_fr),
		.reset_n(reset_n),
		.D(data_write_int),
		.Y(data_write)
	);

	// Random data generation
	always @(posedge ck_fr) begin
		random_data <= $random;
	end

	// Check Process for Part I
	wire read_enable = (side_read | data_read_int);
	reg [DUT_DATA_SIZE - 1 : 0] data_received;
	reg [DUT_DATA_SIZE - 1 : 0] data_expected;
	reg perform_read_check;
	always @(posedge ck_fr or negedge reset_n) begin
		if(~reset_n) begin
			perform_read_check <= 1'b0;
			buffer_read_address <= 0;
		end
		else begin
			if(read_enable) begin
				data_received <= (side_read) ? side_in : data_in;
				data_expected <= buffer[buffer_read_address];
				perform_read_check <= 1'b1;
				// In HR during DUT read, we need to increment the address
				// only half the time
				if(data_read_int && (RATE == 4)) begin
					#1;
					if(~ck_hr) begin
						buffer_read_address <= buffer_read_address + 1;
					end
				end
				else begin
					buffer_read_address <= buffer_read_address + 1;
				end
			end
			else begin
				perform_read_check <= 1'b0;
			end
		end
	end

	reg [31:0] data_correct;
	reg [31:0] data_wrong;
	always @(posedge ck_fr or negedge reset_n) begin
		if(~reset_n) begin
			data_correct <= 0;
			data_wrong <= 0;
		end
		else begin
			if(perform_read_check) begin
				if(data_received == data_expected) begin
					data_correct <= data_correct + 1;
				end
				else begin
					data_wrong <= data_wrong + 1;
				end
			end
		end
	end

	// TASK: sleep
	task sleep(reg [7:0] cycles);
		repeat(cycles) begin
			@(posedge ck_fr);
		end
	endtask
	
	// TASK: write_burst_to_dut
	task write_burst_to_dut(reg [7:0] burst_size);
		repeat(burst_size) begin
			@(posedge ck_dut) begin
				// This can be randomized later on
				data_oe_out <= {DUT_OE_SIZE{1'b1}};
				data_out <= random_data;
				data_write_int <= 1'b1;
				buffer[buffer_write_address] <= ((random_data & gnd_mask) | vcc_mask);
				buffer_write_address <= buffer_write_address + 1;
			end
		end
		@(posedge ck_dut) begin
			data_write_int <= 1'b0;
			data_oe_out <= {DUT_OE_SIZE{1'b0}};
		end
    endtask

	// TASK: read_burst_from_dut
	task read_burst_from_dut(reg [7:0] burst_size);
		repeat(burst_size) begin
			@(posedge ck_dut) begin
				data_read <= 1'b1;
			end
		end
		@(posedge ck_dut) begin
			data_read <= 1'b0;
		end
    endtask

	// TASK: write_burst_to_side
	task write_burst_to_side(reg [7:0] burst_size);
		repeat(burst_size) begin
			@(posedge ck_side) begin
				side_out <= random_data;
				side_write <= 1'b1;
				buffer[buffer_write_address] <= random_data;
				buffer_write_address <= buffer_write_address + 1;
			end
		end
		@(posedge ck_side) begin
			side_write <= 1'b0;
		end
    endtask

	// TASK: read_burst_from_side
	task read_burst_from_side(reg [7:0] burst_size);
		repeat(burst_size) begin
			@(posedge ck_side) begin
				side_read <= 1'b1;
			end
		end
		@(posedge ck_side) begin
			side_read <= 1'b0;
		end
    endtask


    // TASK: take_pad_control
    task take_pad_control;
            data_oe_out <= {DUT_OE_SIZE{1'b0}};
            drive_pad <= 1;
    endtask        

    // TASK: release_pad_control
    task release_pad_control;
            data_oe_out <= {DUT_OE_SIZE{1'b1}};
            drive_pad <= 0;
    endtask

    // TASK: set_data_value
    task set_data_value(reg value);
        @(posedge ck_dut);
            data_out <= {DUT_DATA_SIZE{value}};
    endtask

    // TASK: set_pad_value
    task set_pad_value(reg value);
        @(posedge ck_dut);
            pad_internal <= {SIZE{value}};
    endtask        

    // TASK: assert_aclr_and_check 
    task assert_aclr_and_check(reg check_what, reg value);
        @(posedge ck_dut);
            // make this "asynchronous"
            #(TREF * 0.123)
                aclr <= ACLR_ACTIVE_VALUE;
                aset <= ACLR_ACTIVE_VALUE;
        fork
            begin
                // This is an asynchronous reset: check right away (give it
                // some time to settle in case the sim model has some delay)
                #(TREF)
                    check(check_what,ARESET_VALUE);
            end
            begin
                repeat(3)
                    @(posedge ck_dut);
                // Make this "asynchronous" randomly write values, output
                // should not change
                
                #(TREF * 0.123)
                    aclr <= ~ACLR_ACTIVE_VALUE;
                    aset <= ~ACLR_ACTIVE_VALUE;
            end
        join
    endtask   

    // TASK: assert_sclr_and_check
    task assert_sclr_and_check(reg check_what, reg value);
        @(posedge ck_dut);
            sclr <= SCLR_ACTIVE_VALUE;
            sset <= SCLR_ACTIVE_VALUE;
        fork
            begin
                repeat(3)
                    @(posedge ck_dut);
                sclr <= ~SCLR_ACTIVE_VALUE;
                sset <= ~SCLR_ACTIVE_VALUE;
            end
            begin
                // This is a synchronous reset: wait for a couple clocks to
                // give it time to propagate to the output in all cases plus
                // some time to settle in case the sim model has some delay)
                repeat(2)
                    @(posedge ck_dut);
                    #(TREF * 0.1)
                        check(check_what, SRESET_VALUE);
            end
        join

    endtask

    
    // TASK: deassert_cke_and_check
    task deassert_cke_and_check(reg check_what);
        @(posedge ck_dut);

        if (check_what == CHECK_DATA) begin
            set_pad_value(1'b1);
        end
        else begin
            set_data_value(1'b1);
        end

        sleep(3);
        cke <= 1'b0;
        repeat(3)
            @(posedge ck_dut);

        if(check_what == CHECK_DATA) begin
            set_pad_value(1'b0);
        end
        else begin
            set_data_value(1'b0);
        end 

        repeat(3)
            @(posedge ck_dut);
        check(check_what, 1'b1);
        repeat(3)
            @(posedge ck_dut);
        cke <= 1'b1;
    endtask
   

    // Check Process for Part II
    task check(reg check_what, reg value);
        reg [SIZE -1 : 0] expected_value;
        if(check_what == CHECK_DATA) begin
            expected_value = data_in;
        end
        else begin
            expected_value = pad;
        end
        if(expected_value == {SIZE{value}}) begin
            data_correct <= data_correct + 1;
        end
        else begin
            $display("Error @ %t", $time);
            //TBD Print statement below appears to be flipped.
            $display("    Expected: $h ", expected_value);
            $display("    Detected: $h ", {SIZE{value}});
            data_wrong <= data_wrong + 1;
        end
    endtask

    
	// TASK: print_report_and_finish
	task print_report_and_finish;
        if(BOGUS_TEST) begin
            $display("");
            $display("NO NEED TO TEST RESET SIGNALS");
            $display("");
        end
		if((data_correct > 0) && (data_wrong == 0)) begin
			$display("");
			$display("SIMULATION COMPLETED: SUCCESS ! ! !");
			$display("");
		end
		else begin
			$display("");
			$display("SIMULATION COMPLETED: FAILED ! ! !");
			$display("");
		end
		$display("Stats:");
		$display("   Correct Data: %d", data_correct);
		$display("   Wrong Data: %d", data_wrong);

		$finish;
	endtask
endmodule

module latency_block(
	clk,
	reset_n,
	D,
	Y
);

	input clk;
	input reset_n;
	input D;
	output Y;

	parameter LATENCY = 0;

	genvar i;
	generate
		begin
			if(LATENCY == 0) begin
				assign Y = D;
			end
			else if(LATENCY == 1) begin
				reg stage;
				always @(posedge clk or negedge reset_n) begin
					if(~reset_n) begin
						stage <= 1'b0;
					end
					else begin
						stage <= D;		
					end
				end
				assign Y = stage;
			end
			else begin
				reg stages[LATENCY - 1 : 0];
				for(i = 0; i < LATENCY - 1; i = i + 1) 
				begin : latency_loop
					always @(posedge clk or negedge reset_n) begin
						if(~reset_n) begin
							stages[i] <= 1'b0;
						end
						else begin
							stages[i] <= stages[i + 1];
						end
					end
				end
				always @(posedge clk or negedge reset_n) begin
					if(~reset_n) begin
						stages[LATENCY - 1] <= 1'b0;
					end
					else begin
						stages[LATENCY - 1] <= D;
					end
				end
				assign Y = stages[0];
			end
		end
	endgenerate

endmodule

