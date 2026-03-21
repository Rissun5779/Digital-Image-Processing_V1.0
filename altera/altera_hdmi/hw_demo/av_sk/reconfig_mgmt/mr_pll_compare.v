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


module mr_pll_compare #(
    parameter [3:0] PLL_DEFAULT_RANGE = 3
) (
    input  wire        clock,
    input  wire        reset,
    input  wire        clr_valid,
    input  wire [23:0] measure,
    input  wire        measure_valid,
    output wire [3:0]  range,
    output wire        range_valid,
    output wire [17:0] m,
    output wire [17:0] n,
    output wire [22:0] c0, // RX REFCLK
    output wire [22:0] c1, // LS CLK
    output wire [22:0] c2, // VID CLK
    output wire [1:0]  cp,
    output wire [6:0]  bw,
    input  wire [3:0]  bpc
    );

localparam [23:0]
    PLL_THRESHOLD_0 =  400000,
    PLL_THRESHOLD_1 =  600000,
    PLL_THRESHOLD_2 = 1600000,
    PLL_THRESHOLD_3 = 3400000;

localparam [3:0]
    PLL_PIX_RATE_LESS_THAN_40MHZ  = 0,
    PLL_PIX_RATE_LESS_THAN_60MHZ  = 1,
    PLL_PIX_RATE_LESS_THAN_160MHZ = 2,
    PLL_PIX_RATE_LESS_THAN_340MHZ = 3;
   
localparam [3:0] PLL_LOOPS_MAX = 3;

reg        current_state, next_state;
reg        inc_loops;
reg        clr_loops;
reg [3:0]  loops;
reg [23:0] threshold;
reg [3:0]  range_r1, range_r2;
reg [17:0] m_r1, m_r2;
reg [17:0] n_r1, n_r2;
reg [22:0] c0_r1, c0_r2;
reg [22:0] c1_r1, c1_r2;
reg [22:0] c2_r1, c2_r2;
reg [1:0]  cp_r1, cp_r2;
reg [6:0]  bw_r1, bw_r2;
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

