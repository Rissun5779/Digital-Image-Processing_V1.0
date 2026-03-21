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


module mr_rx_compare_av #(
    parameter [3:0] RX_DEFAULT_RANGE = 0
) (
    input  wire        clock,
    input  wire        reset,
    input  wire        clr_valid,
    input  wire [23:0] measure,
    input  wire        measure_valid,
    output wire [3:0]  range,
    output wire        range_valid,
    output wire        oversampled,
    output wire [1:0]  m_sel,
    output wire [3:0]  m,
    output wire [1:0]  lpfd,
    output wire [1:0]  lpd,
    output wire [1:0]  pfd_bwctrl,
    output wire [1:0]  pd_bwctrl,
    output wire [2:0]  isel,
    output wire [2:0]  icp_high,
    output wire [1:0]  sel_ppm,
    output wire        sel_halfbw			  
);

// HDMI 1.4 Data Rate <=340Mhz
// HMDI 2.0 Data Rate >=340Mhz and <=600Mhz
localparam [23:0]
    RX_THRESHOLD_0  =  650000,
    RX_THRESHOLD_1  =  790000,
    RX_THRESHOLD_2  =  810000,
    RX_THRESHOLD_3  = 1010000,
    RX_THRESHOLD_4  = 1250000, 
    RX_THRESHOLD_5  = 2550000,
    RX_THRESHOLD_6  = 3250000,
    RX_THRESHOLD_7  = 3950000,
    RX_THRESHOLD_8  = 4050000,
    RX_THRESHOLD_9  = 5150000,
    RX_THRESHOLD_10 = 6050000; 
	 
localparam [3:0]
    RX_PIX_RATE_LESS_THAN_65MHZ_OR_325MHZ  = 0,
    RX_PIX_RATE_LESS_THAN_79MHZ_OR_395MHZ  = 1,		
    RX_PIX_RATE_LESS_THAN_81MHZ_OR_405MHZ  = 2,		
    RX_PIX_RATE_LESS_THAN_101MHZ_OR_515MHZ = 3,
    RX_PIX_RATE_LESS_THAN_125MHZ           = 4,
    RX_PIX_RATE_LESS_THAN_255MHZ           = 5,
    RX_PIX_RATE_LESS_THAN_605MHZ           = 6;

localparam [3:0]
    RX_LOOPS_MAX = 10;

reg        current_state, next_state;
reg        inc_loops;
reg        clr_loops;
reg [3:0]  loops;
reg [23:0] threshold;
reg [3:0]  range_r1, range_r2;
reg        os_r1, os_r2;
reg [1:0]  m_sel_r1, m_sel_r2;
reg [3:0]  m_r1, m_r2;
reg [1:0]  lpfd_r1, lpfd_r2;
reg [1:0]  lpd_r1, lpd_r2;
reg [1:0]  pfd_bwctrl_r1, pfd_bwctrl_r2;
reg [1:0]  pd_bwctrl_r1, pd_bwctrl_r2;
reg [2:0]  isel_r1, isel_r2;
reg [2:0]  icp_high_r1, icp_high_r2;
reg [1:0]  sel_ppm_r1, sel_ppm_r2;
reg        sel_halfbw_r1, sel_halfbw_r2;   
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

