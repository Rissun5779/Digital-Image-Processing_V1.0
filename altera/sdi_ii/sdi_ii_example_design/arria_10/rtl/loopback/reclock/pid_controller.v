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


module pid_controller (
    input               sys_clk,            // fPLL input clock: 100MHz
    input               sys_clk_rst,        // reset
    input               refclk,             // Rx H sync pulse
    input               rx_locked,          // Rx trs locked
    input               pll_locked,         // pll_locked
    input [31:0]        gain_proportional,  // Kp - the Proportional gain
    input               rx_rate,            // Rx rate
    input               up,
    input               down,
    input               clear,
    input               waitrequest,        // reconfig waitrequest signal
    input [31:0]        readdata,           // reconfig readdata signal  

    output reg [9:0]    address,            // reconfig address signal
    output reg          write,              // reconfig write signal
    output reg [31:0]   writedata,          // reconfig writedata signal
    output reg          read                // reconfig read signal
);

// steady_state_err_threshold
localparam [ 3:0] SS_ERR_THRESHOLD     = 8;
localparam [15:0] SS_CNT_THRESHOLD     = 20000;
localparam [15:0] NON_SS_CNT_THRESHOLD = 200;
localparam [31:0] GAIN_INTEGRAL        = 3;
localparam [31:0] STEADY_STATE_KP      = 100;

parameter [9:0] CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR0_OFST = 10'd301;
parameter [9:0] CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR1_OFST = 10'd302;
parameter [9:0] CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR2_OFST = 10'd303;
parameter [9:0] CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR3_OFST = 10'd304;

parameter [31:0] PLL_DSM_FRACTIONAL_DIVISION_FOR_PAL = 32'd1717986918;
parameter [31:0] PLL_DSM_FRACTIONAL_DIVISION_FOR_NTSC = 32'd1460288881;

//------------------------------------------------------
// Synchronization across different clock domain
//------------------------------------------------------
wire pll_locked_sync;
wire refclk_sync;
wire up_sync;
wire down_sync;
wire clear_sync;
altera_std_synchronizer #(.depth(3)) u_pll_locked_sync  (.clk(sys_clk),.reset_n(1'b1),.din(pll_locked),.dout(pll_locked_sync));
altera_std_synchronizer #(.depth(3)) u_hsync_sync       (.clk(sys_clk),.reset_n(1'b1),.din(refclk),.dout(refclk_sync));
altera_std_synchronizer #(.depth(4)) u_up_sync          (.clk(sys_clk),.reset_n(1'b1),.din(up),.dout(up_sync));
altera_std_synchronizer #(.depth(4)) u_down_sync        (.clk(sys_clk),.reset_n(1'b1),.din(down),.dout(down_sync));
altera_std_synchronizer #(.depth(3)) u_clear_sync       (.clk(sys_clk),.reset_n(1'b1),.din(clear),.dout(clear_sync));

//----------------------------------- 
// Phase and frequency detector (PFD)
//-----------------------------------
// To detect the assertion of H sync signal from Rx
wire rx_h_deassert;
edge_detector #(
    .EDGE_DETECT ("NEGEDGE")
) u_hsync_negedge_det (
    .clk (sys_clk),
    .rst (sys_clk_rst),
    .d (refclk_sync),
    .q (rx_h_deassert)
);

wire clear_deassert;
edge_detector #(
    .EDGE_DETECT ("NEGEDGE")
) u_clear_negedge_det (
    .clk (sys_clk),
    .rst (sys_clk_rst),
    .d (clear_sync),
    .q (clear_deassert)
);

//--------------------------------------------------------
// Check if the system has reached steady-state
// Consecutive large phase errors means non steady-state
// Consecutive very small phase errors means steady-state 
//--------------------------------------------------------
reg steady_state;
reg [31:0] non_steady_state_cnt;
reg [31:0] steady_state_cnt;
reg [15:0] error_cnt;

always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        steady_state <= 1'b0;
        non_steady_state_cnt <= 32'd0;
        steady_state_cnt <= 32'd0;
    end else if (rx_locked & pll_locked_sync) begin
        // Check the phase error during every falling edge of H bit
        if (rx_h_deassert) begin      
            if (error_cnt < SS_ERR_THRESHOLD) begin
                non_steady_state_cnt <= 32'd0;
                if (steady_state_cnt < SS_CNT_THRESHOLD) begin
                    steady_state_cnt <= steady_state_cnt + 32'd1; 
                end
            end else begin
                steady_state_cnt <= 32'd0;
                if (non_steady_state_cnt < NON_SS_CNT_THRESHOLD) begin
                    non_steady_state_cnt <= non_steady_state_cnt + 32'd1; 
                end
            end
        end

        if (steady_state_cnt == SS_CNT_THRESHOLD) begin
            steady_state <= 1'b1;
        end else if (non_steady_state_cnt == NON_SS_CNT_THRESHOLD) begin 
            steady_state <= 1'b0;
        end
    end
