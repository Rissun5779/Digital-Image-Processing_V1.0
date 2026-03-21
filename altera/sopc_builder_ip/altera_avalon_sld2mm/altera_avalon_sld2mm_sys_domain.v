module altera_avalon_sld2mm_sys_domain (
        clk        ,
        reset_n    ,
        // Connection from tck domain
        jtag_writedata    ,
        wr_starting_toggle  ,
        wr_done    ,
        sys_addr   ,
        rd_done    ,
        rd_starting_toggle  ,
        rd_data    ,
        sys_rti    ,
        sys_cancel ,
        
        // connection to Avalon_MM/ST
        av_writedata   ,
        av_write       ,
        av_waitrequest ,
        av_address     ,
        av_read        , 
        av_readdata    , 
        debug_extra
    );
    
    parameter ADDR_WIDTH = 10;
    input clk;
    input reset_n;
    // connection from tck domain
input [31:0 ] jtag_writedata;
input wr_starting_toggle;
output reg  wr_done;
input [ADDR_WIDTH-1:0] sys_addr;
output reg rd_done;
input rd_starting_toggle;
output reg [31:0 ] rd_data;    
input sys_rti;
input sys_cancel;

    // connection to SLD2MM
output reg [31:0 ] av_writedata;
output reg av_write;
input av_waitrequest;
output reg [ADDR_WIDTH-1:0] av_address;
input [31:0 ] av_readdata;
output reg av_read;
output [1:0 ] debug_extra;

// Wire and regs
// Avalon ADDR
wire av_address_reg_en;
// Avalon WRITE
reg wr_starting_toggle_sync_d1;
wire wr_starting_toggle_sync;
reg wr_done_toggle;
wire wr_starting_sync;

// Avalon READ
reg rd_starting_toggle_sync_d1;
wire rd_starting_toggle_sync;
wire rd_starting_toggle;
reg rd_done_toggle;

reg sys_rti_sync_d1;
wire sys_rti_sync;
reg sys_cancel_sync_d1;
wire sys_cancel_sync;

// synchronizers

altera_std_synchronizer #(.depth(2)) wr_starting_toggle_synchronizer (
        .clk(clk),
        .reset_n(reset_n),
        .din(wr_starting_toggle),
        .dout(wr_starting_toggle_sync));

altera_std_synchronizer #(.depth(2)) rd_starting_toggle_synchronizer (
        .clk(clk),
        .reset_n(reset_n),
        .din(rd_starting_toggle),
        .dout(rd_starting_toggle_sync));

altera_std_synchronizer #(.depth(2)) sys_rti_synchronizer (
        .clk(clk),
        .reset_n(reset_n),
        .din(sys_rti),
        .dout(sys_rti_sync));

altera_std_synchronizer #(.depth(2)) sys_cancel_synchronizer (
        .clk(clk),
        .reset_n(reset_n),
        .din(sys_cancel),
        .dout(sys_cancel_sync));

wire rd_starting_sync;
reg [31:0] readdata_d1;
// RTI and CANCEL
    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0) begin
        sys_rti_sync_d1 <= 0;
    end else begin
        sys_rti_sync_d1 <= sys_rti_sync;
    end

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0) begin
        sys_cancel_sync_d1 <= 0;
    end else begin
        sys_cancel_sync_d1 <= sys_cancel_sync;
    end

    assign debug_extra = {(sys_cancel_sync ^ sys_cancel_sync_d1),(sys_rti_sync ^ sys_rti_sync_d1)};
/*    
    Describe the Hardware behavior of Avalon ADDR
*/ 
    assign av_address_reg_en = wr_starting_sync | rd_starting_sync;
    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        av_address <= 0;
    else
        if (av_address_reg_en)
            av_address <= sys_addr;
/*    
    Describe the Hardware behavior of Avalon WRITE
*/
    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0) begin
        wr_starting_toggle_sync_d1 <= 0;
    end else begin
        wr_starting_toggle_sync_d1 <= wr_starting_toggle_sync;
    end
    
    assign wr_starting_sync = wr_starting_toggle_sync ^ wr_starting_toggle_sync_d1;

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        av_write <= 0;
    else
        av_write <= wr_starting_sync | (av_write & av_waitrequest);

    always@(negedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        wr_done <= 0;
    else
        wr_done <= wr_done_toggle;

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        wr_done_toggle <= 0;
    else
        wr_done_toggle <= wr_done_toggle ^ (av_write & ~av_waitrequest);
        
    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        av_writedata <= 0;
    else
        av_writedata <= jtag_writedata;
/*    
    Describe the Hardware behavior of Avalon READ
*/ 

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0) begin
        rd_starting_toggle_sync_d1 <= 0;
    end else begin
        rd_starting_toggle_sync_d1 <= rd_starting_toggle_sync;
    end
    
    assign rd_starting_sync = rd_starting_toggle_sync ^ rd_starting_toggle_sync_d1;

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        av_read <= 0;
    else
        av_read <= rd_starting_sync | (av_read & av_waitrequest);

    always@(negedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        rd_done <= 0;
    else
        rd_done <= rd_done_toggle;

    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        rd_done_toggle <= 0;
    else
        rd_done_toggle <= rd_done_toggle ^ (av_read & ~av_waitrequest);
        
    always@(posedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        readdata_d1 <= 0;
    else
        if (av_read)
            readdata_d1 <= av_readdata;

    always@(negedge clk, negedge reset_n)
    if (reset_n == 1'b0)
        rd_data <= 0;
    else
        rd_data <= readdata_d1;
endmodule
