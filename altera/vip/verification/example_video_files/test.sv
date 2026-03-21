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




initial
begin
    
    wait (av_st_reset_n == 1'b1)
    repeat (4) @ (posedge (av_st_clk));

    
    // Avaon-ST video packets should be sent with pixels in parallel :
    `SOURCE.set_pixel_transport(parallel);
      `SINK.set_pixel_transport(parallel);
    
    `SOURCE.set_name(`SOURCE_STR);
      `SINK.set_name(  `SINK_STR);
    
    `SOURCE.set_readiness_probability(90);
      `SINK.set_readiness_probability(90); 
      
    `SOURCE.set_long_delay_probability(0.01);
      `SINK.set_long_delay_probability(0.01);       
    
    fork    
    
        `SOURCE.start();
        `SINK.start(av_st_clk);

        begin

            // File reader :

            // Associate the source BFM's video in mailbox with the video file reader object via the file reader's constructor :
            video_file_reader = new(m_video_items_for_src_bfm[0][0]);   
            
            // Arguments are : (File name, read/write)
            video_file_reader.open_file("jimP_rgb32.raw", read);  
            
            // Get the video details from the input file, as we shall re-use these
            // when generating the output file :
            video_format = video_file_reader.get_video_data_type();  
            height       = video_file_reader.get_image_height();  
            width        = video_file_reader.get_image_width();  
                             
            video_file_reader.set_send_control_packets(random);            
            video_file_reader.set_control_packet_probability(100);                                                 
            video_file_reader.set_early_eop_probability(0);                                                 
            video_file_reader.set_late_eop_probability(0);                                                 
            
            // Read and send file :
            video_file_reader.read_file();
            video_file_reader.close_file();     

            fields_read = video_file_reader.get_video_packets_handled();

            // File writer :
            
            video_file_writer = new(m_video_items_for_sink_bfm[0][0]);   
            
            // Set the file format to be the same as for the input file :
            video_file_writer.set_video_data_type(video_format);    

            // NB. Output frame as set in the mixer is larger than the input video :   
            video_file_writer.set_image_height(`MAX_HEIGHT);
            video_file_writer.set_image_width(`MAX_WIDTH);
            
            // Open the file, reading for writing :
            video_file_writer.open_file("jimP_out_rgb32.raw", write);       

            // Now wait for and write the video output packets to the file as they arrive :
            do
            begin  
                video_file_writer.wait_for_and_write_video_packet_to_file();    
            end        
            while ( video_file_writer.get_video_packets_handled() < (fields_read -1)); // -1 allows for VFB latency
            
            video_file_writer.close_file();
            
            $display("Simulation complete. To view resultant video, now run the windows raw2avi application :\n   >raw2avi.exe %s video.avi\n\n",video_file_writer.get_filename());        

            $finish;
            
        end
        
    join   
         
end  