// Combinatorial mux that define the PLL range for respective clock measure result
always @ (*)
begin
    case (loops)
      0: begin // <40MHz
          threshold    = PLL_THRESHOLD_0; 
          range_r1     = PLL_PIX_RATE_LESS_THAN_40MHZ; // 0
          m_r1[17:16]  = 2'b00;
          m_r1[15:8]   = 8'b00010100; // 20
          m_r1[7:0]    = 8'b00010100; // 20
          n_r1[17:16]  = 2'b01;       // N is bypassed
          n_r1[15:8]   = 8'b00000000;
          n_r1[7:0]    = 8'b00000000;
          c0_r1[22:18] = 5'b00000;    // C0
          c0_r1[17:16] = 2'b00;
          c0_r1[15:8]  = 8'b00000100; // 4
          c0_r1[7:0]   = 8'b00000100; // 4
          c1_r1[22:18] = 5'b00001;    // C1
          c1_r1[17:16] = 2'b00;
          c1_r1[15:8]  = 8'b00101000; // 40
          c1_r1[7:0]   = 8'b00101000; // 40
          c2_r1[22:18] = 5'b00010;    // C2
          c2_r1[17:16] = 2'b00;
          c2_r1[15:8]  = bpc == 4'b0100 ? 8'b00101000 : // 40
                         bpc == 4'b0101 ? 8'b00110010 : // 50
                         bpc == 4'b0110 ? 8'b00111100 : // 60
                         bpc == 4'b0111 ? 8'b01010000 : // 80
                                          8'b00101000;  // 40			 
          c2_r1[7:0]   = bpc == 4'b0100 ? 8'b00101000 : // 40
                         bpc == 4'b0101 ? 8'b00110010 : // 50
                         bpc == 4'b0110 ? 8'b00111100 : // 60
                         bpc == 4'b0111 ? 8'b01010000 : // 80
                                          8'b00101000;  // 40
          cp_r1[1:0]   = 2'b10;
          bw_r1[6:0]   = 7'b0000111;  
      end
              
      1: begin // <60MHz
          threshold    = PLL_THRESHOLD_1; 
          range_r1     = PLL_PIX_RATE_LESS_THAN_60MHZ; // 0
          m_r1[17:16]  = 2'b00;
          m_r1[15:8]   = 8'b00001010; // 10
          m_r1[7:0]    = 8'b00001010; // 10
          n_r1[17:16]  = 2'b01;       // N is bypassed
          n_r1[15:8]   = 8'b00000000;
          n_r1[7:0]    = 8'b00000000;
          c0_r1[22:18] = 5'b00000;    // C0
          c0_r1[17:16] = 2'b00;
          c0_r1[15:8]  = 8'b00000010; // 2
          c0_r1[7:0]   = 8'b00000010; // 2
          c1_r1[22:18] = 5'b00001;    // C1
          c1_r1[17:16] = 2'b00;
          c1_r1[15:8]  = 8'b00010100; // 20
          c1_r1[7:0]   = 8'b00010100; // 20
          c2_r1[22:18] = 5'b00010;    // C2
          c2_r1[17:16] = 2'b00;
          c2_r1[15:8]  = bpc == 4'b0100 ? 8'b00010100 : // 20
                         bpc == 4'b0101 ? 8'b00011001 : // 25
                         bpc == 4'b0110 ? 8'b00011110 : // 30
                         bpc == 4'b0111 ? 8'b00101000 : // 40
                                          8'b00010100;  // 20			 
          c2_r1[7:0]   = bpc == 4'b0100 ? 8'b00010100 : // 20
                         bpc == 4'b0101 ? 8'b00011001 : // 25
                         bpc == 4'b0110 ? 8'b00011110 : // 30
                         bpc == 4'b0111 ? 8'b00101000 : // 40
                                          8'b00010100;  // 20
          cp_r1[1:0]   = 2'b10;
          bw_r1[6:0]   = 7'b0000111;  
      end
        
      2: begin // <160MHz
          threshold    = PLL_THRESHOLD_2; 
          range_r1     = PLL_PIX_RATE_LESS_THAN_160MHZ; // 1
          m_r1[17:16]  = 2'b00;
          m_r1[15:8]   = 8'b00000101; // 5
          m_r1[7:0]    = 8'b00000101; // 5
          n_r1[17:16]  = 2'b01;       // N is bypassed
          n_r1[15:8]   = 8'b00000000;
          n_r1[7:0]    = 8'b00000000;
          c0_r1[22:18] = 5'b00000;    // C0
          c0_r1[17:16] = 2'b00;
          c0_r1[15:8]  = 8'b00000101; // 5
          c0_r1[7:0]   = 8'b00000101; // 5
          c1_r1[22:18] = 5'b00001;    // C1
          c1_r1[17:16] = 2'b00;
          c1_r1[15:8]  = 8'b00001010; // 10
          c1_r1[7:0]   = 8'b00001010; // 10
          c2_r1[22:18] = 5'b00010;    // C2
          c2_r1[17:16] = 2'b00;
          c2_r1[15:8]  = bpc == 4'b0100 ? 8'b00001010 : // 10
                         bpc == 4'b0101 ? 8'b00001100 : // 12
                         bpc == 4'b0110 ? 8'b00001111 : // 15
                         bpc == 4'b0111 ? 8'b00010100 : // 20
                                          8'b00001010;  // 10			 
          c2_r1[7:0]   = bpc == 4'b0100 ? 8'b00001010 : // 10
                         bpc == 4'b0101 ? 8'b00001101 : // 13
                         bpc == 4'b0110 ? 8'b00001111 : // 15
                         bpc == 4'b0111 ? 8'b00010100 : // 20
                                          8'b00001010;  // 10
          cp_r1[1:0]   = 2'b11;
          bw_r1[6:0]   = 7'b0001000;  
      end
        
      3: begin // <340MHz
          threshold    = PLL_THRESHOLD_3; 
          range_r1     = PLL_PIX_RATE_LESS_THAN_340MHZ; // 2
          m_r1[17:16]  = 2'b00;
          m_r1[15:8]   = 8'b00000010; // 2
          m_r1[7:0]    = 8'b00000010; // 2
          n_r1[17:16]  = 2'b01;       // N is bypassed
          n_r1[15:8]   = 8'b00000000;
          n_r1[7:0]    = 8'b00000000;
          c0_r1[22:18] = 5'b00000;    // C0
          c0_r1[17:16] = 2'b00;
          c0_r1[15:8]  = 8'b00000010; // 2
          c0_r1[7:0]   = 8'b00000010; // 2
          c1_r1[22:18] = 5'b00001;    // C1
          c1_r1[17:16] = 2'b00;
          c1_r1[15:8]  = 8'b00000100; // 4
          c1_r1[7:0]   = 8'b00000100; // 4
          c2_r1[22:18] = 5'b00010;    // C2
          c2_r1[17:16] = 2'b00;
          c2_r1[15:8]  = bpc == 4'b0100 ? 8'b00000100 : // 4
                         bpc == 4'b0101 ? 8'b00000101 : // 5
                         bpc == 4'b0110 ? 8'b00000110 : // 6
                         bpc == 4'b0111 ? 8'b00001000 : // 8
                                          8'b00000100;  // 4			 
          c2_r1[7:0]   = bpc == 4'b0100 ? 8'b00000100 : // 4
                         bpc == 4'b0101 ? 8'b00000101 : // 5 
                         bpc == 4'b0110 ? 8'b00000110 : // 6
                         bpc == 4'b0111 ? 8'b00001000 : // 8
                                          8'b00000100;  // 4
          cp_r1[1:0]   = 2'b10;
          bw_r1[6:0]   = 7'b0001000; 
      end
    
      default: begin // <340MHz
          threshold    = PLL_THRESHOLD_3; 
          range_r1     = PLL_PIX_RATE_LESS_THAN_340MHZ; // 2
          m_r1[17:16]  = 2'b00;
          m_r1[15:8]   = 8'b00000010; // 2
          m_r1[7:0]    = 8'b00000010; // 2
          n_r1[17:16]  = 2'b01;       // N is bypassed
          n_r1[15:8]   = 8'b00000000;
          n_r1[7:0]    = 8'b00000000;
          c0_r1[22:18] = 5'b00000;    // C0
          c0_r1[17:16] = 2'b00;
          c0_r1[15:8]  = 8'b00000010; // 2
          c0_r1[7:0]   = 8'b00000010; // 2
          c1_r1[22:18] = 5'b00001;    // C1
          c1_r1[17:16] = 2'b00;
          c1_r1[15:8]  = 8'b00000100; // 4
          c1_r1[7:0]   = 8'b00000100; // 4
          c2_r1[22:18] = 5'b00010;    // C2
          c2_r1[17:16] = 2'b00;
          c2_r1[15:8]  = bpc == 4'b0100 ? 8'b00000100 : // 4
                         bpc == 4'b0101 ? 8'b00000101 : // 5
                         bpc == 4'b0110 ? 8'b00000110 : // 6
                         bpc == 4'b0111 ? 8'b00001000 : // 8
                                          8'b00000100;  // 4			 
          c2_r1[7:0]   = bpc == 4'b0100 ? 8'b00000100 : // 4
                         bpc == 4'b0101 ? 8'b00000101 : // 5 
                         bpc == 4'b0110 ? 8'b00000110 : // 6
                         bpc == 4'b0111 ? 8'b00001000 : // 8
                                          8'b00000100;  // 4
          cp_r1[1:0]   = 2'b10;
          bw_r1[6:0]   = 7'b0001000; 
      end 
   endcase