// Combinatorial mux that define the RX CDR attributes for respective clock measure result
always @ (*)
begin
    case (loops)
        0: begin // <65MHz
            threshold = RX_THRESHOLD_0; 
            range_r1 = RX_PIX_RATE_LESS_THAN_65MHZ_OR_325MHZ; // 0
            os_r1 = 1'b1;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b1; 
        end
      
        1: begin // <79MHz
            threshold = RX_THRESHOLD_1; 
            range_r1 = RX_PIX_RATE_LESS_THAN_79MHZ_OR_395MHZ; // 1
            os_r1 = 1'b1;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b0; 
        end
      
        2: begin // <81MHz
            threshold = RX_THRESHOLD_2; 
            range_r1 = RX_PIX_RATE_LESS_THAN_81MHZ_OR_405MHZ; // 2
            os_r1 = 1'b1;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b01;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b0;
        end
      
        3: begin // <101MHz
            threshold = RX_THRESHOLD_3; 
            range_r1 = RX_PIX_RATE_LESS_THAN_101MHZ_OR_515MHZ; // 3
            os_r1 = 1'b1;
            m_sel_r1 = 2'b01;
            m_r1 = 4'b0101;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b01;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            sel_halfbw_r1 = 1'b0;
        end
                          
        4: begin // <125MHz
            threshold = RX_THRESHOLD_4; 
            range_r1 = RX_PIX_RATE_LESS_THAN_125MHZ; // 4
            os_r1 = 1'b0;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0101;
            lpfd_r1 = 2'b10;
            lpd_r1 = 2'b11;
            isel_r1 = 3'b011;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b10;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            sel_halfbw_r1 = 1'b1;
        end
      
        5: begin // <255MHz
            threshold = RX_THRESHOLD_5; 
            range_r1 = RX_PIX_RATE_LESS_THAN_255MHZ; // 5
            os_r1 = 1'b0;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0101;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b10;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b01;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            sel_halfbw_r1 = 1'b1;
        end
                           
        6: begin // <325MHz
            threshold = RX_THRESHOLD_6; 
            range_r1 = RX_PIX_RATE_LESS_THAN_65MHZ_OR_325MHZ; // 0
            os_r1 = 1'b0;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b1;
        end

        7: begin // <395MHz
            threshold = RX_THRESHOLD_7; 
            range_r1 = RX_PIX_RATE_LESS_THAN_79MHZ_OR_395MHZ; // 1
            os_r1 = 1'b0;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b0; 
        end
		  
        8: begin // <405MHz
            threshold = RX_THRESHOLD_8; 
            range_r1 = RX_PIX_RATE_LESS_THAN_81MHZ_OR_405MHZ; // 2
            os_r1 = 1'b0;
            m_sel_r1 = 2'b00;
            m_r1 = 4'b0011;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b01;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b0; 
        end
		  
        9: begin // <515MHz
            threshold = RX_THRESHOLD_9; 
            range_r1 = RX_PIX_RATE_LESS_THAN_101MHZ_OR_515MHZ; // 3
            os_r1 = 1'b0;
            m_sel_r1 = 2'b01;
            m_r1 = 4'b0101;
            lpfd_r1 = 2'b01;
            lpd_r1 = 2'b01;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01;
            pfd_bwctrl_r1 = 2'b01;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b000;
            sel_halfbw_r1 = 1'b0; 
        end
		  
        10: begin // <605MHz
            threshold = RX_THRESHOLD_10; 
            range_r1 = RX_PIX_RATE_LESS_THAN_605MHZ; // 6
            os_r1 = 1'b0;
            m_sel_r1 = 2'b01;
            m_r1 = 4'b0011; 
            lpfd_r1 = 2'b01; 
            lpd_r1 = 2'b00;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01; 
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001;
            sel_halfbw_r1 = 1'b0; 
        end
		  
        default: begin // <605MHz
            threshold = RX_THRESHOLD_10; 
            range_r1 = RX_PIX_RATE_LESS_THAN_605MHZ; // 6
            os_r1 = 1'b0;
            m_sel_r1 = 2'b01;
            m_r1 = 4'b0011; 
            lpfd_r1 = 2'b01; 
            lpd_r1 = 2'b00;
            isel_r1 = 3'b100;
            pd_bwctrl_r1 = 2'b01; 
            pfd_bwctrl_r1 = 2'b00;
            sel_ppm_r1 = 2'b00;
            icp_high_r1 = 3'b001; 
            sel_halfbw_r1 = 1'b0; 
        end 
    endcase
end

assign match = measure < threshold;
assign loops_max = loops == RX_LOOPS_MAX;

// Outputs
always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        range_valid_r2 <= 1'b0;
        range_r2 <= RX_DEFAULT_RANGE; // 6
        os_r2 = 1'b0;
        m_sel_r2 = 2'b01; 
        m_r2 = 4'b0011;
        lpfd_r2 = 2'b01; 
        lpd_r2 = 2'b00;
        isel_r2 = 3'b100;
        pd_bwctrl_r2 = 2'b01; 
        pfd_bwctrl_r2 = 2'b00; 
        sel_ppm_r2 = 2'b00;
        icp_high_r2 = 3'b001; 
        sel_halfbw_r2 = 1'b0;          
    end else begin
        if (clr_valid | measure_valid) begin
            range_valid_r2 <= 1'b0;
        end else if (set_valid) begin
            range_valid_r2 <= 1'b1;
            range_r2 <= range_r1;
            os_r2 <= os_r1;
            m_sel_r2 <= m_sel_r1;
            m_r2 <= m_r1;
            lpfd_r2 <= lpfd_r1;
            lpd_r2 <= lpd_r1;
            pfd_bwctrl_r2 <= pfd_bwctrl_r1;
            pd_bwctrl_r2 <= pd_bwctrl_r1;
            isel_r2 <= isel_r1;
            icp_high_r2 <= icp_high_r1;
            sel_ppm_r2 <= sel_ppm_r1;
            sel_halfbw_r2 <= sel_halfbw_r1;  
        end 
    end
end

assign range = range_r2;
assign range_valid = range_valid_r2;
assign oversampled = os_r2;
assign m_sel = m_sel_r2;
assign m = m_r2;   
assign lpfd = lpfd_r2;
assign lpd = lpd_r2;   
assign pfd_bwctrl = pfd_bwctrl_r2;
assign pd_bwctrl = pd_bwctrl_r2;
assign isel = isel_r2;
assign icp_high = icp_high_r2;
assign sel_ppm = sel_ppm_r2;
assign sel_halfbw = sel_halfbw_r2;
   
endmodule
