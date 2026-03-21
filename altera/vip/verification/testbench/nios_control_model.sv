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



task send_write_to_mixer(int unsigned address, int unsigned data);
    automatic c_av_mm_control_register register_update = new(1);
    register_update.use_event = 0;
    register_update.write = 1;
    register_update.address = address;
    register_update.value = data;
    m_register_items_for_mixer_control_bfm.put(register_update);
endtask

task send_read_to_mixer(int unsigned address);
    automatic c_av_mm_control_register register_update = new(1);
    register_update.use_event = 0;
    register_update.write = 0;
    register_update.address = address;
    m_register_items_for_mixer_control_bfm.put(register_update);
endtask

task verified_mixer_write(int unsigned address, int unsigned data);
    c_av_mm_control_register status;

    send_write_to_mixer(address,data); // Bottom Offset / height
    $display("%t    CONTROL : Writing %0d to mixer address %0d.",$time,data,address);

    // Try read-back :
    repeat (100) @ (posedge (av_st_clk));
    send_read_to_mixer(address);
    m_readdata_from_mixer_control_bfm.get(status);
    if (status.value != data)
        $fatal (1,"%t   DUT DOUT : DUT mixer register read back failed.",$time);
    else
        $display("%t    CONTROL : Written and read-back %0d at mixer address %0d successfully.",$time,data,address);
endtask



task send_write_to_vfb(int unsigned address, int unsigned data);
    automatic c_av_mm_control_register register_update = new(1);
    register_update.use_event = 0;
    register_update.write = 1;
    register_update.address = address;
    register_update.value = data;
    m_register_items_for_vfb_control_bfm.put(register_update);
endtask

task send_read_to_vfb(int unsigned address);
    automatic c_av_mm_control_register register_update = new(1);
    register_update.use_event = 0;
    register_update.write = 0;
    register_update.address = address;
    m_register_items_for_vfb_control_bfm.put(register_update);
endtask

task verified_vfb_write(int unsigned address, int unsigned data);
    c_av_mm_control_register status;

    send_write_to_vfb(address,data); // Bottom Offset / height
    $display("%t    CONTROL : Writing %0d to vfb address %0d.",$time,data,address);

    // Try read-back :
    repeat (100) @ (posedge (av_st_clk));
    send_read_to_vfb(address);
    m_readdata_from_vfb_control_bfm.get(status);
    if (status.value != data)
        $fatal (1,"%t   DUT DOUT : DUT vfb register read back failed.",$time);
    else
        $display("%t    CONTROL : Written and read-back %0d at vfb address %0d successfully.",$time,data,address);
endtask



int clocks = 1000;
bit seen_status_bit_set = 0;


int reg_status_addr = 1;

int reg_control = 8;
int reg_locked_en_addr = 9;
int reg_locked_inrate_addr = 10;
int reg_locked_outrate_addr = 11;


int go_val;
int control_val;


/*
`ifdef QUESTA

    `ifdef CONSTRAINED_RANDOM_TEST
        `define OP_PKTS_SEEN op_pkts_seen
    `else
        `define OP_PKTS_SEEN video_file_writer.get_video_packets_handled()>0
    `endif

`else
    `define OP_PKTS_SEEN op_pkts_seen
`endif
*/

`define OP_PKTS_SEEN op_pkts_seen


initial
begin : initial_construct

    c_av_mm_control_register status;
    c_av_mm_control_register frame_count;
    c_av_mm_control_register drop_count;

    #0                                // Delta-cycle delay to ensure the BFM drivers were constructed in bfm_drivers.sv
    fork                              // .start() calls to the VIP BFM drivers are blocking. Fork the calls.
        bfm_mixer_control_drv.start();
        bfm_vfb_control_drv.start();
    join_none;


    wait (av_st_reset_n == 1'b1)
    repeat (10) @ (posedge (av_st_clk));

    fork

        repeat(1)
        begin : nios_control

            go_val = 1;
            control_val = 0;

`ifdef CONSTRAINED_RANDOM_TEST
            send_write_to_mixer(8, 0); // X offset
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 0 to the X offset of the Mixer",$time);

            send_write_to_mixer(9, 0); // Y offset
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 0 to the Y offset of the Mixer",$time);

            send_write_to_mixer(3, `MIXER_BACKGROUND_WIDTH_SW); 
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing a background layer of width %0d to the Mixer",$time,`MIXER_BACKGROUND_WIDTH_SW);

            send_write_to_mixer(4, `MIXER_BACKGROUND_HEIGHT_SW); 
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing a background layer of height %0d to the Mixer",$time,`MIXER_BACKGROUND_HEIGHT_SW);

`else
            send_write_to_mixer(8, 20); // X offset
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 20 to the X offset of the Mixer",$time);

            send_write_to_mixer(9, 20); // Y offset
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 20 to the Y offset of the Mixer",$time);
`endif

            send_write_to_mixer(10, 1); // enable input 0
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 1 to address 10 of Mixer to enable input layer 1",$time);

            send_write_to_vfb(0, 1);
            repeat (10) @ (posedge (av_st_clk));
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 1 to GO bit of VFB",$time);

            send_write_to_mixer(0, 1);            
            repeat (10) @ (posedge (av_st_clk));  
            $display("%t NIOS CONTROL EMULATOR : Test harness writing 1 to GO bit of Mixer",$time);
    
            // Check status bit of mixer:
            while (seen_status_bit_set == 0) begin 

                repeat (clocks) @ (posedge (av_st_clk));

                if (`OP_PKTS_SEEN ) begin
                    send_read_to_mixer(reg_status_addr);
                    m_readdata_from_mixer_control_bfm.get(status);
                    if (status.value & 1) begin
                         seen_status_bit_set = 1;
                         $display("%t NIOS CONTROL EMULATOR :  Test harness read 1 from mixer status register",$time);
                    end else begin
                         $error("%t NIOS CONTROL EMULATOR :  mixer status register check did not return '1' after GO bit was set.\n",$time);
                         error_severity.push_front(2);
                         error_time.push_front($time);
                         error_queue.push_front("NIOS CONTROL EMULATOR :  mixer status register check did not return 1 after Go bit was set.");
                         clocks = clocks*10;
                         pass = 0;
                    end
                end
            end

        end
    join
end