end

//---------------------------------------------------
// Count the phase error at H sync rate
// If phase error is zero, no DSM update is required
//---------------------------------------------------
reg [15:0] up_cnt;
reg [15:0] down_cnt;
reg update;
reg update_done;
always @(posedge sys_clk or posedge sys_clk_rst) 
begin
    if (sys_clk_rst) begin
        up_cnt <= 16'd0;
        down_cnt <= 16'd0;
        update <= 1'b0;
        error_cnt <= 16'd0;
    end else begin
        if (update_done) begin
            up_cnt <= 16'd0;
            down_cnt <= 16'd0;
            update <= 1'b0;
            error_cnt <= 16'd0;
        end else if (clear_deassert) begin
            if ((up_cnt > 0) | (down_cnt > 0)) begin
                if (up_cnt != down_cnt) begin
                    update <= 1'b1;
                    // If the refclk is faster than vcoclk
                    if (up_cnt > down_cnt) begin 
                        error_cnt <= up_cnt - down_cnt;
                        // If the refclk is slower than vcoclk
                    end else begin                   
                        error_cnt <= down_cnt - up_cnt;
                    end
                end else begin
                    up_cnt <= 16'd0;
                    down_cnt <= 16'd0;
                    update <= 1'b0;
                    error_cnt <= 16'd0;
                end
            end else begin
                update <= 1'b0;
                error_cnt <= 16'd0;
            end
        end else begin
            if (up_sync) up_cnt <= up_cnt + 16'd1;
            if (down_sync) down_cnt <= down_cnt + 16'd1;
        end
    end
end

///////////////////////////////////////////////////////////////////////////////////////
//-------------------
// State machine
//-------------------
reg [3:0] state;
reg [3:0] next_state;
reg [2:0] num_exec;
reg en_p_calc;
reg en_i_calc;
reg en_compare;
reg [31:0] temp_read;
localparam [3:0] IDLE           = 4'd0;
localparam [3:0] WAIT           = 4'd1; 
localparam [3:0] INIT_COMPARE   = 4'd2; 
localparam [3:0] P_CALCULATE    = 4'd3;
localparam [3:0] I_CALCULATE    = 4'd4;
localparam [3:0] RD             = 4'd5; 
localparam [3:0] MOD            = 4'd6; 
localparam [3:0] WR             = 4'd7; 
localparam [3:0] TRANS          = 4'd8;
localparam [2:0] TOTAL_EXEC     = 3'd6;

always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        num_exec <= TOTAL_EXEC;
    end else begin
        if (next_state == IDLE) begin
            num_exec <= TOTAL_EXEC;
        end else if (next_state == TRANS && num_exec != 3'd0) begin
            num_exec <= num_exec - 2'd1;
        end
    end
end

//***********************************************************************************
//***************************Control State Machine***********************************
// state register
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) 
        state <= IDLE;
    else
        state <= next_state;
end   

// next state logic
always @ (*) 
begin
    case(state)
    IDLE :          begin
                        if (rx_locked & pll_locked_sync & update)
                            next_state = WAIT;
                        else    
                            next_state = IDLE;
                    end

    WAIT :          begin
                        if (waitrequest)
                            next_state = WAIT;
                        else
                            next_state = INIT_COMPARE;
                    end

    INIT_COMPARE :  begin
                        next_state = P_CALCULATE;
                    end

    P_CALCULATE :   begin
                        next_state = I_CALCULATE;
                    end

    I_CALCULATE :   begin
                        next_state = RD;
                    end

    RD :            begin
                        if (waitrequest)
                            next_state = RD;
                        else
                            next_state = MOD;
                    end

    MOD :           begin
                        next_state = WR;
                    end

    WR :            begin
                        if (waitrequest)
                            next_state = WR;
                        else
                            next_state = TRANS;
                    end

    TRANS :         begin
                        if (num_exec == 2'd0)
                            next_state = IDLE;
                        else
                            next_state = RD;
                    end

    default :       next_state = IDLE;
    endcase
end

//********************************************************************************
//*****************Generate DPRIO signals for single XCVR Interface***************
//DPRIO read
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst)
        read  <= 1'b0; 
    else begin
        if(next_state == RD)
            read  <= 1'b1; 
        else
            read  <= 1'b0; 
    end
end

//DPRIO write
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst)
        write  <= 1'b0; 
    else begin
        if(next_state == WR)  
            write  <= 1'b1; 
        else 
            write  <= 1'b0; 
    end
end

