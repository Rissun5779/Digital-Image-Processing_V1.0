module altera_avalon_sld2mm (
    // system clock/reset
    clk,
    reset_n,
    debug_reset,
    
    // SLD interface
    tdi,
    tck,
    tdo,
    virtual_state_cdr,
    virtual_state_sdr,
    virtual_state_udr,
    virtual_state_uir,
    ir_in,
    jtag_state_rti,
    
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
    output debug_reset;

    input tdi;
    input tck;
    output tdo;
    input virtual_state_cdr;
    input virtual_state_sdr;
    input virtual_state_udr;
    input virtual_state_uir;
    input ir_in;
    input jtag_state_rti;
    
    // connection to Avalon MM/ST
    output [31:0 ] av_writedata;
    output av_write;
    input av_waitrequest;
    output [ADDR_WIDTH-1:0] av_address;
    input [31:0 ] av_readdata;
    output av_read;
    output [1:0 ] debug_extra;
    
    // Wires
    // connection between dr and tck
    wire  [31:0] readdata;
    wire  overrun;
    wire  active;
    wire  [ADDR_WIDTH-1:0] addr;
    wire  set_addr;
    wire  inc;
    wire  rd;
    wire  wr;     
    wire  [31:0] writedata;
    wire  clr;
    wire  cancel;
    wire  xfer_in_cdr;

    // connection between tck and sys
    wire [31:0 ] jtag_writedata;
    wire wr_starting_toggle;
    wire   wr_done;
    wire [ADDR_WIDTH-1:0] sys_addr;
    wire   rd_done;
    wire rd_starting_toggle;
    wire   [31:0 ] rd_data;    
    wire sys_rti;
    wire sys_cancel;

    altera_avalon_sld2mm_dr #(.ADDR_WIDTH(ADDR_WIDTH)) sld2mm_dr (
        // SLD interface
        .reset_n    (reset_n  ),
        .tdi        (tdi   ),
        .tck        (tck   ),
        .tdo        (tdo   ),
        .virtual_state_cdr     (virtual_state_cdr),
        .virtual_state_sdr     (virtual_state_sdr),
        .virtual_state_udr     (virtual_state_udr),
        .virtual_state_uir     (virtual_state_uir),
        .ir_in      (ir_in ),
        
        // Connection to tck domain
        .readdata   (readdata ),
        .overrun    (overrun  ),
        .active     (active   ),
        .addr       (addr     ),
        .set_addr   (set_addr ),
        .inc        (inc      ),
        .rd         (rd       ),
        .wr         (wr       ),     
        .writedata  (writedata),
        .clr        (clr      ),
        .cancel     (cancel   ),
        .xfer_in_cdr(xfer_in_cdr)
    );

    altera_avalon_sld2mm_tck_domain #(.ADDR_WIDTH(ADDR_WIDTH)) sld2mm_tck (
        .tck        (tck      ),
        .reset_n    (reset_n  ),
         // Connection to tck domain
        .readdata   (readdata ),
        .overrun    (overrun  ),
        .active     (active   ),
        .addr       (addr     ),
        .set_addr   (set_addr ),
        .inc        (inc      ),
        .rd         (rd       ),
        .wr         (wr       ),     
        .writedata  (writedata),
        .clr        (clr      ),
        .cancel     (cancel   ),
        .xfer_in_cdr(xfer_in_cdr),
        .jtag_state_rti        (jtag_state_rti      ),
        
        // Connection to sys domain
        .jtag_writedata    (jtag_writedata  ),
        .wr_starting_toggle  (wr_starting_toggle),
        .wr_done    (wr_done  ),
        .sys_addr   (sys_addr ),
        .rd_done    (rd_done  ),
        .rd_starting_toggle  (rd_starting_toggle),
        .rd_data    (rd_data  ),
        .sys_cancel (sys_cancel),
        .sys_rti    (sys_rti  )
    );
   
    altera_avalon_sld2mm_sys_domain #(.ADDR_WIDTH(ADDR_WIDTH)) sld2mm_sys (
        .clk        (clk),
        .reset_n    (reset_n),
        // Connection from tck domain
        .jtag_writedata    (jtag_writedata  ),
        .wr_starting_toggle  (wr_starting_toggle),
        .wr_done    (wr_done  ),
        .sys_addr   (sys_addr ),
        .rd_done    (rd_done  ),
        .rd_starting_toggle  (rd_starting_toggle),
        .rd_data    (rd_data  ),  
        .sys_cancel (sys_cancel  ),
        .sys_rti    (sys_rti  ),
        
        // connection to Avalon_MM/ST
        .av_writedata   (av_writedata  ),
        .av_write       (av_write      ),
        .av_waitrequest (av_waitrequest),
        .av_address     (av_address    ),
        .av_read        (av_read       ), 
        .av_readdata    (av_readdata   ), 
        .debug_extra    (debug_extra   )
    );

    assign debug_reset = ~reset_n;

endmodule
