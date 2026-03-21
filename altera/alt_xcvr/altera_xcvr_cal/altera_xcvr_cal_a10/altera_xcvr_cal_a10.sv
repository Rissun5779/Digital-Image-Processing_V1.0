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


import altera_xcvr_functions::*;

//Top-level module containing support for PMA calibration IP
(* ALTERA_ATTRIBUTE = {"-name POWER_UP_LEVEL LOW -to \"core_uc_rst_p\""} *)
(* ALTERA_ATTRIBUTE = {"-name POWER_UP_LEVEL LOW -to \"core_uc_rst_p2\""} *)
(* ALTERA_ATTRIBUTE = {"-name POWER_UP_LEVEL LOW -to \"core_uc_rst_p3\""} *)
module altera_xcvr_cal_a10
#(
parameter ENABLE_SOFT_NIOS = 0,
parameter ENABLE_CORE_M20K = 0,
parameter ENABLE_PMA_AUX = 0,
parameter ENABLE_JTAG_DBG = 1,
parameter M20K_SIZE = 512,			//Size of the M20K memory spcace if ENABLE_CORE_M20K is true
parameter M20K_SIZE_BITS = clogb2(M20K_SIZE-1),
parameter UC_CORE_CLKSEL = "DISABLE_CORE_CLK",
parameter UC_CLK_SRC = "CB_CLKUSR",
parameter NIOS_RESET_VECTOR = 16'b0,
parameter NIOS_EXCEPTION_VECTOR = 16'b1000,
parameter NIOS_BREAK_VECTOR = 16'b1000,
parameter USR_FILE_NAME = "pm_uc.hex",
parameter EXP_INIT_FILE = "/data/pakim/cal_codes/mem_exp/pm_uc_core_m20k.hex"
)(
//input           core_uc_rst,              // reset from Core to NIOS subsystem
input           core_uc_clk,              // Clock from Core to NIOS subsystem

// JTAG IO from device pin to SLD logic, replacing the ones from JTAG atom
// This is for testing purpose
input			jtag_tck,
input			jtag_tms,
input			jtag_tdi,
output		    jtag_tdo,
	
//DFX connections
output 		   	dbg_dfx_out,               //
input  		   	dbg_dfx_sel,               //
input  		   	dbg_dfx_clk,               //
output		   	dft_flag_down,      	   // PM_AUX
output		   	dft_flag_up,               // PM_AUX
   
//Custom channel connections
input [7:0]  	core_interrupt_in,         // interrupt input lines
output [7:0] 	core_interrupt_out,        // interrupt output lines

//PM_AUX Terminations
input [4:0] 		aux_tx_50,
output [4:0]		aux_rx_50

//Test Bus
//output	        tstmux_out
    );
    
localparam UC_HARD_OR_SOFT_NIOS = (ENABLE_SOFT_NIOS == 1) ? "ENABLE_SOFT" : "DISABLE_SOFT"; 

   
//JTAG signals
    wire                        dbg_jtg_tck;
    wire                        dbg_jtg_tdi;
    wire                        dbg_jtg_tdo;
    wire [1:0]                  dbg_jtg_ir_in;
    wire [1:0]                  dbg_jtg_ir_out;
    wire                        dbg_jtg_cdr;
    wire                        dbg_jtg_sdr;
    wire                        dbg_jtg_udr;
    wire                        dbg_jtg_uir;

    wire [7:0]                  tstmux_out_aux;

//Avalon Interface to PLD signals
    wire [31:0]                 core_avl_readdata;
    wire                        core_avl_readdatavalid;
    wire                        core_avl_rst_n;
    wire [15:0]                 core_avl_addr;
    wire                        core_avl_burstcount;
    wire [3:0]                  core_avl_byteenable;
    wire                        core_avl_debugaccess;
    wire                        core_avl_read;
    wire                        core_avl_waitrequest;
    wire                        core_avl_write;
    wire [31:0]                 core_avl_writedata;
    wire                        core_avl_clk;

//soft NIOS interface
    wire [19:0]                 soft_nios_addr;
    wire                        soft_nios_clk;
    wire                        soft_nios_read;
    wire                        soft_nios_write;
    wire [31:0]                 soft_nios_writedata;
    wire [31:0]                 soft_nios_readdata;
    wire			soft_nios_waitrequest;

   /******* automatic reset flop chain - begin *******/

   wire                         core_uc_rst;
   reg 				core_uc_rst_p, core_uc_rst_p2, core_uc_rst_p3;

   // synthesis translate_off
   initial begin
      core_uc_rst_p = 1'b0;
      core_uc_rst_p2 = 1'b0;
      core_uc_rst_p3 = 1'b0;
   end
   // synthesis translate_on
   
   always @(posedge core_uc_clk) begin
      core_uc_rst_p <= #1 core_uc_rst_p2;
      core_uc_rst_p2 <= #1 core_uc_rst_p3;
      core_uc_rst_p3 <= #1 1'b1;
   end

   /*********** automatic flop chain - end ************/
   
   assign core_uc_rst = ~core_uc_rst_p; 
   
