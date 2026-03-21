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


module pio_top #(
  parameter  WIDTH          = 64,
  parameter  FAMILY         = "Arria 10"

)(

// RX side
input                         pld_clk,
input                         clr_st,
input     [WIDTH-1:0]         rx_st_data,
input     [1:0]               rx_st_empty,
input                         rx_st_sop,
input                         rx_st_eop,  
input     [7:0]               rx_st_bar,    
input                         rx_st_valid,
input                         rx_st_err,
output                        rx_st_ready, // back pressure when fifo can only accept 2 read more packets.

// Config side
input    [3:0]                tl_cfg_add,
input    [31:0]               tl_cfg_ctl,
// TX side
input                         tx_st_ready,
output                        tx_st_valid,  
output                        tx_st_sop,   
output                        tx_st_eop,   
output                        tx_st_empty,
output                        tx_st_err, 
output      [WIDTH-1:0]       tx_st_data,    

// Avmm Master Interface

output logic                 avmm_write,
output logic [15:0]          avmm_address,
output logic [31:0]          avmm_writedata,
output logic [3:0]           avmm_byteenable,
input  logic                 avmm_waitrequest,
output logic                 avmm_read,
input  logic [31:0]          avmm_readdata,
input  logic                 avmm_readdata_valid

);


wire [13:0]       raddress, waddress;
wire [31:0]       mm_data_out;
wire [3:0]        be_first_r;
wire [31:0]       mm_data_in;
wire              mm_write;
wire              put_header;
wire              put_data;


reg [WIDTH-1:0]   rx_st_data_r;
reg               rx_st_sop_r;
reg               rx_st_valid_r;
reg  [7:0]        rx_st_bar_r;
reg               rx_st_eop_r; 

logic  [15:0]                             cfg_busdev,requester_id;
logic                                     avmm_readdata_valid_r;
logic                                     write_pkt;
logic                                     read_pkt;
logic                                     dw3;
logic                                     dw4;
logic                                     mem_type;
logic                                     bar_hit;
logic  [3:0]                              be_first,be_first_to_mem;
logic  [13:0]                             address;
logic                                     qword_alignment;
logic                                     qword_alignmentdw3;
logic                                     qword_alignmentdw4;
logic  [7:0]                              tag;
logic  [15:0]                             requester_i;
logic  [1:0]                              be_first_count;
logic  [2:0]                              be_count;
logic  [2:0]                              tc;
logic  [1:0]                              attr;
logic  [WIDTH-1:0]                        mem_st_data;
logic                                     mem_st_sop;
logic                                     mem_st_valid;
logic                                     mem_st_eop;
logic                                     get_data;
logic                                     get_header;
logic  [(WIDTH == 64) ? (WIDTH): 96 : 0]  fifo_st_header,header_fifo_in;
logic  [31 : 0]                           fifo_mem_data;
logic                                     header_fifo_empty;
logic                                     data_fifo_empty;
logic                                     read_to_interfcae;  
logic   [13:0]                            readaddress_to_interfcae;
logic   [3:0]                             byteenable_to_interface;
logic   [31:0]                            writedata_to_interface;
logic                                     write_to_interface;
logic   [13:0]                            writeaddress_to_interface;

logic                                     avmm_read_r;
logic   [31:0]                            avmm_readdata_r;

//localparam  INTERFACE_TYPE = "Avalon-ST_only"; // This interface has no AVMM. The memory is intantiated. 
//pio_ed may need modiciations

localparam  INTERFACE_TYPE = "Avalon-MM_bridge"; // Default operation. This instantiates an AVMM bridge

assign tx_st_err = '0;


//Instantiate the avst_to_mm block

// register all inputs
wire                    header_afull;
wire                    interface_fifo_afull;
assign rx_st_ready = !(header_afull | interface_fifo_afull);

always_ff @(posedge pld_clk) begin
  if (clr_st) begin
    rx_st_data_r          <= '0;
    rx_st_sop_r           <= '0; 
    rx_st_valid_r         <= '0; 
    rx_st_bar_r           <= '0;
    rx_st_eop_r           <= '0;
    avmm_readdata_r       <= '0;
    avmm_readdata_valid_r <= '0;
  end
  else begin    
    rx_st_data_r          <= rx_st_data;
    rx_st_sop_r           <= rx_st_err ? 1'b0 : rx_st_sop; 
    rx_st_valid_r         <= rx_st_err ? 1'b0 : rx_st_valid; 
    rx_st_eop_r           <= rx_st_err ? 1'b0 : rx_st_eop;
    rx_st_bar_r           <= rx_st_bar;
    avmm_readdata_valid_r <= avmm_readdata_valid;
    avmm_readdata_r       <= avmm_readdata;
  end
end

