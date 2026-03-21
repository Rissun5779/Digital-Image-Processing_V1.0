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


module mr_tx_pll_compare_av #(
    parameter [3:0] TX_PLL_DEFAULT_RANGE = 1
) (
    input  wire        clock,
    input  wire        reset,
    input  wire        clr_valid,
    input  wire [23:0] measure,
    input  wire        measure_valid,
    output wire [3:0]  range,
    output wire        range_valid,
    output wire [1:0]  lpfd,
    output wire [2:0]  isel,
    output wire [1:0]  pfd_bwctrl,
    output wire [2:0]  icp_high,
    output wire [2:0]  rgla_isel,
    output wire        pcie_mode_sel			  
);

localparam [23:0]
    TX_PLL_THRESHOLD_0 =  380000,
    TX_PLL_THRESHOLD_1 =  610000,
    TX_PLL_THRESHOLD_2 =  900000,
    TX_PLL_THRESHOLD_3 = 1900000,
    TX_PLL_THRESHOLD_4 = 3750000;

localparam [3:0]
    TX_PLL_PIX_RATE_LESS_THAN_38MHZ_OR_190MHZ = 0,
    TX_PLL_PIX_RATE_LESS_THAN_61MHZ_OR_375MHZ = 1,
    TX_PLL_PIX_RATE_LESS_THAN_90MHZ           = 2;

localparam [3:0]
    TX_PLL_LOOPS_MAX = 4;

reg        current_state, next_state;
reg        inc_loops;
reg        clr_loops;
reg [3:0]  loops;
reg [23:0] threshold;
reg [3:0]  range_r1, range_r2;
reg [1:0]  lpfd_r1, lpfd_r2;
reg [2:0]  isel_r1, isel_r2;
reg [1:0]  pfd_bwctrl_r1, pfd_bwctrl_r2;
reg [2:0]  icp_high_r1, icp_high_r2;
reg [2:0]  rgla_isel_r1, rgla_isel_r2;
reg        pcie_mode_sel_r1, pcie_mode_sel_r2; 
reg        set_valid;
reg        range_valid_r2;
wire       match;
wire       loops_max;

// Simple FSM to sequentially compare against the predefined thresholds
always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        current_state <= 1'b0;    
    end else begin
        current_state <= next_state;
    end  
end

always @ (*)
begin
    next_state = current_state;
    clr_loops = 1'b0;
    inc_loops = 1'b0;
    set_valid = 1'b0;
      
    case (current_state)
        0: begin
            clr_loops = 1'b1;
            if (measure_valid) begin
                next_state = 1'b1;
            end        
        end
        
        1: begin
            inc_loops = 1'b1;
            if (match | loops_max) begin
               set_valid = 1'b1;
               clr_loops = 1'b1;
               next_state = 1'b0;
            end                         
        end

        default: begin
            next_state = 1'b0;
            clr_loops = 1'b1;
            inc_loops = 1'b0;
            set_valid = 1'b0;
        end      
    endcase  
end

always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        loops <= 4'd0;  
    end else begin
        if (clr_loops) begin
            loops <= 4'd0;
        end else if (inc_loops) begin
            loops <= loops + 4'd1;
        end 
    end
end

// Combinatorial mux that define the TX PLL range for respective clock measure result
always @ (loops)
begin
    case (loops)
        0: begin // <38MHz
            threshold = TX_PLL_THRESHOLD_0; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_38MHZ_OR_190MHZ; // 0
            lpfd_r1 = 2'b10;
            isel_r1 = 3'b100;
            pfd_bwctrl_r1 = 2'b01;
            icp_high_r1 = 3'b001;
            rgla_isel_r1 = 3'b100;
            pcie_mode_sel_r1 = 1'b0; 
        end
      
        1: begin // <61MHz
            threshold = TX_PLL_THRESHOLD_1; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_61MHZ_OR_375MHZ; // 1
            lpfd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pfd_bwctrl_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            rgla_isel_r1 = 3'b000;
            pcie_mode_sel_r1 = 1'b1; 
        end
      
        2: begin // <90MHz
            threshold = TX_PLL_THRESHOLD_2; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_90MHZ; // 2
            lpfd_r1 = 2'b11;
            isel_r1 = 3'b011;
            pfd_bwctrl_r1 = 2'b10;
            icp_high_r1 = 3'b001;
            rgla_isel_r1 = 3'b100;
            pcie_mode_sel_r1 = 1'b0; 
        end
      
        3: begin // <190MHz
            threshold = TX_PLL_THRESHOLD_3; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_38MHZ_OR_190MHZ; // 0
            lpfd_r1 = 2'b10;
            isel_r1 = 3'b100;
            pfd_bwctrl_r1 = 2'b01;
            icp_high_r1 = 3'b001;
            rgla_isel_r1 = 3'b100;
            pcie_mode_sel_r1 = 1'b0;  
        end
       
        4: begin // <375MHz
            threshold = TX_PLL_THRESHOLD_4; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_61MHZ_OR_375MHZ; // 1
            lpfd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pfd_bwctrl_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            rgla_isel_r1 = 3'b000;
            pcie_mode_sel_r1 = 1'b1; 
        end
                              
        default: begin 
            threshold = TX_PLL_THRESHOLD_4; 
            range_r1 = TX_PLL_PIX_RATE_LESS_THAN_61MHZ_OR_375MHZ; // 1
            lpfd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pfd_bwctrl_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            rgla_isel_r1 = 3'b000;
            pcie_mode_sel_r1 = 1'b1; 
        end
    endcase
end

assign match = measure < threshold;
assign loops_max = loops == TX_PLL_LOOPS_MAX;

// Outputs
always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        range_valid_r2 <= 1'b0;
        range_r2 <= TX_PLL_DEFAULT_RANGE; // 1
        lpfd_r2 <= 2'b01;
        isel_r2 <= 3'b100;
        pfd_bwctrl_r2 <= 2'b00;
        icp_high_r2 <= 3'b000;
        rgla_isel_r2 <= 3'b000;
        pcie_mode_sel_r2 <= 1'b1;        
    end else begin
        if (clr_valid | measure_valid) begin
            range_valid_r2 <= 1'b0;
        end else if (set_valid) begin
            range_valid_r2 <= 1'b1;
            range_r2 <= range_r1;
            lpfd_r2 <= lpfd_r1;
            isel_r2 <= isel_r1;
            pfd_bwctrl_r2 <= pfd_bwctrl_r1;
            icp_high_r2 <= icp_high_r1;
            rgla_isel_r2 <= rgla_isel_r1;
            pcie_mode_sel_r2 <= pcie_mode_sel_r1;	    
        end 
    end
end

assign range = range_r2;
assign range_valid = range_valid_r2;
assign lpfd = lpfd_r2;
assign isel = isel_r2;
assign pfd_bwctrl = pfd_bwctrl_r2;
assign icp_high = icp_high_r2;
assign rgla_isel = rgla_isel_r2;
assign pcie_mode_sel = pcie_mode_sel_r2;
   
endmodule
