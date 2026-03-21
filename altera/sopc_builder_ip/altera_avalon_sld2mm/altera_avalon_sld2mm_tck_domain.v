module altera_avalon_sld2mm_tck_domain (
         // Connection from dr domain
        reset_n    ,
        tck        ,
        readdata   ,
        overrun    ,
        active     ,
        addr       ,
        set_addr   ,
        inc        ,
        rd         ,
        wr         ,     
        writedata  ,
        clr        ,
        cancel     ,
        xfer_in_cdr,
        
        // Connection to sys domain
        jtag_writedata    ,
        wr_starting_toggle  ,
        wr_done    ,
        sys_addr   ,
        rd_done    ,
        rd_starting_toggle  ,
        rd_data    ,
        jtag_state_rti,     
        sys_rti,
        sys_cancel
    );
    
    parameter ADDR_WIDTH = 10;
    
    input reset_n;
    input tck;
// Connection from dr domain
output  [31:0] readdata;
output  reg overrun;
output  active;
input   [ADDR_WIDTH-1:0] addr;
input   set_addr;
input   inc;
input   rd;
input   wr;     
input   [31:0] writedata;
input   clr;
input   cancel;
input   xfer_in_cdr;

// connection to sys domain
output reg [31:0 ] jtag_writedata;
output reg wr_starting_toggle;
input  wr_done;
output reg [ADDR_WIDTH-1:0] sys_addr;
input  rd_done;
output reg rd_starting_toggle;
input  [31:0 ] rd_data;
input  jtag_state_rti;     
output reg sys_rti;
output reg sys_cancel;

// wires and registers
// JTAG ADDR
reg inc_reg;

wire [ADDR_WIDTH-1:0] sys_addr_nxt;
wire sys_want_new_addr;
wire sys_addr_en;
wire sys_addr_inc;
wire any_overrun_detected;

// JTAG WRITE 
reg wr_active;
reg wr_active_d1;
wire wr_done_sync;
reg wr_done_sync_d1;

wire wr_starting;
wire wr_overrun_detected;
// JTAG READ
reg rd_active;
reg rd_active_d1;
reg active_xfer_in_cdr_d1;
reg xfer_in_cdr_d1;
wire rd_done_sync;
reg rd_done_sync_d1;

wire rd_starting;
wire rd_overrun_detected;

// synchronizers for wr_done and rd_done

altera_std_synchronizer #(.depth(2)) wr_done_synchronizer (
        .clk(tck),
        .reset_n(reset_n),
        .din(wr_done),
        .dout(wr_done_sync));

altera_std_synchronizer #(.depth(2)) rd_done_synchronizer (
        .clk(tck),
        .reset_n(reset_n),
        .din(rd_done),
        .dout(rd_done_sync));

// SYS RTI
    always @(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        sys_rti <= 1'b0;
    else
        sys_rti <= sys_rti ^ jtag_state_rti;

// SYS CANCEL
    always @(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        sys_cancel <= 1'b0;
    else
        sys_cancel <= sys_cancel ^ cancel;
/*    
    Describe the Hardware behavior of JTAG ADDR
*/
    // inc regirester
    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        inc_reg <= 1'b0;
    else
        if (set_addr) 
            inc_reg <= inc;

    assign sys_addr_inc = ~wr_active & wr_active_d1 & inc_reg; 
    // want new address when it is a set addr or rd starting
    assign sys_want_new_addr = set_addr | rd_starting;
    assign sys_addr_en = sys_addr_inc | sys_want_new_addr;        
    assign sys_addr_nxt = sys_addr_inc ? sys_addr + 3'b100 : addr;
    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        sys_addr <= 0;
    else
        if (sys_addr_en)
            sys_addr <= sys_addr_nxt;
            
    // Active and Overrun here
    assign active = wr_active | rd_active;
    
    assign any_overrun_detected = wr_overrun_detected | rd_overrun_detected;

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        overrun <= 1'b0;
    else
        overrun <= any_overrun_detected | (overrun & ~clr) ;
/*    
    Describe the Hardware behavior of JTAG WRITE
*/ 
    assign wr_starting = wr & ~(active | overrun);
    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        jtag_writedata <= 0;
    else
        if (wr_starting)
            jtag_writedata <= writedata;

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        wr_starting_toggle <= 1'b0;
    else
        wr_starting_toggle <= wr_starting ^ wr_starting_toggle;

    always@(posedge tck, negedge reset_n)
    if (reset_n == 1'b0) begin
        wr_done_sync_d1 <= 1'b0;
    end else begin
        wr_done_sync_d1 <= wr_done_sync;
    end

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        wr_active <= 1'b0;
    else
        wr_active <= wr_active ? ~(wr_done_sync ^ wr_done_sync_d1) : wr_starting;

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        wr_active_d1 <= 1'b0;
    else
        wr_active_d1 <= wr_active;

    assign wr_overrun_detected = wr & active;

/*    
    Describe the Hardware behavior of JTAG READ
*/
    always@(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        xfer_in_cdr_d1 <= 1'b0;
    else
        xfer_in_cdr_d1 <= xfer_in_cdr;
        
    always@(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        active_xfer_in_cdr_d1 <= 1'b0;
    else
        if (xfer_in_cdr_d1)
            active_xfer_in_cdr_d1 <= rd_active_d1;

    assign rd_starting = rd & ~(wr_active | active_xfer_in_cdr_d1 | overrun);

    always@(posedge tck, negedge reset_n)
    if (reset_n == 1'b0) begin
        rd_done_sync_d1 <= 1'b0;
    end else begin
        rd_done_sync_d1 <= rd_done_sync;
    end

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        rd_active <= 1'b0;
    else
        rd_active <= rd_active ? ~(rd_done_sync ^ rd_done_sync_d1) : rd_starting;

    always@(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        rd_active_d1 <= 1'b0;
    else
        rd_active_d1 <= rd_active;

    always@(negedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        rd_starting_toggle <= 1'b0;
    else
        rd_starting_toggle <= rd_starting ^ rd_starting_toggle;
     
    assign readdata = rd_data;
    
    assign rd_overrun_detected = (wr_active & rd) | (rd & active_xfer_in_cdr_d1);
endmodule