pio_tlp_parser #(
  .WIDTH (WIDTH)
) tlp_parser (


.pld_clk_i                (pld_clk),
.clr_st_i                 (clr_st),
.rx_st_data_i             (rx_st_data_r),
.rx_st_sop_i              (rx_st_sop_r),
.rx_st_eop_i              (rx_st_eop_r),
.rx_st_valid_i            (rx_st_valid_r),
.rx_st_bar_i              (rx_st_bar_r[5:0]),


.tl_cfg_add_i             (tl_cfg_add),
.tl_cfg_ctl_i             (tl_cfg_ctl),


.tx_st_ready_i            (tx_st_ready),
.tx_st_valid_o            (tx_st_valid),
.tx_st_sop_o              (tx_st_sop),
.tx_st_eop_o              (tx_st_eop),
.tx_st_empty_o            (tx_st_empty),
.tx_st_data_o             (tx_st_data),

.cfg_busdev_r_o           (cfg_busdev),
.write_pkt_o              (write_pkt),
.read_pkt_o               (read_pkt),
.dw3_o                    (dw3),
.dw4_o                    (dw4),
.mem_type_o               (mem_type),
.rx_st_bar_hit_o          (bar_hit), 
.be_first_r_o             (be_first),
.address_r_o              (address),
.qword_alignment_o        (qword_alignment),
.qword_alignmentdw3_o     (qword_alignmentdw3),
.qword_alignmentdw4_o     (qword_alignmentdw4),
.tag_o                    (tag),
.requester_id_o           (requester_id),
.be_first_count_o         (be_first_count),
.be_count_o               (be_count),
.tc_o                     (tc),
.attr_o                   (attr),


.mem_data_o               (mem_st_data),
.mem_sop_o                (mem_st_sop),  
.mem_valid_o              (mem_st_valid),
.mem_eop_o                (mem_st_eop),

.get_data                 (get_data),
.get_header               (get_header),
.fifo_st_header_i         (fifo_st_header),
.fifo_mem_data_i          (fifo_mem_data),
.header_fifo_empty        (header_fifo_empty),
.data_fifo_empty          (data_fifo_empty)

);


generate

  if (INTERFACE_TYPE == "Avalon-ST_only") begin

    pio_mm_to_avst #(
      .WIDTH (WIDTH)
    
    ) read_controller (
    
    .pld_clk_i                    (pld_clk),
    .reset_i                      (clr_st),
    
    .completer_id                 (cfg_busdev),
    .read_pkt_i                   (read_pkt),
    .dw3_i                        (dw3),
    .dw4_i                        (dw4),
    .mem_type_i                   (mem_type),
    .rx_st_bar_hit_i              (bar_hit),
    .address_r_i                  (address),
    .qword_alignment_i            (qword_alignment),
    .qword_alignmentdw3_i         (qword_alignmentdw3),
    .qword_alignmentdw4_i         (qword_alignmentdw4),
    .tag_i                        (tag),
    .requester_id_i               (requester_id),
    .tc_i                         (tc),
    .attr_i                       (attr),
    .be_first_count_i             (be_first_count),
    .be_count_i                   (be_count),
    
    .mem_sop_i                    (mem_st_sop),  
    .mem_valid_i                  (mem_st_valid),
    .mem_eop_i                    (mem_st_eop),
    
    .raddress_o                   (raddress),          // memory Interface
    .header_fifo_in               (header_fifo_in),
    .fifo_put_data                (put_data),
    .fifo_put_header              (put_header)
    
    );
    
    
    pio_avst_to_mm #(
      .WIDTH (WIDTH),
      .FAMILY (FAMILY)
    
    ) write_controller (
    
    .pld_clk_i                (pld_clk),
    .reset_i                  (clr_st),
    
    .write_pkt_i              (write_pkt),
    .dw3_i                    (dw3),
    .dw4_i                    (dw4),
    .mem_type_i               (mem_type),
    .rx_st_bar_hit_i          (bar_hit),
    .be_first_i               (be_first),
    .mem_data_i               (mem_st_data), 
    .mem_sop_i                (mem_st_sop),  
    .mem_valid_i              (mem_st_valid),
    .mem_eop_i                (mem_st_eop),
    .address_r_i              (address),
    .qword_alignment_i        (qword_alignment),
    .qword_alignmentdw3_i     (qword_alignmentdw3),
    .qword_alignmentdw4_i     (qword_alignmentdw4),
    
    // Interface to avst_to_mm
    
    .be_first_o              (be_first_to_mem),
    .mm_data_out_o           (mm_data_in),
    .mm_write_o              (mm_write),
    .waddress_o              (waddress)
    
    );
  end
  
  if (INTERFACE_TYPE == "Avalon-MM_bridge") begin
  
    pio_avmm_interface pio_avmm_interface (
     .pld_clk_i               (pld_clk),
     .clr_st_i                (clr_st),
     
     .avmm_read_i              (read_to_interfcae),                 
     .avmm_raddress_i          (readaddress_to_interfcae),
     .avmm_be_first_i          (byteenable_to_interface),
     .avmm_data_out_i          (writedata_to_interface),
     .avmm_write_i             (write_to_interface),
     .avmm_waddress_i          (writeaddress_to_interface),
     .avmm_waitrequest_i       (avmm_waitrequest),
     
     .avmm_address_o           (avmm_address),
     .avmm_writedata_o         (avmm_writedata),
     .avmm_byteenable_o        (avmm_byteenable),
     .avmm_write_o             (avmm_write),
     .avmm_read_o              (avmm_read),
     .fifo_afull               (interface_fifo_afull)
   
    );

    pio_avmm_read_controller #(
      .WIDTH (WIDTH)

    )avmm_read_controller(
      .pld_clk_i            (pld_clk),
      .reset_i              (clr_st),

      .completer_id         (cfg_busdev),
      .read_pkt_i           (read_pkt),
      .dw3_i                (dw3),
      .dw4_i                (dw4),
      .mem_type_i           (mem_type),
      .rx_st_bar_hit_i      (bar_hit),
      .address_r_i          (address),
      .qword_alignment_i    (qword_alignment),
      .qword_alignmentdw3_i (qword_alignmentdw3),
      .qword_alignmentdw4_i (qword_alignmentdw4),
      .tag_i                (tag),
      .requester_id_i       (requester_id),
      .tc_i                 (tc),
      .attr_i               (attr),
      .be_first_count_i     (be_first_count),
      .be_count_i           (be_count),
                            
      .mem_sop_i            (mem_st_sop),  
      .mem_valid_i          (mem_st_valid),
      .mem_eop_i            (mem_st_eop),
      
      .avmm_read_o          (read_to_interfcae),
      .avmm_raddress_o      (readaddress_to_interfcae),
      .header_fifo_in       (header_fifo_in),
      .fifo_put_header      (put_header)
    );


    pio_avmm_write_controller #(
      .WIDTH (WIDTH)

      )avmm_write_controller(
      
      .pld_clk_i               (pld_clk),
      .reset_i                 (clr_st),
      
      .write_pkt_i             (write_pkt),
      .dw3_i                   (dw3),
      .dw4_i                   (dw4),
      .mem_type_i              (mem_type),
      .rx_st_bar_hit_i         (bar_hit),
      .mem_data_i              (mem_st_data), 
      .mem_sop_i               (mem_st_sop),  
      .mem_valid_i             (mem_st_valid),
      .mem_eop_i               (mem_st_eop),
      .address_r_i             (address),
      .qword_alignment_i       (qword_alignment),
      .qword_alignmentdw3_i    (qword_alignmentdw3),
      .qword_alignmentdw4_i    (qword_alignmentdw4),
      .be_first_i              (be_first),
      
      .avmm_be_first_o         (byteenable_to_interface), 
      .avmm_data_out_o         (writedata_to_interface),
      .avmm_write_o            (write_to_interface),
      .avmm_waddress_o         (writeaddress_to_interface)
      
      );

  end