assign core_avl_waitrequest = 1'b0;
assign soft_nios_waitrequest = 0;
assign core_avl_rst_n = ~core_uc_rst;

assign soft_nios_clk = core_uc_clk;
assign core_avl_clk  = core_uc_clk;

generate if (ENABLE_SOFT_NIOS == 1) begin: g_soft_nios
  //Soft NIOS instantiation

    soft_HW_NIOS inst_soft_HW_NIOS (
        .system_reset_n_reset_n          (~core_uc_rst),          		//            system_reset_n.reset_n
        .system_clock_clk                (soft_nios_clk),                	//              system_clock.clk
        .nios_break_vector_export        (NIOS_BREAK_VECTOR),        		//         nios_break_vector.export
        .nios_exception_vector_export    (NIOS_EXCEPTION_VECTOR),    		//     nios_exception_vector.export
        .nios_reset_vector_export        (NIOS_RESET_VECTOR),        		//         nios_reset_vector.export
        .nios_jtag_ir_out                (soft_nios_jtag_ir_out),               //                 nios_jtag.ir_out
        .nios_jtag_tdo                   (soft_nios_jtag_tdo),                  //                          .tdo
        .nios_jtag_cdr                   (soft_nios_jtag_cdr),                  //                          .cdr
        .nios_jtag_ir_in                 (soft_nios_jtag_ir_in),                //                          .ir_in
        .nios_jtag_rti                   (soft_nios_jtag_rti),                  //                          .rti
        .nios_jtag_sdr                   (soft_nios_jtag_sdr),                  //                          .sdr
        .nios_jtag_tck                   (soft_nios_jtag_tck),                  //                          .tck
        .nios_jtag_tdi                   (soft_nios_jtag_tdi),                  //                          .tdi
        .nios_jtag_udr                   (soft_nios_jtag_udr),                  //                          .udr
        .nios_jtag_uir                   (soft_nios_jtag_uir),                  //                          .uir
        .nios_jtag_reset_req_reset       (),      				//       nios_jtag_reset_req.reset
        .nios_jtag_reset_export          (),         				//           nios_jtag_reset.export
        .soft_cpu_cal_if_reset_out_reset (), 					// soft_cpu_cal_if_reset_out.reset
        .soft_cpu_cal_if_cal_address     (soft_nios_addr),     			// (20b)soft_cpu_cal_if_cal.address
        .soft_cpu_cal_if_cal_read        (soft_nios_read),        		//                          .read
        .soft_cpu_cal_if_cal_readdata    (soft_nios_readdata),    		// (8b)                     .readdata
        .soft_cpu_cal_if_cal_write       (soft_nios_write),       		//                          .write
        .soft_cpu_cal_if_cal_writedata   (soft_nios_writedata[7:0]),   		// (8b)                     .writedata
        .soft_cpu_cal_if_cal_waitrequest (soft_nios_waitrequest)  		//                          .waitrequest
    );
end
else //Hard NIOS. Tie to ground all Avalon Soft-NIOS PM_UC inputs
begin
  	assign  	soft_nios_addr = 20'd0;
   	assign		soft_nios_read = 1'd0;
   	assign		soft_nios_write = 1'd0;
   	assign		soft_nios_writedata = 8'd0;
end
endgenerate



twentynm_hssi_pma_uc 
     #(
