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



// Top level of altera_iopll_reconfig IP 

`timescale 1ps/1ps

module altera_iopll_reconfig_top
#(
    // Family dependant parameters
    parameter   device_family                  = "Stratix 10",
    parameter   DPRIO_ADDR_WIDTH               = 8,
    parameter   DPRIO_DATA_WIDTH               = 8,
    parameter   DPRIO_MODE_SEL_WIDTH           = 2,
    parameter   ROM_ADDR_WIDTH                 = 9,
    parameter   ROM_DATA_WIDTH                 = 16,
    parameter   ROM_NUM_WORDS                  = 512, 
    parameter   TO_PLL_WIDTH                   = 30, 
    parameter   FROM_PLL_WIDTH                 = 10,
    parameter   DPRIO_GATING_ADDR              = 8'b00010110,

    // Whether or not to wait for IOPLL lock before deasserting waitrequest
    parameter   WAIT_FOR_LOCK                  = "false",
  
    // MIF file informaiton
    parameter   reconfig_mif_filename          = "",
    parameter   MIF_EOF                        = 16'b1111111111111111,

    // Addresses in the combined MIF file of individual IOPLL configurations
    parameter   MIF_ADDRESS_0                  = 0,
    parameter   MIF_ADDRESS_1                  = 0,
    parameter   MIF_ADDRESS_2                  = 0,
    parameter   MIF_ADDRESS_3                  = 0,
    parameter   MIF_ADDRESS_4                  = 0,
    parameter   MIF_ADDRESS_5                  = 0,
    parameter   MIF_ADDRESS_6                  = 0,
    parameter   MIF_ADDRESS_7                  = 0,
    parameter   MIF_ADDRESS_8                  = 0,
    parameter   MIF_ADDRESS_9                  = 0,
    parameter   MIF_ADDRESS_10                 = 0,
    parameter   MIF_ADDRESS_11                 = 0,
    parameter   MIF_ADDRESS_12                 = 0,
    parameter   MIF_ADDRESS_13                 = 0,
    parameter   MIF_ADDRESS_14                 = 0,
    parameter   MIF_ADDRESS_15                 = 0,
    parameter   MIF_ADDRESS_16                 = 0,
    parameter   MIF_ADDRESS_17                 = 0,
    parameter   MIF_ADDRESS_18                 = 0,
    parameter   MIF_ADDRESS_19                 = 0,
    parameter   MIF_ADDRESS_20                 = 0,
    parameter   MIF_ADDRESS_21                 = 0,
    parameter   MIF_ADDRESS_22                 = 0,
    parameter   MIF_ADDRESS_23                 = 0,
    parameter   MIF_ADDRESS_24                 = 0,
    parameter   MIF_ADDRESS_25                 = 0,
    parameter   MIF_ADDRESS_26                 = 0,
    parameter   MIF_ADDRESS_27                 = 0,
    parameter   MIF_ADDRESS_28                 = 0,
    parameter   MIF_ADDRESS_29                 = 0,
    parameter   MIF_ADDRESS_30                 = 0,
    parameter   MIF_ADDRESS_31                 = 0
) ( 
    // Inputs
    input logic                          mgmt_clk,
    input logic                          mgmt_reset,
    input logic  [FROM_PLL_WIDTH-1:0]    reconfig_from_pll,

    // Conduits
    output logic [TO_PLL_WIDTH-1:0]      reconfig_to_pll,

    //  User data (avalon-MM slave interface),
    input logic                          mgmt_write,
    input logic  [DPRIO_DATA_WIDTH-1:0]  mgmt_writedata,
    input logic  [DPRIO_ADDR_WIDTH+DPRIO_MODE_SEL_WIDTH-1:0]  mgmt_address,  
    input logic                          mgmt_read,
    output logic                         mgmt_waitrequest,
    output logic [DPRIO_DATA_WIDTH-1:0]  mgmt_readdata
);

    // LEGALITY CHECKING ************************************************************************************
    //     Check device family legality.
    //     This IP is currently only available for Stratix 10. 
    // ******************************************************************************************************
  
    localparam IS_STRATIX_10 = ((device_family == "Stratix 10") || (device_family == "Stratix10")
                                || (device_family == "STRATIX 10") || (device_family == "STRATIX10"));
    initial
    begin
        if (!IS_STRATIX_10)
        begin
            $display("Error: The Altera IOPLL Reconfig IP is only available for Stratix 10. For previous families, please instantiate the Altera PLL Reconfig IP.");
            $finish;
        end
    end		 
            
    // DECLARATIONS *****************************************************************************************
    // ******************************************************************************************************
    // Local Parameters
    localparam MODE_MIF               =   0;
    localparam MODE_ADV               =   1;
    localparam MODE_GATING            =   2;
    localparam MODE_DPS               =   3;
   
    // FSM outputs 
    logic   [DPRIO_ADDR_WIDTH-1:0]        fsm_dprio_address;
    logic                                 fsm_dprio_write;
    logic                                 fsm_usr_waitrequest;
    logic   [DPRIO_DATA_WIDTH-1:0]        fsm_dprio_writedata;
    logic   [ROM_ADDR_WIDTH-1:0]          fsm_rom_address;

    // Synchronizer outputs
    logic                                 synch_locked;

    // ROM outputs
    logic   [ROM_DATA_WIDTH-1:0]          rom_q;

    // Other wires
    logic [1:0]                           w_effective_mode;
    logic                                 w_locked_orig;
    logic [ROM_ADDR_WIDTH-1:0]            w_first_rom_address;
    logic [DPRIO_DATA_WIDTH-1:0]          w_gating_data;
   
   // Assignments********************************************************************************************
   //    Unpack Reconfig_to_pll and reconfig_from_pll assignments signals, which depend on family.
   //    Also set the first rom address, depending on the users input index and the MIF address parameters. 
   // ******************************************************************************************************

   // Mode is either MIF, ADVANCED, DPS or GATING. It is set by the highest bits of mgmt_address, 
   // but should not change when the FSM waitrequest is asserted so as to not interrupt a MIF / GATING operation. 

   // Unpack Reconfig_to_pll and reconfig_from_pll assignments signals, which depend on family
   always @*
   begin
       if (IS_STRATIX_10)
       begin
            w_effective_mode = (fsm_usr_waitrequest) ? MODE_MIF
                                           : mgmt_address[DPRIO_ADDR_WIDTH+DPRIO_MODE_SEL_WIDTH-1:DPRIO_ADDR_WIDTH];
            
            // Reconfig to pll assignments
            reconfig_to_pll[0]     =  mgmt_clk; 
            reconfig_to_pll[1]     =  ~mgmt_reset;
             
            // Reconfiguration mode dependent outputs: address, read, write and writedata
            reconfig_to_pll[2]     =  (w_effective_mode == MODE_ADV)  ?  mgmt_read           :  1'b0;     
            reconfig_to_pll[3]     =  (w_effective_mode == MODE_ADV)  ?  mgmt_write          :  fsm_dprio_write;  
            reconfig_to_pll[11:4]  =  (w_effective_mode == MODE_ADV)  ?  mgmt_address[DPRIO_ADDR_WIDTH-1:0]   
                                      :  fsm_dprio_address;
            reconfig_to_pll[12]    =  1'b0;
            reconfig_to_pll[20:13] =  (w_effective_mode == MODE_ADV)  ?  mgmt_writedata[7:0]
                                      :  fsm_dprio_writedata;
           
            // DPS mode outputs: Counter address, num phase shifts, up_dn and DPS en
            reconfig_to_pll[24:21] =  (w_effective_mode == MODE_DPS)  ?  mgmt_writedata[7:4] :  4'b0; // C index
            reconfig_to_pll[27:25] =  (w_effective_mode == MODE_DPS)  ?  mgmt_writedata[2:0] :  3'b0; // # shifts
            reconfig_to_pll[28]    =  (w_effective_mode == MODE_DPS)  ?  mgmt_writedata[3]   :  1'b0; // up_dn
            reconfig_to_pll[29]    =  (w_effective_mode == MODE_DPS)  ?  mgmt_write          :  1'b0; // dps_en
       
            // Assign internal wires
            w_locked_orig          =  reconfig_from_pll[8];
            w_gating_data          =  mgmt_writedata[7:0];
    
            // Set outputs to user
            mgmt_waitrequest       =  (w_effective_mode == MODE_DPS)  ?  reconfig_from_pll[9] // Phase done 
                                      :  fsm_usr_waitrequest;  
            mgmt_readdata[DPRIO_DATA_WIDTH-1:0]  
                                          =  (w_effective_mode == MODE_ADV)  ?  reconfig_from_pll[7:0] 
                                      :  {(DPRIO_ADDR_WIDTH){1'b0}};
        end
    end
    // Set the value of w_first_rom_address based on the user's input index.  
    assign  w_first_rom_address       =  (mgmt_writedata[4:0] == 5'd0)  ?  MIF_ADDRESS_0
                                       : (mgmt_writedata[4:0] == 5'd1)  ?  MIF_ADDRESS_1
                                       : (mgmt_writedata[4:0] == 5'd2)  ?  MIF_ADDRESS_2
                                       : (mgmt_writedata[4:0] == 5'd3)  ?  MIF_ADDRESS_3
                                       : (mgmt_writedata[4:0] == 5'd4)  ?  MIF_ADDRESS_4
                                       : (mgmt_writedata[4:0] == 5'd5)  ?  MIF_ADDRESS_5
                                       : (mgmt_writedata[4:0] == 5'd6)  ?  MIF_ADDRESS_6
                                       : (mgmt_writedata[4:0] == 5'd7)  ?  MIF_ADDRESS_7
                                       : (mgmt_writedata[4:0] == 5'd8)  ?  MIF_ADDRESS_8
                                       : (mgmt_writedata[4:0] == 5'd9)  ?  MIF_ADDRESS_9
                                       : (mgmt_writedata[4:0] == 5'd10)  ?  MIF_ADDRESS_10
                                       : (mgmt_writedata[4:0] == 5'd11)  ?  MIF_ADDRESS_11
                                       : (mgmt_writedata[4:0] == 5'd12)  ?  MIF_ADDRESS_12
                                       : (mgmt_writedata[4:0] == 5'd13)  ?  MIF_ADDRESS_13
                                       : (mgmt_writedata[4:0] == 5'd14)  ?  MIF_ADDRESS_14
                                       : (mgmt_writedata[4:0] == 5'd15)  ?  MIF_ADDRESS_15
                                       : (mgmt_writedata[4:0] == 5'd16)  ?  MIF_ADDRESS_16
                                       : (mgmt_writedata[4:0] == 5'd17)  ?  MIF_ADDRESS_17
                                       : (mgmt_writedata[4:0] == 5'd18)  ?  MIF_ADDRESS_18
                                       : (mgmt_writedata[4:0] == 5'd19)  ?  MIF_ADDRESS_19
                                       : (mgmt_writedata[4:0] == 5'd20)  ?  MIF_ADDRESS_20
                                       : (mgmt_writedata[4:0] == 5'd21)  ?  MIF_ADDRESS_21
                                       : (mgmt_writedata[4:0] == 5'd22)  ?  MIF_ADDRESS_22
                                       : (mgmt_writedata[4:0] == 5'd23)  ?  MIF_ADDRESS_23
                                       : (mgmt_writedata[4:0] == 5'd24)  ?  MIF_ADDRESS_24
                                       : (mgmt_writedata[4:0] == 5'd25)  ?  MIF_ADDRESS_25
                                       : (mgmt_writedata[4:0] == 5'd26)  ?  MIF_ADDRESS_26
                                       : (mgmt_writedata[4:0] == 5'd27)  ?  MIF_ADDRESS_27
                                       : (mgmt_writedata[4:0] == 5'd28)  ?  MIF_ADDRESS_28
                                       : (mgmt_writedata[4:0] == 5'd29)  ?  MIF_ADDRESS_29
                                       : (mgmt_writedata[4:0] == 5'd30)  ?  MIF_ADDRESS_30
                                       : (mgmt_writedata[4:0] == 5'd31)  ?  MIF_ADDRESS_31
                                       :                                    MIF_ADDRESS_0;
    

    // Module Instances *************************************************************************************
    altsyncram #(
        .address_aclr_a("NONE"),
    	.clock_enable_input_a("BYPASS"),
    	.clock_enable_output_a("BYPASS"),
    	.init_file(reconfig_mif_filename),
      	.intended_device_family(device_family),
    	.lpm_hint("ENABLE_RUNTIME_MOD=NO"),
    	.lpm_type("altsyncram"),
    	.numwords_a(ROM_NUM_WORDS),
        .maximum_depth(ROM_NUM_WORDS),
    	.operation_mode("ROM"),
    	.outdata_aclr_a("NONE"),
    	.outdata_reg_a("CLOCK0"),
    	.widthad_a(ROM_ADDR_WIDTH),
    	.width_a(ROM_DATA_WIDTH),
    	.width_byteena_a(1)
    ) altsyncram_inst (
        .address_a (fsm_rom_address),
    	.clock0 (mgmt_clk),
        .q_a (rom_q),
       	.aclr0 (1'b0),
      	.aclr1 (1'b0),
    	.address_b (1'b1),
      	.addressstall_a (1'b0),
        .addressstall_b (1'b0),
     	.byteena_a (1'b1),
     	.byteena_b (1'b1),
      	.clock1 (1'b1),
    	.clocken0 (1'b1),
    	.clocken1 (1'b1),
    	.clocken2 (1'b1),
    	.clocken3 (1'b1),
    	.data_a ({(ROM_ADDR_WIDTH){1'b1}}),
    	.data_b (1'b1),
    	.eccstatus (),
    	.q_b (),
    	.rden_a (1'b1),
    	.rden_b (1'b1),
    	.wren_a (1'b0),
        .wren_b (1'b0)
    );   

    altera_std_synchronizer #(
        .depth(3)
    ) altera_std_synchronizer_inst (
        .clk(mgmt_clk),
        .reset_n(~mgmt_reset), 
        .din(w_locked_orig),
        .dout(synch_locked)
    );
   	
    altera_iopll_reconfig_fsm #(
        .DPRIO_ADDR_WIDTH(DPRIO_ADDR_WIDTH),
        .DPRIO_DATA_WIDTH(DPRIO_DATA_WIDTH),
        .DPRIO_MODE_SEL_WIDTH(DPRIO_MODE_SEL_WIDTH),
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DATA_WIDTH(ROM_DATA_WIDTH),
        .DPRIO_GATING_ADDR(DPRIO_GATING_ADDR),     
        .MIF_EOF(MIF_EOF),   
        .MODE_MIF(MODE_MIF),
        .MODE_GATING(MODE_GATING),
        .WAIT_FOR_LOCK(WAIT_FOR_LOCK)            
    ) altera_iopll_reconfig_fsm_inst (
        .i_clk(mgmt_clk),
    	.i_reset(mgmt_reset),
    	.i_mode(w_effective_mode), 
        .i_write(mgmt_write),
    	.i_first_rom_address(w_first_rom_address), 
    	.i_gating_data(w_gating_data), 
    	.i_locked(synch_locked), 
        .i_rom_q(rom_q),
    
    	.q_rom_address(fsm_rom_address), 
    	.q_dprio_address(fsm_dprio_address), 
    	.q_dprio_writedata(fsm_dprio_writedata),
        .q_dprio_write(fsm_dprio_write),
        .q_usr_waitrequest(fsm_usr_waitrequest)
    );

endmodule
