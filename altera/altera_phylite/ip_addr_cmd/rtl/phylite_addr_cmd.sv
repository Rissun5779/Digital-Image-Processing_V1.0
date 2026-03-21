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


module phylite_addr_cmd
(
    cmd_clk,
    interface_locked,
    cmd_from_core,

    core_cmd_oe,
    core_cmd_clk,
    core_cmd_clk_oe,

    ck,
    cmd
);
parameter PHYLITE_NUM_GROUPS            = 1                 ;
parameter PHYLITE_RATE_ENUM             = "RATE_IN_QUARTER" ;
parameter SIM_CMD_DELAY                 = 257                 ;   
parameter integer PLL_VCO_TO_MEM_CLK_FREQ_RATIO = 1 ;

localparam integer RATE_MULT =  (PHYLITE_RATE_ENUM == "RATE_IN_QUARTER") ? 4 :
                                (PHYLITE_RATE_ENUM == "RATE_IN_HALF")    ? 2 :
                                                                           1 ;

localparam integer SIM_CTRL_CMD_WIDTH     = (3 + PHYLITE_NUM_GROUPS) * RATE_MULT;
localparam integer STRB_CMD_WIDTH	  = 2 * RATE_MULT;

input  wire                                   cmd_clk;
input  wire                                   interface_locked;
input  wire  [SIM_CTRL_CMD_WIDTH - 1 : 0]     cmd_from_core;

input  wire  [SIM_CTRL_CMD_WIDTH - 1 : 0]     core_cmd_oe;
input  wire  [STRB_CMD_WIDTH - 1 : 0]         core_cmd_clk;
input  wire  [RATE_MULT - 1 : 0]     core_cmd_clk_oe;


output logic                                  ck;
output logic [PHYLITE_NUM_GROUPS + 3 - 1 : 0] cmd;      

real  dram_clk_period;
real cmd_dly;

logic [SIM_CTRL_CMD_WIDTH - 1 : 0]     cmd_from_core_reg;
int   count = 0;
logic [PHYLITE_NUM_GROUPS + 3 - 1 : 0] cmd_r1, cmd_r2, cmd_c;
int  pipe = 0;

initial begin
    ck <= 1'b0;
    cmd_c <= 0;
    cmd_r1 <= 0;
    cmd_r2 <= 0;

    wait (interface_locked);

    calc_dram_period();

    @(posedge cmd_clk);
    
    cmd_dly = real'(SIM_CMD_DELAY) * real'(dram_clk_period) / real'(128 * PLL_VCO_TO_MEM_CLK_FREQ_RATIO);
    
    pipe = int'(cmd_dly / dram_clk_period);

    $display("Command Delay in ps: %f ps, number of pipeline %0d", cmd_dly, pipe);

    #(cmd_dly);  

    forever begin
        #(dram_clk_period/2) ck  = ~ck;
	#(dram_clk_period - (dram_clk_period/2)) ck = ~ck;
    end
end

always @(posedge cmd_clk) begin
    cmd_from_core_reg <= cmd_from_core;
end

always @(*) begin
	case (pipe) 
		0 : cmd <= cmd_c;
		1 : cmd <= cmd_r1;
		2 : cmd <= cmd_r2;
		default : cmd <= cmd_c;
	endcase
end

always @(negedge ck) begin
    cmd_r1 <= cmd_c;
    cmd_r2 <= cmd_r1;
end

always @(negedge ck) begin
    cmd_c[0] <=  cmd_from_core_reg[(4 * count)];
    cmd_c[1] <=  cmd_from_core_reg[(4 * count) + 1];
    cmd_c[2] <=  cmd_from_core_reg[(4 * count) + 2];
    cmd_c[3] <=  cmd_from_core_reg[(4 * count) + 3];  

    count <= (count < RATE_MULT-1) ? count + 1 : 0;
end

    task calc_dram_period();
        time redge1, redge2;
        time cmd_clk_period;
        real div;
        @(posedge cmd_clk);
        redge1 = $time;
        @(posedge cmd_clk);
        redge2 = $time;
        cmd_clk_period = redge2-redge1;

        div = real'(RATE_MULT);

        dram_clk_period = int'(real'(cmd_clk_period / div) + 0.5 );
        $display("phylite_sim_cmd_gen: Core clock period = %f ps, Synethsized cmd clock period = %f ps", cmd_clk_period, dram_clk_period);
    endtask

endmodule
