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



/* Classes and mailboxes */

 // Declare some objects from our defined classes :
c_av_st_video_control     #(`BITS_PER_SYMBOL, `CHANNELS_PER_PIXEL) video_control_pkt1,  video_control_pkt2;
c_av_st_video_control     #(`BITS_PER_SYMBOL, `CHANNELS_PER_PIXEL) video_control_dut, video_control_golden;
c_av_st_video_data        #(`BITS_PER_SYMBOL, `CHANNELS_PER_PIXEL) video_data_dut, video_data_scoreboard ;
c_av_st_video_data        #(`BITS_PER_SYMBOL, `CHANNELS_PER_PIXEL) dut_video_pkt, scoreboard_video_pkt  ;
c_av_st_video_data        video_data_real_pkt1,  video_data_real_pkt2 ;
c_av_st_video_item        dut_pkt  ;
c_av_st_video_item        scoreboard_pkt  ;

mailbox #(c_av_st_video_item) m_tmp;
mailbox #(c_av_st_video_item) m_video_items_for_scoreboard[1];

int input_frame_count = 0;

initial
begin

    // Construct the 0th element of the video items mailbox array
    m_video_items_for_scoreboard[0] = new(0);

    // Construct the temporary mailbox, used for pushing video items
    // back into the scoreboard mailbox
    m_tmp = new(0);
end


