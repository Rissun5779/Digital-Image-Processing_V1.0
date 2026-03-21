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

module reset_csr #(
    parameter PHY2MAC_RESET_EN         = 0,
    parameter MAC_RESET_DURATION       = 100

)
( 
    input               clk,                // phy mgmt_clk 
    input               reset,
    input [5:0]         pcs_mode_rc,        // speed change notification from phy
    input               rx_block_lock,  // signal indicate 10G PHY is ready
    input               led_link,       // signal indicate 1G PHY is ready
    output              reset_to_mac        // to reset MAC when PHY change speed
);

    //   
    // FSM states declaration   
    //   
    localparam INIT                = 0;
    localparam OLD_RESET_SCHEME    = 1;
    localparam RESET_MAC           = 2;
    localparam DETECT_LINK         = 3;
    localparam LINK_READY          = 4;


    // register declaration
    reg [4:0]   current_state;
    reg [4:0]   next_state;
    reg         reset_to_mac_reg;
    reg         clr_reset_mac;
    reg         set_reset_mac;
    reg         set_old_reset_scheme;
    reg         set_delay_cnt;  
    reg         dec_delay_cnt;
    reg [9:0]   delay_cnt;


    //   
    // FSM
    //     
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            current_state <= INIT;
        end else begin
            current_state <= next_state;		
        end
    end

    //
    // Next state logic
    //  	
    always @ (current_state or pcs_mode_rc or delay_cnt)
    begin
        next_state              = current_state;
        clr_reset_mac           = 1'b0;
        set_reset_mac           = 1'b0;
        set_old_reset_scheme    = 1'b0;
        set_delay_cnt           = 1'b0;  
        dec_delay_cnt           = 1'b0;  

        case (current_state)
            // Initial state upon power up
            INIT: begin
                if(PHY2MAC_RESET_EN == 1)
                begin
                    next_state = OLD_RESET_SCHEME;
                end else begin
                    if(pcs_mode_rc == 6'b000000)
                    begin
                        next_state = RESET_MAC;
                    end else begin
                        next_state = INIT;
                    end
                end
            end

            OLD_RESET_SCHEME: begin
                set_old_reset_scheme = 1'b1;
                next_state = OLD_RESET_SCHEME;
            end

            RESET_MAC: begin
                set_reset_mac = 1'b1;
                next_state = DETECT_LINK;
            end

            DETECT_LINK: begin
                set_reset_mac = 1'b1;
                dec_delay_cnt = 1'b1;

                if (delay_cnt == 0) begin
                    set_delay_cnt = 1'b1;
                    next_state = LINK_READY;
                end else begin
                    next_state = DETECT_LINK;		
                end
            end            

            LINK_READY: begin
                clr_reset_mac = 1'b1;
                next_state = INIT;
            end

        endcase
    end

    //   
    // Output register for delay counter
    //   
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin  
            delay_cnt <= MAC_RESET_DURATION;
        end else begin
            if (set_delay_cnt) begin
                delay_cnt <= MAC_RESET_DURATION;  
            end else if (dec_delay_cnt) begin
                delay_cnt <= delay_cnt - 5'd1;  
            end
        end       
    end

    //   
    // Output register for MAC reset   
    // 
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            reset_to_mac_reg <= 1'b1;
        end else begin
            if (clr_reset_mac) begin
                reset_to_mac_reg <= 1'b0;
            end else if (set_reset_mac) begin
                reset_to_mac_reg <= 1'b1;
            end		
        end	
    end

    assign reset_to_mac = (set_old_reset_scheme == 1'b0)? reset_to_mac_reg : (~rx_block_lock & ~led_link);

endmodule