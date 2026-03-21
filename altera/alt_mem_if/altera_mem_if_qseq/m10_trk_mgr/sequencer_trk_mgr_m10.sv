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


// ******
// trk_mgr
// ******
//
// TRK Manager
//
// General Description
// -------------------
//
// This component interface to the controller to stall it after refresh
// takes over AFI interface, trigger RW manager to issue DQS calibration routine
// and issue scc manager to update its dqs delay chain when count is reached
//

`timescale 1 ps / 1 ps

module sequencer_trk_mgr #
    ( parameter
        MEM_CHIP_SELECT_WIDTH   = 1,
        MEM_IF_READ_DQS_WIDTH   = 2,
        AVL_DATA_WIDTH          = 32,
        AVL_ADDR_WIDTH          = 20,
        READ_VALID_FIFO_SIZE    = 5,
        MUX_SEL_SEQUENCER_VAL   = 1,
        MUX_SEL_CONTROLLER_VAL  = 0,
        PHY_MGR_BASE            = 20'h00000,
        RW_MGR_BASE             = 20'h08000,
        PLL_MGR_BASE            = 20'h10000,
        LONGIDLE_COUNTER_WIDTH  = 24
    )
    (
    // AFI interface to controller
    afi_ctl_refresh_done,
    afi_seq_busy,
    afi_ctl_long_idle,
    
	// Avalon Interface	
	avl_clk,
	avl_reset_n,
	
	trkm_address,
	trkm_write,
	trkm_writedata,
	trkm_read,
	trkm_readdata,
	trkm_waitrequest,
	
	capture_strobe_tracking
);

	input afi_ctl_refresh_done;
	output afi_seq_busy;
	input afi_ctl_long_idle;

	input avl_clk;
	input avl_reset_n;
	
	output [AVL_ADDR_WIDTH - 1:0] trkm_address;
	output trkm_write;
	output [AVL_DATA_WIDTH - 1:0] trkm_writedata;
	output trkm_read;
	input [AVL_DATA_WIDTH - 1:0] trkm_readdata;
	input trkm_waitrequest;
	
	input [MEM_IF_READ_DQS_WIDTH - 1:0] capture_strobe_tracking;
	
    localparam PHY_MGR_MUX_SEL  =    PHY_MGR_BASE+20'h04008;
    localparam RW_MGR_JMPCOUNT  =    RW_MGR_BASE+20'h800;
    localparam RW_MGR_JMPADDR   =    RW_MGR_BASE+20'hC00;
    
    logic [LONGIDLE_COUNTER_WIDTH-1:0] longidle_counter;
	logic afi_ctl_trk_req_r;
	logic afi_ctl_trk_req_r2;
	logic afi_seq_busy;
	
	logic [AVL_ADDR_WIDTH - 1:0] trkm_address;
	logic trkm_write;
	logic [AVL_DATA_WIDTH - 1:0] trkm_writedata;
	logic trkm_read;
	
	logic reset_jumplogic_done;
	logic avl_prdc_ack;
	logic avl_long_ack;
	logic [1:0] substate; // for 4 jump counters
	
	logic [AVL_DATA_WIDTH - 1:0] count; 
	logic [AVL_DATA_WIDTH - 1:0] longidle_outer_loop;
	
	logic [5:0] afi_mux_delay;
	
	logic [AVL_DATA_WIDTH - 1:0] cfg_sample_count;
	logic [15:0] cfg_longidle_smpl_count;
	logic [5:0] cfg_afi_mux_delay;
	logic [5:0] cfg_vfifo_wait;
	logic [5:0] cfg_trcd;
	logic [15:0] cfg_longidle_outer_loop;
	
	logic [7:0] rw_mgr_idle;
	logic [7:0] rw_mgr_activate_0_and_1;
	logic [7:0] rw_mgr_sgle_read;
	logic [7:0] rw_mgr_precharge_all;
	
	typedef enum int unsigned {
		TRK_MGR_STATE_IDLE,
		TRK_MGR_STATE_JMPCOUNT,
		TRK_MGR_STATE_JMPADDR,
		TRK_MGR_STATE_INIT,
		TRK_MGR_STATE_ACTIVATE,
		TRK_MGR_STATE_READ,
		TRK_MGR_STATE_PRECHARGE,
		TRK_MGR_STATE_DO_SAMPLE,
		TRK_MGR_STATE_RD_SAMPLE,
		TRK_MGR_STATE_CLR_ALL_SMPL,
		TRK_MGR_STATE_CLR_SAMPLE,
		TRK_MGR_STATE_PLL_TRK,
		TRK_MGR_STATE_PLL_CAP,
		TRK_MGR_STATE_RELEASE,
		TRK_MGR_STATE_DONE
	} TRK_MGR_STATE;

	TRK_MGR_STATE avl_state;
	
	logic do_sample;
	logic clr_sample;
	logic [3:0] delay;
	
	localparam SAMPLE_COUNTER_WIDTH = 14;
	
	reg    [MEM_IF_READ_DQS_WIDTH - 1:0] capture_strobe_tracking_r;
	reg signed [SAMPLE_COUNTER_WIDTH - 1:0] sample_counter [MEM_IF_READ_DQS_WIDTH - 1:0];
	
	integer i;
	
	assign afi_seq_busy = avl_prdc_ack | avl_long_ack;
	
	// synchronizer
	always_ff @(posedge avl_clk, negedge avl_reset_n)
        begin
            if (!avl_reset_n)
                begin
                    afi_ctl_trk_req_r  <=  0;
                    afi_ctl_trk_req_r2 <=  0;
                end
            else
                begin
                    afi_ctl_trk_req_r  <=  afi_ctl_refresh_done | afi_ctl_long_idle; 
                    afi_ctl_trk_req_r2 <=  afi_ctl_trk_req_r;
                end
        end
    
    // Clock counter
	always_ff @(posedge avl_clk, negedge avl_reset_n)
        begin
            if (!avl_reset_n)
                longidle_counter  <= 0;
            else
                begin
                    if (afi_seq_busy)
                        longidle_counter  <= 0;
                    else if (!(&longidle_counter))
                        longidle_counter <= longidle_counter + 1'b1;
                end
        end
	
    assign cfg_sample_count         = 2;
    assign cfg_longidle_smpl_count  = 100;
    assign cfg_longidle_outer_loop  = 10;
    assign cfg_afi_mux_delay        = 2;
    assign cfg_vfifo_wait           = 3;
    assign cfg_trcd                 = 2;
    assign rw_mgr_precharge_all     = 'h14;
    assign rw_mgr_sgle_read         = 'h52;
    assign rw_mgr_activate_0_and_1  = 'h11;
    assign rw_mgr_idle              = 'h7;
	
	always_ff @(posedge avl_clk, negedge avl_reset_n)
        begin
            if (!avl_reset_n)
                begin
                    avl_state       <=  TRK_MGR_STATE_IDLE;
                    reset_jumplogic_done    <=  0;
                    substate        <=  0;
                    avl_prdc_ack    <=  0;
                    avl_long_ack    <=  0;
                    count           <=  0;
                    trkm_address    <=  0;
	                trkm_write      <=  1'b0;
	                trkm_writedata  <=  0;
	                trkm_read       <=  1'b0;
	                delay           <=  0;
	                afi_mux_delay   <=  0;
	                longidle_outer_loop <=  0;
	                do_sample       <=  0;
	                clr_sample      <=  0;
                end
            else
                case(avl_state)
                    TRK_MGR_STATE_IDLE :
                        begin
                            trkm_read        <=  1'b0;
                            if (afi_ctl_trk_req_r2)
                                begin
                                    if (reset_jumplogic_done)
                                        avl_state <= TRK_MGR_STATE_INIT;
                                    else
                                        avl_state <= TRK_MGR_STATE_JMPCOUNT;
                                    
                                    avl_long_ack    <=  &longidle_counter;
                                    avl_prdc_ack    <=  ~(&longidle_counter);
                                end
                            else
                                begin
                                    avl_state <= TRK_MGR_STATE_IDLE;
                                end
                        end
                    TRK_MGR_STATE_JMPCOUNT :
                        begin
                            // loop through substate value, empty all jump counter value
                            trkm_write <= 1'b1;
                            trkm_address <= RW_MGR_JMPCOUNT + {substate,2'b00}; // append two zeros because masters are byte addressed
                            trkm_writedata <= 32'h00;
                            if (!trkm_waitrequest && trkm_write)
                                begin
                                    avl_state <= TRK_MGR_STATE_JMPADDR;
                                    trkm_write <= 1'b0;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_JMPADDR :
                        begin
                            // loop through substate value, set jump address to idle
                            trkm_write <= 1'b1;
                            trkm_address <= RW_MGR_JMPADDR + {substate,2'b00};
                            trkm_writedata <= rw_mgr_idle;
                            if (!trkm_waitrequest && trkm_write)
                                begin
                                    trkm_write <= 1'b0;
                                    if (substate == 3) // this is 3 because RW has four jump counters
                                        begin
                                            avl_state   <=  TRK_MGR_STATE_INIT;
                                            reset_jumplogic_done    <=  1;
                                            substate    <=    0;
                                        end
                                    else
                                        begin
                                            avl_state   <=  TRK_MGR_STATE_JMPCOUNT;
                                            substate  <= substate + 1'b1;
                                        end
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_INIT :
                        begin
                            // sequencer takes control over path to memory
                            trkm_write <= 1'b1;
                            trkm_address <= PHY_MGR_MUX_SEL;
                            trkm_writedata <= MUX_SEL_SEQUENCER_VAL;
                            if (cfg_afi_mux_delay == 0 && !trkm_waitrequest && trkm_write)
                                begin
                                    trkm_write <= 1'b0;
                                    if (avl_prdc_ack)
                                        avl_state <= TRK_MGR_STATE_ACTIVATE;
                                    else
                                        begin
                                            avl_state <= TRK_MGR_STATE_CLR_ALL_SMPL;
                                            count   <=  0;
                                            longidle_outer_loop <=  cfg_longidle_outer_loop;
                                        end
                                end
                            else if (afi_mux_delay != 0)
                                begin
                                    trkm_write <= 1'b0;
                                    if (afi_mux_delay == 1)
                                        begin
                                            afi_mux_delay   <=  0;
                                            if (avl_prdc_ack)
                                                avl_state <= TRK_MGR_STATE_ACTIVATE;
                                            else
                                                begin
                                                    avl_state <= TRK_MGR_STATE_CLR_ALL_SMPL;
                                                    count   <=  0;
                                                    longidle_outer_loop <=  cfg_longidle_outer_loop;
                                                end
                                        end
                                    else
                                        afi_mux_delay   <=  afi_mux_delay - 1'b1;
                                end
                            else if (afi_mux_delay == 0 && !trkm_waitrequest && trkm_write)
                                begin
                                    afi_mux_delay   <=  cfg_afi_mux_delay;
                                    trkm_write <= 1'b0;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_ACTIVATE :
                        begin                            
                            // command to RW MGR to activate
                            clr_sample  <=  0;
                            write_task_rw (RW_MGR_BASE     ,rw_mgr_activate_0_and_1     ,TRK_MGR_STATE_READ         ,cfg_trcd);
                        end
                    TRK_MGR_STATE_READ :
                        begin
                            write_task_rw (RW_MGR_BASE     ,rw_mgr_sgle_read            ,TRK_MGR_STATE_DO_SAMPLE    ,cfg_vfifo_wait);
                        end
                    TRK_MGR_STATE_DO_SAMPLE :
                        begin
                            if (count != {AVL_DATA_WIDTH{1'b1}} && do_sample)
                                count <= count + 1'b1;
                            
                            do_sample   <=  1;
                            
                            if (do_sample)
                                begin
                                    do_sample   <=  0;
                                    if (avl_prdc_ack)
                                        avl_state <= TRK_MGR_STATE_PRECHARGE;
                                    else
                                        begin
                                            if (count >= cfg_longidle_smpl_count)
                                                begin
                                                    avl_state <= TRK_MGR_STATE_PRECHARGE;
                                                    count   <= 0;
                                                end
                                            else
                                                begin
                                                    avl_state <= TRK_MGR_STATE_READ;
                                                end
                                        end
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_PRECHARGE :
                        begin                            
                            // command to RW MGR to precharge
                            trkm_write <= 1'b1;
                            trkm_address <= RW_MGR_BASE;
                            trkm_writedata <= rw_mgr_precharge_all;
                            
                            if (!trkm_waitrequest && trkm_write)
                                begin
                                    trkm_write <= 1'b0;
                                    if (avl_prdc_ack)
                                        begin
                                            if (count >= cfg_sample_count)
                                                begin
                                                    avl_state <= TRK_MGR_STATE_PLL_TRK;
                                                    count   <= 0;
                                                end
                                            else
                                                avl_state <= TRK_MGR_STATE_RELEASE;
                                        end
                                    else
                                        avl_state <= TRK_MGR_STATE_PLL_TRK;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_CLR_ALL_SMPL :
                        begin
                            clr_sample  <=  1;
                            
                            if (clr_sample)
                                begin
                                    clr_sample  <=  0;
                                    avl_state <= TRK_MGR_STATE_ACTIVATE;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_PLL_TRK :
                        begin
                            trkm_write <= 1'b1;
                            trkm_address <= PLL_MGR_BASE + 'h4; 
                            
                            if (!sample_counter[0][SAMPLE_COUNTER_WIDTH-1])
                                trkm_writedata <= 32'h0;   
                            else
                                trkm_writedata <= 32'h1;   
                            
                            if (!trkm_waitrequest && trkm_write)
                                begin
                                    avl_state   <=  TRK_MGR_STATE_PLL_CAP;
                                    trkm_write <= 1'b0;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_PLL_CAP :
                        begin
                            trkm_write <= 1'b1;
                            trkm_address <= PLL_MGR_BASE + 'h0; 
                            
                            if (!sample_counter[0][SAMPLE_COUNTER_WIDTH-1])
                                trkm_writedata <= 32'h0;   
                            else
                                trkm_writedata <= 32'h1;   
                            
                            if (!trkm_waitrequest && trkm_write)
                                begin
                                    if ((avl_long_ack && longidle_outer_loop == 0) || avl_prdc_ack)
                                        begin
                                            avl_state <= TRK_MGR_STATE_RELEASE;
                                        end
                                    else
                                        begin
                                            avl_state <= TRK_MGR_STATE_ACTIVATE;
                                            longidle_outer_loop <=  longidle_outer_loop - 1'b1;
                                        end
                                    trkm_write <= 1'b0;
                                    clr_sample  <=  1;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_RELEASE :
                        begin
                            clr_sample  <=  0;
                            
                            // sequencer gives control over path to memory
                            trkm_write <= 1'b1;
                            trkm_address <= PHY_MGR_MUX_SEL;
                            trkm_writedata <= MUX_SEL_CONTROLLER_VAL;
                            if (cfg_afi_mux_delay == 0 && !trkm_waitrequest && trkm_write)
                                begin
                                    trkm_write <= 1'b0;
                                    avl_state <= TRK_MGR_STATE_DONE;
                                    avl_long_ack <= 0;
                                    avl_prdc_ack <= 0;
                                end
                            else if (afi_mux_delay != 0)
                                begin
                                    trkm_write <= 1'b0;
                                    if (afi_mux_delay == 1)
                                        begin
                                            afi_mux_delay   <=  0;
                                            avl_state <= TRK_MGR_STATE_DONE;
                                            avl_long_ack <= 0;
                                            avl_prdc_ack <= 0;
                                        end
                                    else
                                        afi_mux_delay   <=  afi_mux_delay - 1'b1;
                                end
                            else if (afi_mux_delay == 0 && !trkm_waitrequest && trkm_write)
                                begin
                                    afi_mux_delay   <=  cfg_afi_mux_delay;
                                    trkm_write <= 1'b0;
                                end
                            else
                                avl_state <= avl_state;
                        end
                    TRK_MGR_STATE_DONE :
                        begin
                            if (!afi_ctl_trk_req_r2)
                                avl_state <= TRK_MGR_STATE_IDLE;
                            else
                                avl_state <= TRK_MGR_STATE_DONE;
                        end
                endcase
        end
    
task write_task_rw;
    input [AVL_ADDR_WIDTH - 1:0] task_address;
    input [AVL_DATA_WIDTH - 1:0] data;
    input TRK_MGR_STATE next_state;
    input [3:0] delay_int;
    
    begin
        trkm_write       <=  1;
        trkm_address     <=  RW_MGR_BASE + {task_address,2'b0};
        trkm_writedata   <=  data;
        if (delay !=0)
            begin
                trkm_write <= 1'b0;
                if (delay == 1)
                    begin
                        delay   <=  0;
                        avl_state <= next_state;
                    end
                else
                    delay   <=  delay - 1'b1;
            end
        else if (delay == 0 && trkm_write && !trkm_waitrequest)
            begin
                delay       <=  delay_int;
                trkm_write       <=  0;
            end
        else
            avl_state   <=  avl_state;
    end
endtask


always_ff @(posedge avl_clk, negedge avl_reset_n)
    begin
        if (~avl_reset_n)
            capture_strobe_tracking_r    <=    1'b0;
        else
            capture_strobe_tracking_r    <=    capture_strobe_tracking;
    end

always_ff @(posedge avl_clk, negedge avl_reset_n)
    begin
        if (~avl_reset_n)
            begin
                for (i=0; i<MEM_IF_READ_DQS_WIDTH; i=i+1)
                begin
                    sample_counter[i]    <= 1'b0;
                end
            end
        else
            begin
                for (i=0; i<MEM_IF_READ_DQS_WIDTH; i=i+1)
                begin
                    if (clr_sample)
	                    sample_counter[i] <= '0;
	                else if (do_sample)
                        begin
                            if (capture_strobe_tracking_r[i])
                                begin
                                    if (!sample_counter[i][SAMPLE_COUNTER_WIDTH-1] && &sample_counter[i][SAMPLE_COUNTER_WIDTH-2:0])
                                        sample_counter[i]    <=    sample_counter[i];
                                    else
                                        sample_counter[i]    <=    sample_counter[i] + 1'b1;
                                end
                            else if (!capture_strobe_tracking_r[i])
                                begin
                                    if (sample_counter[i][SAMPLE_COUNTER_WIDTH-1] && ~(|sample_counter[i][SAMPLE_COUNTER_WIDTH-2:0]))
                                        sample_counter[i]    <=    sample_counter[i];
                                    else
                                        sample_counter[i]    <=    sample_counter[i] - 1'b1;
                                end
                        end
                end
            end
    end

endmodule
