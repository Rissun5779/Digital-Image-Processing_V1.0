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


// ********************************************************************************************************************************
// Filename: afi_gasket.v
// This module contains logic necessary to handle DIMMs where the number of chip select signals does not
// necessarily match the number of physical ranks in the system (e.g. RDIMMs and LRDIMMs).
// ********************************************************************************************************************************

`timescale 1 ps / 1 ps

module afi_gasket_ddr2_ddrx (

    afi_ctlr_addr,
    afi_ctlr_ba,
    afi_ctlr_cs_n,
    afi_ctlr_cke,
    afi_ctlr_odt,
    afi_ctlr_ras_n,
    afi_ctlr_cas_n,
    afi_ctlr_we_n,
    afi_ctlr_dm,
    afi_ctlr_wlat,
    afi_ctlr_rlat,
    afi_ctlr_dqs_burst,
    afi_ctlr_cal_success,
    afi_ctlr_cal_fail,
    afi_ctlr_cal_req,
    afi_ctlr_init_req,
    afi_ctlr_wdata,
    afi_ctlr_wdata_valid,
    afi_ctlr_rdata_en,
    afi_ctlr_rdata_en_full,
    afi_ctlr_rdata,
    afi_ctlr_rdata_valid,
    afi_ctlr_mem_clk_disable,





    afi_addr,
    afi_ba,
    afi_cs_n,
    afi_cke,
    afi_odt,
    afi_ras_n,
    afi_cas_n,
    afi_we_n,
    afi_dm,
    afi_wlat,
    afi_rlat,
    afi_dqs_burst,
    afi_cal_success,
    afi_cal_fail,
    afi_cal_req,
    afi_init_req,
    afi_wdata,
    afi_wdata_valid,
    afi_rdata_en,
    afi_rdata_en_full,
    afi_rdata,
    afi_rdata_valid,
    afi_mem_clk_disable
);

// Controller-facing parameters
parameter AFI_CTLR_ADDR_WIDTH            = 0;
parameter AFI_CTLR_BANKADDR_WIDTH        = 0;
parameter AFI_CTLR_CLK_EN_WIDTH          = 0;
parameter AFI_CTLR_CS_WIDTH              = 0;
parameter AFI_CTLR_ODT_WIDTH             = 0;
parameter AFI_CTLR_WLAT_WIDTH            = 0;
parameter AFI_CTLR_RLAT_WIDTH            = 0;
parameter AFI_CTLR_RRANK_WIDTH           = 0;
parameter AFI_CTLR_WRANK_WIDTH           = 0;
parameter AFI_CTLR_DM_WIDTH              = 0;
parameter AFI_CTLR_CONTROL_WIDTH         = 0;
parameter AFI_CTLR_DQ_WIDTH              = 0;
parameter AFI_CTLR_WRITE_DQS_WIDTH       = 0;
parameter AFI_CTLR_RATE_RATIO            = 0;
parameter AFI_CTLR_CLK_PAIR_COUNT        = 0;
parameter AFI_CTLR_MEM_IF_CS_WIDTH       = 0;

// AFIMux-facing parameters
parameter AFI_MUX_ADDR_WIDTH             = 0;
parameter AFI_MUX_BANKADDR_WIDTH         = 0;
parameter AFI_MUX_CLK_EN_WIDTH           = 0;
parameter AFI_MUX_CS_WIDTH               = 0;
parameter AFI_MUX_ODT_WIDTH              = 0;
parameter AFI_MUX_WLAT_WIDTH             = 0;
parameter AFI_MUX_RLAT_WIDTH             = 0;
parameter AFI_MUX_RRANK_WIDTH            = 0;
parameter AFI_MUX_WRANK_WIDTH            = 0;
parameter AFI_MUX_DM_WIDTH               = 0;
parameter AFI_MUX_CONTROL_WIDTH          = 0;
parameter AFI_MUX_DQ_WIDTH               = 0;
parameter AFI_MUX_WRITE_DQS_WIDTH        = 0;
parameter AFI_MUX_RATE_RATIO             = 0;
parameter AFI_MUX_CLK_PAIR_COUNT         = 0;
parameter AFI_MUX_MEM_IF_CS_WIDTH        = 0;

parameter MEM_CS_WIDTH                   = 0;
parameter MEM_NUMBER_OF_DIMMS            = 0;
parameter MEM_NUMBER_OF_RANKS_PER_DIMM   = 0;
parameter MEM_IF_NUMBER_OF_RANKS         = 0;
parameter MEM_RANK_MULTIPLICATION_FACTOR = 0; 
parameter MEM_IF_LRDIMM_RM               = 0;
parameter DDR2_RDIMM                     = 0;
parameter DDR3_RDIMM                     = 0;
parameter DDR3_LRDIMM                    = 0;



// AFI Inputs from Controller
input              [AFI_CTLR_ADDR_WIDTH-1:0]  afi_ctlr_addr;
input          [AFI_CTLR_BANKADDR_WIDTH-1:0]  afi_ctlr_ba;
input           [AFI_CTLR_CONTROL_WIDTH-1:0]  afi_ctlr_cas_n;
input            [AFI_CTLR_CLK_EN_WIDTH-1:0]  afi_ctlr_cke;
input                [AFI_CTLR_CS_WIDTH-1:0]  afi_ctlr_cs_n;
input               [AFI_CTLR_ODT_WIDTH-1:0]  afi_ctlr_odt;
input           [AFI_CTLR_CONTROL_WIDTH-1:0]  afi_ctlr_ras_n;
input           [AFI_CTLR_CONTROL_WIDTH-1:0]  afi_ctlr_we_n;
input                [AFI_CTLR_DM_WIDTH-1:0]  afi_ctlr_dm;
output             [AFI_CTLR_WLAT_WIDTH-1:0]  afi_ctlr_wlat;
output             [AFI_CTLR_RLAT_WIDTH-1:0]  afi_ctlr_rlat;
input         [AFI_CTLR_WRITE_DQS_WIDTH-1:0]  afi_ctlr_dqs_burst;
input                [AFI_CTLR_DQ_WIDTH-1:0]  afi_ctlr_wdata;
input         [AFI_CTLR_WRITE_DQS_WIDTH-1:0]  afi_ctlr_wdata_valid;
input              [AFI_CTLR_RATE_RATIO-1:0]  afi_ctlr_rdata_en;
input              [AFI_CTLR_RATE_RATIO-1:0]  afi_ctlr_rdata_en_full;
output               [AFI_CTLR_DQ_WIDTH-1:0]  afi_ctlr_rdata;
output             [AFI_CTLR_RATE_RATIO-1:0]  afi_ctlr_rdata_valid;
output                                        afi_ctlr_cal_success;
output                                        afi_ctlr_cal_fail;
input                                         afi_ctlr_cal_req;
input                                         afi_ctlr_init_req;
input          [AFI_CTLR_CLK_PAIR_COUNT-1:0]  afi_ctlr_mem_clk_disable;


// AFI Outputs to Mux
output             [AFI_MUX_ADDR_WIDTH-1:0]   afi_addr;
output         [AFI_MUX_BANKADDR_WIDTH-1:0]   afi_ba;
output          [AFI_MUX_CONTROL_WIDTH-1:0]   afi_cas_n;
output           [AFI_MUX_CLK_EN_WIDTH-1:0]   afi_cke;
output               [AFI_MUX_CS_WIDTH-1:0]   afi_cs_n;
output              [AFI_MUX_ODT_WIDTH-1:0]   afi_odt;
output          [AFI_MUX_CONTROL_WIDTH-1:0]   afi_ras_n;
output          [AFI_MUX_CONTROL_WIDTH-1:0]   afi_we_n;
output               [AFI_MUX_DM_WIDTH-1:0]   afi_dm;
input              [AFI_MUX_WLAT_WIDTH-1:0]   afi_wlat;
input              [AFI_MUX_RLAT_WIDTH-1:0]   afi_rlat;
output        [AFI_MUX_WRITE_DQS_WIDTH-1:0]   afi_dqs_burst;
output               [AFI_MUX_DQ_WIDTH-1:0]   afi_wdata;
output        [AFI_MUX_WRITE_DQS_WIDTH-1:0]   afi_wdata_valid;
output             [AFI_MUX_RATE_RATIO-1:0]   afi_rdata_en;
output             [AFI_MUX_RATE_RATIO-1:0]   afi_rdata_en_full;
input                [AFI_MUX_DQ_WIDTH-1:0]   afi_rdata;
input              [AFI_MUX_RATE_RATIO-1:0]   afi_rdata_valid;
input                                         afi_cal_success;
input                                         afi_cal_fail;
output                                        afi_cal_req;
output                                        afi_init_req;
output         [AFI_MUX_CLK_PAIR_COUNT-1:0]   afi_mem_clk_disable;




// Pass-Through Signals
assign afi_ctlr_wlat[AFI_CTLR_WLAT_WIDTH-1:0]                           = afi_wlat[AFI_MUX_WLAT_WIDTH-1:0];
assign afi_ctlr_rlat[AFI_CTLR_RLAT_WIDTH-1:0]                           = afi_rlat[AFI_MUX_RLAT_WIDTH-1:0];
assign afi_ctlr_rdata[AFI_CTLR_DQ_WIDTH-1:0]                            = afi_rdata[AFI_MUX_DQ_WIDTH-1:0];
assign afi_ctlr_rdata_valid[AFI_CTLR_RATE_RATIO-1:0]                    = afi_rdata_valid[AFI_MUX_RATE_RATIO-1:0];
assign afi_ctlr_cal_success                                             = afi_cal_success;
assign afi_ctlr_cal_fail                                                = afi_cal_fail;
assign afi_ba[AFI_MUX_BANKADDR_WIDTH-1:0]                               = afi_ctlr_ba[AFI_CTLR_BANKADDR_WIDTH-1:0];
assign afi_cas_n[AFI_MUX_CONTROL_WIDTH-1:0]                             = afi_ctlr_cas_n[AFI_CTLR_CONTROL_WIDTH-1:0];
assign afi_ras_n[AFI_MUX_CONTROL_WIDTH-1:0]                             = afi_ctlr_ras_n[AFI_CTLR_CONTROL_WIDTH-1:0];
assign afi_we_n[AFI_MUX_CONTROL_WIDTH-1:0]                              = afi_ctlr_we_n[AFI_CTLR_CONTROL_WIDTH-1:0];
assign afi_dm[AFI_MUX_DM_WIDTH-1:0]                                     = afi_ctlr_dm[AFI_CTLR_DM_WIDTH-1:0];
assign afi_dqs_burst[AFI_MUX_WRITE_DQS_WIDTH-1:0]                       = afi_ctlr_dqs_burst[AFI_CTLR_WRITE_DQS_WIDTH-1:0];
assign afi_wdata[AFI_MUX_DQ_WIDTH-1:0]                                  = afi_ctlr_wdata[AFI_CTLR_DQ_WIDTH-1:0];
assign afi_wdata_valid[AFI_MUX_WRITE_DQS_WIDTH-1:0]                     = afi_ctlr_wdata_valid[AFI_CTLR_WRITE_DQS_WIDTH-1:0];
assign afi_rdata_en[AFI_MUX_RATE_RATIO-1:0]                             = afi_ctlr_rdata_en[AFI_CTLR_RATE_RATIO-1:0];
assign afi_rdata_en_full[AFI_MUX_RATE_RATIO-1:0]                        = afi_ctlr_rdata_en_full[AFI_CTLR_RATE_RATIO-1:0];
assign afi_init_req                                                     = afi_ctlr_init_req;
assign afi_mem_clk_disable[AFI_MUX_CLK_PAIR_COUNT-1:0]                  = afi_ctlr_mem_clk_disable[AFI_CTLR_CLK_PAIR_COUNT-1:0];
assign afi_cal_req                                                      = afi_ctlr_cal_req;
assign afi_cke[AFI_MUX_CLK_EN_WIDTH-1:0]                                = afi_ctlr_cke[AFI_CTLR_CLK_EN_WIDTH-1:0];
assign afi_odt[AFI_MUX_ODT_WIDTH-1:0]                                   = afi_ctlr_odt[AFI_CTLR_ODT_WIDTH-1:0];


genvar i, j, k;

wire [(AFI_MUX_CS_WIDTH-1): 0] w_afi_mux_cs_n;

// Replication/Signal tie-offs
generate
   //  RDIMMs don't use rank multiplication, however, they require a minimum of two chip select signals to support register programming.
   //  If only one rank is present, the CS/ODT/CKE signals need to be adjusted accordingly.
   if ((DDR3_RDIMM == 1) || (DDR2_RDIMM == 1))
   begin : gen_rdimm
      if (MEM_NUMBER_OF_RANKS_PER_DIMM == 1)
      begin : gen_rdimm_nr1
         for (i = 0; i < AFI_CTLR_CS_WIDTH; i = i + 1)
         begin : gen_rdimm_nr1_interleave
            assign afi_cs_n[((2*i)+1):(2*i)] = {1'b1, afi_ctlr_cs_n[i]};
         end
      end
      else if (MEM_NUMBER_OF_RANKS_PER_DIMM == 2)
      begin : gen_rdimm_nr2
         assign afi_cs_n[AFI_MUX_CS_WIDTH-1:0] = afi_ctlr_cs_n[AFI_CTLR_CS_WIDTH-1:0];
      end
      else if (MEM_NUMBER_OF_RANKS_PER_DIMM == 4)
      begin : gen_rdimm_nr4
         assign afi_cs_n[AFI_MUX_CS_WIDTH-1:0] = afi_ctlr_cs_n[AFI_CTLR_CS_WIDTH-1:0];
      end
         
      assign afi_addr[AFI_MUX_ADDR_WIDTH-1:0] = afi_ctlr_addr[AFI_CTLR_ADDR_WIDTH-1:0];
   end

   //  LRDIMMs can use rank multiplication and also require a minimum of two chip select signals for register programming.
   //  They can accomodate a total of eight ranks per slot.  Note that single-rank LRDIMMs aren't supported.
   if (DDR3_LRDIMM == 1)
   begin : gen_lrdimm
      //  The DDR3 spec supports 16 address pins and up to 4 CS pins. 
      //  LRDIMMs use rank multiplication to allow controllers to access multiple physical
      //  banks by stitching them together and using additional row bits.
      //  The controller can remain unaware of this logical mapping, but when the number
      //  of row address bits exceeds 16, CS2 becomes A16 and CS3 becomes A17.
        
      if (MEM_IF_LRDIMM_RM == 1)
      begin : gen_lrdimm_rm1
         //  RM = 1; CS's are passed straight through
         assign afi_cs_n[AFI_MUX_CS_WIDTH-1:0] = afi_ctlr_cs_n[AFI_CTLR_CS_WIDTH-1: 0];
         assign afi_addr[AFI_MUX_ADDR_WIDTH-1:0] = afi_ctlr_addr[AFI_CTLR_ADDR_WIDTH-1:0];
      end
      else if (MEM_IF_LRDIMM_RM == 2)
      begin : gen_lrdimm_rm2
         //  RM = 2 - 4Gbit devices require an extra address bit that becomes CS2,
         //  all other cases are already handled.
         if (AFI_CTLR_ADDR_WIDTH == (AFI_CTLR_RATE_RATIO * 17))
         begin : gen_lrdimm_rm2_4gbit
            //  A[16] gets remapped to CS[2].
            for (j = 0; j < AFI_CTLR_RATE_RATIO; j = j + 1)
            begin : gen_lrdimm_rm2_4gbit_afislot
               for (k = 0; k < MEM_NUMBER_OF_DIMMS; k = k + 1)
               begin : gen_lrdimm_rm2_4gbit_afislot_dimmslot
                  //  AFI_MUX: CS[2:0]  <=> AFI_CTLR: {A[16],CS[1:0]}
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)  ] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)  ];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)+1] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)+1];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)+2] = afi_ctlr_addr[(j*17) + 16];
               end

               assign afi_addr[(j*16)+15:(j*16)] = afi_ctlr_addr[(j*17)+15:(j*17)];
            end
         end
         else
         begin : gen_rm2_1gbit_2gbit
            assign afi_cs_n[AFI_MUX_CS_WIDTH-1:0] = afi_ctlr_cs_n[AFI_CTLR_CS_WIDTH-1:0];
            assign afi_addr[AFI_MUX_ADDR_WIDTH-1:0] = afi_ctlr_addr[AFI_CTLR_ADDR_WIDTH-1:0];
         end

      end
      else if (MEM_IF_LRDIMM_RM == 4)
      begin : gen_lrdimm_rm4
         if (AFI_CTLR_ADDR_WIDTH == (AFI_CTLR_RATE_RATIO * 16))
         begin : gen_lrdimm_rm4_4gbit
            assign afi_cs_n[AFI_MUX_CS_WIDTH-1:0] = afi_ctlr_cs_n[AFI_CTLR_CS_WIDTH-1: 0];
            assign afi_addr[AFI_MUX_ADDR_WIDTH-1:0] = afi_ctlr_addr[AFI_CTLR_ADDR_WIDTH-1:0];
         end
         else if (AFI_CTLR_ADDR_WIDTH == (AFI_CTLR_RATE_RATIO * 17))
         begin : gen_lrdimm_rm4_8gbit
            //  A[16] gets remapped to CS[2].
            for (j = 0; j < AFI_CTLR_RATE_RATIO; j = j + 1)
            begin : gen_lrdimm_rm2_4gbit_afislot
               for (k = 0; k < MEM_NUMBER_OF_DIMMS; k = k + 1)
               begin : gen_lrdimm_rm2_4gbit_afislot_dimmslot
                  //  AFI_MUX: CS[2:0]  <=> AFI_CTLR: {A[16],CS[1:0]}
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)  ] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)  ];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)+1] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)+1];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*3)+2] = afi_ctlr_addr[(j*17) + 16];
               end
               
               assign afi_addr[(j*16)+15:(j*16)] = afi_ctlr_addr[(j*17)+15:(j*17)];
            end

         end
         else if (AFI_CTLR_ADDR_WIDTH == (AFI_CTLR_RATE_RATIO * 18))
         begin : gen_lrdimm_rm4_16gbit
            //  A[17:16] get remapped to CS[3:2].
            for (j = 0; j < AFI_CTLR_RATE_RATIO; j = j + 1)
            begin : gen_lrdimm_rm4_16gbit_afislot
               for (k = 0; k < MEM_NUMBER_OF_DIMMS; k = k + 1)
               begin : gen_lrdimm_rm4_16gbit_afislot_dimmslot
                  //  AFI_MUX: CS[3:0]  <=> AFI_CTLR: {A[17:16],CS[1:0]}
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*4)  ] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)  ];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*4)+1] = afi_ctlr_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*2)+1];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*4)+2] = afi_ctlr_addr[(j*18) + 16];
                  assign afi_cs_n[(((j*MEM_NUMBER_OF_DIMMS)+k)*4)+3] = afi_ctlr_addr[(j*18) + 17];

               end
               assign afi_addr[(j*16)+15:(j*16)] = afi_ctlr_addr[(j*18)+15:(j*18)];
            end
         end
      end
   end
endgenerate
endmodule