end

assign match = measure < threshold;
assign loops_max = loops == PLL_LOOPS_MAX;

// Outputs
always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        range_valid_r2 <= 1'b0;
        range_r2 <= PLL_DEFAULT_RANGE;
        m_r2 <= 18'b00_00000010_00000010;
        n_r2 <= 18'b01_00000000_00000000;
        c0_r2 <= 23'b00000_00_00000010_00000010;
        c1_r2 <= 23'b00001_00_00000100_00000100;
        c2_r2 <= 23'b00010_00_00000100_00000100;
        cp_r2 <= 2'b10;
        bw_r2 <= 7'b0001000;        
    end else begin
        if (clr_valid | measure_valid) begin
            range_valid_r2 <= 1'b0;
        end else if (set_valid) begin
            range_valid_r2 <= 1'b1;
            range_r2 <= range_r1;
            m_r2 <= m_r1;
            n_r2 <= n_r1;
            c0_r2 <= c0_r1;
            c1_r2 <= c1_r1;
            c2_r2 <= c2_r1;
            cp_r2 <= cp_r1;
            bw_r2 <= bw_r1;       
        end 
    end
end

assign range = range_r2;
assign range_valid = range_valid_r2;
assign m = m_r2;
assign n = n_r2;
assign c0 = c0_r2;
assign c1 = c1_r2;
assign c2 = c2_r2;
assign cp = cp_r2;
assign bw = bw_r2;
   
endmodule


