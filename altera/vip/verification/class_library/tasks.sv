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



/* Tasks */

task produce_control_pkt;
    input bit copy_to_scoreboard ;
    input int maximum_width;
    input int maximum_height;
    input int quantization;
    output int  ctrl_width;
    output int  ctrl_height;
    output int  ctrl_interlacing;

    video_control_pkt1 = new();

    do
    begin
        if ((video_control_pkt1.randomize() with { interlace == 4'h0; width >`MIXER_BACKGROUND_WIDTH_SW-1;  width <=`MIXER_BACKGROUND_WIDTH_SW; height > `MIXER_BACKGROUND_HEIGHT_SW-1; height <= `MIXER_BACKGROUND_HEIGHT_SW; }) != 1)
        begin
           $error ("Randomisation failure when generating input control packet");
        end       

        // Extract height and width information :
        ctrl_height = video_control_pkt1.get_height();
        ctrl_width  = video_control_pkt1.get_width();
        ctrl_interlacing  = video_control_pkt1.get_interlacing();

        break;
    end while (1);

    $display("%t   STIM TST : Constrained random sending            (CONTROL, width = %0d, height = %0d, interlacing = 0x%0h) to mailbox (%0dx%0d = %0d)- %0d items now pending",$time,
        ctrl_width,ctrl_height,ctrl_interlacing,ctrl_width,ctrl_height,ctrl_width*ctrl_height,m_video_items_for_src_bfm[0][0].num());
    m_video_items_for_src_bfm[0][0].put(video_control_pkt1);

    // Copy and send to scoreboard :
    if (copy_to_scoreboard)
    begin
        video_control_pkt2 = new();
        video_control_pkt2.copy(video_control_pkt1);
        m_video_items_for_scoreboard[0].put(video_control_pkt2);
        `ifdef ENABLE_SCOREBOARD_MSGS
            $display("%t   STIM TST : Constrained random dupe to scoreboard (CONTROL, width = %0d, height = %0d, interlacing = 0x%0h) - %0d items now pending",$time,ctrl_width,ctrl_height,video_control_pkt1.get_interlacing(),m_video_items_for_scoreboard[0].num());
        `endif
    end

endtask



task produce_video_pkt;

    input int w ;
    input int h ;
    input bit copy_to_scoreboard ;

    video_data_real_pkt1    = new();
    video_data_real_pkt1.set_max_length(`MAX_WIDTH*`MAX_HEIGHT);
    video_data_real_pkt1.set_height(h);
    video_data_real_pkt1.set_width(w);
    if (video_data_real_pkt1.randomize() != 1) begin $error ("Randomisation failure for input video data"); end
    $display("%t   STIM TST : Constrained random sending            (VIDEO length %0d x %0d == %0d pixels) to mailbox (%0d items now pending)",$time,  video_data_real_pkt1.get_height(), video_data_real_pkt1.get_width(), video_data_real_pkt1.get_length(),m_video_items_for_src_bfm[0][0].num());

    // Send it to the source BFM :
    m_video_items_for_src_bfm[0][0].put(video_data_real_pkt1);

    // Copy and send to scoreboard :
    if (copy_to_scoreboard)
    begin
        video_data_real_pkt2 = new();
        video_data_real_pkt2.copy(video_data_real_pkt1);
        m_video_items_for_scoreboard[0].put(video_data_real_pkt2);
        `ifdef ENABLE_SCOREBOARD_MSGS
            $display("%t   STIM TST : Constrained random dupe to scoreboard (VIDEO of length %0d x %0d == %0d pixels) - %0d items now pending",$time,video_data_real_pkt1.get_height(), video_data_real_pkt1.get_width(), video_data_real_pkt1.get_length(),m_video_items_for_scoreboard[0].num());
        `endif
    end

endtask