endgenerate
///////////////////////// INSTANTIAITE THE HEADER AND DATA FIFO/////////////////////////

pio_fifo #(
  .DATA_WIDTH ((WIDTH == 64) ? 65 :97)

) header_fifo (
  .clk_i                      (pld_clk),
  .reset_i                    (clr_st),
  .data_in_i                  (header_fifo_in),
  .data_out_o                 (fifo_st_header),
  .empty_o                    (header_fifo_empty),
  .almost_full_o              (header_afull),
  .full_o                     (),
  .put_i                      (put_header),
  .get_i                      (get_header)
);

generate

if ((INTERFACE_TYPE == "Avalon-MM_bridge")) begin
  pio_fifo #(
    .DATA_WIDTH (32)
  
  ) data_fifo (
    .clk_i                      (pld_clk),
    .reset_i                    (clr_st),
    .data_in_i                  (avmm_readdata_r),
    .data_out_o                 (fifo_mem_data),
    .empty_o                    (data_fifo_empty),
    .almost_full_o              (),
    .full_o                     (),
    .put_i                      (avmm_readdata_valid_r),
    .get_i                      (get_data)
  );
end

if ((INTERFACE_TYPE == "Avalon-ST_only")) begin
  pio_fifo #(
    .DATA_WIDTH (32)
  
  ) data_fifo (
    .clk_i                      (pld_clk),
    .reset_i                    (clr_st),
    .data_in_i                  (mm_data_out),
    .data_out_o                 (fifo_mem_data),
    .empty_o                    (data_fifo_empty),
    .almost_full_o              (),
    .full_o                     (),
    .put_i                      (put_data),
    .get_i                      (get_data)
  );
end
endgenerate

// Instantitate the memory block
pio_ram_2port #(
  .ADDR_WIDTH_IN_BYTES (16),
  .FAMILY (FAMILY)

) PIO_ram (

    .byteena_a                 (be_first_to_mem),
    .clock                     (pld_clk),
    .data                      (mm_data_in),
    .rdaddress                 ({raddress,2'b00}),
    .wraddress                 ({waddress,2'b00}),
    .wren                      (mm_write),
    .q                         (mm_data_out)
);

endmodule