`include "tasks.sv"

/* Main test loop */

initial
begin : main_test_loop

    int ctrl_width       = 10;
    int ctrl_height      = 10;
    int ctrl_interlacing = 0;
    int quantization;
    int add_to_scoreboard;
    int i;
    int j;


    int required_input_packets = `MAX_COMPLIANCE_TEST_PKTS ;

    #0                                // Delta-cycle delay to ensure the BFM drivers were constructed in bfm_drivers.sv
    fork                              // .start() calls to the VIP BFM drivers are blocking. Fork the calls.
        st_source_bfm_0.start();
        st_sink_bfm_0.start(av_st_clk);
    join_none;

    wait (av_st_reset_n == 1'b1)
    repeat (4) @ (posedge (av_st_clk));
    $display("\n%t TEST START : Constrained random Avalon-ST compliance with %0d packets.", $time, `MAX_COMPLIANCE_TEST_PKTS);

    if (`ENABLE_DUPLICATE_CONTROL_PKTS == 1)
        $display("%t  TEST TYPE : `ENABLE_DUPLICATE_CONTROL_PKTS ENABLED.",$time);
    else
        $display("%t  TEST TYPE : `ENABLE_DUPLICATE_CONTROL_PKTS DISABLED - THIS DEFINE MUST BE SET in tb_test.sv FOR CONFORMANCE TEST PASS.",$time);

    st_sink_bfm_0.set_readiness_probability(`SINK_READINESS);
    st_sink_bfm_0.set_long_delay_probability(0.0);
    st_source_bfm_0.set_readiness_probability(`SOURCE_READINESS);  
    st_source_bfm_0.set_long_delay_probability(0.0);

    $display("%t  TEST INFO : `PIXELS_IN_PARALLEL     = %0d",$time,`PIXELS_IN_PARALLEL);
    $display("%t  TEST INFO : `NUMBER_OF_COLOR_PLANES = %0d",$time,`CHANNELS_PER_PIXEL);
    $display("%t  TEST INFO : `MAX_WIDTH = %0d",$time,`MAX_WIDTH);
    $display("%t  TEST INFO : `MAX_HEIGHT = %0d",$time,`MAX_HEIGHT);

    // Reduce 'quantization' to produce video packets of lengths which will require use of the empty bits :
    quantization = `PIXELS_IN_PARALLEL;

    video_control_golden = new();
    video_control_golden.set_width(`MIXER_BACKGROUND_WIDTH_SW);
    video_control_golden.set_height(`MIXER_BACKGROUND_HEIGHT_SW);
    video_control_golden.set_interlacing(4'b0000); // NB. Progressive

    fork

        // Keep the input mailbox busy :
        // allowed to generate past fixed number to ensure last frame generated is valid, to make end of test easier to detect.
        while (input_frame_count < required_input_packets)
        begin : packet_generator

            add_to_scoreboard = `COPY_TO_SCOREBOARD;
        
            if (`ENABLE_DUPLICATE_CONTROL_PKTS == 1) begin
                produce_control_pkt(`DONT_COPY_TO_SCOREBOARD,`MAX_WIDTH,`MAX_HEIGHT,quantization,ctrl_width, ctrl_height, ctrl_interlacing);
            end                

            // Always produce one control packet for 1st video packet.  
            // Don't add this to the scoreboard if we are going to send a 'drop' packet after the video :
            produce_control_pkt(add_to_scoreboard,`MAX_WIDTH,`MAX_HEIGHT,quantization,ctrl_width,ctrl_height,ctrl_interlacing);

            // Don't add video packet to scoreboard if a drop packet will be IMMEDIATELY following it
            if (`COLOR_PLANES_ARE_IN_PARALLEL == 1)
                produce_video_pkt((ctrl_width), ctrl_height, add_to_scoreboard);
            else
                produce_video_pkt((ctrl_width*`CHANNELS_PER_PIXEL), ctrl_height, add_to_scoreboard);        

            input_frame_count++;

            // This delay allows the sim to catch up, so that the number of user packets in the DUT is more meaningful and
            // we get a better test out of better stimulus :
            repeat (1000) @ (posedge (av_st_clk));

            if (input_frame_count >= `MAX_COMPLIANCE_TEST_PKTS)
                 $display("\n%t   STIM TST : Constrained random Avalon-ST compliance stimulus generated %0d traceable packets OK.\n",$time,input_frame_count);

        end //while test not done
    join

end



int timeout;
int frames_left;
int matching_frame = 0;
int frames_to_check;
int expecting_dut_control_packet = 1;

longint last_pkt_time;

initial
begin : packet_checker

    frames_left = 0;
    timeout = 0;
    last_pkt_time = $time;

    op_pkts_seen = 0;  

    expecting_dut_control_packet = 1;

    repeat (1000) @ (posedge (av_st_clk));

    //Wait for 1st packet to arrive in scoreboard :
    while (m_video_items_for_scoreboard[0].num() == 0)
    begin : wait_for_first_packets
        @(posedge(av_st_clk));
    end

    //We now have a packet in the scoreboard - so we can enter the main test loop
    while ((op_pkts_seen <= (input_frame_count*2)) && !timeout)
    begin : main_checker_loop  // NB x2 for control packets

        @(posedge(av_st_clk));

        if (m_video_items_for_sink_bfm[0][0].try_get(dut_pkt) == 1)
        begin : packet_found

            op_pkts_seen++;

            timeout = 0;
            last_pkt_time = $time;

            // DUT has output a Video packet
            if (dut_pkt.get_packet_type() != control_packet)
            begin : possible_video_packet_found

                if (dut_pkt.get_packet_type() == video_packet)
                begin : video_packet_found

                    dut_video_pkt = c_av_st_video_data'(dut_pkt); //'

                    // First output packets should be colour bars :
                    if ((op_pkts_seen <= `MIXER_NUM_TPG_OUTPUT_FRAMES*2) && !expecting_dut_control_packet)
                    begin : absorb_colour_bars
                        $display("%t   DUT DOUT : PASS - DUT output an assumed mixer background pattern video packet %0d(VIDEO length == %0d).",$time,op_pkts_seen,dut_video_pkt.get_length());                
                    end 

                    else
                    begin : mixed_packets

                        // Sledgehammer approach for example test - search all input frames for the one currently output :
                        matching_frame = 0;
                        frames_to_check = m_video_items_for_scoreboard[0].num();
                        while (frames_to_check>0 && !matching_frame) begin
                            frames_to_check--;
                            m_video_items_for_scoreboard[0].get(scoreboard_pkt);
                            if (scoreboard_pkt.get_packet_type() == video_packet) begin
                                scoreboard_video_pkt = c_av_st_video_data'(scoreboard_pkt); //'
                                if (dut_video_pkt.silent_compare(scoreboard_video_pkt) == 1)
                                    matching_frame = 1;

                                m_tmp.put(scoreboard_pkt);
                            end
                        end

                        // Put all previously popped video packets back on the scoreboard mailbox, ready for next time round :
                        $display("%t   DUT DOUT : Servicing scoreboards.",$time);
                        while (m_tmp.num()>0)
                        begin
                            m_tmp.get(scoreboard_pkt);
                            m_video_items_for_scoreboard[0].put(scoreboard_pkt);
                        end
                        $display("%t   DUT DOUT : Servicing complete.",$time);

                        if (expecting_dut_control_packet)
                        begin  
                            $display("%t   DUT DOUT :  FAIL. DUT output a video packet but control packet was expected.",$time);
                        end 

                        else if (matching_frame)
                        begin  
                            $display("%t   DUT DOUT : PASS - DUT correctly output a matching video packet %0d (VIDEO length == %0d).",$time,op_pkts_seen,dut_video_pkt.get_length());
                        end 

                        else
                        begin
                            $display("%t   DUT DOUT :  FAIL. DUT output a video packet with incorrect data.",$time);
                            error_severity.push_front(3);
                            error_time.push_front($time);
                            error_queue.push_front("DUT DOUT :  FAIL. DUT output a video packet with incorrect data. ");
                            pass = 0;
                        end

                    end

                    expecting_dut_control_packet = 1;

                end

                else
                begin
                    // If not control or video, must be a USER packet
                    error_queue.push_front("DUT DOUT :  FAIL. DUT erroneously output a user packet.");                
                end        

            end

            else
            begin

                // DUT has output a Control packet
                // Cast DUT packet into a control packet object :
                video_control_dut = c_av_st_video_control'(dut_pkt); //'
  
                if (!expecting_dut_control_packet)
                begin
                    $error("%t   DUT DOUT :  FAIL. DUT output a control packet, but was expecting a video packet.",$time);
                    error_severity.push_front(3);
                    error_time.push_front($time);
                    error_queue.push_front("DUT DOUT :  FAIL. DUT erroneously output a control packet.");
                    pass = 0;
                end

                else
                begin
                    if (video_control_dut.compare(video_control_golden))
                    begin
                        $display("%t   DUT DOUT : PASS - mailbox received correct packet %0d (CONTROL packet specifying %0d x %0d (%4b)).",$time,op_pkts_seen,video_control_golden.get_width(),video_control_golden.get_height(),video_control_golden.get_interlacing());
                    end

                    else
                    begin
                        $display("%t   DUT DOUT :  FAIL. DUT output a control packet with incorrect fields. Expecting %0d x %0d (%4b) but saw %0d x %0d (%4b)",$time,video_control_golden.get_width(),video_control_golden.get_height(),video_control_golden.get_interlacing(),video_control_dut.get_width(),video_control_dut.get_height(),video_control_dut.get_interlacing());
                        error_severity.push_front(3);
                        error_time.push_front($time);
                        error_queue.push_front("DUT DOUT :  FAIL. DUT output a control packet with incorrect fields. ");
                        pass = 0;
                    end

                end

                expecting_dut_control_packet = 0;
                
            end
        end

        else if ($time - last_pkt_time > `TIMEOUT_LENGTH )
        begin
            // no output for an extended period or uncontrolled repeat at end, so bail out to avoid
            // running forever.  This isn't necessarily an error, as this can occur if a non-locked-rate
            // drop occurs at the end of the input data - a frame will remain on the scoreboard, but it
            // will never be output, so stop to evaluate the situation.

            timeout = 1;
            $display("%t       INFO : Timeout occurred waiting for output, aborting simulation.",$time);
            $display("%t       INFO :   Scoreboard Mailbox entries remaining = %0d",$time,m_video_items_for_scoreboard[0].num());

            // count whole frames remaining in scoreboard
            while (m_video_items_for_scoreboard[0].num())
            begin
                m_video_items_for_scoreboard[0].get(scoreboard_pkt);
                if (scoreboard_pkt.get_packet_type() == video_packet)
                begin
                    video_data_scoreboard = c_av_st_video_data'(scoreboard_pkt); //'
                    if (video_data_scoreboard.get_length()) begin //'
                        frames_left++;
                    end
                end
            end

            if (frames_left <= 2)
            begin
                $display("%t       INFO :   Frames left in scoreboard = %0d, likely to have been correctly dropped at the end.",$time,frames_left);
            end

            else
            begin
                $display("%t       INFO :  FAIL. DUT did not output %0d frames.",$time,frames_left);
                error_severity.push_front(3);
                error_time.push_front($time);
                error_queue.push_front("INFO :  FAIL. DUT did not output all frames");
                pass = 0;
            end

        end

    end // while test not done

    all_tests_complete = 1;

end


initial
begin : test_completion

    wait (all_tests_complete);
    repeat (4) @ (posedge (av_st_clk)); // Flush any output

    if (error_queue.size() == 0)
    begin : test_pass
        $display("\nTest run complete - TEST_PASS.\n");
    end

    else
    begin : test_fail

        $display("\nTest run complete - TEST_FAIL.  Errors reported below :\n");

        while (error_queue.size() != 0)
        begin

            severity = error_severity.pop_back();
            case (severity)

            0       :  $display("FATAL Error at %t ps - %s",error_time.pop_back(), error_queue.pop_back());
            1       :  $display("Error at %t ps - %s",error_time.pop_back(), error_queue.pop_back());
            2       :  $display("VIP Core compliance error (major) at %t ps - %s",error_time.pop_back(), error_queue.pop_back());
            3       :  $display("VIP Core compliance error (moderate) at %t ps - %s",error_time.pop_back(), error_queue.pop_back());
            default :  $display("VIP Core compliance error (minor) at %t ps - %s",error_time.pop_back(), error_queue.pop_back());

            endcase

        end

    end

    $finish;

end
