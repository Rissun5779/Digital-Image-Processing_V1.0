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


// $Id: //acds/rel/18.1std/ip/altera_voltage_sensor/control/voltage_sensor_avalon_control.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $
// +----------------------------------------------------------------------
// | Altera Voltage Sensor Controller: 
// | Avalon interface to voltage sensor signals 
// +----------------------------------------------------------------------
`timescale 1 ps / 1 ps

module voltage_sensor_avalon_control
   (
    // Clock and reset
    input             clk,
    input             reset,

    // CSR interface: Avalon MM
    input             addr,
    input             read,
    input             write,
    input [31:0]      writedata,
    output reg [31:0] readdata,

    // Response interface: Avalon ST
    output reg        rsp_valid,
    output reg [2:0]  rsp_channel,
    output reg [5:0]  rsp_data,
    output reg        rsp_sop,
    output reg        rsp_eop,

    // Signals to/from the voltage sensor block
    output reg        vs_corectl,
    output reg        vs_reset,
    output reg        vs_coreconfig,
    output reg        vs_confin,
    output reg [3:0]  vs_chsel,
    input             vs_eoc,
    input             vs_eos,
    input [3:0]       vs_muxsel,
    input [11:0]      vs_dataout
);

    //+---------------------------------------------------------
    //| Internal signals
    //+---------------------------------------------------------
    wire          valid_addr;
    wire          wr;
    wire          rd;
    wire          valid_wr;
    reg [1:0]     conv_mode;
    wire [1:0]    conv_mode_wire;
    wire          single_mode;
    wire          repeat_mode;
    wire          valid_mode;
    reg           conv_run;
    reg           clr_run;
    reg           sw_clr_run;
    wire          run_bit;
    wire          done_single_conv;
    wire          done_repeat_conv;
    wire          done_conv;
    // VS configuration register field
    wire [1:0]    sequence_sel_wire;
    wire [2:0]    chsel_wire;
    wire [1:0]    bu_wire;
    wire          cal_wire;
    reg [1:0]     sequence_sel;
    reg [1:0]     bu;
    reg           cal;

    reg           vs_eoc_pipe1;
    reg           vs_eos_pipe1;
    reg [3:0]     vs_muxsel_pipe1;
    reg [11:0]    vs_dataout_pipe1;
    reg           vs_eoc_pipe2;
    reg           vs_eos_pipe2;
    reg [3:0]     vs_muxsel_pipe2;
    reg [11:0]    vs_dataout_pipe2;

    //+---------------------------------------------------------
    //| Address and command decode
    //+---------------------------------------------------------  
    assign valid_addr         = (addr == '0);
    assign wr                 = valid_addr & write;
    assign rd                 = valid_addr & read;
    // valid wr when the ID does not operate
    assign valid_wr           = wr & !conv_run;
    // Read fields in command register
    assign run_bit            = writedata[0];
    assign conv_mode_wire     = writedata[2:1];
    assign chsel_wire         = writedata[6:4];
    assign sequence_sel_wire  = writedata[9:8];
    assign bu_wire            = writedata[11:10];
    assign cal_wire           = writedata[12];
   
    // Register values that need to send to the core
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            conv_mode    <= '0;
            sequence_sel <= '0;
            bu           <= '0;
            cal          <= '0;
            vs_chsel     <= '0;
        end
        else begin
            if (valid_wr) begin
                conv_mode    <= conv_mode_wire;
                sequence_sel <= sequence_sel_wire;
                bu           <= bu_wire;
                cal          <= cal_wire;
                vs_chsel     <= {1'b0, chsel_wire};
            end
        end // else: !if(reset)
    end // always_ff @

    // Conversion mode
    assign single_mode       = (conv_mode == 2'b00);
    assign repeat_mode       = (conv_mode == 2'b01);
    assign valid_mode        = single_mode | repeat_mode;

    // Use rsp_oep to indicate end of conversion to have one
    // more cycle buffer after conversion is done.
    assign done_single_conv  = single_mode & rsp_eop;
    assign done_repeat_conv  = repeat_mode & rsp_eop & sw_clr_run;
    assign done_conv         = done_single_conv | done_repeat_conv;
    //+---------------------------------------------------------
    //| Run bit logic
    //+---------------------------------------------------------    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            conv_run <= '0;
        else begin
            if (clr_run)
                conv_run <= '0;
            else if (valid_wr & run_bit)
                conv_run <= '1;
        end
    end // always_ff @
    
    //+---------------------------------------------------------
    //| Software clear run bit 
    //+---------------------------------------------------------    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            sw_clr_run <= '0;
        else begin
            if (clr_run)
                sw_clr_run <= '0;
            else if (repeat_mode & conv_run & wr & !run_bit)
                sw_clr_run <= '1;
        end
    end
    
    //+---------------------------------------------------------
    //| Avalon ST register output
    //+---------------------------------------------------------
    //| sop signal: trigger when first channel of sequence detected
    reg rsp_sop_internal;
    always_comb begin
        case(sequence_sel)
            2'b00: begin // channel 2 -> 7
                if (vs_muxsel_pipe2[2:0] == 3'b010)
                    rsp_sop_internal  = 1'b1;
                else
                    rsp_sop_internal  = 1'b0;
            end
            2'b11: begin // single channel, packet with one beat, sop and eop both 1
                rsp_sop_internal  = 1'b1;
            end
            default: begin // channel 0 - 1, 0 - 7, set sop when seeing channel 0
                if (vs_muxsel_pipe2[2:0] == 3'b000)
                    rsp_sop_internal  = 1'b1;
                else
                    rsp_sop_internal  = 1'b0;
            end
        endcase // case (sequence_sel)
    end
    
    // case:331644 - Additional Cycle Latency for VADC conversion capture
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            vs_eoc_pipe1     <= '0;
            vs_eos_pipe1     <= '0;
            vs_muxsel_pipe1  <= '0;
            vs_dataout_pipe1 <= '0;
            vs_eoc_pipe2     <= '0;
            vs_eos_pipe2     <= '0;
            vs_muxsel_pipe2  <= '0;
            vs_dataout_pipe2 <= '0;
        end
        else begin
            vs_eoc_pipe1     <= vs_eoc;
            vs_eos_pipe1     <= vs_eos;
            vs_muxsel_pipe1  <= vs_muxsel;
            vs_dataout_pipe1 <= vs_dataout;
            vs_eoc_pipe2     <= vs_eoc_pipe1;
            vs_eos_pipe2     <= vs_eos_pipe1;
            vs_muxsel_pipe2  <= vs_muxsel_pipe1;
            vs_dataout_pipe2 <= vs_dataout_pipe1;
        end // else: !if(reset)
    end // always_ff @


    // flop output signals, the valid data will appear one cycle
    // after eoc/eos trigger.
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rsp_valid   <= '0;
            rsp_channel <= '0;
            rsp_sop     <= '0;
            rsp_eop     <= '0;
            rsp_data    <= '0;
        end
        else begin
            rsp_valid   <= vs_eoc_pipe2;
            rsp_channel <= vs_muxsel_pipe2[2:0];
            rsp_sop     <= rsp_sop_internal;
            rsp_eop     <= vs_eos_pipe2;
            rsp_data    <= vs_dataout_pipe2[11:6];
        end // else: !if(reset)
    end // always_ff @

    //+---------------------------------------------------------
    
    //+---------------------------------------------------------
    //| Read CSR status
    //+---------------------------------------------------------
    reg [31:0] readdata_internal;
    always_comb begin
        if (rd)
            readdata_internal  = {18'h0, cal, bu, sequence_sel, 1'b0, vs_chsel[2:0], 1'b0, conv_mode ,conv_run};
        else
            readdata_internal = '0;
    end
        
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            readdata <= '0;
        end
        else begin
            readdata <= readdata_internal;
        end
    end
    //|
    //+---------------------------------------------------------
    
    //+---------------------------------------------------------
    //| Voltage sensor state machine
    //+---------------------------------------------------------
    //|
    
    typedef enum bit [4:0]
    {
     ST_IDLE          = 5'b00001,
     ST_CORECTL_SETUP = 5'b00010,
     ST_RESET_SETUP   = 5'b00100,
     ST_CONFIN_SHIFT  = 5'b01000,
     ST_CAPTURE_DATA  = 5'b10000
     } t_state;

    t_state state, next_state;
    
    // Internal signals for state machine
    reg counter_en;
    reg counter_done;
    reg [4:0] cylce_value;
    
    // | State machine: updates state
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            state <= ST_IDLE;
        else
            state <= next_state;
    end
    // | State machine: next state conditions
    always_comb begin
        next_state = ST_IDLE;
        case (state)
            ST_IDLE: begin
                if (conv_run & valid_mode)
                    next_state  = ST_CORECTL_SETUP;
                else
                    next_state  = ST_IDLE;
            end
            ST_CORECTL_SETUP: begin
                if (counter_done)
                    next_state  = ST_RESET_SETUP;
                else
                    next_state  = ST_CORECTL_SETUP;
            end
            ST_RESET_SETUP: begin
                if (counter_done)
                    next_state  = ST_CONFIN_SHIFT;
                else
                    next_state = ST_RESET_SETUP;
            end
            ST_CONFIN_SHIFT: begin
                if (counter_done)
                    next_state  = ST_CAPTURE_DATA;
                else
                    next_state = ST_CONFIN_SHIFT;
            end
            ST_CAPTURE_DATA: begin
                if (done_conv)
                    next_state  = ST_IDLE;
                else
                    next_state = ST_CAPTURE_DATA;
            end
        endcase
    end // always_comb
    
    // | State machine: state outputs
    always_comb begin
        case (state)
            ST_IDLE: begin
                clr_run        = '0;
                counter_en     = '0;
                cylce_value    = '0;
                vs_reset       = '1;
                vs_corectl     = '0;
                vs_coreconfig  = '0;
            end
            ST_CORECTL_SETUP: begin
                clr_run        = '0;
                counter_en     = '1;
                cylce_value    = 5'd5;
                vs_reset       = '1;
                vs_corectl     = '1;
                vs_coreconfig  = '0;
            end
            ST_RESET_SETUP: begin
                clr_run        = '0;
                counter_en     = '1;
                cylce_value    = 5'd5;
                vs_reset       = '0;
                vs_corectl     = '1;
                vs_coreconfig  = '0;
            end
            ST_CONFIN_SHIFT: begin
                clr_run        = '0;
                counter_en     = '1;
                cylce_value    = 5'd7;
                vs_reset       = '0;
                vs_corectl     = '1;
                vs_coreconfig  = '1;
            end
            ST_CAPTURE_DATA: begin
                if (done_conv)
                    clr_run  = '1;
                else
                    clr_run    = '0;
                counter_en     = '1;
                cylce_value    = 5'd21;
                vs_reset       = '0;
                vs_corectl     = '1;
                vs_coreconfig  = '0;
            end
            default: begin
                clr_run        = '0;
                counter_en     = '0;
                cylce_value    = '0;
                vs_reset       = '1;
                vs_corectl     = '0;
                vs_coreconfig  = '0;
            end
        endcase // case (state)
    end // always_comb
    
    // counter
    reg [4:0] counter_value;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            counter_value <= '0;
        else begin
            if (counter_en) begin
                counter_value     <= counter_value + 5'h1;
                if (counter_done) begin
                    counter_value <= '0;
                end
            end
            else 
                counter_value <= '0;
        end // else: !if(reset)
    end // always_ff @

    always_comb begin
        counter_done  = (counter_value == cylce_value);
    end
    //|
    //+---------------------------------------------------------
    //+---------------------------------------------------------
    //| Voltage sensor configuration logic
    //+---------------------------------------------------------
    reg [7:0] confin_reg;
    reg [7:0] confin_shift;
    always_comb begin
        confin_reg  = {1'b0, cal, 2'b00, bu, sequence_sel};
        // just make the waveform look nice by set 0 when not in used
		if (state == ST_CONFIN_SHIFT)
			vs_confin   = confin_shift[0];
		else
			vs_confin = '0;
    end
    // shift config register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            confin_shift <= '0;
        else begin
            if (state == ST_CONFIN_SHIFT)
                confin_shift[6:0] <= confin_shift[7:1];
            else 
                confin_shift <= confin_reg;
        end
    end // always_ff @

endmodule
