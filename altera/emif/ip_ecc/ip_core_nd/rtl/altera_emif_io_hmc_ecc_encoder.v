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


`timescale 1 ps / 1 ps

module altera_emif_io_hmc_ecc_encoder #
    ( parameter
        CFG_ECC_DATA_WIDTH              = 72,
        CFG_ECC_CODE_WIDTH              = 8,
        CFG_ADDR_WIDTH                  = 35,
        
        CFG_PORT_WIDTH_DRAM_DATA_WIDTH  = 7,
        CFG_PORT_WIDTH_LOCAL_DATA_WIDTH = 7,
        CFG_PORT_WIDTH_ENABLE_ECC       = 1,
        
        CFG_ADDR_ENCODE_ENABLED         = 0
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        cfg_local_data_width,
        cfg_dram_data_width,
        cfg_enable_ecc,
        
        input_data,
        input_addr,
        input_ecc_code,
        input_ecc_code_overwrite,
        output_data
    );

localparam CFG_LOCAL_DATA_WIDTH = CFG_ECC_DATA_WIDTH - CFG_ECC_CODE_WIDTH;

input                                            ctl_clk;
input                                            ctl_reset_n;

input  [CFG_PORT_WIDTH_DRAM_DATA_WIDTH  - 1 : 0] cfg_local_data_width;
input  [CFG_PORT_WIDTH_LOCAL_DATA_WIDTH - 1 : 0] cfg_dram_data_width;
input  [CFG_PORT_WIDTH_ENABLE_ECC       - 1 : 0] cfg_enable_ecc;

input  [CFG_ECC_DATA_WIDTH              - 1 : 0] input_data;
input  [CFG_ADDR_WIDTH                  - 1 : 0] input_addr;
input  [CFG_ECC_CODE_WIDTH              - 1 : 0] input_ecc_code;
input                                            input_ecc_code_overwrite;

output [CFG_ECC_DATA_WIDTH              - 1 : 0] output_data;

    reg  [CFG_ECC_DATA_WIDTH   - 1 : 0] int_encoder_input;
    
    reg  [CFG_ECC_DATA_WIDTH   - 1 : 0] output_data;
    reg  [CFG_ECC_DATA_WIDTH   - 1 : 0] int_encoder_output;
    
    wire [CFG_LOCAL_DATA_WIDTH - 1 : 0] encoder_input;
    wire [CFG_ECC_DATA_WIDTH   - 1 : 0] encoder_output;
    
    wire [CFG_ADDR_WIDTH       - 1 : 0] encoder_addr_output;
    
    genvar i;

    generate
        for (i = 0;i < CFG_ECC_DATA_WIDTH;i = i + 1)
        begin : encoder_input_per_data_width
            always @ (*)
            begin
                if (i < cfg_local_data_width)
                    int_encoder_input [i] = input_data [i];
                else
                    int_encoder_input [i] = 1'b0;
            end
        end
    endgenerate
    
    assign encoder_input = int_encoder_input [CFG_LOCAL_DATA_WIDTH - 1 : 0];
    
    generate
        for (i = 0;i < CFG_ECC_DATA_WIDTH;i = i + 1)
        begin : encoder_output_per_data_width
            always @ (*)
            begin
                if (i < cfg_local_data_width)
                begin
                    int_encoder_output [i] = encoder_output [i];
                end
                else if (i < cfg_dram_data_width)
                begin
                    if (input_ecc_code_overwrite)
                        int_encoder_output [i] = input_ecc_code [(i % 8)];
                    else
                        int_encoder_output [i] = encoder_output [(i % 8) + 64]; 
                end
                else
                begin
                    int_encoder_output [i] = 1'b0;
                end
            end
        end
    endgenerate
    
    always @ (*)
    begin
        if (cfg_enable_ecc)
        begin
            output_data = int_encoder_output;
        end
        else
        begin
            output_data = input_data;
        end
    end
    

    
    generate
        if (CFG_ECC_DATA_WIDTH > 72)
        begin
            assign encoder_output [CFG_ECC_DATA_WIDTH - 1 : 72] = {(CFG_ECC_DATA_WIDTH - 72){1'b0}};
        end
    endgenerate
    
    generate
        if (CFG_ADDR_ENCODE_ENABLED == 1)
        begin
            altera_emif_io_hmc_ecc_encoder_112 #
            (
                .DI     (64 + CFG_ADDR_WIDTH                                                                ),
                .DOUT   (72 + CFG_ADDR_WIDTH                                                                )
            )
            encoder_inst
            (
                .data   ({input_addr, encoder_input  [64 - 1 : 0]}                                          ),
                .q      ({encoder_output [72 - 1 : 64], encoder_addr_output, encoder_output [64 - 1 : 0]}   )
            );
        end
        else
        begin
            altera_emif_io_hmc_ecc_encoder_64 encoder_inst
            (
                .data   (encoder_input  [64 - 1 : 0]),
                .q      (encoder_output [72 - 1 : 0])
            );
        end
    endgenerate



endmodule
