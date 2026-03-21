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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altera_rapidio_top
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
     parameter DEVICE_FAMILY                   = "Arria 10",
     parameter mode_selection              = "SERIAL_1X",
     parameter p_TX_PORT_WRITE               = 1'b0,
     parameter p_RX_PORT_WRITE               = 1'b0,
     parameter p_DRBELL_TX                   = 1'b0,
     parameter p_DRBELL_RX                   = 1'b0,
     parameter p_TRANSPORT_LARGE             = 1'b0,
     parameter p_SEND_RESET_DEVICE = 1'b0,     
     parameter p_GENERIC_LOGICAL = 1'b0,
     parameter p_IO_SLAVE_WIDTH = 30,
     parameter p_MAINTENANCE = 1'b1,
     parameter p_IO_MASTER = 1'b1,
     parameter p_IO_SLAVE = 1'b1,
     parameter p_timeout_enable = 1'b1,
     parameter p_SOURCE_OPERATION_DATA_MESSAGE = 1'b0,
     parameter p_DESTINATION_OPERATION_DATA_MESSAGE = 1'b0,
     parameter XCVR_RECONFIG    = 1'b1,
     parameter NUMBER_OF_XCVR_CHANNELS = (mode_selection == "SERIAL_1X")? 1: ((mode_selection == "SERIAL_2X")? 2: 4),
     parameter XCVR_NUMBER_OF_BYTE  = ((mode_selection == "SERIAL_2X")? 4: 2),
     parameter p_ADAT = ((mode_selection == "SERIAL_1X")? 32: 64),
     parameter p_ADAT_SIZE_WIDTH = ((p_ADAT == 64)? 6 : 7),
     parameter p_ADAT_BYTEENABLE_WIDTH = ((p_ADAT == 64)? 8 : 4),
     parameter p_ADAT_MTY_WIDTH = ((p_ADAT == 64)? 3 : 2),
     parameter p_IO_SLAVE_ADDRESS_LSB = ((p_ADAT == 64) ? 3 : 2),
     parameter MAINTENANCE_ADDRESS_WIDTH = 26

)
(
//--------------------------------------------------------------------------------
//------------- Transceiver Related Ports ----------------------------------------
//--------------------------------------------------------------------------------
    output [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_ctrldetect,
    output [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_patterndetect, 
    output [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_errdetect,
    input [NUMBER_OF_XCVR_CHANNELS - 1:0]   tx_analogreset,     //     tx_analogreset.tx_analogreset
    input [NUMBER_OF_XCVR_CHANNELS - 1:0]   tx_digitalreset,    //    tx_digitalreset.tx_digitalreset
    input [NUMBER_OF_XCVR_CHANNELS - 1:0]   rx_analogreset,     //     rx_analogreset.rx_analogreset
    input [NUMBER_OF_XCVR_CHANNELS - 1:0]   rx_digitalreset,    //    rx_digitalreset.rx_digitalreset
    output [NUMBER_OF_XCVR_CHANNELS - 1:0]  tx_cal_busy,        //        tx_cal_busy.tx_cal_busy
    output [NUMBER_OF_XCVR_CHANNELS - 1:0]   rx_cal_busy,        //        rx_cal_busy.rx_cal_busy

    input  [(NUMBER_OF_XCVR_CHANNELS*6) -1 :0] tx_bonding_clocks,     //     tx_serial_clk0.clk
    input   clk,     //     rx_cdr_refclk0.clk
    input [NUMBER_OF_XCVR_CHANNELS-1:0] reconfig_clk,
    input [NUMBER_OF_XCVR_CHANNELS-1:0] reconfig_reset,
    input [NUMBER_OF_XCVR_CHANNELS-1:0] reconfig_write,
    input [NUMBER_OF_XCVR_CHANNELS-1:0] reconfig_read,
    input [(NUMBER_OF_XCVR_CHANNELS*10)-1:0] reconfig_address,
    input [(NUMBER_OF_XCVR_CHANNELS*32)-1:0] reconfig_writedata,
    output [(NUMBER_OF_XCVR_CHANNELS*32)-1:0] reconfig_readdata,
    output [NUMBER_OF_XCVR_CHANNELS-1:0] reconfig_waitrequest,
    output  [NUMBER_OF_XCVR_CHANNELS-1:0] td,     //     tx_serial_data.tx_serial_data
    input  [NUMBER_OF_XCVR_CHANNELS-1:0] rd,     //     rx_serial_data.rx_serial_data
    output [NUMBER_OF_XCVR_CHANNELS-1:0] rx_is_lockedtoref,  //  rx_is_lockedtoref.rx_is_lockedtoref
    output [NUMBER_OF_XCVR_CHANNELS-1:0] rx_is_lockedtodata, // rx_is_lockedtodata.rx_is_lockedtodata
    output wire rxclk,
    output wire txclk,
    output wire rxgxbclk,
    input gxbpll_locked,
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------	 
	
//--------------------------------------------------------------------------------
//--------------RapidIO Gen 1 Soft logic Core Ports-------------------------------
//--------------------------------------------------------------------------------
    
    input sysclk,
    input reset_n,
    input [15:0] ef_ptr,
    input io_m_wr_waitrequest,
    output io_m_wr_write,
    output [31:0] io_m_wr_address,
    output [p_ADAT - 1:0] io_m_wr_writedata,
    output [p_ADAT_BYTEENABLE_WIDTH - 1:0]  io_m_wr_byteenable,
    output [p_ADAT_SIZE_WIDTH - 1:0] io_m_wr_burstcount,
    input io_m_rd_waitrequest,
    output io_m_rd_read,
    output [31:0] io_m_rd_address,
    input io_m_rd_readdatavalid,
    input io_m_rd_readerror,
    input [p_ADAT - 1:0] io_m_rd_readdata,
    output [p_ADAT_SIZE_WIDTH - 1:0] io_m_rd_burstcount,
    input io_s_wr_chipselect,
    output io_s_wr_waitrequest,
    input io_s_wr_write,
    input [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_wr_address,
    input [p_ADAT - 1:0] io_s_wr_writedata,
    input [p_ADAT_BYTEENABLE_WIDTH - 1:0] io_s_wr_byteenable,
    input [p_ADAT_SIZE_WIDTH - 1:0] io_s_wr_burstcount,
    input io_s_rd_chipselect,
    output io_s_rd_waitrequest,
    input io_s_rd_read,
    input [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_rd_address,
    output io_s_rd_readdatavalid,
    output [p_ADAT - 1:0] io_s_rd_readdata,
    input [p_ADAT_SIZE_WIDTH - 1:0] io_s_rd_burstcount,
    output io_s_rd_readerror,
    input mnt_m_waitrequest,
    output mnt_m_read,
    output mnt_m_write,
    output [31:0] mnt_m_address,
    output [31:0] mnt_m_writedata,
    input [31:0] mnt_m_readdata,
    input mnt_m_readdatavalid,
    input mnt_s_chipselect,
    output mnt_s_waitrequest,
    input mnt_s_read,
    input mnt_s_write,
    input[MAINTENANCE_ADDRESS_WIDTH - 3:0] mnt_s_address,
    input[31:0] mnt_s_writedata,
    output[31:0] mnt_s_readdata,
    output mnt_s_readerror,
    output mnt_s_readdatavalid,
    input sys_mnt_s_chipselect,
    output sys_mnt_s_waitrequest,
    input sys_mnt_s_read,
    input sys_mnt_s_write,
    input [14:0] sys_mnt_s_address,
    input [31:0] sys_mnt_s_writedata,
    output [31:0] sys_mnt_s_readdata,
    output sys_mnt_s_irq,
    output rx_packet_dropped,
    output master_enable,
    input output_enable,
    input input_enable,
    output port_initialized,
    output[8:0] atxwlevel,
    output atxovf,
    output[9:0] arxwlevel,
    output buf_av0,
    output buf_av1,
    output buf_av2,
    output buf_av3,
    output packet_transmitted,
    output packet_cancelled,
    output packet_accepted,
    output packet_retry,
    output packet_not_accepted,
    output packet_crc_error,
    output symbol_error,
    output port_error,
    output char_err,
    output multicast_event_rx,
    input multicast_event_tx,
    output wire gen_tx_ready,
    input  gen_tx_valid,
    input  gen_tx_startofpacket,
    input  gen_tx_endofpacket,
    input  gen_tx_error,
    input  [p_ADAT_MTY_WIDTH-1:0] gen_tx_empty,
    input  [p_ADAT-1:0] gen_tx_data,
    input   gen_rx_ready,
    output wire gen_rx_valid,
    output wire gen_rx_startofpacket,
    output wire gen_rx_endofpacket,
    output wire [p_ADAT_MTY_WIDTH-1:0] gen_rx_empty,
    output wire [p_ADAT-1:0] gen_rx_data,
    output wire [p_ADAT_SIZE_WIDTH-1:0] gen_rx_size,
    input              drbell_s_chipselect,
    output wire        drbell_s_waitrequest,
    input              drbell_s_read,
    input              drbell_s_write,
    input [3:0] drbell_s_address,
    input [31:0]       drbell_s_writedata,
    output wire [31:0] drbell_s_readdata,
    output wire        drbell_s_irq,
    input[9:0] rx_threshold_0,
    input[9:0] rx_threshold_1,
    input[9:0] rx_threshold_2,
    input[6:0] txclk_timeout_prescaler,
    input[6:0] sysclk_timeout_prescaler,
    input[15:0] device_identifier,
    input[15:0] device_vendor_id,
    input[31:0] device_revision,
    input[15:0] assembly_id,
    input[15:0] assembly_vendor_id,
    input[15:0] assembly_revision,
    input[15:0] extended_features_ptr,
    input bridge_support,
    input memory_access,
    input processor_present,
    input switch_support,
    input[7:0] number_of_ports,
    input[7:0] port_number,
    output wire [23:0] port_response_timeout,
    output wire no_sync_indicator,
    input error_detect_message_error_response,
    input error_detect_message_format_error,
    input error_detect_message_request_timeout,
    input [1:0] error_capture_letter,
    input [1:0] error_capture_mbox,
    input [3:0] error_capture_msgseg_or_xmbox,
    input error_detect_illegal_transaction_decode,
    input error_detect_illegal_transaction_target,
    input error_detect_packet_response_timeout,
    input error_detect_unsolicited_response,
    input error_detect_unsupported_transaction,
    input [3:0] error_capture_ftype,
    input [3:0] error_capture_ttype,
    input [15:0] error_capture_destination_id,
    input [15:0] error_capture_source_id

);

localparam UNUSED_XCVR_TX_PARALLEL_DATA_WIDTH = (mode_selection == "SERIAL_2X")? (NUMBER_OF_XCVR_CHANNELS * 92): (NUMBER_OF_XCVR_CHANNELS * 110);
localparam UNUSED_XCVR_RX_PARALLEL_DATA_WIDTH = (mode_selection == "SERIAL_2X")? (NUMBER_OF_XCVR_CHANNELS * 72): (NUMBER_OF_XCVR_CHANNELS * 100);

wire  [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_parallel_datain;
wire [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_parallel_dataout;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_patterndetect_wire;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_ctrldetect_wire;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_ctrlenable;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_errdetect_wire;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_disperr_wire;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_runningdisp_wire;
wire [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_syncstatus_wire;
wire [NUMBER_OF_XCVR_CHANNELS - 1:0] rx_std_signaldetect_wire;
wire [UNUSED_XCVR_RX_PARALLEL_DATA_WIDTH - 1 : 0] unused_rx_parallel_data_wire;
wire [NUMBER_OF_XCVR_CHANNELS - 1:0]   tx_pma_elecidle;    //    tx_pma_elecidle.tx_pma_elecidle
wire [NUMBER_OF_XCVR_CHANNELS - 1:0]   tx_coreclkin;       //       tx_coreclkin.clk
wire [NUMBER_OF_XCVR_CHANNELS - 1:0]   rx_coreclkin;       //       rx_coreclkin.clk
wire [NUMBER_OF_XCVR_CHANNELS - 1:0]   tx_clkout;          //          tx_clkout.clk
wire [NUMBER_OF_XCVR_CHANNELS - 1:0]   rx_clkout;          //          rx_clkout.clk
wire rx_clkout_0;
wire tx_clkout_0;
wire link_drvr_oe;

/* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT "set_false_path -to [get_keepers {*riophy_reset:*|gxbpll_locked_tx_clk_d1}]" "} */
reg  gxbpll_locked_tx_clk_d1  ;
/* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} */
reg  gxbpll_locked_tx_clk_d2  ;
reg rxreset_n;
reg txreset_n;
reg  txreset_n_p2  ;
reg  rxreset_n_p2  ;
reg  txreset_n_p1  ;
reg  rxreset_n_p1  ;
wire [UNUSED_XCVR_TX_PARALLEL_DATA_WIDTH - 1 : 0] unused_tx_parallel_data_wire;

reg  [NUMBER_OF_XCVR_CHANNELS - 1:0] tx_digitalreset_s0;
reg  [NUMBER_OF_XCVR_CHANNELS - 1:0] tx_digitalreset_s1;
reg  [NUMBER_OF_XCVR_CHANNELS - 1:0] rx_digitalreset_s0;
reg  [NUMBER_OF_XCVR_CHANNELS - 1:0] rx_digitalreset_s1;



assign unused_tx_parallel_data_wire = {UNUSED_XCVR_TX_PARALLEL_DATA_WIDTH{1'b0}};


assign rx_patterndetect = rx_patterndetect_wire;
assign rx_ctrldetect = rx_ctrldetect_wire;
assign rx_errdetect = rx_errdetect_wire;
assign tx_pma_elecidle= {NUMBER_OF_XCVR_CHANNELS{~link_drvr_oe}};
assign rx_clkout_0 = rx_clkout[0];
assign tx_clkout_0 = tx_clkout[0];

assign tx_coreclkin = {NUMBER_OF_XCVR_CHANNELS{tx_clkout[0]}};
assign rx_coreclkin = {NUMBER_OF_XCVR_CHANNELS{rx_clkout[0]}};
assign rxgxbclk = rx_clkout_0;

// Generated clock logic
generate

	if (mode_selection == "SERIAL_1X") begin
                reg  rxclk_reg  /* synthesis altera_attribute="disable_da_rule=\"c104,c101,c103\"" */;
		always @(posedge rx_clkout_0)
		begin
    			if (rxclk_reg == 1'b1) begin
        			rxclk_reg<=1'b0;
    			end
    			else
    			begin
        			rxclk_reg<=1'b1;
    			end
		end 
        	assign rxclk = rxclk_reg;
		reg clk_div_by_two /* synthesis altera_attribute="disable_da_rule=\"c104,c101,c103\"" */;

		always @(posedge tx_clkout_0)
		begin
    			if (clk_div_by_two == 1'b1) begin
        			clk_div_by_two<=1'b0;
    			end
    			else
    			begin
        			clk_div_by_two<=1'b1;
    			end
		end
		assign txclk = clk_div_by_two;
 
        end else begin
		assign txclk = tx_clkout_0;
                assign rxclk = rx_clkout_0;
        end

endgenerate

// RapidIO Gen 1 instantiation which does not include the hard transceiver
   altera_rapidio_rio #(.max_icnt(3)) rio_mac_inst (
      .rx_patterndetect(rx_patterndetect_wire),
      .rx_ctrldetect(rx_ctrldetect_wire),
      .rx_out(rx_parallel_datain),
      .tx_in(tx_parallel_dataout),
      .tx_ctrlenable(tx_ctrlenable),
      .txclk(txclk),
      .rxclk(rxclk),
      .sysclk(sysclk),
      .txgxbclk(tx_clkout_0),
      .rxgxbclk(rx_clkout_0),
      .io_s_wr_clk(sysclk),
      .io_s_rd_clk(sysclk),
      .io_m_rd_clk(sysclk),
      .mnt_m_clk(sysclk),
      .mnt_s_clk(sysclk),
      .sys_mnt_s_clk(sysclk),
      .reset_n(reset_n),
      .rxreset_n(rxreset_n),
      .txreset_n(txreset_n),
      .ef_ptr(ef_ptr),
      .io_m_wr_waitrequest(io_m_wr_waitrequest),
      .io_m_wr_write(io_m_wr_write),
      .io_m_wr_address(io_m_wr_address),
      .io_m_wr_writedata(io_m_wr_writedata),
      .io_m_wr_byteenable(io_m_wr_byteenable),
      .io_m_wr_burstcount(io_m_wr_burstcount),
      .io_m_rd_waitrequest(io_m_rd_waitrequest),
      .io_m_rd_read(io_m_rd_read),
      .io_m_rd_address(io_m_rd_address),
      .io_m_rd_readdatavalid(io_m_rd_readdatavalid),
      .io_m_rd_readerror(io_m_rd_readerror),
      .io_m_rd_readdata(io_m_rd_readdata),
      .io_m_rd_burstcount(io_m_rd_burstcount),
      .io_s_wr_chipselect(io_s_wr_chipselect),
      .io_s_wr_waitrequest(io_s_wr_waitrequest),
      .io_s_wr_write(io_s_wr_write),
      .io_s_wr_address(io_s_wr_address),
      .io_s_wr_writedata(io_s_wr_writedata),
      .io_s_wr_byteenable(io_s_wr_byteenable),
      .io_s_wr_burstcount(io_s_wr_burstcount),
      .io_s_rd_chipselect(io_s_rd_chipselect),
      .io_s_rd_waitrequest(io_s_rd_waitrequest),
      .io_s_rd_read(io_s_rd_read),
      .io_s_rd_address(io_s_rd_address),
      .io_s_rd_readdatavalid(io_s_rd_readdatavalid),
      .io_s_rd_readdata(io_s_rd_readdata),
      .io_s_rd_burstcount(io_s_rd_burstcount),
      .io_s_rd_readerror(io_s_rd_readerror),
      .mnt_m_waitrequest(mnt_m_waitrequest),
      .mnt_m_read(mnt_m_read),
      .mnt_m_write(mnt_m_write),
      .mnt_m_address(mnt_m_address),
      .mnt_m_writedata(mnt_m_writedata),
      .mnt_m_readdata(mnt_m_readdata),
      .mnt_m_readdatavalid(mnt_m_readdatavalid),
      .mnt_s_chipselect(mnt_s_chipselect),
      .mnt_s_waitrequest(mnt_s_waitrequest),
      .mnt_s_read(mnt_s_read),
      .mnt_s_write(mnt_s_write),
      .mnt_s_address(mnt_s_address),
      .mnt_s_writedata(mnt_s_writedata),
      .mnt_s_readdata(mnt_s_readdata),
      .mnt_s_readerror(mnt_s_readerror),
      .mnt_s_readdatavalid(mnt_s_readdatavalid),
      .sys_mnt_s_chipselect(sys_mnt_s_chipselect),
      .sys_mnt_s_waitrequest(sys_mnt_s_waitrequest),
      .sys_mnt_s_read(sys_mnt_s_read),
      .sys_mnt_s_write(sys_mnt_s_write),
      .sys_mnt_s_address(sys_mnt_s_address),
      .sys_mnt_s_writedata(sys_mnt_s_writedata),
      .sys_mnt_s_readdata(sys_mnt_s_readdata),
      .sys_mnt_s_irq(sys_mnt_s_irq),
      .rx_packet_dropped(rx_packet_dropped),
      .master_enable(master_enable),
      .output_enable(output_enable),
      .input_enable(input_enable),
      .rx_errdetect(rx_errdetect_wire),
      .port_initialized(port_initialized),
      .atxwlevel(atxwlevel),
      .atxovf(atxovf),
      .arxwlevel(arxwlevel),
      .buf_av0(buf_av0),
      .buf_av1(buf_av1),
      .buf_av2(buf_av2),
      .buf_av3(buf_av3),
      .packet_transmitted(packet_transmitted),
      .packet_cancelled(packet_cancelled),
      .packet_accepted(packet_accepted),
      .packet_retry(packet_retry),
      .packet_not_accepted(packet_not_accepted),
      .packet_crc_error(packet_crc_error),
      .symbol_error(symbol_error),
      .port_error(port_error),
      .char_err(char_err),
      .multicast_event_rx(multicast_event_rx),
      .multicast_event_tx(multicast_event_tx),
      .gen_tx_ready(gen_tx_ready),
      .gen_tx_valid(gen_tx_valid),
      .gen_tx_startofpacket(gen_tx_startofpacket),
      .gen_tx_endofpacket(gen_tx_endofpacket),
      .gen_tx_error(gen_tx_error),
      .gen_tx_empty(gen_tx_empty),
      .gen_tx_data(gen_tx_data),
      .gen_rx_ready(gen_rx_ready),
      .gen_rx_valid(gen_rx_valid),
      .gen_rx_startofpacket(gen_rx_startofpacket),
      .gen_rx_endofpacket(gen_rx_endofpacket),
      .gen_rx_empty(gen_rx_empty),
      .gen_rx_data(gen_rx_data),
      .gen_rx_size(gen_rx_size),
      .drbell_s_clk(sysclk),
      .drbell_s_chipselect(drbell_s_chipselect),
      .drbell_s_waitrequest(drbell_s_waitrequest),
      .drbell_s_read(drbell_s_read),
      .drbell_s_write(drbell_s_write),
      .drbell_s_address(drbell_s_address),
      .drbell_s_writedata(drbell_s_writedata),
      .drbell_s_readdata(drbell_s_readdata),
      .drbell_s_irq(drbell_s_irq),
      .rx_threshold_0(rx_threshold_0),
      .rx_threshold_1(rx_threshold_1),
      .rx_threshold_2(rx_threshold_2),
      .txclk_timeout_prescaler(txclk_timeout_prescaler),
      .sysclk_timeout_prescaler(sysclk_timeout_prescaler),
      .device_identifier(device_identifier),
      .device_vendor_id(device_vendor_id),
      .device_revision(device_revision),
      .assembly_id(assembly_id),
      .assembly_vendor_id(assembly_vendor_id),
      .assembly_revision(assembly_revision),
      .extended_features_ptr(extended_features_ptr),
      .bridge_support(bridge_support),
      .memory_access(memory_access),
      .processor_present(processor_present),
      .switch_support(switch_support),
      .number_of_ports(number_of_ports),
      .port_number(port_number),
      .link_drvr_oe(link_drvr_oe),
      .port_response_timeout(port_response_timeout),
      .no_sync_indicator(no_sync_indicator),
      .error_detect_message_error_response(error_detect_message_error_response),
      .error_detect_message_format_error(error_detect_message_format_error),
      .error_detect_message_request_timeout(error_detect_message_request_timeout),
      .error_capture_letter(error_capture_letter),
      .error_capture_mbox(error_capture_mbox),
      .error_capture_msgseg_or_xmbox(error_capture_msgseg_or_xmbox),
      .error_detect_illegal_transaction_decode(error_detect_illegal_transaction_decode),
      .error_detect_illegal_transaction_target(error_detect_illegal_transaction_target),
      .error_detect_packet_response_timeout(error_detect_packet_response_timeout),
      .error_detect_unsolicited_response(error_detect_unsolicited_response),
      .error_detect_unsupported_transaction(error_detect_unsupported_transaction),
      .error_capture_ftype(error_capture_ftype),
      .error_capture_ttype(error_capture_ttype),
      .error_capture_destination_id(error_capture_destination_id),
      .error_capture_source_id(error_capture_source_id)
       );
   
     defparam rio_mac_inst.TX_PORT_WRITE = p_TX_PORT_WRITE;
     defparam rio_mac_inst.RX_PORT_WRITE = p_RX_PORT_WRITE;
     defparam rio_mac_inst.IS_X2_MODE = (mode_selection == "SERIAL_2X")? 1'b1 : 1'b0;
     defparam rio_mac_inst.IS_X4_MODE = (mode_selection == "SERIAL_4X")? 1'b1 : 1'b0;
     defparam rio_mac_inst.DRBELL_TX = p_DRBELL_TX;
     defparam rio_mac_inst.DRBELL_RX = p_DRBELL_RX;
     defparam rio_mac_inst.TRANSPORT_LARGE = p_TRANSPORT_LARGE;
     defparam rio_mac_inst.p_ADAT = p_ADAT;    
     defparam rio_mac_inst.p_ADAT_MTY_WIDTH = p_ADAT_MTY_WIDTH;
     defparam rio_mac_inst.p_GENERIC_LOGICAL = p_GENERIC_LOGICAL;
     defparam rio_mac_inst.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
     defparam rio_mac_inst.p_IO_SLAVE_WIDTH = p_IO_SLAVE_WIDTH;
     defparam rio_mac_inst.p_MAINTENANCE = p_MAINTENANCE;
     defparam rio_mac_inst.p_IO_MASTER = p_IO_MASTER ;
     defparam rio_mac_inst.p_IO_SLAVE = p_IO_SLAVE ;
     defparam rio_mac_inst.p_TIMEOUT_ENABLE = p_timeout_enable;
     defparam rio_mac_inst.p_SOURCE_OPERATION_DATA_MESSAGE = p_SOURCE_OPERATION_DATA_MESSAGE;
     defparam rio_mac_inst.p_DESTINATION_OPERATION_DATA_MESSAGE = p_DESTINATION_OPERATION_DATA_MESSAGE;
     
// Hard transceiver instantiation
generate
    if (XCVR_RECONFIG == 1'b1) begin
		
   altera_rapidio_xcvr_native_phy xcvr_native_phy_inst(
      	   .tx_analogreset(tx_analogreset),     //     tx_analogreset.tx_analogreset
		   .tx_digitalreset(tx_digitalreset),    //    tx_digitalreset.tx_digitalreset
		   .rx_analogreset(rx_analogreset),     //     rx_analogreset.rx_analogreset
		   .rx_digitalreset(rx_digitalreset),    //    rx_digitalreset.rx_digitalreset
		   .tx_cal_busy(tx_cal_busy),        //        tx_cal_busy.tx_cal_busy
		   .rx_cal_busy(rx_cal_busy),        //        rx_cal_busy.rx_cal_busy
		   .tx_bonding_clocks(tx_bonding_clocks),     //     tx_serial_clk0.clk
		   .rx_cdr_refclk0(clk),     //     rx_cdr_refclk0.clk
		   .tx_serial_data(td),     //     tx_serial_data.tx_serial_data
		   .rx_serial_data(rd),     //     rx_serial_data.rx_serial_data
		   .rx_set_locktodata({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .rx_set_locktoref({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .rx_is_lockedtoref(rx_is_lockedtoref),  //  rx_is_lockedtoref.rx_is_lockedtoref
		   .rx_is_lockedtodata(rx_is_lockedtodata), // rx_is_lockedtodata.rx_is_lockedtodata
		   .tx_pma_elecidle(tx_pma_elecidle),    //    tx_pma_elecidle.tx_pma_elecidle
		   .tx_coreclkin(tx_coreclkin),       //       tx_coreclkin.clk
		   .rx_coreclkin(rx_coreclkin),       //       rx_coreclkin.clk
		   .tx_clkout(tx_clkout),          //          tx_clkout.clk
		   .rx_clkout(rx_clkout),          //          rx_clkout.clk
		   .tx_parallel_data(tx_parallel_dataout),   //   tx_parallel_data.tx_parallel_data
		   .rx_parallel_data(rx_parallel_datain),    //   rx_parallel_data.rx_parallel_data
  		   .rx_std_bitrev_ena         ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
           .tx_polinv                 ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),             //IF not in used, MUST tied to zero.
           .rx_polinv                 ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .tx_datak		(tx_ctrlenable),
           .unused_tx_parallel_data   (unused_tx_parallel_data_wire),
           .unused_rx_parallel_data   (unused_rx_parallel_data_wire),
           .reconfig_clk              (reconfig_clk),
		   .reconfig_reset            (reconfig_reset),
		   .reconfig_write            (reconfig_write),
		   .reconfig_read             (reconfig_read),
		   .reconfig_address          (reconfig_address),
            .reconfig_writedata        (reconfig_writedata),
            .rx_datak                  (rx_ctrldetect_wire),
   		   .rx_errdetect              (rx_errdetect_wire),
   		   .rx_disperr                (rx_disperr_wire),
		   .rx_runningdisp            (rx_runningdisp_wire),
		   .rx_patterndetect          (rx_patterndetect_wire),
		   .rx_syncstatus             (rx_syncstatus_wire),
		   .rx_std_signaldetect       (rx_std_signaldetect_wire),         //to soft PCS and export
            .reconfig_readdata         (reconfig_readdata),
            .reconfig_waitrequest      (reconfig_waitrequest)

    );

end else begin
      altera_rapidio_xcvr_native_phy xcvr_native_phy_inst(
      	   .tx_analogreset(tx_analogreset),     //     tx_analogreset.tx_analogreset
		   .tx_digitalreset(tx_digitalreset),    //    tx_digitalreset.tx_digitalreset
		   .rx_analogreset(rx_analogreset),     //     rx_analogreset.rx_analogreset
		   .rx_digitalreset(rx_digitalreset),    //    rx_digitalreset.rx_digitalreset
		   .tx_cal_busy(tx_cal_busy),        //        tx_cal_busy.tx_cal_busy
		   .rx_cal_busy(rx_cal_busy),        //        rx_cal_busy.rx_cal_busy
		   .tx_bonding_clocks(tx_bonding_clocks),     //     tx_serial_clk0.clk
		   .rx_cdr_refclk0(clk),     //     rx_cdr_refclk0.clk
		   .tx_serial_data(td),     //     tx_serial_data.tx_serial_data
		   .rx_serial_data(rd),     //     rx_serial_data.rx_serial_data
		   .rx_set_locktodata({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .rx_set_locktoref({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .rx_is_lockedtoref(rx_is_lockedtoref),  //  rx_is_lockedtoref.rx_is_lockedtoref
		   .rx_is_lockedtodata(rx_is_lockedtodata), // rx_is_lockedtodata.rx_is_lockedtodata
		   .tx_pma_elecidle(tx_pma_elecidle),    //    tx_pma_elecidle.tx_pma_elecidle
		   .tx_coreclkin(tx_coreclkin),       //       tx_coreclkin.clk
		   .rx_coreclkin(rx_coreclkin),       //       rx_coreclkin.clk
		   .tx_clkout(tx_clkout),          //          tx_clkout.clk
		   .rx_clkout(rx_clkout),          //          rx_clkout.clk
		   .tx_parallel_data(tx_parallel_dataout),   //   tx_parallel_data.tx_parallel_data
		   .rx_parallel_data(rx_parallel_datain),    //   rx_parallel_data.rx_parallel_data
  		   .rx_std_bitrev_ena         ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
           .tx_polinv                 ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),             //IF not in used, MUST tied to zero.
           .rx_polinv                 ({NUMBER_OF_XCVR_CHANNELS{1'b0}}),
		   .tx_datak		(tx_ctrlenable),
           .unused_tx_parallel_data   (unused_tx_parallel_data_wire),
           .unused_rx_parallel_data   (unused_rx_parallel_data_wire),
            .rx_datak                  (rx_ctrldetect_wire),
   		   .rx_errdetect              (rx_errdetect_wire),
   		   .rx_disperr                (rx_disperr_wire),
		   .rx_runningdisp            (rx_runningdisp_wire),
		   .rx_patterndetect          (rx_patterndetect_wire),
		   .rx_syncstatus             (rx_syncstatus_wire),
		   .rx_std_signaldetect       (rx_std_signaldetect_wire)         //to soft PCS and export
        );

end

endgenerate

// Reset deassertion based on the TX PLL locked status, tx_clk and rx_clk domain

always @(posedge txclk or negedge reset_n)
begin
        if (!reset_n) begin
            tx_digitalreset_s0 <= 1'b1;
            tx_digitalreset_s1 <= 1'b1;
        end else begin
            tx_digitalreset_s0 <= tx_digitalreset;
            tx_digitalreset_s1 <= tx_digitalreset_s0;
        end
end


always @(posedge txclk or negedge gxbpll_locked)
begin 
    if (! gxbpll_locked) begin 
        gxbpll_locked_tx_clk_d1<=1'b0;
        gxbpll_locked_tx_clk_d2<=1'b0;
    end 
    else
    begin 
        gxbpll_locked_tx_clk_d1<=gxbpll_locked;
        gxbpll_locked_tx_clk_d2<=gxbpll_locked_tx_clk_d1;
    end 
end 

always @(posedge txclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        txreset_n_p2<=1'b0;
        txreset_n_p1<=1'b0;
        txreset_n<=1'b0;
    end 
    else
    begin 
        if ((!gxbpll_locked_tx_clk_d2 )||(|tx_digitalreset_s1)) begin 
            txreset_n_p2<=1'b0;
            txreset_n_p1<=1'b0;
            txreset_n<=1'b0;
        end 
        else
        begin 
            txreset_n_p2<=1'b1;
            txreset_n_p1<=txreset_n_p2;
            txreset_n<=txreset_n_p1;
        end 
    end 
end //RX_SIDE

always @(posedge rxclk or negedge reset_n)
begin
        if (!reset_n) begin
            rx_digitalreset_s0 <= 1'b1;
            rx_digitalreset_s1 <= 1'b1;
        end else begin
            rx_digitalreset_s0 <= rx_digitalreset;
            rx_digitalreset_s1 <= rx_digitalreset_s0;
        end
end



always @(posedge rxclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        rxreset_n_p2<=1'b0;
        rxreset_n_p1<=1'b0;
        rxreset_n<=1'b0;
    end 
    else
    begin 
        if(|rx_digitalreset_s1) begin
            rxreset_n_p2<=1'b0;
            rxreset_n_p1<=1'b0;
            rxreset_n<=1'b0;
        end else begin
            rxreset_n_p2<=1'b1;
            rxreset_n_p1<=rxreset_n_p2;
            rxreset_n<=rxreset_n_p1;
        end
    end 
end 



endmodule
