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



module altera_iopll_reconfig_fsm
#(
    // Family specific information
    parameter   DPRIO_ADDR_WIDTH               = 8,
    parameter   DPRIO_DATA_WIDTH               = 8,
    parameter   DPRIO_MODE_SEL_WIDTH           = 2,
    parameter   ROM_ADDR_WIDTH                 = 10,
    parameter   ROM_DATA_WIDTH                 = 16,
    parameter   DPRIO_GATING_ADDR              = 8'b00010110,

    parameter   MIF_EOF                        = 16'b1111111111111111,
    parameter   MODE_MIF                       = 2'd0,
    parameter   MODE_GATING                    = 2'd2,

    parameter   WAIT_FOR_LOCK                  = "false"
) ( 
    // ********* INPUTS ****************
    // Inputs from user
    input logic                                i_clk,
    input logic                                i_reset,
    input logic                                i_write,
    input logic    [DPRIO_MODE_SEL_WIDTH-1:0]  i_mode,
    input logic    [ROM_ADDR_WIDTH-1:0]        i_first_rom_address,
    input logic    [DPRIO_DATA_WIDTH-1:0]      i_gating_data,
    // Input from IOPLL
    input logic                                i_locked,
    // Input from ROM
    input logic    [ROM_DATA_WIDTH-1:0]        i_rom_q,

    // ********* OUTPUTS ****************
    //  FSM synchronous output to ROM 
    output logic   [ROM_ADDR_WIDTH-1:0]        q_rom_address,
    //  FSM synchronous output to DPRIO
    output logic   [DPRIO_ADDR_WIDTH-1:0]      q_dprio_address,
    output logic   [DPRIO_DATA_WIDTH-1:0]      q_dprio_writedata,
    output logic                               q_dprio_write,
    //  FSM synchronous output to user
    output logic                               q_usr_waitrequest
);
   
    // DECLARATIONS AND ASSIGNMENTS *************************************************************************
    // Declare registers, assign output values and instantiate altsyncram
    // ******************************************************************************************************

    localparam DPRIO_ADDR_BASE        =   {(DPRIO_ADDR_WIDTH){1'b0}};
    localparam DPRIO_DATA_DEFAULT     =   {(DPRIO_DATA_WIDTH){1'b0}};
    localparam ROM_ADDR_DEFAULT       =   {(ROM_ADDR_WIDTH){1'b0}};
	 
    // FSM State Declarations 
    typedef enum logic[2:0] {TOP_FSM_IDLE, TOP_FSM_ROM_0, TOP_FSM_ROM_1, TOP_FSM_ROM_2, TOP_FSM_DPRIO_0,
                             TOP_FSM_END, TOP_FSM_GATING} top_fsm_state;

    // Other useful local parameters
   
    // Combinatorial Declarations 

    logic   [ROM_ADDR_WIDTH-1:0]          d_rom_address; 
    logic   [DPRIO_ADDR_WIDTH-1:0]        d_dprio_address; 
    logic   [DPRIO_DATA_WIDTH-1:0]        d_dprio_writedata;
    logic                                 d_dprio_write;
    logic                                 d_usr_waitrequest;
    top_fsm_state                         d_top_fsm_state;
    top_fsm_state                         q_top_fsm_state;

    // STATE SELECTION LOGIC  *******************************************************************************
    //     MIF MODE:  IDLE, ROM_0, ([ROM_1, ROM_2, DPRIO_0] x # of lines in config) ROM_1, ROM_2, END, IDLE
    //     ADVANCED:  IDLE
    //     GATING:    IDLE, GATING, END 
    //     DPS:       IDLE
    //
    //   Inputs : Current state, i_write, i_locked, i_mode, i_rom_q
    //   Outputs: Next state, next waitrequest
    //
    // *****************************************************************************************************     
    always @(*)
    begin  
        case (q_top_fsm_state)
            // IDLE: Wait for mgmt write to be asserted 
	        TOP_FSM_IDLE:
            	if (i_write && (i_mode == MODE_MIF))
                    d_top_fsm_state    =  TOP_FSM_ROM_0;
            	else if (i_write && (i_mode == MODE_GATING))
                    d_top_fsm_state    =  TOP_FSM_GATING;
                else
                    d_top_fsm_state    =  TOP_FSM_IDLE;
            // ROM 0: Get the first MIF instruction
            TOP_FSM_ROM_0:
        	    d_top_fsm_state        =  TOP_FSM_ROM_1;
            // ROM 1: Wait for the ROM for another cycle 
            TOP_FSM_ROM_1: 
                d_top_fsm_state        =  TOP_FSM_ROM_2;
            // ROM 2: Wait for the ROM for another cycle 
            TOP_FSM_ROM_2: 
                if (i_rom_q != MIF_EOF)
                   d_top_fsm_state     =  TOP_FSM_DPRIO_0;
                else 
                   d_top_fsm_state     =  TOP_FSM_END;
            // DPRIO_0: Send the current instruction to the DPRIO
            TOP_FSM_DPRIO_0: 
                d_top_fsm_state        =  TOP_FSM_ROM_1;
            TOP_FSM_END: 
                if (WAIT_FOR_LOCK == "true" && ~i_locked)
                    d_top_fsm_state    =  TOP_FSM_END;
            	else
                    d_top_fsm_state    =  TOP_FSM_IDLE;
            // GATING: Send the gating instruction to the DPRIO
            TOP_FSM_GATING: 
                d_top_fsm_state        =  TOP_FSM_END;
            default:
                d_top_fsm_state        =  TOP_FSM_IDLE;
	endcase
    end 
   
    // COMBINATIONAL OUTPUT LOGIC  **************************************************************************
    // Set combination output of state machine (to DPRIO, ROM, and user)
    // ******************************************************************************************************  
    always @(*)
    begin
        // Waitrequest is only low during IDLE state *******************************************************
        case (q_top_fsm_state)
            // IDLE: Wait for mgmt write to be asserted 
            TOP_FSM_IDLE:
             	if (i_write && (i_mode == MODE_MIF))
                    d_usr_waitrequest      =  1'b1;
            	else if (i_write && (i_mode == MODE_GATING))
                    d_usr_waitrequest      =  1'b1;
                else
                    d_usr_waitrequest      =  1'b0;
    	    // END : Wait for IOPLL to lock.
    	    TOP_FSM_END: 
    	        if (WAIT_FOR_LOCK == "true" && ~i_locked)
                    d_usr_waitrequest      =  1'b1;
    	    	else
                    d_usr_waitrequest      =  1'b0;
            default:
                d_usr_waitrequest          =  1'b1;
    	endcase

        // DPRIO facing registers ***************************************************************************
        case (i_mode)
            MODE_GATING:
            begin
            	d_rom_address                    =  ROM_ADDR_DEFAULT;
            	case (q_top_fsm_state)
            	    TOP_FSM_IDLE: 
            	    begin // IDLE: Prepare to send gating byte if in gating mode or
            	          // prepare to read from ROM if in MIF Mode. 
            	        if (i_write)
            	        begin
            	            d_dprio_address           =  DPRIO_GATING_ADDR;
            	            d_dprio_writedata         =  i_gating_data;
            	            d_dprio_write             =  1'b1;
            	        end
                        else
                        begin
            	            d_dprio_address           =  DPRIO_ADDR_BASE;
            	            d_dprio_writedata         =  DPRIO_DATA_DEFAULT;
            	            d_dprio_write             =  1'b0;
                        end
                    end
            	    default: 
            	    begin // All other states:  Default values
            	        d_dprio_address               =  DPRIO_ADDR_BASE;
            	        d_dprio_writedata             =  DPRIO_DATA_DEFAULT;
            	        d_dprio_write                 =  1'b0;
            	    end   
                endcase
            end
            MODE_MIF:  
            begin
                case (q_top_fsm_state)
            	    TOP_FSM_IDLE: 
            	    begin // IDLE: Prepare to send gating byte if in gating mode or
            	          // prepare to read from ROM if in MIF Mode. 
            	        d_dprio_address               =  DPRIO_ADDR_BASE;
        	            d_dprio_writedata             =  DPRIO_DATA_DEFAULT;
        	            d_dprio_write                 =  1'b0;
    		            if (i_write)
    		                d_rom_address             =  i_first_rom_address;
    		            else
    		                d_rom_address             =  ROM_ADDR_DEFAULT;
	                end
                    TOP_FSM_ROM_2: 
                    begin // ROM_2: Prepare to send either the current instruction from the ROM, or  
                          // set to default for during END state. 
                        if (i_rom_q != MIF_EOF)
                        begin
                            d_dprio_address           =  i_rom_q[DPRIO_DATA_WIDTH+DPRIO_ADDR_WIDTH-1:DPRIO_DATA_WIDTH];
                            d_dprio_writedata         =  i_rom_q[DPRIO_DATA_WIDTH-1:0];
                            d_dprio_write             =  1'b1;
                            d_rom_address             =  q_rom_address + 1'b1;
                        end
                        else
                        begin
                            d_dprio_address           =  DPRIO_ADDR_BASE;
                            d_dprio_writedata         =  DPRIO_DATA_DEFAULT;
                            d_dprio_write             =  1'b0;
                            d_rom_address             =  ROM_ADDR_DEFAULT;
                        end 
                    end            
                    default:
                    begin // All other states:  Default values
                        d_dprio_address               =  DPRIO_ADDR_BASE;
                        d_dprio_writedata             =  DPRIO_DATA_DEFAULT;
                        d_dprio_write                 =  1'b0;
                        d_rom_address                 =  q_rom_address;
                    end   
    	        endcase
            end
            default :
            begin // In other modes, these signals are unused
                d_dprio_address                       =  DPRIO_ADDR_BASE;
                d_dprio_writedata                     =  DPRIO_DATA_DEFAULT;
                d_dprio_write                         =  1'b0;
                d_rom_address                         =  ROM_ADDR_DEFAULT;
            end
        endcase
    end 

    // SYNCHRONOUS OUTPUT LOGIC  ****************************************************************************
    // Synchronize outputs. 
    //*******************************************************************************************************
    always @(posedge i_clk)
    begin 
        if (i_reset)
        begin
            q_rom_address                     =  ROM_ADDR_DEFAULT;
            q_dprio_address                   =  DPRIO_ADDR_BASE;
            q_dprio_writedata                 =  DPRIO_DATA_DEFAULT;
            q_dprio_write                     =  1'b0;
            q_usr_waitrequest                 =  1'b0;
            q_top_fsm_state                   =  TOP_FSM_IDLE;
        end
        else
        begin
            q_rom_address                     =  d_rom_address;
            q_dprio_address                   =  d_dprio_address;
            q_dprio_writedata                 =  d_dprio_writedata;
            q_dprio_write                     =  d_dprio_write;
            q_usr_waitrequest                 =  d_usr_waitrequest;
            q_top_fsm_state                   =  d_top_fsm_state;
        end      
    end

endmodule