.pm_uc_aux_base_addr		(10'b0),
.a_break_vector_word_addr       (NIOS_BREAK_VECTOR),
.a_exception_vector_word_addr   (NIOS_EXCEPTION_VECTOR),
.a_reset_vector_word_addr       (NIOS_RESET_VECTOR),
.pm_uc_clksel_core		(UC_CORE_CLKSEL),
.pm_uc_clksel_osc		(UC_CLK_SRC),
.pm_uc_core_jtg_rst_disable	("ENABLE_JTG_RST"),
.pm_uc_core_sys_rst_disable	("DISABLE_CORE_RST"),
.pm_uc_ecc_rst_disable		("ENABLE_ECC_RST"),
.pm_uc_hssi_base_addr		(10'b1),
.pm_uc_pwr_dwn			("DISABLE"),
.pm_uc_soft_nios		(UC_HARD_OR_SOFT_NIOS),
.pm_uc_sys_enable               ("ENABLE_SYS")
//.silicon_rev			("20NM5ES"),
//.pmu_cal_bin_fname		(USR_FILE_NAME), 
//.pmu_qparam_fname		("nf_qparam_nf1.hex")
	) my_hssi_pma_uc (
.core_uc_rst_n(~core_uc_rst),
//Avalon Signals for core M20K access
//**************************************************
.core_avl_clk(core_avl_clk),
.core_avl_readdata(core_avl_readdata),
.core_avl_readdatavalid(core_avl_readdatavalid),
.core_avl_rst_n(core_avl_rst_n),
.core_avl_addr(core_avl_addr),
.core_avl_burstcount(core_avl_burstcount),
.core_avl_byteenable(core_avl_byteenable),
.core_avl_debugaccess(core_avl_debugaccess),
.core_avl_read(core_avl_read),
.core_avl_waitrequest(core_avl_waitrequest),
.core_avl_write(core_avl_write),
.core_avl_writedata(core_avl_writedata),
//JTAG debug Signals
//**************************************************		
.dbg_jtg_tck(dbg_jtg_tck),
.dbg_jtg_tdi(dbg_jtg_tdi),
.dbg_jtg_tdo(dbg_jtg_tdo),
.dbg_jtg_ir_in(dbg_jtg_ir_in),
.dbg_jtg_ir_out(dbg_jtg_ir_out),
.dbg_jtg_cdr(dbg_jtg_cdr),
.dbg_jtg_sdr(dbg_jtg_sdr),
.dbg_jtg_udr(dbg_jtg_udr),
.dbg_jtg_uir(dbg_jtg_uir),
//Avalon signals for soft nios access
//**************************************************
.soft_nios_addr(soft_nios_addr),
.soft_nios_clk(soft_nios_clk),
.soft_nios_read(soft_nios_read),
.soft_nios_write(soft_nios_write),
.soft_nios_writedata(soft_nios_writedata[7:0]),
.soft_nios_readdata(soft_nios_readdata[7:0]),
//Core interrupts to PIO
//**************************************************
.core_interrupt_in(core_interrupt_in),
.core_interrupt_out(core_interrupt_out),
//DFX debug signals
//**************************************************
.dbg_dfx_clk(dbg_dfx_clk),
.dbg_dfx_sel(dbg_dfx_sel),
.dbg_dfx_out(dbg_dfx_out)
//Others
//**************************************************
//.tstmux_out_aux(tstmux_out_aux),
//.tstmux_out(tstmux_out),
);

generate if ((ENABLE_JTAG_DBG == 1) && (ENABLE_SOFT_NIOS == 0)) begin: HW_jtag_dbg
sld_virtual_jtag_basic	
#(
   .sld_auto_instance_index( "YES" ),
   .sld_instance_index( 0 ),
   .sld_ir_width( 2 ),
   .sld_mfg_id( 70 ),
   .sld_type_id( 34 ),
   .sld_version( 3 )		
) virtual_HW_JTAG_inst (
   .tck 	      ( dbg_jtg_tck ),
   .tdi 	      ( dbg_jtg_tdi ),
   .tdo 	      ( dbg_jtg_tdo ),
   .ir_in 	      ( dbg_jtg_ir_in ),
   .ir_out	      ( dbg_jtg_ir_out ),
   .virtual_state_cdr ( dbg_jtg_cdr ),
   .virtual_state_sdr ( dbg_jtg_sdr ),
   .virtual_state_udr ( dbg_jtg_udr ),
   .virtual_state_uir ( dbg_jtg_uir )
);
altera_soft_core_jtag_io
#(
	.ENABLE_JTAG_IO_SELECTION(0)
) hw_jtag_io_inst (
	.tck( jtag_tck ),
	.tms( jtag_tms ),
	.tdi( jtag_tdi ),
	.tdo( jtag_tdo )
);

