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


`timescale 1ps / 1ps

module tod_calc # (
    parameter TIME_OF_DAY_FORMAT        = 2,     //0 = 96b timestamp, 1 = 64b timestamp, 2= both 96b+64b timestamp
              DELAY_SIGN                = 0      // Sign of the delay adjustment
                                                 // TX: set this parameter to 0 (unsigned) to add delays to Tod
                                                 // RX: set this parameter to 1 (signed) to subtract the delays from ToD                   
) (
    // Common clock and Reset
    input                                                 clk,
    input                                                 rst_n,
    
    // CSR Configuration Input
    input [31:0]                                          pma_delay_reg,
    input [19:0]                                          period,
    
    input                                                 sop_mac_to_calc,
    
    //to or from extractor block
    input                                                 non_empty_ctrl_fifo_extractor_to_calc, //expect this signal to be 1 everytime sop is asserted, not able to wait
    output                                                pop_ctrl_fifo_calc_to_extractor,
    input [5:0]                                           ctrl_extractor_to_calc,
    
    // Input from PCS
    input  [21:0]                                         path_delay_data,
    input  [15:0]                                         mac_delay,
    
    // Inputs from ToD              
    input  [95:0]                                         time_of_day_96b_data,
    input  [63:0]                                         time_of_day_64b_data,
    
    //to CF calc control
    output                                                ctrl_tod_to_cf_valid,
    output [5:0]                                          ctrl_tod_to_cf,
    
    //to inserter
    output                                                push_tod_fifo_calc_to_inserter,
    output [95:0]                                         tod_calc_to_inserter_96,
    output [63:0]                                         tod_calc_to_inserter_64,
    
    //to chkA's TOD FIFO
    output                                                push_tod_fifo_for_chka   
);
                             
    // Symbols that represent data on the lane    
    localparam NSECOND_OVERFLOW_THRESHOLD    = 48'h3B9ACA00_0000;
    localparam TOD_CALC_LATENCY = 8;
    
    wire [63:0] timestamp_64b_data;
    wire [95:0] timestamp_96b_data;    
    
    //Control signal handling
    //signal mapping
    //ctrl_extractor_to_calc[0] = tx_etstamp_ins_ctrl_checksum_correct
    //ctrl_extractor_to_calc[1] = tx_etstamp_ins_ctrl_residence_time_calc_format
    //ctrl_extractor_to_calc[2] = tx_etstamp_ins_ctrl_residence_time_update/ tx_etstamp_ins_ctrl_timestamp_insert
    //ctrl_extractor_to_calc[3] = tx_etstamp_ins_ctrl_timestamp_format
    //ctrl_extractor_to_calc[4] = tx_egress_timestamp_request_valid/ tx_etstamp_ins_ctrl_timestamp_insert
    //ctrl_extractor_to_calc[5] = tx_egress_asymmetry_update

	genvar i;
    wire      timestamp_valid;    
    reg [5:0] ctrl_reg [TOD_CALC_LATENCY-1:0];
    assign ctrl_tod_to_cf_valid = timestamp_valid;
    assign ctrl_tod_to_cf = ctrl_reg[TOD_CALC_LATENCY-1];
    
	generate
	for (i = 0; i < TOD_CALC_LATENCY; i=i+1) 
    begin: ctrl_pipe
        always @ (posedge clk) begin
            if (~rst_n) begin
                ctrl_reg[i] <= 6'h0;
            end else begin
			    if (i == 0) begin
                    if (sop_mac_to_calc & non_empty_ctrl_fifo_extractor_to_calc) begin
                        ctrl_reg[i] <= ctrl_extractor_to_calc;
                    end else begin
                        ctrl_reg[i] <= 6'b0;
                    end
			    end else begin
                    ctrl_reg[i] <= ctrl_reg[i-1];
                end			
            end
        end
	end
	endgenerate
    
    //use sop_mac_to_calc to pop control FIFO
    assign pop_ctrl_fifo_calc_to_extractor = sop_mac_to_calc;
    
    reg [TOD_CALC_LATENCY-1:0] sop_pipe;
    always @ (posedge clk) begin
        if (~rst_n) begin
            sop_pipe <= {TOD_CALC_LATENCY{1'b0}};
        end else begin
            sop_pipe <= {sop_pipe[TOD_CALC_LATENCY-2:0], sop_mac_to_calc};
        end
    end   
    
    //
    // Calculate the total path delay inclusive of PCS delay and internal MAC PTP data path delay
    //    
    reg [22:0] path_delay_total;   
    always @ (posedge clk) begin
        if (~rst_n) begin
            path_delay_total <= 23'h0;
        end else begin
            if (sop_mac_to_calc & non_empty_ctrl_fifo_extractor_to_calc & (ctrl_extractor_to_calc[2] | ctrl_extractor_to_calc[4])) begin
                path_delay_total <= path_delay_data + {mac_delay,2'b0}; //path_delay_data is 12b cycle and 10 fractional cycle
            end                                                         //mac_delay is 8b cycle and 8b fractional cycle    
        end
    end
    
    reg [19:0] csr_period_reg;
    reg [42:0] path_delay_calc_reg;
    wire [42:0] path_delay_calc;
    reg [22:0] path_delay_total_reg; 
    
    //flop the input of multiplier
    always @ (posedge clk) begin
        if (~rst_n) begin
            csr_period_reg <= 20'h0;
            path_delay_calc_reg <= 43'h0;
            path_delay_total_reg <= 23'h0;
        end else begin
            csr_period_reg <= period;
            path_delay_calc_reg <= path_delay_calc;
            path_delay_total_reg <= path_delay_total;
        end
    end
 
    // 2-pipeline multiplier 
    tod_calc_lpm_mult u_mult(
        .clock  (clk),
        .dataa  (path_delay_total_reg),
        .datab  (csr_period_reg),
        .result (path_delay_calc)
    );
    
    //
    // Normalize by adding extra MSB padding and truncating LSB fractional bits 
    // to get format {12,16} ie. {integer ns, fractional ns} before adding
    // Remove additional fractional result, and keep only 16-bits of fractional
    // nanoseconds information
    //
    wire [47:0] path_delay_ns_fns;
    assign path_delay_ns_fns = {15'h0,path_delay_calc_reg[42:10]}; // discard LSB 10bits, bit[25:10] is fns, bit[37:26] is ns..14bits of ns is enough for
    
    //96 bit operation 
    generate
    if (TIME_OF_DAY_FORMAT == 0 || TIME_OF_DAY_FORMAT == 2) begin
        //snapshot of TOD when sop_mac_to_calc is asserted
        //snapshot of TOD will stay in tod_*_reg_0 for 2 cycles before being consumed
        //this is with the assumption that there will be no continuos SOP coming in. If at least 1 empty cycle between SOP to the next SOP then will be fine.
        reg [47:0] tod_s_reg;
        reg [47:0] tod_ns_fns_reg;
        reg [47:0] tod_s_reg_0;
        reg [47:0] tod_ns_fns_reg_0;
        always @ (posedge clk)
        begin
                if (sop_mac_to_calc & non_empty_ctrl_fifo_extractor_to_calc & (ctrl_extractor_to_calc[2] | ctrl_extractor_to_calc[4])) begin
                    tod_s_reg <= time_of_day_96b_data[95:48];
                    tod_ns_fns_reg <= time_of_day_96b_data[47:0];
                end
                tod_s_reg_0 <= tod_s_reg;
                tod_ns_fns_reg_0 <= tod_ns_fns_reg;
            end
    
        //add adjust_ns_fns with the snapshotted TOD
        reg [47:0] tod_s_reg_1;
        reg [47:0] tod_s_reg_2;   
        reg [24:0] tod_ns_fns_plus_adjust_lower_0;
        reg [23:0] tod_ns_fns_plus_adjust_upper_0;
        reg [23:0] tod_ns_fns_plus_adjust_lower_1;
        reg [23:0] tod_ns_fns_plus_adjust_upper_1;
        wire [47:0] adjust_ns_fns_with_sign;
        wire [47:0] tod_ns_fns_plus_adjust;   
        assign adjust_ns_fns_with_sign = DELAY_SIGN == 0 ? {16'h0,pma_delay_reg} : ~{16'h0,pma_delay_reg};
        assign tod_ns_fns_plus_adjust = {tod_ns_fns_plus_adjust_upper_1,tod_ns_fns_plus_adjust_lower_1};
        always @ (posedge clk)
        begin
                tod_s_reg_1 <= tod_s_reg_0;
                tod_s_reg_2 <= tod_s_reg_1;
                
                tod_ns_fns_plus_adjust_lower_0 <= tod_ns_fns_reg_0[23:0] + adjust_ns_fns_with_sign[23:0];
                tod_ns_fns_plus_adjust_upper_0 <= tod_ns_fns_reg_0[47:24] + adjust_ns_fns_with_sign[47:24];
                
                tod_ns_fns_plus_adjust_lower_1 <= tod_ns_fns_plus_adjust_lower_0[23:0];
                tod_ns_fns_plus_adjust_upper_1 <= tod_ns_fns_plus_adjust_upper_0 + tod_ns_fns_plus_adjust_lower_0[24];
            end
        
        //add tod_ns_fns_plus_adjust with path delay
        reg [47:0] tod_s_reg_3;
        reg [47:0] tod_s_reg_4;
        reg [24:0] tod_ns_fns_plus_adjust_plus_path_delay_lower_0;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_upper_0;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_lower_1;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_upper_1;
        wire [47:0] path_delay_ns_fns_with_sign; 
        wire [47:0] tod_ns_fns_plus_adjust_plus_path_delay; 
        assign path_delay_ns_fns_with_sign = DELAY_SIGN == 0 ? path_delay_ns_fns : ~path_delay_ns_fns; 
        assign tod_ns_fns_plus_adjust_plus_path_delay = {tod_ns_fns_plus_adjust_plus_path_delay_upper_1,tod_ns_fns_plus_adjust_plus_path_delay_lower_1};   
        always @ (posedge clk)
        begin
                tod_s_reg_3 <= tod_s_reg_2;
                tod_s_reg_4 <= tod_s_reg_3;
                
                tod_ns_fns_plus_adjust_plus_path_delay_lower_0 <= tod_ns_fns_plus_adjust[23:0] + path_delay_ns_fns_with_sign[23:0];
                tod_ns_fns_plus_adjust_plus_path_delay_upper_0 <= tod_ns_fns_plus_adjust[47:24] + path_delay_ns_fns_with_sign[47:24];
                
                tod_ns_fns_plus_adjust_plus_path_delay_lower_1 <= tod_ns_fns_plus_adjust_plus_path_delay_lower_0[23:0];
                tod_ns_fns_plus_adjust_plus_path_delay_upper_1 <= tod_ns_fns_plus_adjust_plus_path_delay_upper_0 + tod_ns_fns_plus_adjust_plus_path_delay_lower_0[24];
            end
        
        //TX Operation
        //if tod_ns_fns_plus_adjust_plus_path_delay >= NSECOND_OVERFLOW_THRESHOLD
        reg [24:0] ts_point_s_plus_1s_lower_0;   
        reg [23:0] ts_point_s_plus_1s_upper_0;
        reg [23:0] ts_point_s_plus_1s_lower_1;   
        reg [23:0] ts_point_s_plus_1s_upper_1;         
        reg [47:0] tod_ns_fns_plus_adjust_plus_path_delay_minus_1s;
        wire [47:0] ts_point_s_plus_1s;
        assign ts_point_s_plus_1s = {ts_point_s_plus_1s_upper_1,ts_point_s_plus_1s_lower_1};
        always @ (posedge clk) begin
                ts_point_s_plus_1s_lower_0 <= tod_s_reg_3[23:0] + 24'h1;
                ts_point_s_plus_1s_upper_0 <= tod_s_reg_3[47:24];
                ts_point_s_plus_1s_lower_1 <= ts_point_s_plus_1s_lower_0[23:0];
                ts_point_s_plus_1s_upper_1 <= ts_point_s_plus_1s_upper_0 + ts_point_s_plus_1s_lower_0[24];
                tod_ns_fns_plus_adjust_plus_path_delay_minus_1s[23:0] <=  tod_ns_fns_plus_adjust_plus_path_delay[23:0]; //NSECOND_OVERFLOW_THRESHOLD[23:0] = 0, thus no operation required
                tod_ns_fns_plus_adjust_plus_path_delay_minus_1s[47:24] <=  tod_ns_fns_plus_adjust_plus_path_delay[47:24] - NSECOND_OVERFLOW_THRESHOLD[47:24];
            end
        
        //if 0 < ts_plus_total_path_delay < NSECOND_OVERFLOW_THRESHOLD, then no operation
        reg [47:0] ts_point_s_no_op;   
        reg [47:0] tod_ns_fns_plus_adjust_plus_path_delay_no_op;
        always @ (posedge clk) begin
                ts_point_s_no_op <= tod_s_reg_4;
                tod_ns_fns_plus_adjust_plus_path_delay_no_op <= tod_ns_fns_plus_adjust_plus_path_delay;
            end
        
        //RX operation
        //if tod_ns_fns_plus_adjust_plus_path_delay < 0 --> second field minus 1s and nanosecond field add NSECOND_OVERFLOW_THRESHOLD
        //if 0 < tod_ns_fns_plus_adjust_plus_path_delay <= NSECOND_OVERFLOW_THRESHOLD --> no operation
        reg [24:0] ts_point_s_minus_1s_or_no_op_lower_0;   
        reg [23:0] ts_point_s_minus_1s_or_no_op_upper_0;
        reg [23:0] ts_point_s_minus_1s_or_no_op_lower_1;   
        reg [23:0] ts_point_s_minus_1s_or_no_op_upper_1;         
        reg [47:0] tod_ns_fns_plus_adjust_plus_path_delay_plus_1s_or_no_op;
        wire [47:0] ts_point_s_minus_1s_or_no_op;
        assign ts_point_s_minus_1s_or_no_op = {ts_point_s_minus_1s_or_no_op_upper_1,ts_point_s_minus_1s_or_no_op_lower_1};
        always @ (posedge clk) begin
                ts_point_s_minus_1s_or_no_op_lower_0 <= tod_s_reg_3[23:0] - 24'h1;
                ts_point_s_minus_1s_or_no_op_upper_0 <= tod_s_reg_3[47:24];
                if (tod_ns_fns_plus_adjust_plus_path_delay[47]) begin //indicate it is negative
                    ts_point_s_minus_1s_or_no_op_lower_1 <= ts_point_s_minus_1s_or_no_op_lower_0[23:0];
                    ts_point_s_minus_1s_or_no_op_upper_1 <= ts_point_s_minus_1s_or_no_op_upper_0 - ts_point_s_minus_1s_or_no_op_lower_0[24];
                    tod_ns_fns_plus_adjust_plus_path_delay_plus_1s_or_no_op[23:0] <=  tod_ns_fns_plus_adjust_plus_path_delay[23:0]; //NSECOND_OVERFLOW_THRESHOLD[23:0] = 0, thus no operation required
                    tod_ns_fns_plus_adjust_plus_path_delay_plus_1s_or_no_op[47:24] <=  tod_ns_fns_plus_adjust_plus_path_delay[47:24] + NSECOND_OVERFLOW_THRESHOLD[47:24];
                end else begin
                    ts_point_s_minus_1s_or_no_op_lower_1 <= tod_s_reg_4[23:0];
                    ts_point_s_minus_1s_or_no_op_upper_1 <= tod_s_reg_4[47:24];
                    tod_ns_fns_plus_adjust_plus_path_delay_plus_1s_or_no_op <= tod_ns_fns_plus_adjust_plus_path_delay;
                end
            end
        
        //choosing final tod
        wire [95:0] timestamp_96b_data_tx;
        wire [95:0] timestamp_96b_data_rx;
        assign timestamp_96b_data_tx[95:48] = tod_ns_fns_plus_adjust_plus_path_delay_minus_1s[47] ? ts_point_s_no_op : ts_point_s_plus_1s;  //tod_ns_fns_plus_adjust_plus_path_delay_minus_1s[47] = 1 indicate ns_fns is smaller than 1 second
        assign timestamp_96b_data_tx[47:0] = tod_ns_fns_plus_adjust_plus_path_delay_minus_1s[47] ? tod_ns_fns_plus_adjust_plus_path_delay_no_op : tod_ns_fns_plus_adjust_plus_path_delay_minus_1s;
        assign timestamp_96b_data_rx[95:48] = ts_point_s_minus_1s_or_no_op;
        assign timestamp_96b_data_rx[47:0] = tod_ns_fns_plus_adjust_plus_path_delay_plus_1s_or_no_op;
        assign timestamp_96b_data = DELAY_SIGN == 0 ? timestamp_96b_data_tx : timestamp_96b_data_rx;        
    end else begin
        assign timestamp_96b_data = 96'b0; 
    end
    endgenerate    
        
    //64 bit operation
    generate
    if (TIME_OF_DAY_FORMAT == 1 || TIME_OF_DAY_FORMAT == 2) begin 
        //snapshot of TOD when sop_mac_to_calc is asserted
        //snapshot of TOD will stay in tod_*_reg_0 for 2 cycles before being consumed
        //this is with the assumption that there will be no continuos SOP coming in. If at least 1 empty cycle between SOP to the next SOP then will be fine.
        reg [63:0] tod_ns_fns_64_reg;   
        reg [63:0] tod_ns_fns_64_reg_0;   
        always @ (posedge clk)
        begin
                if (sop_mac_to_calc & non_empty_ctrl_fifo_extractor_to_calc & (ctrl_extractor_to_calc[2] | ctrl_extractor_to_calc[4])) begin
                    tod_ns_fns_64_reg <= time_of_day_64b_data;     
                end
                tod_ns_fns_64_reg_0 <= tod_ns_fns_64_reg;
            end
    
        //add adjust_ns_fns with the snapshotted TOD
        reg [24:0] tod_ns_fns_plus_adjust_lower_64b_0;
        reg [24:0] tod_ns_fns_plus_adjust_middle_64b_0;
        reg [15:0] tod_ns_fns_plus_adjust_upper_64b_0;
        reg [23:0] tod_ns_fns_plus_adjust_lower_64b_1;
        reg [24:0] tod_ns_fns_plus_adjust_middle_64b_1;
        reg [15:0] tod_ns_fns_plus_adjust_upper_64b_1;
        wire [63:0] adjust_ns_fns_with_sign_64b;
        wire [63:0] tod_ns_fns_plus_adjust_64b;   
        assign adjust_ns_fns_with_sign_64b = DELAY_SIGN == 0 ? {32'h0,pma_delay_reg} : ~{32'h0,pma_delay_reg};
        assign tod_ns_fns_plus_adjust_64b = {(tod_ns_fns_plus_adjust_upper_64b_1+tod_ns_fns_plus_adjust_middle_64b_1[24]),tod_ns_fns_plus_adjust_middle_64b_1[23:0],tod_ns_fns_plus_adjust_lower_64b_1};
        always @ (posedge clk)
        begin
                tod_ns_fns_plus_adjust_lower_64b_0 <= tod_ns_fns_64_reg_0[23:0] + adjust_ns_fns_with_sign_64b[23:0];
                tod_ns_fns_plus_adjust_middle_64b_0 <= tod_ns_fns_64_reg_0[47:24] + adjust_ns_fns_with_sign_64b[47:24];
                tod_ns_fns_plus_adjust_upper_64b_0 <= tod_ns_fns_64_reg_0[63:48] + adjust_ns_fns_with_sign_64b[63:48];
                
                tod_ns_fns_plus_adjust_lower_64b_1 <= tod_ns_fns_plus_adjust_lower_64b_0[23:0];
                tod_ns_fns_plus_adjust_middle_64b_1 <= tod_ns_fns_plus_adjust_middle_64b_0[23:0] + tod_ns_fns_plus_adjust_lower_64b_0[24];
                tod_ns_fns_plus_adjust_upper_64b_1 <= tod_ns_fns_plus_adjust_upper_64b_0 + tod_ns_fns_plus_adjust_middle_64b_0[24];     

        end    
        
        //add tod_ns_fns_plus_adjust_64b with path delay
        reg [24:0] tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_0;
        reg [24:0] tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_0;
        reg [15:0] tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_0;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_1;
        reg [24:0] tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_1;
        reg [15:0] tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_1;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_2;
        reg [23:0] tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_2;
        reg [15:0] tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_2;   
        wire [63:0] path_delay_ns_fns_with_sign_64b; 
        wire [63:0] tod_ns_fns_plus_adjust_plus_path_delay_64b; 
        assign path_delay_ns_fns_with_sign_64b = DELAY_SIGN == 0 ? {16'h0,path_delay_ns_fns} : ~{16'h0,path_delay_ns_fns}; 
        assign tod_ns_fns_plus_adjust_plus_path_delay_64b = {tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_2,tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_2,tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_2};   
        always @ (posedge clk)
        begin
                tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_0 <= tod_ns_fns_plus_adjust_64b[23:0] + path_delay_ns_fns_with_sign_64b[23:0];
                tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_0 <= tod_ns_fns_plus_adjust_64b[47:24] + path_delay_ns_fns_with_sign_64b[47:24];
                tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_0 <= tod_ns_fns_plus_adjust_64b[63:48] + path_delay_ns_fns_with_sign_64b[63:48];
                
                tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_1 <= tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_0[23:0];
                tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_1 <= tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_0[23:0] + tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_0[24];
                tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_1 <= tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_0 + tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_0[24];
                
                tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_2 <= tod_ns_fns_plus_adjust_plus_path_delay_lower_64b_1;
                tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_2 <= tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_1[23:0];
                tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_2 <= tod_ns_fns_plus_adjust_plus_path_delay_upper_64b_1 + tod_ns_fns_plus_adjust_plus_path_delay_middle_64b_1[24];
        end 
        
        assign timestamp_64b_data = tod_ns_fns_plus_adjust_plus_path_delay_64b;
    end else begin
        assign timestamp_64b_data = 64'b0;
    end
    endgenerate    
    
    //timestamp valid
    assign timestamp_valid = sop_pipe[TOD_CALC_LATENCY-1];  
    
    //to inserter
    assign push_tod_fifo_calc_to_inserter = timestamp_valid 
                                            & ((ctrl_tod_to_cf[4] & ctrl_tod_to_cf[2] & ~ctrl_tod_to_cf[3]) //v2 insert
                                            | (ctrl_tod_to_cf[4] & ~ctrl_tod_to_cf[2] & ctrl_tod_to_cf[3]) //v1 insert or report
                                            | (ctrl_tod_to_cf[4] & ~ctrl_tod_to_cf[2] & ~ctrl_tod_to_cf[3]) //v2 report
                                            );
    assign tod_calc_to_inserter_96 = timestamp_96b_data;
    assign tod_calc_to_inserter_64 = timestamp_64b_data;
    
    //to chkA's TOD FIFO
    assign push_tod_fifo_for_chka = timestamp_valid & ctrl_tod_to_cf[0] 
                                    & ((ctrl_tod_to_cf[2] & ctrl_tod_to_cf[4] & ~ctrl_tod_to_cf[3]) //v2 insert
                                    | (~ctrl_tod_to_cf[2] & ctrl_tod_to_cf[4] & ctrl_tod_to_cf[3])); //v1 insert 
  
   
endmodule

