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


module tmr_comparator (
  
    // general interface
    clk,
    reset_n,
    tmr_output_disable_n,
    tmr_err_inj,
    tmr_interrupt,
    tmr_reset_request,
  
    // instruction master
    i_address,              i_address_a,                i_address_b,                i_address_c,
    i_read,                 i_read_a,                   i_read_b,                   i_read_c, 
    i_readdata,             i_readdata_a,               i_readdata_b,               i_readdata_c, 
    i_waitrequest,          i_waitrequest_a,            i_waitrequest_b,            i_waitrequest_c,
    i_response,             i_response_a,               i_response_b,               i_response_c,
    i_readdatavalid,        i_readdatavalid_a,          i_readdatavalid_b,          i_readdatavalid_c,
    i_burstcount,           i_burstcount_a,             i_burstcount_b,             i_burstcount_c,

    // flash instruction master
    fa_address,				fa_address_a,				fa_address_b,				fa_address_c,
    fa_read,                fa_read_a,                  fa_read_b,                  fa_read_c,
    fa_readdata,            fa_readdata_a,              fa_readdata_b,              fa_readdata_c,
    fa_waitrequest,         fa_waitrequest_a,           fa_waitrequest_b,           fa_waitrequest_c,
    fa_response,            fa_response_a,              fa_response_b,              fa_response_c,
    fa_readdatavalid,       fa_readdatavalid_a,         fa_readdatavalid_b,         fa_readdatavalid_c,
    fa_burstcount,          fa_burstcount_a,            fa_burstcount_b,            fa_burstcount_c,

    // Data Master
    d_readdata,                                 d_address_a,                                d_address_b,                                d_address_c,
    d_waitrequest,                              d_read_a,                                   d_read_b,                                   d_read_c, 
    d_readdatavalid,                            d_readdata_a,                               d_readdata_b,                               d_readdata_c, 
    d_address,                                  d_waitrequest_a,                            d_waitrequest_b,                            d_waitrequest_c,
    d_read,                                     d_burstcount_a,                             d_burstcount_b,                             d_burstcount_c,
    d_burstcount,                               d_readdatavalid_a,                          d_readdatavalid_b,                          d_readdatavalid_c,
    d_write,                                    d_write_a,                                  d_write_b,                                  d_write_c,
    d_writedata,                                d_writedata_a,                              d_writedata_b,                              d_writedata_c,
    d_byteenable,                               d_byteenable_a,                             d_byteenable_b,                             d_byteenable_c,
    debug_mem_slave_debugaccess_to_roms,        debug_mem_slave_debugaccess_to_roms_a,      debug_mem_slave_debugaccess_to_roms_b,      debug_mem_slave_debugaccess_to_roms_c, 
    d_response,                                 d_response_a,                               d_response_b,                               d_response_c,
    
    // instruction master tightly coupled
    itcm0_readdata,            itcm0_readdata_a,              itcm0_readdata_b,             itcm0_readdata_c,        
    itcm0_address,             itcm0_address_a,               itcm0_address_b,              itcm0_address_c,
    itcm0_read,                itcm0_read_a,                  itcm0_read_b,                 itcm0_read_c,
    itcm0_clken,               itcm0_clken_a,                 itcm0_clken_b,                itcm0_clken_c,
    itcm0_writedata,           itcm0_writedata_a,             itcm0_writedata_b,            itcm0_writedata_c,
    itcm0_write,               itcm0_write_a,                 itcm0_write_b,                itcm0_write_c,
    itcm0_response,            itcm0_response_a,              itcm0_response_b,             itcm0_response_c,
    itcm1_readdata,            itcm1_readdata_a,              itcm1_readdata_b,             itcm1_readdata_c,
    itcm1_address,             itcm1_address_a,               itcm1_address_b,              itcm1_address_c,
    itcm1_read,                itcm1_read_a,                  itcm1_read_b,                 itcm1_read_c,
    itcm1_clken,               itcm1_clken_a,                 itcm1_clken_b,                itcm1_clken_c,
    itcm1_writedata,           itcm1_writedata_a,             itcm1_writedata_b,            itcm1_writedata_c,
    itcm1_write,               itcm1_write_a,                 itcm1_write_b,                itcm1_write_c,
    itcm1_response,            itcm1_response_a,              itcm1_response_b,             itcm1_response_c,
    itcm2_readdata,            itcm2_readdata_a,              itcm2_readdata_b,             itcm2_readdata_c,
    itcm2_address,             itcm2_address_a,               itcm2_address_b,              itcm2_address_c,
    itcm2_read,                itcm2_read_a,                  itcm2_read_b,                 itcm2_read_c,
    itcm2_clken,               itcm2_clken_a,                 itcm2_clken_b,                itcm2_clken_c,
    itcm2_writedata,           itcm2_writedata_a,             itcm2_writedata_b,            itcm2_writedata_c,
    itcm2_write,               itcm2_write_a,                 itcm2_write_b,                itcm2_write_c,
    itcm2_response,            itcm2_response_a,              itcm2_response_b,             itcm2_response_c,
    itcm3_readdata,            itcm3_readdata_a,              itcm3_readdata_b,             itcm3_readdata_c,
    itcm3_address,             itcm3_address_a,               itcm3_address_b,              itcm3_address_c,
    itcm3_read,                itcm3_read_a,                  itcm3_read_b,                 itcm3_read_c,
    itcm3_clken,               itcm3_clken_a,                 itcm3_clken_b,                itcm3_clken_c,
    itcm3_writedata,           itcm3_writedata_a,             itcm3_writedata_b,            itcm3_writedata_c,    
    itcm3_write,               itcm3_write_a,                 itcm3_write_b,                itcm3_write_c,
    itcm3_response,            itcm3_response_a,              itcm3_response_b,             itcm3_response_c,
    
    // data master tightly coupled
    dtcm0_readdata,            dtcm0_readdata_a,              dtcm0_readdata_b,             dtcm0_readdata_c,        
    dtcm0_address,             dtcm0_address_a,               dtcm0_address_b,              dtcm0_address_c,
    dtcm0_read,                dtcm0_read_a,                  dtcm0_read_b,                 dtcm0_read_c,
    dtcm0_clken,               dtcm0_clken_a,                 dtcm0_clken_b,                dtcm0_clken_c,
    dtcm0_writedata,           dtcm0_writedata_a,             dtcm0_writedata_b,            dtcm0_writedata_c,
    dtcm0_write,               dtcm0_write_a,                 dtcm0_write_b,                dtcm0_write_c,
    dtcm0_byteenable,          dtcm0_byteenable_a,            dtcm0_byteenable_b,           dtcm0_byteenable_c,
    dtcm0_response,            dtcm0_response_a,              dtcm0_response_b,             dtcm0_response_c,
    dtcm1_readdata,            dtcm1_readdata_a,              dtcm1_readdata_b,             dtcm1_readdata_c,
    dtcm1_address,             dtcm1_address_a,               dtcm1_address_b,              dtcm1_address_c,
    dtcm1_read,                dtcm1_read_a,                  dtcm1_read_b,                 dtcm1_read_c,
    dtcm1_clken,               dtcm1_clken_a,                 dtcm1_clken_b,                dtcm1_clken_c,
    dtcm1_writedata,           dtcm1_writedata_a,             dtcm1_writedata_b,            dtcm1_writedata_c,
    dtcm1_write,               dtcm1_write_a,                 dtcm1_write_b,                dtcm1_write_c,
    dtcm1_byteenable,          dtcm1_byteenable_a,            dtcm1_byteenable_b,           dtcm1_byteenable_c,
    dtcm1_response,            dtcm1_response_a,              dtcm1_response_b,             dtcm1_response_c,
    dtcm2_readdata,            dtcm2_readdata_a,              dtcm2_readdata_b,             dtcm2_readdata_c,
    dtcm2_address,             dtcm2_address_a,               dtcm2_address_b,              dtcm2_address_c,
    dtcm2_read,                dtcm2_read_a,                  dtcm2_read_b,                 dtcm2_read_c,
    dtcm2_clken,               dtcm2_clken_a,                 dtcm2_clken_b,                dtcm2_clken_c,
    dtcm2_writedata,           dtcm2_writedata_a,             dtcm2_writedata_b,            dtcm2_writedata_c,
    dtcm2_write,               dtcm2_write_a,                 dtcm2_write_b,                dtcm2_write_c,
    dtcm2_byteenable,          dtcm2_byteenable_a,            dtcm2_byteenable_b,           dtcm2_byteenable_c,
    dtcm2_response,            dtcm2_response_a,              dtcm2_response_b,             dtcm2_response_c,
    dtcm3_readdata,            dtcm3_readdata_a,              dtcm3_readdata_b,             dtcm3_readdata_c,
    dtcm3_address,             dtcm3_address_a,               dtcm3_address_b,              dtcm3_address_c,
    dtcm3_read,                dtcm3_read_a,                  dtcm3_read_b,                 dtcm3_read_c,
    dtcm3_clken,               dtcm3_clken_a,                 dtcm3_clken_b,                dtcm3_clken_c,
    dtcm3_writedata,           dtcm3_writedata_a,             dtcm3_writedata_b,            dtcm3_writedata_c,    
    dtcm3_write,               dtcm3_write_a,                 dtcm3_write_b,                dtcm3_write_c,     
    dtcm3_byteenable,          dtcm3_byteenable_a,            dtcm3_byteenable_b,           dtcm3_byteenable_c,
    dtcm3_response,            dtcm3_response_a,              dtcm3_response_b,             dtcm3_response_c,
    
    // High Performance instruction master
    ihp_readdata,              ihp_readdata_a,                ihp_readdata_b,               ihp_readdata_c,
    ihp_waitrequest,           ihp_waitrequest_a,             ihp_waitrequest_b,            ihp_waitrequest_c,
    ihp_readdatavalid,         ihp_readdatavalid_a,           ihp_readdatavalid_b,          ihp_readdatavalid_c,
    ihp_address,               ihp_address_a,                 ihp_address_b,                ihp_address_c,
    ihp_read,                  ihp_read_a,                    ihp_read_b,                   ihp_read_c,
    ihp_response,              ihp_response_a,                ihp_response_b,               ihp_response_c,
    
    // High performance data master 
    dhp_readdata,              dhp_readdata_a,                dhp_readdata_b,               dhp_readdata_c,
    dhp_waitrequest,           dhp_waitrequest_a,             dhp_waitrequest_b,            dhp_waitrequest_c,
    dhp_readdatavalid,         dhp_readdatavalid_a,           dhp_readdatavalid_b,          dhp_readdatavalid_c,
    dhp_address,               dhp_address_a,                 dhp_address_b,                dhp_address_c,
    dhp_read,                  dhp_read_a,                    dhp_read_b,                   dhp_read_c,
    dhp_write,                 dhp_write_a,                   dhp_write_b,                  dhp_write_c,
    dhp_writedata,             dhp_writedata_a,               dhp_writedata_b,              dhp_writedata_c,
    dhp_byteenable,            dhp_byteenable_a,              dhp_byteenable_b,             dhp_byteenable_c,
    dhp_response,              dhp_response_a,                dhp_response_b,               dhp_response_c,

    // Non TMR Signals
    debug_mem_slave_address,            debug_mem_slave_address_a,          debug_mem_slave_address_b,          debug_mem_slave_address_c, 
    debug_mem_slave_byteenable,         debug_mem_slave_byteenable_a,       debug_mem_slave_byteenable_b,       debug_mem_slave_byteenable_c,
    debug_mem_slave_debugaccess,        debug_mem_slave_debugaccess_a,      debug_mem_slave_debugaccess_b,      debug_mem_slave_debugaccess_c,
    debug_mem_slave_read,               debug_mem_slave_read_a,             debug_mem_slave_read_b,             debug_mem_slave_read_c, 
    debug_mem_slave_write,              debug_mem_slave_write_a,            debug_mem_slave_write_b,            debug_mem_slave_write_c,
    debug_mem_slave_writedata,          debug_mem_slave_writedata_a,        debug_mem_slave_writedata_b,        debug_mem_slave_writedata_c,
    debug_mem_slave_readdata,           debug_mem_slave_readdata_a,         debug_mem_slave_readdata_b,         debug_mem_slave_readdata_c, 
    debug_mem_slave_waitrequest,        debug_mem_slave_waitrequest_a,      debug_mem_slave_waitrequest_b,      debug_mem_slave_waitrequest_c,
    
    debug_host_slave_address,           debug_host_slave_address_a,         debug_host_slave_address_b,         debug_host_slave_address_c, 
    debug_host_slave_read,              debug_host_slave_read_a,            debug_host_slave_read_b,            debug_host_slave_read_c, 
    debug_host_slave_write,             debug_host_slave_write_a,           debug_host_slave_write_b,           debug_host_slave_write_c,
    debug_host_slave_writedata,         debug_host_slave_writedata_a,       debug_host_slave_writedata_b,       debug_host_slave_writedata_c,
    debug_host_slave_readdata,          debug_host_slave_readdata_a,        debug_host_slave_readdata_b,        debug_host_slave_readdata_c, 
    debug_host_slave_waitrequest,       debug_host_slave_waitrequest_a,     debug_host_slave_waitrequest_b,     debug_host_slave_waitrequest_c, 

    debug_trace_slave_address,          debug_trace_slave_address_a,        debug_trace_slave_address_b,        debug_trace_slave_address_c,
    debug_trace_slave_read,             debug_trace_slave_read_a,           debug_trace_slave_read_b,           debug_trace_slave_read_c,
    debug_trace_slave_readdata,         debug_trace_slave_readdata_a,       debug_trace_slave_readdata_b,       debug_trace_slave_readdata_c, 
                                                                                                                
    debug_reset_request,            debug_reset_request_a,
        
    debug_extra,        debug_extra_a,      debug_extra_b,      debug_extra_c,
    
    avalon_debug_port_address,      avalon_debug_port_address_a,        avalon_debug_port_address_b,        avalon_debug_port_address_c,
    avalon_debug_port_readdata,     avalon_debug_port_readdata_a,       avalon_debug_port_readdata_b,       avalon_debug_port_readdata_c,
    avalon_debug_port_write,        avalon_debug_port_write_a,          avalon_debug_port_write_b,          avalon_debug_port_write_c,
    avalon_debug_port_read,         avalon_debug_port_read_a,           avalon_debug_port_read_b,           avalon_debug_port_read_c,
    avalon_debug_port_writedata,    avalon_debug_port_writedata_a,      avalon_debug_port_writedata_b,      avalon_debug_port_writedata_c, 

    eic_port_valid,             eic_port_valid_a,           eic_port_valid_b,           eic_port_valid_c,
    eic_port_data,              eic_port_data_a,            eic_port_data_b,            eic_port_data_c,

    // Conduits
    debug_ack,              debug_ack_a,            debug_ack_b,            debug_ack_c,
    debug_req,              debug_req_a,            debug_req_b,            debug_req_c,
    debug_trigout,          debug_trigout_a,        debug_trigout_b,        debug_trigout_c,
   
    // vectors    
    reset_vector_word_addr,                 reset_vector_word_addr_a,               reset_vector_word_addr_b,               reset_vector_word_addr_c,
    exception_vector_word_addr,             exception_vector_word_addr_a,           exception_vector_word_addr_b,           exception_vector_word_addr_c,
    fast_tlb_miss_vector_word_addr,         fast_tlb_miss_vector_word_addr_a,       fast_tlb_miss_vector_word_addr_b,       fast_tlb_miss_vector_word_addr_c, 

    // SLD JTAG
    vji_ir_out,         vji_ir_out_a,           vji_ir_out_b,           vji_ir_out_c,
    vji_tdo,            vji_tdo_a,              vji_tdo_b,              vji_tdo_c,
    vji_cdr,            vji_cdr_a,              vji_cdr_b,              vji_cdr_c,
    vji_ir_in,          vji_ir_in_a,            vji_ir_in_b,            vji_ir_in_c,
    vji_rti,            vji_rti_a,              vji_rti_b,              vji_rti_c,
    vji_sdr,            vji_sdr_a,              vji_sdr_b,              vji_sdr_c,
    vji_tck,            vji_tck_a,              vji_tck_b,              vji_tck_c,
    vji_tdi,            vji_tdi_a,              vji_tdi_b,              vji_tdi_c,
    vji_udr,            vji_udr_a,              vji_udr_b,              vji_udr_c,
    vji_uir,            vji_uir_a,              vji_uir_b,              vji_uir_c,

    debug_reset,        debug_reset_a,      debug_reset_b,      debug_reset_c,   
    
    cpu_resetrequest,       cpu_resetrequest_a,         cpu_resetrequest_b,         cpu_resetrequest_c,
    cpu_resettaken,         cpu_resettaken_a,           cpu_resettaken_b,           cpu_resettaken_c,
    
    debug_offchip_trace_data,       debug_offchip_trace_data_a,     debug_offchip_trace_data_b,     debug_offchip_trace_data_c  
  );
  
  parameter I_MASTER_ADDRESS_WIDTH = 3;
  parameter D_MASTER_ADDRESS_WIDTH = 3;
  parameter IHP_MASTER_ADDRESS_WIDTH = 3;
  parameter DHP_MASTER_ADDRESS_WIDTH = 3;
  parameter TCIM_MASTER_ADDRESS_WIDTH0 = 3;
  parameter TCIM_MASTER_ADDRESS_WIDTH1 = 3;
  parameter TCIM_MASTER_ADDRESS_WIDTH2 = 3;
  parameter TCIM_MASTER_ADDRESS_WIDTH3 = 3;
  parameter TCDM_MASTER_ADDRESS_WIDTH0 = 3;
  parameter TCDM_MASTER_ADDRESS_WIDTH1 = 3;
  parameter TCDM_MASTER_ADDRESS_WIDTH2 = 3;
  parameter TCDM_MASTER_ADDRESS_WIDTH3 = 3;
  parameter DEBUG_TRACE_ADDRESS_WIDTH = 8;
  parameter TCIM_MASTER_DATA_WIDTH = 32;
  parameter TCDM_MASTER_DATA_WIDTH = 32;
  parameter VECTOR_WIDTH = 3;
  parameter FA_MASTER_ADDRESS_WIDTH = 3;
  parameter FA_MASTER_BURST_WIDTH = 3;

  // general interface
  input   clk;
  input   reset_n;
  input   tmr_output_disable_n;
  input   [2:0] tmr_err_inj;
  output  tmr_interrupt;
  output  tmr_reset_request;

  wire enable;
  // global TMR signals
  wire [2:0] control;
  wire [2:0] mega_or_signal;
  wire [2:0] status_i;
  wire [2:0] status_fa;
  wire [2:0] status_d;
  wire [2:0] status_ihp;
  wire [2:0] status_dhp;
  wire [2:0] status_itcm0;
  wire [2:0] status_itcm1;
  wire [2:0] status_itcm2;
  wire [2:0] status_itcm3;
  wire [2:0] status_dtcm0;
  wire [2:0] status_dtcm1;
  wire [2:0] status_dtcm2;
  wire [2:0] status_dtcm3;
  
  // Instruction Master Interface
  output [I_MASTER_ADDRESS_WIDTH-1:0]   i_address; 
  output i_read; 
  input  [31:0] i_readdata; 
  input  i_waitrequest;
  input  [1:0] i_response;
  input  i_readdatavalid;
  output [3:0] i_burstcount;
  
  input [I_MASTER_ADDRESS_WIDTH-1:0]   i_address_a; 
  input i_read_a; 
  output [31:0] i_readdata_a; 
  output i_waitrequest_a;
  output [1:0] i_response_a;
  output i_readdatavalid_a;
  input  [3:0] i_burstcount_a;
  
  input  [I_MASTER_ADDRESS_WIDTH-1:0]   i_address_b; 
  input  i_read_b; 
  output [31:0] i_readdata_b; 
  output i_waitrequest_b;
  output [1:0] i_response_b;
  output i_readdatavalid_b;
  input  [3:0] i_burstcount_b;
  
  input  [I_MASTER_ADDRESS_WIDTH-1:0]   i_address_c; 
  input  i_read_c; 
  output [31:0] i_readdata_c; 
  output i_waitrequest_c;
  output [1:0] i_response_c;
  output i_readdatavalid_c;
  input  [3:0] i_burstcount_c;
  
  // All instruction Master input is a pass through
  assign i_readdata_a = i_readdata;
  assign i_waitrequest_a = i_waitrequest;
  assign i_response_a = i_response;
  assign i_readdatavalid_a = i_readdatavalid;
  assign i_readdata_b = i_readdata;
  assign i_waitrequest_b = i_waitrequest;
  assign i_response_b = i_response;
  assign i_readdatavalid_b = i_readdatavalid;
  assign i_readdata_c = i_readdata;
  assign i_waitrequest_c = i_waitrequest;
  assign i_response_c = i_response;
  assign i_readdatavalid_c = i_readdatavalid;
  
  wire [2:0] status_i_read;
  wire [2:0] status_i_burstcount;
  wire [2:0] status_i_address;
  
  tmr_maj tmr_maj_i_read (
    .a            (i_read_a),
    .b            (i_read_b),
    .c            (i_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_i_read),
    .q            (i_read)
  );
  defparam tmr_maj_i_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_i_burstcount (
    .a            (i_burstcount_a),
    .b            (i_burstcount_b),
    .c            (i_burstcount_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_i_burstcount),
    .q            (i_burstcount)
  );
  defparam tmr_maj_i_burstcount.TMR_WIDTH = 4;
   
  tmr_maj tmr_maj_i_address (
    .a            (i_address_a),
    .b            (i_address_b),
    .c            (i_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_i_address),
    .q            (i_address)
  );
  defparam tmr_maj_i_address.TMR_WIDTH = I_MASTER_ADDRESS_WIDTH;
  
  assign status_i[0] = status_i_read[0] | status_i_burstcount[0] | status_i_address[0];
  assign status_i[1] = status_i_read[1] | status_i_burstcount[1] | status_i_address[1];
  assign status_i[2] = status_i_read[2] | status_i_burstcount[2] | status_i_address[2];

  // flash instruction master
  output  [FA_MASTER_ADDRESS_WIDTH-1:0]   fa_address;			
  output  fa_read;
  input   [31:0] fa_readdata;
  input   fa_waitrequest;  
  input   [1:0] fa_response;     
  input   fa_readdatavalid;
  output  [FA_MASTER_BURST_WIDTH-1:0]   fa_burstcount;
  
  input  [FA_MASTER_ADDRESS_WIDTH-1:0]   fa_address_a;			
  input  fa_read_a;
  output   [31:0] fa_readdata_a;
  output   fa_waitrequest_a;  
  output   [1:0] fa_response_a;     
  output   fa_readdatavalid_a;
  input  [FA_MASTER_BURST_WIDTH-1:0]   fa_burstcount_a;
  
  input  [FA_MASTER_ADDRESS_WIDTH-1:0]   fa_address_b;			
  input  fa_read_b;
  output   [31:0] fa_readdata_b;
  output   fa_waitrequest_b;  
  output   [1:0] fa_response_b;     
  output   fa_readdatavalid_b;
  input  [FA_MASTER_BURST_WIDTH-1:0]   fa_burstcount_b;
  
  input  [FA_MASTER_ADDRESS_WIDTH-1:0]   fa_address_c;			
  input  fa_read_c;
  output   [31:0] fa_readdata_c;
  output   fa_waitrequest_c;  
  output   [1:0] fa_response_c;     
  output   fa_readdatavalid_c;
  input  [FA_MASTER_BURST_WIDTH-1:0]   fa_burstcount_c;

  wire [2:0] status_fa_read;
  wire [2:0] status_fa_burstcount;
  wire [2:0] status_fa_address;
  
  tmr_maj tmr_maj_fa_read (
    .a            (fa_read_a),
    .b            (fa_read_b),
    .c            (fa_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_fa_read),
    .q            (fa_read)
  );
  defparam tmr_maj_fa_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_fa_burstcount (
    .a            (fa_burstcount_a),
    .b            (fa_burstcount_b),
    .c            (fa_burstcount_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_fa_burstcount),
    .q            (fa_burstcount)
  );
  defparam tmr_maj_fa_burstcount.TMR_WIDTH = FA_MASTER_BURST_WIDTH;
   
  tmr_maj tmr_maj_fa_address (
    .a            (fa_address_a),
    .b            (fa_address_b),
    .c            (fa_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_fa_address),
    .q            (fa_address)
  );
  defparam tmr_maj_fa_address.TMR_WIDTH = FA_MASTER_ADDRESS_WIDTH;
  
  assign status_fa[0] = status_fa_read[0] | status_fa_burstcount[0] | status_fa_address[0];
  assign status_fa[1] = status_fa_read[1] | status_fa_burstcount[1] | status_fa_address[1];
  assign status_fa[2] = status_fa_read[2] | status_fa_burstcount[2] | status_fa_address[2];

  // All flash instruction Master input is a pass through
  assign fa_readdata_a = fa_readdata;
  assign fa_waitrequest_a = fa_waitrequest;
  assign fa_response_a = fa_response;
  assign fa_readdatavalid_a = fa_readdatavalid;
  assign fa_readdata_b = fa_readdata;
  assign fa_waitrequest_b = fa_waitrequest;
  assign fa_response_b = fa_response;
  assign fa_readdatavalid_b = fa_readdatavalid;
  assign fa_readdata_c = fa_readdata;
  assign fa_waitrequest_c = fa_waitrequest;
  assign fa_response_c = fa_response;
  assign fa_readdatavalid_c = fa_readdatavalid;
  
  // Data Master Interface
  input  [31:0] d_readdata; 
  input  d_waitrequest;
  input  [1:0]  d_response;
  input  d_readdatavalid;
  output [D_MASTER_ADDRESS_WIDTH-1:0]   d_address; 
  output d_read; 
  output [3:0] d_burstcount;
  output d_write;
  output [31:0] d_writedata;
  output [3:0] d_byteenable;
  output debug_mem_slave_debugaccess_to_roms;
  
  output  [31:0] d_readdata_a; 
  output  d_waitrequest_a;
  output  [1:0]  d_response_a;
  output  d_readdatavalid_a;
  input  [D_MASTER_ADDRESS_WIDTH-1:0]   d_address_a; 
  input  d_read_a; 
  input  [3:0] d_burstcount_a;
  input  d_write_a;
  input  [31:0] d_writedata_a;
  input  [3:0] d_byteenable_a;
  input debug_mem_slave_debugaccess_to_roms_a;
  
  output  [31:0] d_readdata_b; 
  output  d_waitrequest_b;
  output  [1:0]  d_response_b;
  output  d_readdatavalid_b;
  input  [D_MASTER_ADDRESS_WIDTH-1:0]   d_address_b; 
  input  d_read_b; 
  input  [3:0] d_burstcount_b;
  input  d_write_b;
  input  [31:0] d_writedata_b;
  input  [3:0] d_byteenable_b;
  input debug_mem_slave_debugaccess_to_roms_b;
  
  output  [31:0] d_readdata_c; 
  output  d_waitrequest_c;
  output  [1:0]  d_response_c;
  output  d_readdatavalid_c;
  input [D_MASTER_ADDRESS_WIDTH-1:0]   d_address_c; 
  input d_read_c; 
  input [3:0] d_burstcount_c;
  input d_write_c;
  input [31:0] d_writedata_c;
  input [3:0] d_byteenable_c;
  input debug_mem_slave_debugaccess_to_roms_c;
  
  // All data Master input is a pass through
  assign d_readdata_a = d_readdata;
  assign d_waitrequest_a = d_waitrequest;
  assign d_response_a = d_response;
  assign d_readdatavalid_a = d_readdatavalid;
  assign d_readdata_b = d_readdata;
  assign d_waitrequest_b = d_waitrequest;
  assign d_response_b = d_response;
  assign d_readdatavalid_b = d_readdatavalid;
  assign d_readdata_c = d_readdata;
  assign d_waitrequest_c = d_waitrequest;
  assign d_response_c = d_response;
  assign d_readdatavalid_c = d_readdatavalid;
  
  wire [2:0] status_d_address;
  wire [2:0] status_d_read;
  wire [2:0] status_d_write;
  wire [2:0] status_d_writedata;
  wire [2:0] status_d_byteenable;
  wire [2:0] status_d_burstcount;
  wire [2:0] status_d_debugaccess;

  tmr_maj tmr_maj_d_address (
    .a            (d_address_a),
    .b            (d_address_b),
    .c            (d_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_address),
    .q            (d_address)
  );
  defparam tmr_maj_d_address.TMR_WIDTH = D_MASTER_ADDRESS_WIDTH;

  tmr_maj tmr_maj_d_read (
    .a            (d_read_a),
    .b            (d_read_b),
    .c            (d_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_read),
    .q            (d_read)
  );
  defparam tmr_maj_d_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_d_write (
    .a            (d_write_a),
    .b            (d_write_b),
    .c            (d_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_write),
    .q            (d_write)
  );
  defparam tmr_maj_d_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_d_writedata (
    .a            (d_writedata_a),
    .b            (d_writedata_b),
    .c            (d_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_writedata),
    .q            (d_writedata)
  );
  defparam tmr_maj_d_writedata.TMR_WIDTH = 32;

  tmr_maj tmr_maj_d_byteenable (
    .a            (d_byteenable_a),
    .b            (d_byteenable_b),
    .c            (d_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_byteenable),
    .q            (d_byteenable)
  );
  defparam tmr_maj_d_byteenable.TMR_WIDTH = 4;
  
  tmr_maj tmr_maj_d_burstcount (
    .a            (d_burstcount_a),
    .b            (d_burstcount_b),
    .c            (d_burstcount_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_burstcount),
    .q            (d_burstcount)
  );
  defparam tmr_maj_d_burstcount.TMR_WIDTH = 4;
   
  tmr_maj tmr_maj_d_debugaccess (
    .a            (debug_mem_slave_debugaccess_to_roms_a),
    .b            (debug_mem_slave_debugaccess_to_roms_b),
    .c            (debug_mem_slave_debugaccess_to_roms_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_d_debugaccess),
    .q            (debug_mem_slave_debugaccess_to_roms)
  );
  defparam tmr_maj_d_debugaccess.TMR_WIDTH = 1;

  assign status_d[0] = status_d_address[0] | status_d_read[0] | status_d_write[0] | status_d_writedata[0] | status_d_byteenable[0] | status_d_burstcount[0] | status_d_debugaccess[0]; 
  assign status_d[1] = status_d_address[1] | status_d_read[1] | status_d_write[1] | status_d_writedata[1] | status_d_byteenable[1] | status_d_burstcount[1] | status_d_debugaccess[1]; 
  assign status_d[2] = status_d_address[2] | status_d_read[2] | status_d_write[2] | status_d_writedata[2] | status_d_byteenable[2] | status_d_burstcount[2] | status_d_debugaccess[2];
  
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_readdata;
  input  [1:0]                             itcm0_response;
  output [TCIM_MASTER_ADDRESS_WIDTH0-1:0]   itcm0_address;
  output                                   itcm0_read;
  output                                   itcm0_clken;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_writedata;
  output                                   itcm0_write;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_readdata_a;
  output [1:0]                             itcm0_response_a;
  input  [TCIM_MASTER_ADDRESS_WIDTH0-1:0]   itcm0_address_a;
  input                                    itcm0_read_a;
  input                                    itcm0_clken_a;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_writedata_a;
  input                                    itcm0_write_a;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_readdata_b;
  output [1:0]                             itcm0_response_b;
  input  [TCIM_MASTER_ADDRESS_WIDTH0-1:0]   itcm0_address_b;
  input                                    itcm0_read_b;
  input                                    itcm0_clken_b;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_writedata_b;
  input                                    itcm0_write_b;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_readdata_c;
  output [1:0]                             itcm0_response_c;
  input  [TCIM_MASTER_ADDRESS_WIDTH0-1:0]   itcm0_address_c;
  input                                    itcm0_read_c;
  input                                    itcm0_clken_c;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm0_writedata_c;
  input                                    itcm0_write_c;
  
  // All data Master input is a pass through
  assign itcm0_readdata_a = itcm0_readdata;
  assign itcm0_response_a = itcm0_response;
  assign itcm0_readdata_b = itcm0_readdata;
  assign itcm0_response_b = itcm0_response;
  assign itcm0_readdata_c = itcm0_readdata;
  assign itcm0_response_c = itcm0_response;
  
  wire [2:0] status_itcm0_address;
  wire [2:0] status_itcm0_read;
  wire [2:0] status_itcm0_write;
  wire [2:0] status_itcm0_writedata;
  wire [2:0] status_itcm0_clken;

  tmr_maj tmr_maj_itcm0_address (
    .a            (itcm0_address_a),
    .b            (itcm0_address_b),
    .c            (itcm0_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm0_address),
    .q            (itcm0_address)
  );
  defparam tmr_maj_itcm0_address.TMR_WIDTH = TCIM_MASTER_ADDRESS_WIDTH0;

  tmr_maj tmr_maj_itcm0_read (
    .a            (itcm0_read_a),
    .b            (itcm0_read_b),
    .c            (itcm0_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm0_read),
    .q            (itcm0_read)
  );
  defparam tmr_maj_itcm0_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm0_write (
    .a            (itcm0_write_a),
    .b            (itcm0_write_b),
    .c            (itcm0_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm0_write),
    .q            (itcm0_write)
  );
  defparam tmr_maj_itcm0_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm0_clken (
    .a            (itcm0_clken_a),
    .b            (itcm0_clken_b),
    .c            (itcm0_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm0_clken),
    .q            (itcm0_clken)
  );
  defparam tmr_maj_itcm0_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_itcm0_writedata (
    .a            (itcm0_writedata_a),
    .b            (itcm0_writedata_b),
    .c            (itcm0_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm0_writedata),
    .q            (itcm0_writedata)
  );
  defparam tmr_maj_itcm0_writedata.TMR_WIDTH = TCIM_MASTER_DATA_WIDTH;

  assign status_itcm0[0] = status_itcm0_address[0] | status_itcm0_read[0] | status_itcm0_write[0] | status_itcm0_writedata[0] | status_itcm0_clken[0]; 
  assign status_itcm0[1] = status_itcm0_address[1] | status_itcm0_read[1] | status_itcm0_write[1] | status_itcm0_writedata[1] | status_itcm0_clken[1]; 
  assign status_itcm0[2] = status_itcm0_address[2] | status_itcm0_read[2] | status_itcm0_write[2] | status_itcm0_writedata[2] | status_itcm0_clken[2];
  
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_readdata;
  input  [1:0]                             itcm1_response;
  output [TCIM_MASTER_ADDRESS_WIDTH1-1:0]   itcm1_address;
  output                                   itcm1_read;
  output                                   itcm1_clken;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_writedata;
  output                                   itcm1_write;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_readdata_a;
  output [1:0]                             itcm1_response_a;
  input  [TCIM_MASTER_ADDRESS_WIDTH1-1:0]   itcm1_address_a;
  input                                    itcm1_read_a;
  input                                    itcm1_clken_a;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_writedata_a;
  input                                    itcm1_write_a;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_readdata_b;
  output [1:0]                             itcm1_response_b;
  input  [TCIM_MASTER_ADDRESS_WIDTH1-1:0]   itcm1_address_b;
  input                                    itcm1_read_b;
  input                                    itcm1_clken_b;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_writedata_b;
  input                                    itcm1_write_b;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_readdata_c;
  output [1:0]                             itcm1_response_c;
  input  [TCIM_MASTER_ADDRESS_WIDTH1-1:0]   itcm1_address_c;
  input                                    itcm1_read_c;
  input                                    itcm1_clken_c;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm1_writedata_c;
  input                                    itcm1_write_c;
  
  // All data Master input is a pass through
  assign itcm1_readdata_a = itcm1_readdata;
  assign itcm1_response_a = itcm1_response;
  assign itcm1_readdata_b = itcm1_readdata;
  assign itcm1_response_b = itcm1_response;
  assign itcm1_readdata_c = itcm1_readdata;
  assign itcm1_response_c = itcm1_response;
  
  wire [2:0] status_itcm1_address;
  wire [2:0] status_itcm1_read;
  wire [2:0] status_itcm1_write;
  wire [2:0] status_itcm1_writedata;
  wire [2:0] status_itcm1_clken;

  tmr_maj tmr_maj_itcm1_address (
    .a            (itcm1_address_a),
    .b            (itcm1_address_b),
    .c            (itcm1_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm1_address),
    .q            (itcm1_address)
  );
  defparam tmr_maj_itcm1_address.TMR_WIDTH = TCIM_MASTER_ADDRESS_WIDTH1;

  tmr_maj tmr_maj_itcm1_read (
    .a            (itcm1_read_a),
    .b            (itcm1_read_b),
    .c            (itcm1_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm1_read),
    .q            (itcm1_read)
  );
  defparam tmr_maj_itcm1_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm1_write (
    .a            (itcm1_write_a),
    .b            (itcm1_write_b),
    .c            (itcm1_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm1_write),
    .q            (itcm1_write)
  );
  defparam tmr_maj_itcm1_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm1_clken (
    .a            (itcm1_clken_a),
    .b            (itcm1_clken_b),
    .c            (itcm1_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm1_clken),
    .q            (itcm1_clken)
  );
  defparam tmr_maj_itcm1_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_itcm1_writedata (
    .a            (itcm1_writedata_a),
    .b            (itcm1_writedata_b),
    .c            (itcm1_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm1_writedata),
    .q            (itcm1_writedata)
  );
  defparam tmr_maj_itcm1_writedata.TMR_WIDTH = TCIM_MASTER_DATA_WIDTH;

  assign status_itcm1[0] = status_itcm1_address[0] | status_itcm1_read[0] | status_itcm1_write[0] | status_itcm1_writedata[0] | status_itcm1_clken[0]; 
  assign status_itcm1[1] = status_itcm1_address[1] | status_itcm1_read[1] | status_itcm1_write[1] | status_itcm1_writedata[1] | status_itcm1_clken[1]; 
  assign status_itcm1[2] = status_itcm1_address[2] | status_itcm1_read[2] | status_itcm1_write[2] | status_itcm1_writedata[2] | status_itcm1_clken[2];
  
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_readdata;
  input  [1:0]                             itcm2_response;
  output [TCIM_MASTER_ADDRESS_WIDTH2-1:0]   itcm2_address;
  output                                   itcm2_read;
  output                                   itcm2_clken;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_writedata;
  output                                   itcm2_write;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_readdata_a;
  output [1:0]                             itcm2_response_a;
  input  [TCIM_MASTER_ADDRESS_WIDTH2-1:0]   itcm2_address_a;
  input                                    itcm2_read_a;
  input                                    itcm2_clken_a;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_writedata_a;
  input                                    itcm2_write_a;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_readdata_b;
  output [1:0]                             itcm2_response_b;
  input  [TCIM_MASTER_ADDRESS_WIDTH2-1:0]   itcm2_address_b;
  input                                    itcm2_read_b;
  input                                    itcm2_clken_b;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_writedata_b;
  input                                    itcm2_write_b;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_readdata_c;
  output [1:0]                             itcm2_response_c;
  input  [TCIM_MASTER_ADDRESS_WIDTH2-1:0]   itcm2_address_c;
  input                                    itcm2_read_c;
  input                                    itcm2_clken_c;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm2_writedata_c;
  input                                    itcm2_write_c;
  
  // All data Master input is a pass through
  assign itcm2_readdata_a = itcm2_readdata;
  assign itcm2_response_a = itcm2_response;
  assign itcm2_readdata_b = itcm2_readdata;
  assign itcm2_response_b = itcm2_response;
  assign itcm2_readdata_c = itcm2_readdata;
  assign itcm2_response_c = itcm2_response;
  
  wire [2:0] status_itcm2_address;
  wire [2:0] status_itcm2_read;
  wire [2:0] status_itcm2_write;
  wire [2:0] status_itcm2_writedata;
  wire [2:0] status_itcm2_clken;

  tmr_maj tmr_maj_itcm2_address (
    .a            (itcm2_address_a),
    .b            (itcm2_address_b),
    .c            (itcm2_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm2_address),
    .q            (itcm2_address)
  );
  defparam tmr_maj_itcm2_address.TMR_WIDTH = TCIM_MASTER_ADDRESS_WIDTH2;

  tmr_maj tmr_maj_itcm2_read (
    .a            (itcm2_read_a),
    .b            (itcm2_read_b),
    .c            (itcm2_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm2_read),
    .q            (itcm2_read)
  );
  defparam tmr_maj_itcm2_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm2_write (
    .a            (itcm2_write_a),
    .b            (itcm2_write_b),
    .c            (itcm2_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm2_write),
    .q            (itcm2_write)
  );
  defparam tmr_maj_itcm2_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm2_clken (
    .a            (itcm2_clken_a),
    .b            (itcm2_clken_b),
    .c            (itcm2_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm2_clken),
    .q            (itcm2_clken)
  );
  defparam tmr_maj_itcm2_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_itcm2_writedata (
    .a            (itcm2_writedata_a),
    .b            (itcm2_writedata_b),
    .c            (itcm2_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm2_writedata),
    .q            (itcm2_writedata)
  );
  defparam tmr_maj_itcm2_writedata.TMR_WIDTH = TCIM_MASTER_DATA_WIDTH;

  assign status_itcm2[0] = status_itcm2_address[0] | status_itcm2_read[0] | status_itcm2_write[0] | status_itcm2_writedata[0] | status_itcm2_clken[0]; 
  assign status_itcm2[1] = status_itcm2_address[1] | status_itcm2_read[1] | status_itcm2_write[1] | status_itcm2_writedata[1] | status_itcm2_clken[1]; 
  assign status_itcm2[2] = status_itcm2_address[2] | status_itcm2_read[2] | status_itcm2_write[2] | status_itcm2_writedata[2] | status_itcm2_clken[2];
  
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_readdata;
  input  [1:0]                             itcm3_response;
  output [TCIM_MASTER_ADDRESS_WIDTH3-1:0]   itcm3_address;
  output                                   itcm3_read;
  output                                   itcm3_clken;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_writedata;
  output                                   itcm3_write;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_readdata_a;
  output [1:0]                             itcm3_response_a;
  input  [TCIM_MASTER_ADDRESS_WIDTH3-1:0]   itcm3_address_a;
  input                                    itcm3_read_a;
  input                                    itcm3_clken_a;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_writedata_a;
  input                                    itcm3_write_a;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_readdata_b;
  output [1:0]                             itcm3_response_b;
  input  [TCIM_MASTER_ADDRESS_WIDTH3-1:0]   itcm3_address_b;
  input                                    itcm3_read_b;
  input                                    itcm3_clken_b;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_writedata_b;
  input                                    itcm3_write_b;
  output [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_readdata_c;
  output [1:0]                             itcm3_response_c;
  input  [TCIM_MASTER_ADDRESS_WIDTH3-1:0]   itcm3_address_c;
  input                                    itcm3_read_c;
  input                                    itcm3_clken_c;
  input  [TCIM_MASTER_DATA_WIDTH-1:0]      itcm3_writedata_c;
  input                                    itcm3_write_c;
  
  // All data Master input is a pass through
  assign itcm3_readdata_a = itcm3_readdata;
  assign itcm3_response_a = itcm3_response;
  assign itcm3_readdata_b = itcm3_readdata;
  assign itcm3_response_b = itcm3_response;
  assign itcm3_readdata_c = itcm3_readdata;
  assign itcm3_response_c = itcm3_response;
  
  wire [2:0] status_itcm3_address;
  wire [2:0] status_itcm3_read;
  wire [2:0] status_itcm3_write;
  wire [2:0] status_itcm3_writedata;
  wire [2:0] status_itcm3_clken;

  tmr_maj tmr_maj_itcm3_address (
    .a            (itcm3_address_a),
    .b            (itcm3_address_b),
    .c            (itcm3_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm3_address),
    .q            (itcm3_address)
  );
  defparam tmr_maj_itcm3_address.TMR_WIDTH = TCIM_MASTER_ADDRESS_WIDTH3;

  tmr_maj tmr_maj_itcm3_read (
    .a            (itcm3_read_a),
    .b            (itcm3_read_b),
    .c            (itcm3_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm3_read),
    .q            (itcm3_read)
  );
  defparam tmr_maj_itcm3_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm3_write (
    .a            (itcm3_write_a),
    .b            (itcm3_write_b),
    .c            (itcm3_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm3_write),
    .q            (itcm3_write)
  );
  defparam tmr_maj_itcm3_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_itcm3_clken (
    .a            (itcm3_clken_a),
    .b            (itcm3_clken_b),
    .c            (itcm3_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm3_clken),
    .q            (itcm3_clken)
  );
  defparam tmr_maj_itcm3_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_itcm3_writedata (
    .a            (itcm3_writedata_a),
    .b            (itcm3_writedata_b),
    .c            (itcm3_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_itcm3_writedata),
    .q            (itcm3_writedata)
  );
  defparam tmr_maj_itcm3_writedata.TMR_WIDTH = TCIM_MASTER_DATA_WIDTH;

  assign status_itcm3[0] = status_itcm3_address[0] | status_itcm3_read[0] | status_itcm3_write[0] | status_itcm3_writedata[0] | status_itcm3_clken[0]; 
  assign status_itcm3[1] = status_itcm3_address[1] | status_itcm3_read[1] | status_itcm3_write[1] | status_itcm3_writedata[1] | status_itcm3_clken[1]; 
  assign status_itcm3[2] = status_itcm3_address[2] | status_itcm3_read[2] | status_itcm3_write[2] | status_itcm3_writedata[2] | status_itcm3_clken[2];
  
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_readdata;
  input  [1:0]                             dtcm0_response;
  output [TCDM_MASTER_ADDRESS_WIDTH0-1:0]   dtcm0_address;
  output                                   dtcm0_read;
  output                                   dtcm0_clken;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_writedata;
  output                                   dtcm0_write;
  output [3:0]                             dtcm0_byteenable;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_readdata_a;
  output [1:0]                             dtcm0_response_a;
  input  [TCDM_MASTER_ADDRESS_WIDTH0-1:0]   dtcm0_address_a;
  input                                    dtcm0_read_a;
  input                                    dtcm0_clken_a;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_writedata_a;
  input                                    dtcm0_write_a;
  input [3:0]                              dtcm0_byteenable_a;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_readdata_b;
  output [1:0]                             dtcm0_response_b;
  input  [TCDM_MASTER_ADDRESS_WIDTH0-1:0]   dtcm0_address_b;
  input                                    dtcm0_read_b;
  input                                    dtcm0_clken_b;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_writedata_b;
  input                                    dtcm0_write_b;
  input [3:0]                              dtcm0_byteenable_b;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_readdata_c;
  output [1:0]                             dtcm0_response_c;
  input  [TCDM_MASTER_ADDRESS_WIDTH0-1:0]   dtcm0_address_c;
  input                                    dtcm0_read_c;
  input                                    dtcm0_clken_c;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm0_writedata_c;
  input                                    dtcm0_write_c;
  input [3:0]                              dtcm0_byteenable_c;
  
  // All data Master input is a pass through
  assign dtcm0_readdata_a = dtcm0_readdata;
  assign dtcm0_response_a = dtcm0_response;
  assign dtcm0_readdata_b = dtcm0_readdata;
  assign dtcm0_response_b = dtcm0_response;
  assign dtcm0_readdata_c = dtcm0_readdata;
  assign dtcm0_response_c = dtcm0_response;
  
  wire [2:0] status_dtcm0_address;
  wire [2:0] status_dtcm0_read;
  wire [2:0] status_dtcm0_write;
  wire [2:0] status_dtcm0_writedata;
  wire [2:0] status_dtcm0_clken;
  wire [2:0] status_dtcm0_byteenable;

  tmr_maj tmr_maj_dtcm0_address (
    .a            (dtcm0_address_a),
    .b            (dtcm0_address_b),
    .c            (dtcm0_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_address),
    .q            (dtcm0_address)
  );
  defparam tmr_maj_dtcm0_address.TMR_WIDTH = TCDM_MASTER_ADDRESS_WIDTH0;

  tmr_maj tmr_maj_dtcm0_read (
    .a            (dtcm0_read_a),
    .b            (dtcm0_read_b),
    .c            (dtcm0_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_read),
    .q            (dtcm0_read)
  );
  defparam tmr_maj_dtcm0_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm0_write (
    .a            (dtcm0_write_a),
    .b            (dtcm0_write_b),
    .c            (dtcm0_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_write),
    .q            (dtcm0_write)
  );
  defparam tmr_maj_dtcm0_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm0_clken (
    .a            (dtcm0_clken_a),
    .b            (dtcm0_clken_b),
    .c            (dtcm0_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_clken),
    .q            (dtcm0_clken)
  );
  defparam tmr_maj_dtcm0_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_dtcm0_writedata (
    .a            (dtcm0_writedata_a),
    .b            (dtcm0_writedata_b),
    .c            (dtcm0_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_writedata),
    .q            (dtcm0_writedata)
  );
  defparam tmr_maj_dtcm0_writedata.TMR_WIDTH = TCDM_MASTER_DATA_WIDTH;
  
  tmr_maj tmr_maj_dtcm0_byteenable (
    .a            (dtcm0_byteenable_a),
    .b            (dtcm0_byteenable_b),
    .c            (dtcm0_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm0_byteenable),
    .q            (dtcm0_byteenable)
  );
  defparam tmr_maj_dtcm0_byteenable.TMR_WIDTH = 4;

  assign status_dtcm0[0] = status_dtcm0_address[0] | status_dtcm0_read[0] | status_dtcm0_write[0] | status_dtcm0_writedata[0] | status_dtcm0_clken[0] | status_dtcm0_byteenable[0]; 
  assign status_dtcm0[1] = status_dtcm0_address[1] | status_dtcm0_read[1] | status_dtcm0_write[1] | status_dtcm0_writedata[1] | status_dtcm0_clken[1] | status_dtcm0_byteenable[1]; 
  assign status_dtcm0[2] = status_dtcm0_address[2] | status_dtcm0_read[2] | status_dtcm0_write[2] | status_dtcm0_writedata[2] | status_dtcm0_clken[2] | status_dtcm0_byteenable[2];
  
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_readdata;
  input  [1:0]                             dtcm1_response;
  output [TCDM_MASTER_ADDRESS_WIDTH1-1:0]   dtcm1_address;
  output                                   dtcm1_read;
  output                                   dtcm1_clken;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_writedata;
  output                                   dtcm1_write;
  output [3:0]                             dtcm1_byteenable;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_readdata_a;
  output [1:0]                             dtcm1_response_a;
  input  [TCDM_MASTER_ADDRESS_WIDTH1-1:0]   dtcm1_address_a;
  input                                    dtcm1_read_a;
  input                                    dtcm1_clken_a;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_writedata_a;
  input                                    dtcm1_write_a;
  input [3:0]                              dtcm1_byteenable_a;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_readdata_b;
  output [1:0]                             dtcm1_response_b;
  input  [TCDM_MASTER_ADDRESS_WIDTH1-1:0]   dtcm1_address_b;
  input                                    dtcm1_read_b;
  input                                    dtcm1_clken_b;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_writedata_b;
  input                                    dtcm1_write_b;
  input [3:0]                              dtcm1_byteenable_b;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_readdata_c;
  output [1:0]                             dtcm1_response_c;
  input  [TCDM_MASTER_ADDRESS_WIDTH1-1:0]   dtcm1_address_c;
  input                                    dtcm1_read_c;
  input                                    dtcm1_clken_c;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm1_writedata_c;
  input                                    dtcm1_write_c;
  input [3:0]                              dtcm1_byteenable_c;
  
  // All data Master input is a pass through
  assign dtcm1_readdata_a = dtcm1_readdata;
  assign dtcm1_response_a = dtcm1_response;
  assign dtcm1_readdata_b = dtcm1_readdata;
  assign dtcm1_response_b = dtcm1_response;
  assign dtcm1_readdata_c = dtcm1_readdata;
  assign dtcm1_response_c = dtcm1_response;
  
  wire [2:0] status_dtcm1_address;
  wire [2:0] status_dtcm1_read;
  wire [2:0] status_dtcm1_write;
  wire [2:0] status_dtcm1_writedata;
  wire [2:0] status_dtcm1_clken;
  wire [2:0] status_dtcm1_byteenable;

  tmr_maj tmr_maj_dtcm1_address (
    .a            (dtcm1_address_a),
    .b            (dtcm1_address_b),
    .c            (dtcm1_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_address),
    .q            (dtcm1_address)
  );
  defparam tmr_maj_dtcm1_address.TMR_WIDTH = TCDM_MASTER_ADDRESS_WIDTH1;

  tmr_maj tmr_maj_dtcm1_read (
    .a            (dtcm1_read_a),
    .b            (dtcm1_read_b),
    .c            (dtcm1_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_read),
    .q            (dtcm1_read)
  );
  defparam tmr_maj_dtcm1_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm1_write (
    .a            (dtcm1_write_a),
    .b            (dtcm1_write_b),
    .c            (dtcm1_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_write),
    .q            (dtcm1_write)
  );
  defparam tmr_maj_dtcm1_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm1_clken (
    .a            (dtcm1_clken_a),
    .b            (dtcm1_clken_b),
    .c            (dtcm1_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_clken),
    .q            (dtcm1_clken)
  );
  defparam tmr_maj_dtcm1_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_dtcm1_writedata (
    .a            (dtcm1_writedata_a),
    .b            (dtcm1_writedata_b),
    .c            (dtcm1_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_writedata),
    .q            (dtcm1_writedata)
  );
  defparam tmr_maj_dtcm1_writedata.TMR_WIDTH = TCDM_MASTER_DATA_WIDTH;
  
  tmr_maj tmr_maj_dtcm1_byteenable (
    .a            (dtcm1_byteenable_a),
    .b            (dtcm1_byteenable_b),
    .c            (dtcm1_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm1_byteenable),
    .q            (dtcm1_byteenable)
  );
  defparam tmr_maj_dtcm1_byteenable.TMR_WIDTH = 4;

  assign status_dtcm1[0] = status_dtcm1_address[0] | status_dtcm1_read[0] | status_dtcm1_write[0] | status_dtcm1_writedata[0] | status_dtcm1_clken[0] | status_dtcm1_byteenable[0]; 
  assign status_dtcm1[1] = status_dtcm1_address[1] | status_dtcm1_read[1] | status_dtcm1_write[1] | status_dtcm1_writedata[1] | status_dtcm1_clken[1] | status_dtcm1_byteenable[1]; 
  assign status_dtcm1[2] = status_dtcm1_address[2] | status_dtcm1_read[2] | status_dtcm1_write[2] | status_dtcm1_writedata[2] | status_dtcm1_clken[2] | status_dtcm1_byteenable[2];
  
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_readdata;
  input  [1:0]                             dtcm2_response;
  output [TCDM_MASTER_ADDRESS_WIDTH2-1:0]   dtcm2_address;
  output                                   dtcm2_read;
  output                                   dtcm2_clken;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_writedata;
  output                                   dtcm2_write;
  output [3:0]                             dtcm2_byteenable;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_readdata_a;
  output [1:0]                             dtcm2_response_a;
  input  [TCDM_MASTER_ADDRESS_WIDTH2-1:0]   dtcm2_address_a;
  input                                    dtcm2_read_a;
  input                                    dtcm2_clken_a;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_writedata_a;
  input                                    dtcm2_write_a;
  input [3:0]                              dtcm2_byteenable_a;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_readdata_b;
  output [1:0]                             dtcm2_response_b;
  input  [TCDM_MASTER_ADDRESS_WIDTH2-1:0]   dtcm2_address_b;
  input                                    dtcm2_read_b;
  input                                    dtcm2_clken_b;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_writedata_b;
  input                                    dtcm2_write_b;
  input [3:0]                              dtcm2_byteenable_b;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_readdata_c;
  output [1:0]                             dtcm2_response_c;
  input  [TCDM_MASTER_ADDRESS_WIDTH2-1:0]   dtcm2_address_c;
  input                                    dtcm2_read_c;
  input                                    dtcm2_clken_c;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm2_writedata_c;
  input                                    dtcm2_write_c;
  input [3:0]                              dtcm2_byteenable_c;
  
  // All data Master input is a pass through
  assign dtcm2_readdata_a = dtcm2_readdata;
  assign dtcm2_response_a = dtcm2_response;
  assign dtcm2_readdata_b = dtcm2_readdata;
  assign dtcm2_response_b = dtcm2_response;
  assign dtcm2_readdata_c = dtcm2_readdata;
  assign dtcm2_response_c = dtcm2_response;
  
  wire [2:0] status_dtcm2_address;
  wire [2:0] status_dtcm2_read;
  wire [2:0] status_dtcm2_write;
  wire [2:0] status_dtcm2_writedata;
  wire [2:0] status_dtcm2_clken;
  wire [2:0] status_dtcm2_byteenable;

  tmr_maj tmr_maj_dtcm2_address (
    .a            (dtcm2_address_a),
    .b            (dtcm2_address_b),
    .c            (dtcm2_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_address),
    .q            (dtcm2_address)
  );
  defparam tmr_maj_dtcm2_address.TMR_WIDTH = TCDM_MASTER_ADDRESS_WIDTH2;

  tmr_maj tmr_maj_dtcm2_read (
    .a            (dtcm2_read_a),
    .b            (dtcm2_read_b),
    .c            (dtcm2_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_read),
    .q            (dtcm2_read)
  );
  defparam tmr_maj_dtcm2_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm2_write (
    .a            (dtcm2_write_a),
    .b            (dtcm2_write_b),
    .c            (dtcm2_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_write),
    .q            (dtcm2_write)
  );
  defparam tmr_maj_dtcm2_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm2_clken (
    .a            (dtcm2_clken_a),
    .b            (dtcm2_clken_b),
    .c            (dtcm2_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_clken),
    .q            (dtcm2_clken)
  );
  defparam tmr_maj_dtcm2_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_dtcm2_writedata (
    .a            (dtcm2_writedata_a),
    .b            (dtcm2_writedata_b),
    .c            (dtcm2_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_writedata),
    .q            (dtcm2_writedata)
  );
  defparam tmr_maj_dtcm2_writedata.TMR_WIDTH = TCDM_MASTER_DATA_WIDTH;
  
  tmr_maj tmr_maj_dtcm2_byteenable (
    .a            (dtcm2_byteenable_a),
    .b            (dtcm2_byteenable_b),
    .c            (dtcm2_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm2_byteenable),
    .q            (dtcm2_byteenable)
  );
  defparam tmr_maj_dtcm2_byteenable.TMR_WIDTH = 4;

  assign status_dtcm2[0] = status_dtcm2_address[0] | status_dtcm2_read[0] | status_dtcm2_write[0] | status_dtcm2_writedata[0] | status_dtcm2_clken[0] | status_dtcm2_byteenable[0]; 
  assign status_dtcm2[1] = status_dtcm2_address[1] | status_dtcm2_read[1] | status_dtcm2_write[1] | status_dtcm2_writedata[1] | status_dtcm2_clken[1] | status_dtcm2_byteenable[1]; 
  assign status_dtcm2[2] = status_dtcm2_address[2] | status_dtcm2_read[2] | status_dtcm2_write[2] | status_dtcm2_writedata[2] | status_dtcm2_clken[2] | status_dtcm2_byteenable[2];
  
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_readdata;
  input  [1:0]                             dtcm3_response;
  output [TCDM_MASTER_ADDRESS_WIDTH3-1:0]   dtcm3_address;
  output                                   dtcm3_read;
  output                                   dtcm3_clken;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_writedata;
  output                                   dtcm3_write;
  output [3:0]                             dtcm3_byteenable;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_readdata_a;
  output [1:0]                             dtcm3_response_a;
  input  [TCDM_MASTER_ADDRESS_WIDTH3-1:0]   dtcm3_address_a;
  input                                    dtcm3_read_a;
  input                                    dtcm3_clken_a;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_writedata_a;
  input                                    dtcm3_write_a;
  input [3:0]                              dtcm3_byteenable_a;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_readdata_b;
  output [1:0]                             dtcm3_response_b;
  input  [TCDM_MASTER_ADDRESS_WIDTH3-1:0]   dtcm3_address_b;
  input                                    dtcm3_read_b;
  input                                    dtcm3_clken_b;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_writedata_b;
  input                                    dtcm3_write_b;
  input [3:0]                              dtcm3_byteenable_b;
  output [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_readdata_c;
  output [1:0]                             dtcm3_response_c;
  input  [TCDM_MASTER_ADDRESS_WIDTH3-1:0]   dtcm3_address_c;
  input                                    dtcm3_read_c;
  input                                    dtcm3_clken_c;
  input  [TCDM_MASTER_DATA_WIDTH-1:0]      dtcm3_writedata_c;
  input                                    dtcm3_write_c;
  input [3:0]                              dtcm3_byteenable_c;
  
  // All data Master input is a pass through
  assign dtcm3_readdata_a = dtcm3_readdata;
  assign dtcm3_response_a = dtcm3_response;
  assign dtcm3_readdata_b = dtcm3_readdata;
  assign dtcm3_response_b = dtcm3_response;
  assign dtcm3_readdata_c = dtcm3_readdata;
  assign dtcm3_response_c = dtcm3_response;
  
  wire [2:0] status_dtcm3_address;
  wire [2:0] status_dtcm3_read;
  wire [2:0] status_dtcm3_write;
  wire [2:0] status_dtcm3_writedata;
  wire [2:0] status_dtcm3_clken;
  wire [2:0] status_dtcm3_byteenable;

  tmr_maj tmr_maj_dtcm3_address (
    .a            (dtcm3_address_a),
    .b            (dtcm3_address_b),
    .c            (dtcm3_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_address),
    .q            (dtcm3_address)
  );
  defparam tmr_maj_dtcm3_address.TMR_WIDTH = TCDM_MASTER_ADDRESS_WIDTH3;

  tmr_maj tmr_maj_dtcm3_read (
    .a            (dtcm3_read_a),
    .b            (dtcm3_read_b),
    .c            (dtcm3_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_read),
    .q            (dtcm3_read)
  );
  defparam tmr_maj_dtcm3_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm3_write (
    .a            (dtcm3_write_a),
    .b            (dtcm3_write_b),
    .c            (dtcm3_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_write),
    .q            (dtcm3_write)
  );
  defparam tmr_maj_dtcm3_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dtcm3_clken (
    .a            (dtcm3_clken_a),
    .b            (dtcm3_clken_b),
    .c            (dtcm3_clken_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_clken),
    .q            (dtcm3_clken)
  );
  defparam tmr_maj_dtcm3_clken.TMR_WIDTH = 1;

  tmr_maj tmr_maj_dtcm3_writedata (
    .a            (dtcm3_writedata_a),
    .b            (dtcm3_writedata_b),
    .c            (dtcm3_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_writedata),
    .q            (dtcm3_writedata)
  );
  defparam tmr_maj_dtcm3_writedata.TMR_WIDTH = TCDM_MASTER_DATA_WIDTH;
  
  tmr_maj tmr_maj_dtcm3_byteenable (
    .a            (dtcm3_byteenable_a),
    .b            (dtcm3_byteenable_b),
    .c            (dtcm3_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dtcm3_byteenable),
    .q            (dtcm3_byteenable)
  );
  defparam tmr_maj_dtcm3_byteenable.TMR_WIDTH = 4;

  assign status_dtcm3[0] = status_dtcm3_address[0] | status_dtcm3_read[0] | status_dtcm3_write[0] | status_dtcm3_writedata[0] | status_dtcm3_clken[0] | status_dtcm3_byteenable[0]; 
  assign status_dtcm3[1] = status_dtcm3_address[1] | status_dtcm3_read[1] | status_dtcm3_write[1] | status_dtcm3_writedata[1] | status_dtcm3_clken[1] | status_dtcm3_byteenable[1]; 
  assign status_dtcm3[2] = status_dtcm3_address[2] | status_dtcm3_read[2] | status_dtcm3_write[2] | status_dtcm3_writedata[2] | status_dtcm3_clken[2] | status_dtcm3_byteenable[2];
  

  input [31:0]  ihp_readdata;
  input         ihp_waitrequest;
  input [1:0]   ihp_response;
  input         ihp_readdatavalid;
  output [IHP_MASTER_ADDRESS_WIDTH-1:0]   ihp_address;
  output        ihp_read;
  output [31:0]  ihp_readdata_a;
  output         ihp_waitrequest_a;
  output [1:0]   ihp_response_a;
  output         ihp_readdatavalid_a;
  input [IHP_MASTER_ADDRESS_WIDTH-1:0]   ihp_address_a;
  input          ihp_read_a;
  output [31:0]  ihp_readdata_b;
  output         ihp_waitrequest_b;
  output [1:0]   ihp_response_b;
  output         ihp_readdatavalid_b;
  input [IHP_MASTER_ADDRESS_WIDTH-1:0]   ihp_address_b;
  input          ihp_read_b;
  output [31:0]  ihp_readdata_c;
  output         ihp_waitrequest_c;
  output [1:0]   ihp_response_c;
  output         ihp_readdatavalid_c;
  input [IHP_MASTER_ADDRESS_WIDTH-1:0]   ihp_address_c;
  input          ihp_read_c;
  
  // All data Master input is a pass through
  assign ihp_readdata_a = ihp_readdata;
  assign ihp_waitrequest_a = ihp_waitrequest;
  assign ihp_response_a = ihp_response;
  assign ihp_readdatavalid_a = ihp_readdatavalid;
  assign ihp_readdata_b = ihp_readdata;
  assign ihp_waitrequest_b = ihp_waitrequest;
  assign ihp_response_b = ihp_response;
  assign ihp_readdatavalid_b = ihp_readdatavalid;
  assign ihp_readdata_c = ihp_readdata;
  assign ihp_waitrequest_c = ihp_waitrequest;
  assign ihp_response_c = ihp_response;
  assign ihp_readdatavalid_c = ihp_readdatavalid;
  
  wire [2:0] status_ihp_address;
  wire [2:0] status_ihp_read;
  
  tmr_maj tmr_maj_ihp_address (
    .a            (ihp_address_a),
    .b            (ihp_address_b),
    .c            (ihp_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_ihp_address),
    .q            (ihp_address)
  );
  defparam tmr_maj_ihp_address.TMR_WIDTH = IHP_MASTER_ADDRESS_WIDTH;

  tmr_maj tmr_maj_ihp_read (
    .a            (ihp_read_a),
    .b            (ihp_read_b),
    .c            (ihp_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_ihp_read),
    .q            (ihp_read)
  );
  defparam tmr_maj_ihp_read.TMR_WIDTH = 1;
  
  assign status_ihp[0] = status_ihp_address[0] | status_ihp_read[0]; 
  assign status_ihp[1] = status_ihp_address[1] | status_ihp_read[1]; 
  assign status_ihp[2] = status_ihp_address[2] | status_ihp_read[2]; 
  
  input [31:0]  dhp_readdata;
  input         dhp_waitrequest;
  input [1:0]   dhp_response;
  input         dhp_readdatavalid;
  output [DHP_MASTER_ADDRESS_WIDTH-1:0]     dhp_address;
  output        dhp_read;
  output        dhp_write;
  output [31:0] dhp_writedata;
  output [3:0]  dhp_byteenable;
  output [31:0]  dhp_readdata_a;
  output         dhp_waitrequest_a;
  output [1:0]   dhp_response_a;
  output         dhp_readdatavalid_a;
  input [DHP_MASTER_ADDRESS_WIDTH-1:0]     dhp_address_a;
  input        dhp_read_a;
  input        dhp_write_a;
  input [31:0] dhp_writedata_a;
  input [3:0]  dhp_byteenable_a;
  output [31:0]  dhp_readdata_b;
  output         dhp_waitrequest_b;
  output [1:0]   dhp_response_b;
  output         dhp_readdatavalid_b;
  input [DHP_MASTER_ADDRESS_WIDTH-1:0]     dhp_address_b;
  input        dhp_read_b;
  input        dhp_write_b;
  input [31:0] dhp_writedata_b;
  input [3:0]  dhp_byteenable_b;
  output [31:0]  dhp_readdata_c;
  output         dhp_waitrequest_c;
  output [1:0]   dhp_response_c;
  output         dhp_readdatavalid_c;
  input [DHP_MASTER_ADDRESS_WIDTH-1:0]     dhp_address_c;
  input        dhp_read_c;
  input        dhp_write_c;
  input [31:0] dhp_writedata_c;
  input [3:0]  dhp_byteenable_c;
    
  
      // All data Master input is a pass through
  assign dhp_readdata_a = dhp_readdata;
  assign dhp_waitrequest_a = dhp_waitrequest;
  assign dhp_response_a = dhp_response;
  assign dhp_readdatavalid_a = dhp_readdatavalid;
  assign dhp_readdata_b = dhp_readdata;
  assign dhp_waitrequest_b = dhp_waitrequest;
  assign dhp_response_b = dhp_response;
  assign dhp_readdatavalid_b = dhp_readdatavalid;
  assign dhp_readdata_c = dhp_readdata;
  assign dhp_waitrequest_c = dhp_waitrequest;
  assign dhp_response_c = dhp_response;
  assign dhp_readdatavalid_c = dhp_readdatavalid;
  
  wire [2:0] status_dhp_address;
  wire [2:0] status_dhp_read;
  wire [2:0] status_dhp_write;
  wire [2:0] status_dhp_writedata;
  wire [2:0] status_dhp_byteenable;
  
  tmr_maj tmr_maj_dhp_address (
    .a            (dhp_address_a),
    .b            (dhp_address_b),
    .c            (dhp_address_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dhp_address),
    .q            (dhp_address)
  );
  defparam tmr_maj_dhp_address.TMR_WIDTH = DHP_MASTER_ADDRESS_WIDTH;

  tmr_maj tmr_maj_dhp_read (
    .a            (dhp_read_a),
    .b            (dhp_read_b),
    .c            (dhp_read_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dhp_read),
    .q            (dhp_read)
  );
  defparam tmr_maj_dhp_read.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dhp_write (
    .a            (dhp_write_a),
    .b            (dhp_write_b),
    .c            (dhp_write_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dhp_write),
    .q            (dhp_write)
  );
  defparam tmr_maj_dhp_write.TMR_WIDTH = 1;
  
  tmr_maj tmr_maj_dhp_writedata (
    .a            (dhp_writedata_a),
    .b            (dhp_writedata_b),
    .c            (dhp_writedata_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dhp_writedata),
    .q            (dhp_writedata)
  );
  defparam tmr_maj_dhp_writedata.TMR_WIDTH = 32;
  
  tmr_maj tmr_maj_dhp_byteenable (
    .a            (dhp_byteenable_a),
    .b            (dhp_byteenable_b),
    .c            (dhp_byteenable_c),
    .en           (enable),
    .control_in   (control),
    .status_out   (status_dhp_byteenable),
    .q            (dhp_byteenable)
  );
  defparam tmr_maj_dhp_byteenable.TMR_WIDTH = 4;
  
  assign status_dhp[0] = status_dhp_address[0] | status_dhp_read[0] | status_dhp_write[0] | status_dhp_writedata[0] | status_dhp_byteenable[0]; 
  assign status_dhp[1] = status_dhp_address[1] | status_dhp_read[1] | status_dhp_write[1] | status_dhp_writedata[1] | status_dhp_byteenable[1]; 
  assign status_dhp[2] = status_dhp_address[2] | status_dhp_read[2] | status_dhp_write[2] | status_dhp_writedata[2] | status_dhp_byteenable[2]; 
  
  
  // OR all the MAJ blocks together
  assign mega_or_signal[0] = status_i[0] | status_fa[0] | status_d[0] | status_itcm0[0] | status_itcm1[0] | status_itcm2[0] | status_itcm3[0] | status_dtcm0[0] | status_dtcm1[0] | status_dtcm2[0] | status_dtcm3[0] | status_ihp[0] | status_dhp[0];
  assign mega_or_signal[1] = status_i[1] | status_fa[1] | status_d[1] | status_itcm0[1] | status_itcm1[1] | status_itcm2[1] | status_itcm3[1] | status_dtcm0[1] | status_dtcm1[1] | status_dtcm2[1] | status_dtcm3[1] | status_ihp[1] | status_dhp[1];
  assign mega_or_signal[2] = status_i[2] | status_fa[2] | status_d[2] | status_itcm0[2] | status_itcm1[2] | status_itcm2[2] | status_itcm3[2] | status_dtcm0[2] | status_dtcm1[2] | status_dtcm2[2] | status_dtcm3[2] | status_ihp[2] | status_dhp[2];

  tmr_maj_control tmr_maj_control_inst (
    .clk              (clk),
    .reset_n          (reset_n),
    .core_comparison  (mega_or_signal),
    .control_out      (control),
    .interrupt        (tmr_interrupt),
    .reset_request    (tmr_reset_request),
    .error_injection  (tmr_err_inj)
  );
 
  // Non TMR Port
  // All debug ports, The output will be take from Nios A directly while input will be fan out to all three cores
  // Debug Mem Slave Interface
  input  [8:0] debug_mem_slave_address; 
  input  [3:0] debug_mem_slave_byteenable;
  input  debug_mem_slave_debugaccess;
  input  debug_mem_slave_read; 
  input  debug_mem_slave_write;
  input  [31:0] debug_mem_slave_writedata;
  output [31:0] debug_mem_slave_readdata; 
  output debug_mem_slave_waitrequest;
  
  output  [8:0] debug_mem_slave_address_a; 
  output  [3:0] debug_mem_slave_byteenable_a;
  output        debug_mem_slave_debugaccess_a;
  output        debug_mem_slave_read_a; 
  output        debug_mem_slave_write_a;
  output  [31:0] debug_mem_slave_writedata_a; 
  input   [31:0] debug_mem_slave_readdata_a; 
  input          debug_mem_slave_waitrequest_a;
  
  output  [8:0] debug_mem_slave_address_b; 
  output  [3:0] debug_mem_slave_byteenable_b;
  output        debug_mem_slave_debugaccess_b;
  output        debug_mem_slave_read_b; 
  output        debug_mem_slave_write_b;
  output  [31:0] debug_mem_slave_writedata_b;
  input   [31:0] debug_mem_slave_readdata_b; 
  input          debug_mem_slave_waitrequest_b;
  
  output  [8:0] debug_mem_slave_address_c; 
  output  [3:0] debug_mem_slave_byteenable_c;
  output        debug_mem_slave_debugaccess_c;
  output        debug_mem_slave_read_c; 
  output        debug_mem_slave_write_c;
  output  [31:0] debug_mem_slave_writedata_c;
  input   [31:0] debug_mem_slave_readdata_c; 
  input          debug_mem_slave_waitrequest_c;
  
  // Just get the output from Nios A and send it back
  // Other signals are not connected
  assign debug_mem_slave_readdata     = debug_mem_slave_readdata_a;
  assign debug_mem_slave_waitrequest  = debug_mem_slave_waitrequest_a;
  assign debug_mem_slave_address_a    =   debug_mem_slave_address;     
  assign debug_mem_slave_byteenable_a =   debug_mem_slave_byteenable;
  assign debug_mem_slave_debugaccess_a  = debug_mem_slave_debugaccess;
  assign debug_mem_slave_read_a         = debug_mem_slave_read;        
  assign debug_mem_slave_write_a        = debug_mem_slave_write;
  assign debug_mem_slave_writedata_a    =  debug_mem_slave_writedata;
  assign debug_mem_slave_address_b    =   debug_mem_slave_address;     
  assign debug_mem_slave_byteenable_b =   debug_mem_slave_byteenable;
  assign debug_mem_slave_debugaccess_b  = debug_mem_slave_debugaccess;
  assign debug_mem_slave_read_b         = debug_mem_slave_read;        
  assign debug_mem_slave_write_b        = debug_mem_slave_write;
  assign debug_mem_slave_writedata_b    =  debug_mem_slave_writedata;
  assign debug_mem_slave_address_c    =   debug_mem_slave_address;     
  assign debug_mem_slave_byteenable_c =   debug_mem_slave_byteenable;
  assign debug_mem_slave_debugaccess_c  = debug_mem_slave_debugaccess;
  assign debug_mem_slave_read_c         = debug_mem_slave_read;        
  assign debug_mem_slave_write_c        = debug_mem_slave_write;
  assign debug_mem_slave_writedata_c    =  debug_mem_slave_writedata;  
 
  // Debug host slave for OCI V2
  input  [7:0]  debug_host_slave_address; 
  input         debug_host_slave_read; 
  input         debug_host_slave_write;
  input  [31:0] debug_host_slave_writedata;
  output [31:0] debug_host_slave_readdata; 
  output        debug_host_slave_waitrequest;
  
  output [7:0]  debug_host_slave_address_a; 
  output        debug_host_slave_read_a; 
  output        debug_host_slave_write_a;
  output [31:0] debug_host_slave_writedata_a;
  input  [31:0] debug_host_slave_readdata_a; 
  input         debug_host_slave_waitrequest_a;
  
  output [7:0]  debug_host_slave_address_b; 
  output        debug_host_slave_read_b; 
  output        debug_host_slave_write_b;
  output [31:0] debug_host_slave_writedata_b;
  input  [31:0] debug_host_slave_readdata_b; 
  input         debug_host_slave_waitrequest_b;
  
  output [7:0]  debug_host_slave_address_c; 
  output        debug_host_slave_read_c; 
  output        debug_host_slave_write_c;
  output [31:0] debug_host_slave_writedata_c;
  input  [31:0] debug_host_slave_readdata_c; 
  input         debug_host_slave_waitrequest_c;
  // Just get the output from Nios A and send it back
  // Other signals are not connected
  assign debug_host_slave_readdata     = debug_host_slave_readdata_a;
  assign debug_host_slave_waitrequest  = debug_host_slave_waitrequest_a;
  assign debug_host_slave_address_a    = debug_host_slave_address; 
  assign debug_host_slave_read_a       = debug_host_slave_read;
  assign debug_host_slave_write_a      = debug_host_slave_write;
  assign debug_host_slave_writedata_a  = debug_host_slave_writedata;
  assign debug_host_slave_address_b    = debug_host_slave_address; 
  assign debug_host_slave_read_b       = debug_host_slave_read;
  assign debug_host_slave_write_b      = debug_host_slave_write;
  assign debug_host_slave_writedata_b  = debug_host_slave_writedata; 
  assign debug_host_slave_address_c    = debug_host_slave_address; 
  assign debug_host_slave_read_c       = debug_host_slave_read;
  assign debug_host_slave_write_c      = debug_host_slave_write;
  assign debug_host_slave_writedata_c  = debug_host_slave_writedata;
  
  input  [DEBUG_TRACE_ADDRESS_WIDTH-1:0] debug_trace_slave_address;
  input         debug_trace_slave_read;
  output [31:0] debug_trace_slave_readdata;
 
  output  [DEBUG_TRACE_ADDRESS_WIDTH-1:0] debug_trace_slave_address_a;
  output       debug_trace_slave_read_a;
  input [31:0] debug_trace_slave_readdata_a;
  
  output  [DEBUG_TRACE_ADDRESS_WIDTH-1:0] debug_trace_slave_address_b;
  output       debug_trace_slave_read_b;
  input [31:0] debug_trace_slave_readdata_b;

  output  [DEBUG_TRACE_ADDRESS_WIDTH-1:0] debug_trace_slave_address_c;
  output       debug_trace_slave_read_c;
  input [31:0] debug_trace_slave_readdata_c;
  
  assign debug_trace_slave_readdata = debug_trace_slave_readdata_a;
  assign debug_trace_slave_address_a = debug_trace_slave_address;
  assign debug_trace_slave_read_a = debug_trace_slave_read;
  assign debug_trace_slave_address_b = debug_trace_slave_address;
  assign debug_trace_slave_read_b = debug_trace_slave_read;
  assign debug_trace_slave_address_c = debug_trace_slave_address;
  assign debug_trace_slave_read_c = debug_trace_slave_read;
  
  input debug_reset_request_a;
  output debug_reset_request;
  
  assign debug_reset_request = debug_reset_request_a;
  
  input  [1:0 ] debug_extra;
  output [1:0 ] debug_extra_a;
  output [1:0 ] debug_extra_b;
  output [1:0 ] debug_extra_c;
  
  assign debug_extra_a = debug_extra;
  assign debug_extra_b = debug_extra;
  assign debug_extra_c = debug_extra;
  
  input   [8:0]  avalon_debug_port_address;
  output  [31:0] avalon_debug_port_readdata;
  input          avalon_debug_port_write;
  input          avalon_debug_port_read;
  input   [31:0] avalon_debug_port_writedata;
  output  [8:0]  avalon_debug_port_address_a;
  input   [31:0] avalon_debug_port_readdata_a;
  output         avalon_debug_port_write_a;
  output         avalon_debug_port_read_a;
  output  [31:0] avalon_debug_port_writedata_a;
  output  [8:0]  avalon_debug_port_address_b;
  input   [31:0] avalon_debug_port_readdata_b;
  output         avalon_debug_port_write_b;
  output         avalon_debug_port_read_b;
  output  [31:0] avalon_debug_port_writedata_b;
  output  [8:0]  avalon_debug_port_address_c;
  input   [31:0] avalon_debug_port_readdata_c;
  output         avalon_debug_port_write_c;
  output         avalon_debug_port_read_c;
  output  [31:0] avalon_debug_port_writedata_c;
    
  assign avalon_debug_port_readdata = avalon_debug_port_readdata_a;
  assign avalon_debug_port_address_a = avalon_debug_port_address;
  assign avalon_debug_port_write_a = avalon_debug_port_write;
  assign avalon_debug_port_read_a = avalon_debug_port_read;
  assign avalon_debug_port_writedata_a = avalon_debug_port_writedata;
  assign avalon_debug_port_address_b = avalon_debug_port_address;
  assign avalon_debug_port_write_b = avalon_debug_port_write;
  assign avalon_debug_port_read_b = avalon_debug_port_read;
  assign avalon_debug_port_writedata_b = avalon_debug_port_writedata;
  assign avalon_debug_port_address_c = avalon_debug_port_address;
  assign avalon_debug_port_write_c = avalon_debug_port_write;
  assign avalon_debug_port_read_c = avalon_debug_port_read;
  assign avalon_debug_port_writedata_c = avalon_debug_port_writedata;

  input        eic_port_valid;
  input [44:0] eic_port_data;
  output       eic_port_valid_a;
  output[44:0] eic_port_data_a;
  output       eic_port_valid_b;
  output[44:0] eic_port_data_b;
  output       eic_port_valid_c;
  output[44:0] eic_port_data_c;
  
  assign eic_port_valid_a = eic_port_valid;
  assign eic_port_data_a = eic_port_data;
  assign eic_port_valid_b = eic_port_valid;
  assign eic_port_data_b = eic_port_data;
  assign eic_port_valid_c = eic_port_valid;
  assign eic_port_data_c = eic_port_data;
  
  // Conduits
  output debug_ack;
  input  debug_req;
  output debug_trigout;
  input  debug_ack_a;
  output debug_req_a;
  input  debug_trigout_a;
  input  debug_ack_b;
  output debug_req_b;
  input  debug_trigout_b;
  input  debug_ack_c;
  output debug_req_c;
  input  debug_trigout_c;
  
  assign debug_ack = debug_ack_a;
  assign debug_trigout = debug_trigout_a;
  assign debug_req_a = debug_req;
  assign debug_req_b = debug_req;
  assign debug_req_c = debug_req;
  
  input [VECTOR_WIDTH-1:0]     reset_vector_word_addr;
  input [VECTOR_WIDTH-1:0]     exception_vector_word_addr;
  input [VECTOR_WIDTH-1:0]     fast_tlb_miss_vector_word_addr;
  output [VECTOR_WIDTH-1:0]     reset_vector_word_addr_a;
  output [VECTOR_WIDTH-1:0]     exception_vector_word_addr_a;
  output [VECTOR_WIDTH-1:0]     fast_tlb_miss_vector_word_addr_a;
  output [VECTOR_WIDTH-1:0]     reset_vector_word_addr_b;
  output [VECTOR_WIDTH-1:0]     exception_vector_word_addr_b;
  output [VECTOR_WIDTH-1:0]     fast_tlb_miss_vector_word_addr_b;
  output [VECTOR_WIDTH-1:0]     reset_vector_word_addr_c;
  output [VECTOR_WIDTH-1:0]     exception_vector_word_addr_c;
  output [VECTOR_WIDTH-1:0]     fast_tlb_miss_vector_word_addr_c;
  
  assign reset_vector_word_addr_a         = reset_vector_word_addr;
  assign exception_vector_word_addr_a     = exception_vector_word_addr;  
  assign fast_tlb_miss_vector_word_addr_a = fast_tlb_miss_vector_word_addr; 
  assign reset_vector_word_addr_b         = reset_vector_word_addr;
  assign exception_vector_word_addr_b     = exception_vector_word_addr;  
  assign fast_tlb_miss_vector_word_addr_b = fast_tlb_miss_vector_word_addr;
  assign reset_vector_word_addr_c         = reset_vector_word_addr;
  assign exception_vector_word_addr_c     = exception_vector_word_addr;  
  assign fast_tlb_miss_vector_word_addr_c = fast_tlb_miss_vector_word_addr;
  
  output [1:0]  vji_ir_out;
  output        vji_tdo;
  input         vji_cdr;
  input  [1:0]  vji_ir_in;
  input         vji_rti;
  input         vji_sdr;
  input         vji_tck;
  input         vji_tdi;
  input         vji_udr;
  input         vji_uir;
  input  [1:0]  vji_ir_out_a;
  input         vji_tdo_a;
  output        vji_cdr_a;
  output  [1:0] vji_ir_in_a;
  output        vji_rti_a;
  output        vji_sdr_a;
  output        vji_tck_a;
  output        vji_tdi_a;
  output        vji_udr_a;
  output        vji_uir_a; 
  input  [1:0]  vji_ir_out_b;
  input         vji_tdo_b;
  output        vji_cdr_b;
  output  [1:0] vji_ir_in_b;
  output        vji_rti_b;
  output        vji_sdr_b;
  output        vji_tck_b;
  output        vji_tdi_b;
  output        vji_udr_b;
  output        vji_uir_b;
  input  [1:0]  vji_ir_out_c;
  input         vji_tdo_c;
  output        vji_cdr_c;
  output  [1:0] vji_ir_in_c;
  output        vji_rti_c;
  output        vji_sdr_c;
  output        vji_tck_c;
  output        vji_tdi_c;
  output        vji_udr_c;
  output        vji_uir_c;

  assign vji_ir_out = vji_ir_out_a;
  assign vji_tdo = vji_tdo_a;

  assign vji_ir_in_a = vji_ir_in;
  assign vji_rti_a   = vji_rti;
  assign vji_sdr_a   = vji_sdr;
  assign vji_cdr_a   = vji_cdr;
  assign vji_tck_a   = vji_tck;
  assign vji_tdi_a   = vji_tdi;
  assign vji_udr_a   = vji_udr;
  assign vji_uir_a   = vji_uir;
  assign vji_ir_in_b = vji_ir_in;
  assign vji_rti_b   = vji_rti;
  assign vji_sdr_b   = vji_sdr;
  assign vji_cdr_b   = vji_cdr;
  assign vji_tck_b   = vji_tck;
  assign vji_tdi_b   = vji_tdi;
  assign vji_udr_b   = vji_udr;
  assign vji_uir_b   = vji_uir; 
  assign vji_ir_in_c = vji_ir_in;
  assign vji_rti_c   = vji_rti;
  assign vji_sdr_c   = vji_sdr;
  assign vji_cdr_c   = vji_cdr;
  assign vji_tck_c   = vji_tck;
  assign vji_tdi_c   = vji_tdi;
  assign vji_udr_c   = vji_udr;
  assign vji_uir_c   = vji_uir; 
  
  input debug_reset;
  output debug_reset_a;
  output debug_reset_b;
  output debug_reset_c;
  
  assign debug_reset_a = debug_reset;
  assign debug_reset_b = debug_reset;
  assign debug_reset_c = debug_reset;
  
  input  cpu_resetrequest;
  output cpu_resettaken;
  output cpu_resetrequest_a;
  input  cpu_resettaken_a;
  output cpu_resetrequest_b;
  input  cpu_resettaken_b;
  output cpu_resetrequest_c;
  input  cpu_resettaken_c;
  
  // Any resettaken
  assign cpu_resettaken = cpu_resettaken_a | cpu_resettaken_b | cpu_resettaken_c;
  assign cpu_resetrequest_a = cpu_resetrequest;
  assign cpu_resetrequest_b = cpu_resetrequest;
  assign cpu_resetrequest_c = cpu_resetrequest;
    
  output [35:0] debug_offchip_trace_data;
  input [35:0] debug_offchip_trace_data_a;
  input [35:0] debug_offchip_trace_data_b;
  input [35:0] debug_offchip_trace_data_c;
  // use only trace data from nios A
  assign debug_offchip_trace_data = debug_offchip_trace_data_a;

  assign enable = tmr_output_disable_n;
endmodule