end
else if ((ENABLE_JTAG_DBG == 1) && (ENABLE_SOFT_NIOS == 1)) begin: soft_NIOS_jtag
sld_virtual_jtag_basic	
#(
   .sld_auto_instance_index( "YES" ),
   .sld_instance_index( 0 ),
   .sld_ir_width( 2 ),
   .sld_mfg_id( 71 ),
   .sld_type_id( 34 ),
   .sld_version( 3 )		
) virtual_SW_NIOS_JTAG_inst (
   .tck 	      ( soft_nios_jtg_tck ),
   .tdi 	      ( soft_nios_jtg_tdi ),
   .tdo 	      ( soft_nios_jtg_tdo ),
   .ir_in 	      ( soft_nios_jtg_ir_in ),
   .ir_out	      ( soft_nios_jtg_ir_out ),
   .virtual_state_cdr ( soft_nios_jtg_cdr ),
   .virtual_state_sdr ( soft_nios_jtg_sdr ),
   .virtual_state_udr ( soft_nios_jtg_udr ),
   .virtual_state_uir ( soft_nios_jtg_uir )
);
altera_soft_core_jtag_io
#(
	.ENABLE_JTAG_IO_SELECTION(0)
) soft_nios_jtag_io_inst (
	.tck( jtag_tck ),
	.tms( jtag_tms ),
	.tdi( jtag_tdi ),
	.tdo( jtag_tdo )
);
end
else begin //disable JTAG debugger
  assign dbg_jtg_tck    = 1'b0;
  assign dbg_jtg_tdi    = 1'b0;
  assign dbg_jtg_ir_in  = 1'b0;
  assign dbg_jtg_cdr    = 1'b0;
  assign dbg_jtg_sdr    = 1'b0;
  assign dbg_jtg_udr    = 1'b0;
  assign dbg_jtg_uir    = 1'b0;
  assign jtag_tdo       = 1'b0;
end
endgenerate

generate if(ENABLE_CORE_M20K == 1) begin: g_core_m20k
wire [31:0] sub_wire0;
assign core_avl_readdata[31:0] = sub_wire0[31:0];
altsyncram	altsyncram_component (
	.address_a (core_avl_addr[M20K_SIZE_BITS+1:2]), 
	.clock0 (core_avl_clk),
	.data_a (core_avl_writedata),
	.wren_a (core_avl_write),
	.q_a (sub_wire0),
	.aclr0 (1'b0),
	.aclr1 (1'b0),
	.address_b (1'b1),
	.addressstall_a (1'b0),
	.addressstall_b (1'b0),
	.byteena_a (core_avl_byteenable),
	.byteena_b (1'b1),
	.clock1 (1'b1),
	.clocken0 (1'b1),
	.clocken1 (1'b1),
	.clocken2 (1'b1),
	.clocken3 (1'b1),
	.data_b (1'b1),
	.eccstatus (),
	.q_b (),
	.rden_a (core_avl_read),
	.rden_b (1'b1),
	.wren_b (1'b0));

	defparam
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.intended_device_family = "Stratix V",
		altsyncram_component.numwords_a = M20K_SIZE,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.ram_block_type = "M20K",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = M20K_SIZE_BITS,
		altsyncram_component.width_a = 32,
		altsyncram_component.width_byteena_a = 4,
                altsyncram_component.byte_size = 8,
                altsyncram_component.init_file = EXP_INIT_FILE,
                altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=NONE",
                altsyncram_component.lpm_type = "altsyncram",
                // altsyncram_component.maximum_depth = 7680,
                // altsyncram_component.numwords_a = 7680,
                altsyncram_component.outdata_reg_a = "UNREGISTERED",
                // altsyncram_component.ram_block_type = "AUTO",
                altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE";
   
//    assign tstmux_out = |core_avl_readdata; // FIXME this seems needed to keep memories from getting trimmed
   assign tstmux_out = core_interrupt_out; // FIXME this seems needed to keep memories from getting trimmed
   
   // generate read valid
   reg 	    core_avl_read_d;
   always @ (posedge core_avl_clk) begin
      if (!core_avl_rst_n) core_avl_read_d <= 1'b0;
      else core_avl_read_d <= core_avl_read;
   end 
   assign core_avl_readdatavalid = core_avl_read_d;
   
end
else begin //no core M20K
  assign core_avl_readdata[31:0] = 32'd0;
  assign tstmux_out = 1'b0;
  assign core_avl_readdatavalid = 1'b0;
end
endgenerate

generate if(ENABLE_PMA_AUX == 1) begin: g_pma_aux
twentynm_hssi_pma_aux
     #(
	.pma_aux_clock_select		("PMA_AUX_CLOCK_SELECT_CALCLK"),
	.silicon_rev			("20NM5ES")
) my_hssi_pm_aux (
.tstmux_out(tstmux_out_aux),
//AUX termination signals
//**************************************************
//.tx_50(tx_50),
//.rx_50(rx_50),
//DFX debug signals
//**************************************************
.dft_flag_down(dft_flag_down),
.dft_flag_up(dft_flag_up)

);
end
else begin
  assign tstmux_out_aux = 1'b0;
  assign dft_flag_up    = 1'b0;
  assign dft_flag_down  = 1'b0;
end
endgenerate


endmodule