reg [31:0] current_frac;
//DPRIO writedata
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst)
        writedata  <= {32{1'b0}}; 
    else begin
        if(next_state == WR) begin
            if (num_exec == 3'd6) begin
                writedata <= {temp_read[31:2],2'd2};
            end else if (num_exec == 3'd5) begin
                writedata <= {temp_read[31:8],current_frac[7:0]};
            end else if (num_exec == 3'd4) begin
                writedata <= {temp_read[31:8],current_frac[15:8]};
            end else if (num_exec == 3'd3) begin
                writedata <= {temp_read[31:8],current_frac[23:16]};
            end else if (num_exec == 3'd2) begin
                writedata <= {temp_read[31:8],current_frac[31:24]};
            end else if (num_exec == 3'd1) begin
                writedata <= {temp_read[31:2],2'd3};
            end
        end	
    end
end

//DPRIO address
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst)
        address  <= {10{1'b0}}; 
    else begin
        if (num_exec == 3'd6) begin
            address <= 10'h0;
        end else if (num_exec == 3'd5) begin
            address <= CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR0_OFST;
        end else if (num_exec == 3'd4) begin
            address <= CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR1_OFST;
        end else if (num_exec == 3'd3) begin
            address <= CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR2_OFST;
        end else if (num_exec == 3'd2) begin
            address <= CMU_FPLL_PLL_DSM_FRACTIONAL_DIVISION_ADDR3_OFST;
        end else if (num_exec == 3'd1) begin
            address <= 10'h0;
        end
    end
end

// Save readata for modification
always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst)
        temp_read  <= 32'b0; 
    else begin
        if (next_state == MOD) begin
            temp_read  <= readdata;
        end
    end
end

always @(posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        en_p_calc  <= 1'b0;
        en_i_calc <= 1'b0;
        en_compare <= 1'b0;
        update_done <= 1'b0;
    end else begin
        if(next_state == INIT_COMPARE)  
            en_compare <= 1'b1;
        else
            en_compare <= 1'b0;

        if(next_state == P_CALCULATE) 
            en_p_calc <= 1'b1;
        else
            en_p_calc <= 1'b0;

        if(next_state == I_CALCULATE) 
            en_i_calc <= 1'b1;
        else
            en_i_calc <= 1'b0;

        if(next_state == TRANS && num_exec == 2'd1) 
            update_done <= 1'b1;
        else
            update_done <= 1'b0;
    end
end

wire [31:0] initial_frac = rx_rate ? PLL_DSM_FRACTIONAL_DIVISION_FOR_NTSC : PLL_DSM_FRACTIONAL_DIVISION_FOR_PAL;

reg [31:0] frac_prop;
reg err_positive;
reg [31:0] err_acc;
reg err_acc_minus;
reg [31:0] integral_mult;

always @(posedge sys_clk or posedge sys_clk_rst) 
begin
    if (sys_clk_rst) begin
        current_frac <= PLL_DSM_FRACTIONAL_DIVISION_FOR_PAL;
        frac_prop <= 32'd0;
        err_positive <= 1'b0;
        err_acc <= 32'd0;
        err_acc_minus <= 1'b0;
        integral_mult <= 32'd0;
    end else begin
        if (en_compare) begin
            if (up_cnt > down_cnt) begin
                if (err_acc_minus) begin
                    if (err_acc < error_cnt) begin
                        err_acc <= error_cnt - err_acc;
                        err_acc_minus <= 1'b0;
                    end else begin
                        err_acc <= err_acc - error_cnt;
                        err_acc_minus <= 1'b1;
                    end
                end else begin
                    err_acc <= err_acc + error_cnt;
                    err_acc_minus <= 1'b0;
                end

                err_positive <= 1'b1;

                // Proportional calculation: P = Kp * e(n)
                if (steady_state) begin
                    frac_prop <= STEADY_STATE_KP[7:0] * error_cnt; 
                end else begin
                    frac_prop <= gain_proportional[12:0] * error_cnt;
                end
            end else if (down_cnt > up_cnt) begin
                if (err_acc_minus) begin
                    err_acc <= err_acc + error_cnt;
                    err_acc_minus <= 1'b1;
                end else begin
                    if (err_acc < error_cnt) begin
                        err_acc <= error_cnt - err_acc;
                        err_acc_minus <= 1'b1;
                    end else begin
                        err_acc <= err_acc - error_cnt;
                        err_acc_minus <= 1'b0;
                    end
                end

                err_positive <= 1'b0;

                // Proportional calculation: P = Kp * e(n)
                if (steady_state) begin
                    frac_prop <= STEADY_STATE_KP[7:0] * error_cnt; 
                end else begin
                    frac_prop <= gain_proportional[12:0] * error_cnt;
                end
            end 
        end

        if (en_p_calc) begin
            // if refclk is faster than vcoclk
            if (err_positive) begin
                current_frac <= initial_frac + frac_prop;
            end else begin 
                current_frac <= initial_frac - frac_prop;
            end
            // Integral calculation: I = Ki * accumulation of errors
            integral_mult <= err_acc * GAIN_INTEGRAL[3:0];
        end

        if (en_i_calc) begin
            if (err_acc_minus) begin
                current_frac <= current_frac - integral_mult;
            end else begin 
                current_frac <= current_frac + integral_mult;
            end
        end
    end
end

endmodule
