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

module alt_eth_1588_cal # (
    parameter DEVICE_FAMILY             = "Stratix V",
              TIME_OF_DAY_FORMAT        = 2,     //0 = 96b timestamp, 1 = 64b timestamp, 2= both 96b+64b timestamp
              DELAY_SIGN                = 0      // Sign of the delay adjustment
                                                 // TX: set this parameter to 0 (unsigned) to add delays to Tod
                                                 // RX: set this parameter to 1 (signed) to subtract the delays from ToD                   
) (
    // Common clock and Reset
    input wire         clk,
    input wire         rst_n,
    
    //ctrl fifo to/from tod_calc block
    input wire [5:0]   ctrl_extractor_to_calc,
    input wire         non_empty_ctrl_fifo_extractor_to_calc,
    output wire        pop_ctrl_fifo_calc_to_extractor,    

    //todi fifo to/from cf_calc block
    input wire[95:0]   todi_extractor_to_calc,
    input wire         non_empty_todi_fifo_extractor_to_calc, 
    output wire        pop_todi_fifo_calc_to_extractor,

    //todp fifo to/from cf_calc block
    input wire [95:0]  todp_extractor_to_calc,
    input wire         non_empty_todp_fifo_extractor_to_calc,
    output wire        pop_todp_fifo_calc_to_extractor,

    //cf fifo to/from cf_calc block 
    input wire [63:0]  cf_extractor_to_calc, 
    input wire         non_empty_cf_fifo_extractor_to_calc,
    output wire        pop_cf_fifo_calc_to_extractor,

    //chka fifo to/from chka_calc block
    input wire [16:0]  chka_extractor_to_calc,
    input wire         non_empty_chka_fifo_extractor_to_calc, 
    output wire        pop_chka_fifo_calc_to_extractor,

    //tod_calc to inserter
    output wire        push_tod_fifo_calc_to_inserter,
    output wire [95:0] tod_calc_to_inserter_96,
    output wire [63:0] tod_calc_to_inserter_64,    

    //cf_calc to inserter
    output wire        push_cf_fifo_calc_to_inserter,
    output wire [63:0] cf_calc_to_inserter,

    //chka_calc to inserter
    output wire        push_chka_fifo_calc_to_inserter,
    output wire [15:0] chka_calc_to_inserter,

    // CSR Configuration Input
    input wire [18:0]  asymmetry_reg,
    input wire [31:0]  pma_delay_reg,
    input wire [19:0]  period,
    
    //SOP from deterministic latency point in MAC
    input wire         sop_mac_to_calc,

    //Path Delay data
    input wire [21:0]  path_delay_data,
    input wire [15:0]  mac_delay,
    
    // Inputs from ToD              
    input wire [95:0]  time_of_day_96b_data,
    input wire [63:0]  time_of_day_64b_data   
);

    wire        ctrl_tod_to_cf_valid;
    wire [5:0]  ctrl_tod_to_cf;
    wire        ctrl_cf_to_chka_valid;
    wire [3:0]  ctrl_cf_to_chka;
    wire        push_tod_fifo_for_chka;
    wire [79:0] tod_fifo_for_chka;
    wire        non_empty_tod_fifo_for_chka;
    wire        pop_tod_fifo_for_chka;
    wire        push_cfp_fifo_for_chka;
    wire [63:0] cfp_fifo_for_chka;
    wire        non_empty_cfp_fifo_for_chka;
    wire        pop_cfp_fifo_for_chka;
    
    tod_calc #(
        .TIME_OF_DAY_FORMAT (TIME_OF_DAY_FORMAT),
        .DELAY_SIGN (DELAY_SIGN)
    ) tod_cal_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pma_delay_reg(pma_delay_reg),
        .period(period),
        .sop_mac_to_calc(sop_mac_to_calc),
        .non_empty_ctrl_fifo_extractor_to_calc(non_empty_ctrl_fifo_extractor_to_calc), 
        .pop_ctrl_fifo_calc_to_extractor(pop_ctrl_fifo_calc_to_extractor),
        .ctrl_extractor_to_calc(ctrl_extractor_to_calc),
        .path_delay_data(path_delay_data),
        .mac_delay(mac_delay),
        .time_of_day_96b_data(time_of_day_96b_data),
        .time_of_day_64b_data(time_of_day_64b_data),
        .ctrl_tod_to_cf_valid(ctrl_tod_to_cf_valid),
        .ctrl_tod_to_cf(ctrl_tod_to_cf),
        .push_tod_fifo_calc_to_inserter(push_tod_fifo_calc_to_inserter),
        .tod_calc_to_inserter_96(tod_calc_to_inserter_96),
        .tod_calc_to_inserter_64(tod_calc_to_inserter_64),
        .push_tod_fifo_for_chka(push_tod_fifo_for_chka)   
    );
    
    cf_calc #(
        .TIME_OF_DAY_FORMAT (TIME_OF_DAY_FORMAT)
    ) cf_calc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .asymmetry_reg(asymmetry_reg),
        .ctrl_tod_to_cf_valid(ctrl_tod_to_cf_valid),
        .ctrl_tod_to_cf(ctrl_tod_to_cf),
        .todi_extractor_to_calc(todi_extractor_to_calc), 
        .non_empty_todi_fifo_extractor_to_calc(non_empty_todi_fifo_extractor_to_calc),
        .pop_todi_fifo_calc_to_extractor(pop_todi_fifo_calc_to_extractor),
        .cf_extractor_to_calc(cf_extractor_to_calc),
        .non_empty_cf_fifo_extractor_to_calc(non_empty_cf_fifo_extractor_to_calc),
        .pop_cf_fifo_calc_to_extractor(pop_cf_fifo_calc_to_extractor),
        .push_cfp_fifo_for_chka(push_cfp_fifo_for_chka),
        .push_tod_fifo_calc_to_inserter(push_tod_fifo_calc_to_inserter),
        .tod_calc_to_inserter_96(tod_calc_to_inserter_96),
        .tod_calc_to_inserter_64(tod_calc_to_inserter_64),
        .push_cf_fifo_calc_to_inserter(push_cf_fifo_calc_to_inserter),
        .cf_calc_to_inserter(cf_calc_to_inserter),
        .ctrl_cf_to_chka_valid(ctrl_cf_to_chka_valid),
        .ctrl_cf_to_chka(ctrl_cf_to_chka)
    );
    
    chka_calc #(
        .TIME_OF_DAY_FORMAT (TIME_OF_DAY_FORMAT)
    ) chka_calc_inst (
    
        .clk(clk),
        .rst_n(rst_n),
        .ctrl_cf_to_chka_valid(ctrl_cf_to_chka_valid),
        .ctrl_cf_to_chka(ctrl_cf_to_chka),
        .tod_fifo_for_chka(tod_fifo_for_chka), 
        .non_empty_tod_fifo_for_chka(non_empty_tod_fifo_for_chka),
        .pop_tod_fifo_for_chka(pop_tod_fifo_for_chka),
        .todp_extractor_to_calc(todp_extractor_to_calc), 
        .non_empty_todp_fifo_extractor_to_calc(non_empty_todp_fifo_extractor_to_calc),
        .pop_todp_fifo_calc_to_extractor(pop_todp_fifo_calc_to_extractor),
        .cfp_fifo_for_chka(cfp_fifo_for_chka),
        .non_empty_cfp_fifo_for_chka(non_empty_cfp_fifo_for_chka),
        .pop_cfp_fifo_for_chka(pop_cfp_fifo_for_chka),
        .push_cf_fifo_calc_to_inserter(push_cf_fifo_calc_to_inserter),
        .cf_calc_to_inserter(cf_calc_to_inserter),
        .chka_extractor_to_calc(chka_extractor_to_calc), 
        .non_empty_chka_fifo_extractor_to_calc(non_empty_chka_fifo_extractor_to_calc),
        .pop_chka_fifo_calc_to_extractor(pop_chka_fifo_calc_to_extractor),
        .push_chka_fifo_calc_to_inserter(push_chka_fifo_calc_to_inserter),
        .chka_calc_to_inserter(chka_calc_to_inserter)
    ); 
    
    //SC FIFO to store TOD' for chkA calc
    sc_fifo_1588 #(
        .DEVICE_FAMILY       (DEVICE_FAMILY),
        .ENABLE_MEM_ECC      (0),
        .REGISTER_ENC_INPUT  (0),
        
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (80),
        .FIFO_DEPTH          (8),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0)
    ) tod_fifo_inst (
        .clk               (clk),                              
        .reset             (~rst_n),                           
        .in_data           (tod_calc_to_inserter_96[95:16]),               
        .in_valid          (push_tod_fifo_for_chka),              
        .in_ready          (),                                     
        .out_data          (tod_fifo_for_chka),              
        .out_valid         (non_empty_tod_fifo_for_chka),             
        .out_ready         (pop_tod_fifo_for_chka),         
        .in_startofpacket  (1'b0),                                 
        .in_endofpacket    (1'b0),                                 
        .out_startofpacket (),                                     
        .out_endofpacket   (),                                     
        .in_empty          (1'b0),                                 
        .out_empty         (),                                     
        .in_error          (1'b0),                                 
        .out_error         (),                                     
        .in_channel        (1'b0),                                 
        .out_channel       (),
        .ecc_err_corrected (),
        .ecc_err_fatal     ()
    ); 
    
    //SC FIFO to store CF' for chkA calc
    sc_fifo_1588 #(
        .DEVICE_FAMILY       (DEVICE_FAMILY),
        .ENABLE_MEM_ECC      (0),
        .REGISTER_ENC_INPUT  (0),
        
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (64),
        .FIFO_DEPTH          (8),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0)
    ) cf_fifo_inst (
        .clk               (clk),                              
        .reset             (~rst_n),                           
        .in_data           (cf_extractor_to_calc),               
        .in_valid          (push_cfp_fifo_for_chka),              
        .in_ready          (),                                     
        .out_data          (cfp_fifo_for_chka),              
        .out_valid         (non_empty_cfp_fifo_for_chka),             
        .out_ready         (pop_cfp_fifo_for_chka),         
        .in_startofpacket  (1'b0),                                 
        .in_endofpacket    (1'b0),                                 
        .out_startofpacket (),                                     
        .out_endofpacket   (),                                     
        .in_empty          (1'b0),                                 
        .out_empty         (),                                     
        .in_error          (1'b0),                                 
        .out_error         (),                                     
        .in_channel        (1'b0),                                 
        .out_channel       (),
        .ecc_err_corrected (),
        .ecc_err_fatal     ()
    ); 
   
endmodule

