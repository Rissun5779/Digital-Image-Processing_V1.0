module altera_avalon_sld2mm_dr (
    // SLD interface
    reset_n,
    tdi,
    tck,
    tdo,
    virtual_state_cdr,
    virtual_state_sdr,
    virtual_state_udr,
    virtual_state_uir,
    ir_in,

    // Connection to tck domain
    readdata,
    overrun,
    active,
    addr,
    set_addr,
    inc,
    rd,
    wr,     
    writedata,
    clr,
    cancel,
    xfer_in_cdr
    );
    
parameter ADDR_WIDTH = 10;

// SLD interface
input reset_n;
input tdi;
input tck;
output tdo;
input virtual_state_cdr;
input virtual_state_sdr;
input virtual_state_udr;
input virtual_state_uir;
input ir_in;

// Connection to tck domain
input  [31:0] readdata;
input overrun;
input active;
output [ADDR_WIDTH-1:0] addr;
output set_addr;
output inc;
output rd;
output wr;     
output [31:0] writedata;
output clr;
output reg cancel;
output xfer_in_cdr;

// for the tck register
reg [33:0] sr;
reg vir_reg;

// tr_index calculation
wire active_falling_edge;
reg [17:0] tr_index;
reg active_d1;



always @(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        begin
           vir_reg <= 1'b0;
           sr <= 34'b0;
        end
    else
    begin
      if (virtual_state_cdr)
          case (vir_reg)
              1'b0: begin
                  sr[33:2] <=readdata;
                  sr[1] <= overrun;
                  sr[0] <= active;
              end // 1'b0 
             1'b1: begin
                  sr[22 : 5] <= tr_index;
                  sr[4:0] <= ADDR_WIDTH-1;
              end // 1'b1 
          endcase // ir_in
      if (virtual_state_sdr)
          case (vir_reg)
              1'b0: begin
                  sr <= {tdi, sr[33 : 1]};
              end // 1'b0 
              1'b1: begin
                 sr <= {1'b0, sr[33 : 24], 1'b0, sr[22 : 1]};              
              end // 1'b1 
          endcase // DRsize
      if (virtual_state_uir)
          case (ir_in)
              1'b0: begin
                  vir_reg <= 1'b0;
              end // 1'b0 
              1'b1: begin
                  vir_reg <=1'b1;
              end // 1'b1          
          endcase // ir_in
    end
  assign tdo = sr[0];
  
always @(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        active_d1 <= 1'b0;
    else
        active_d1 <= active;

  
assign active_falling_edge = !active & active_d1;

// TR index increments each time when the active signal toggles and when no overrun occur
always @(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        tr_index <= 18'd0;
    else begin
    if (clr)
        tr_index <= 18'd0;
    else if (active_falling_edge & ~overrun)
        tr_index <= tr_index + 18'b1;
    end



// all op except for WR operation
assign clr       =  ~vir_reg & (sr[31] == 1) & virtual_state_udr & (sr[33:32] != 3);

always @(posedge tck, negedge reset_n)
    if (reset_n == 1'b0)
        cancel <= 0;
    // Only for NOP
    else if (~vir_reg & virtual_state_udr & (sr[33:32] == 0))
        cancel <= sr[30];

// going into the sld2mm_tck_domain
// ~vir_reg is XFER instruction
// synthesis translate_off
assign nop       = ~vir_reg & (sr[33:32] == 0) & virtual_state_udr;
// synthesis translate_on
assign set_addr  = ~vir_reg & (sr[33:32] == 1) & virtual_state_udr;
assign rd        = ~vir_reg & (sr[33:32] == 2) & virtual_state_udr;
assign wr        = ~vir_reg & (sr[33:32] == 3) & virtual_state_udr;
// Word aligned access
assign addr      = {sr[30:33-ADDR_WIDTH],2'b00};
assign inc       = sr[32-ADDR_WIDTH];
assign writedata = sr[31:0];

assign xfer_in_cdr = ~vir_reg & virtual_state_cdr;
endmodule
