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


// (C) 2001-2012 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//  The following must be defined before including this class :
// `SINK
// `SINK_HIERARCHY_NAME
// `PIXEL_DATA_WIDTH
// `BITS_PER_CHANNEL
// `CHANNELS_PER_PIXEL
// `PIXELS_IN_PARALLEL



`define CLASSNAME c_av_st_video_sink_bfm_`SINK

class `CLASSNAME #(int unsigned no_of_streams = 1) extends c_av_st_video_source_sink_base #(no_of_streams);

t_packet_types current_video_item_type =   undefined;


// The constructor 'connects' the output mailbox to the object's mailbox :
function new(mailbox #(c_av_st_video_item) m_vid[no_of_streams]);
    super.new(m_vid);
endfunction

task start(ref bit clk);

    wait (`SINK_HIERARCHY_NAME.reset == 0)
    receive_video(clk);

endtask

task receive_video(ref bit clk);

    // Local objects :
    c_av_st_video_item                                                       item_data;
    c_av_st_video_data        #(`BITS_PER_CHANNEL,  `CHANNELS_PER_PIXEL)    video_data[no_of_streams];
    c_av_st_video_control     #(`BITS_PER_CHANNEL,  `CHANNELS_PER_PIXEL) video_control;
    c_av_st_video_user_packet #(`PIXEL_DATA_WIDTH)     user_data;
    c_pixel                   #(`BITS_PER_CHANNEL,  `CHANNELS_PER_PIXEL)    pixel_data[no_of_streams];
    
    bit                    [`BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL * `PIXELS_IN_PARALLEL - 1:0] bus_data;
    bit                    [`BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL-1:0]          data;
    bit                    [`BITS_PER_CHANNEL -1:                     0]  channel_data;
    
    int unsigned stream;
    
    bit    [3 :0]    nibble_stack[$];
    bit    [3:0]        nibble = 'h0;
    bit    [15:0]       height = 'h0;
    bit    [15:0]        width = 'h0;
    bit    [3 :0]  interlacing = 'h0;    
    int        control_data_id =   0;
    int control_packet_garbage =   0;
    bit               eop_seen =   0;
    int                channel[no_of_streams];
    int                     nw =   0; // Warning prevention
    int           control_length = 0;
    int                sop_empty = 0;
    int                eop_empty = 0;
    int      number_valid_pixels = 0;
    
    fork
    
    forever
    begin
  	@(posedge clk);
        if ($urandom_range(99999, 0) < (long_delay_probability*1000))
        begin
             nw = randomize(long_delay_duration);
            `SINK_HIERARCHY_NAME.set_ready(1'b0);      
            repeat(long_delay_duration) @(posedge clk);                
            `SINK_HIERARCHY_NAME.set_ready(1'b1); 
        end
        else if ($urandom_range(99, 0) > readiness_probability) 
            `SINK_HIERARCHY_NAME.set_ready(1'b0);
        else
            `SINK_HIERARCHY_NAME.set_ready(1'b1); 
    end
   
    forever
    begin

        // Constructors :
        user_data              = new(`PIXELS_IN_PARALLEL);
        video_control          = new(); 
        for(int stream_no = 0; stream_no < no_of_streams; stream_no++) begin
            // Lines should be appended to the current frame
            if(current_video_item_type != line_packet) 
                video_data[stream_no] = new(`PIXELS_IN_PARALLEL);
            pixel_data[stream_no] = new();
            channel[stream_no] =     0;
        end
        control_data_id        =     0;
        control_packet_garbage =     0;
        eop_seen               =  1'b1;
        
        
        do
        begin
            // Wait until we get a transaction
            @(`SINK_HIERARCHY_NAME.signal_transaction_received);

            // get the new transaction from the model
            `SINK_HIERARCHY_NAME.pop_transaction();

            // Pop the raw data from the Av-ST bus :
            bus_data = `SINK_HIERARCHY_NAME.get_transaction_data();

            // Get the stream number
            stream = `SINK_HIERARCHY_NAME.get_transaction_channel();
            
            eop_empty = `SINK_HIERARCHY_NAME.get_transaction_empty();

            
            StreamNumberIsValid: assert(stream < no_of_streams) else $fatal(1,"Stream number is out of range"); 
            
            // The first beat of data is just used to identify the packet type :
            if (`SINK_HIERARCHY_NAME.get_transaction_sop() == 1'b1)
            begin            
                 
                if (!eop_seen)
                    $display("%t   DUT2MBOX : WARNING - missing an EOP from the previous packet",$time);
                   // $fatal(1, "TEST FAILED : %s missing an EOP from the previous packet.\n",$time,name);                      
                    
                casez (bus_data[3:0])
                    4'd0    : current_video_item_type = video_packet;
                    4'd15   : current_video_item_type = control_packet; 
                  //jmh  4'd12   : current_video_item_type = line_packet;
                  //jmh this is now  drop/repeat  4'd11   : current_video_item_type = end_of_frame_packet;
                    default : current_video_item_type = user_packet;
                endcase
                
                if (current_video_item_type == user_packet)
                    user_data.set_identifier(bus_data[3:0]);
                    
                nibble_stack = {}; // Empty the nibble stack    

                for(int stream_no = 0; stream_no < no_of_streams; stream_no++) begin
                  channel[stream_no] =     0;
                  if((current_video_item_type == video_packet || current_video_item_type == line_packet) &&
                     `PIXELS_IN_PARALLEL > 1)
                      sop_empty = bus_data[`BITS_PER_CHANNEL +: 4];
                      video_data[stream_no].set_sop_empty(sop_empty);
                end
               
                eop_seen = 1'b0;   
                control_length         =     0;
                    
            end
                        
            // Subsequent beats are decoded according to type :
            else begin
                eop_assert: assert((`SINK_HIERARCHY_NAME.get_transaction_eop() == 1'b0) || ((eop_empty % `CHANNELS_PER_PIXEL) == 0)) 
                else $fatal(1, "Error in eop transaction or eop_empty");

                number_valid_pixels = (pixel_transport == serial) ? 1 : `PIXELS_IN_PARALLEL - ((`SINK_HIERARCHY_NAME.get_transaction_eop() == 1'b1) ? eop_empty/`CHANNELS_PER_PIXEL : 0);
                for(int pixel = 0; pixel < number_valid_pixels ; pixel++) begin
                    int base = `BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL * pixel;
                    // verilog 2001 -> [base + : length]
                    if(pixel_transport == parallel)
                        data = bus_data[base +:`BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL];
                    else
                        data[`BITS_PER_CHANNEL - 1:0] = bus_data[`BITS_PER_CHANNEL - 1:0];
                        
                    if (current_video_item_type == video_packet || current_video_item_type == line_packet)
                    begin
                                
                        // Pack it into a pixel object :
                        if (pixel_transport == parallel)
                        begin
                            for (channel[0]=0; channel[0]<`CHANNELS_PER_PIXEL; pixel_data[stream].set_data(channel[0]++, channel_data) )        
                                for (int pixel_bit=0; pixel_bit<`BITS_PER_CHANNEL; pixel_bit++)
                                    channel_data[pixel_bit] = data[channel[0]*`BITS_PER_CHANNEL+pixel_bit];
                        end
                        else
                        begin
                            pixel_data[stream].set_data(channel[stream], data[`BITS_PER_CHANNEL - 1:0]);
                        end
                             
                        // If we have enough data, push the pixel into the video packet
                        if (pixel_transport == parallel || channel[stream] == (`CHANNELS_PER_PIXEL - 1))
                        begin
                            if(sop_empty == 0)
                                video_data[stream].push_pixel(pixel_data[stream]);
                            else
                                sop_empty--;
                            //$display("%s Sink BFM assembling packet %0d of length %0d %0d", name, channel[stream], video_data[stream].get_length(), pixel_transport == parallel);
                            channel[stream] = 0;
                            pixel_data[stream] = new();
                        end
                        else
                        begin
                            channel[stream] = channel[stream] + 'h1;               
                        end
                        
                        //$display("%t Sink pushed video pixel ch2=%h ch1=%h ch0=%h, length now %d",$time, pixel_data.get_data(2),pixel_data.get_data(1),pixel_data.get_data(0),video_data.get_length());
                        
                    end else if (current_video_item_type == user_packet)
                    begin
                        user_data.push_data(data);
                        
                    end else if (current_video_item_type == control_packet)
                    begin
                        control_length++;
                        
                        // Non-garbage beat:                           
                        if (control_data_id < 3)
                        begin
                        
                            for (channel[0]=0; channel[0] < ((pixel_transport == serial) ? 1 : `CHANNELS_PER_PIXEL); channel[0]++ )        
                            begin
                    
                                //$display("Sink - control packet data received of %h for channel %h pixel %d",data,channel,pixel);
                    
                                // Construct a nibble from the bus data :
                                for (int nibble_bit=0; nibble_bit<4; nibble_bit++)
                                    nibble[nibble_bit] = data[ (channel[0]*`BITS_PER_CHANNEL) + nibble_bit];
                    
                                // Push the nibble onto nibble_stack :
                                nibble_stack.push_front(nibble);
                                //$display("Sink - pushed first nibble of %h",nibble);
                    
                                // When 3 nibbles have been accumulated, interpret as height, width etc...
                                case (control_data_id)
                    
                                0 :
                                begin
                                    if (nibble_stack.size() == 4)
                                    begin
                                        for (int i=3; i>=0; i--)
                                            width = width | (nibble_stack.pop_back() << (i*4));
                                        control_data_id++;
                                        //$display("Sink - width = %h", width);
                                    end
                                end
                    
                                1 :
                                begin
                                    if (nibble_stack.size() == 4)
                                    begin
                                        for (int i=3; i>=0; i--)
                                            height = height | (nibble_stack.pop_back() << (i*4));
                                         control_data_id++;
                                        //$display("Sink - height = %h", height);
                                    end
                                end
                    
                    
                                2 :
                                begin
                                    if (nibble_stack.size() == 1)
                                    begin
                                        interlacing = nibble_stack.pop_back();
                                        //$display("Sink - interlacing = %h", interlacing);
                                        control_data_id++;
                                    end
                                end
                    
                                endcase 
                    
                            end //for  
                        
                        end
                        
                        // Garbage beat :
                        else
                        begin
                            //$display("Sink - control_packet_garbage = %0d",control_packet_garbage);
                            control_packet_garbage = control_packet_garbage + 1;
                        end
                        
                        //$display("Nibble stack has %d elements left", nibble_stack.size());
                        
                    end 
                end // for
            end //else
            
        end //do
        while (!`SINK_HIERARCHY_NAME.get_transaction_eop()); 
 
        eop_seen = 1'b1;
        
        if (current_video_item_type == video_packet || current_video_item_type == end_of_frame_packet)
        begin
            for(int stream_no = 0; stream_no < no_of_streams; stream_no++) begin
              m_video_items[stream_no].put(video_data[stream_no]);
              `ifdef ENABLE_DUT2MBOX_MSGS 
                 $display("%t   DUT2MBOX : Sink object %s sent a video packet #%0d of length %0d to the mailbox, stream %0d",$time, name, ++video_packets_sent, video_data[stream_no].get_length(), stream_no);
              `endif
            end
        end
            
        else if (current_video_item_type == user_packet)
        begin
            m_video_items[0].put(user_data);
            `ifdef ENABLE_DUT2MBOX_MSGS 
                $display("%t   DUT2MBOX : Sink object %s sent a user packet #%0d of length %0d to the mailbox, stream 0",$time, name, ++user_packets_sent, user_data.get_length());
            `endif
        end
        
        else if (current_video_item_type == control_packet)
        begin

            video_control.set_width(width);
            video_control.set_height(height);
            video_control.set_interlacing(interlacing);              
            m_video_items[0].put(video_control);
            
            //Reset these for next control packet :
            height = 'h0;
            width = 'h0;
            interlacing = 'h0; 
            `ifdef ENABLE_DUT2MBOX_MSGS 
            if (control_packet_garbage == 0)
                $display("%t   DUT2MBOX : Sink object %s sent a control packet #%0d (%s) to the mailbox, stream 0",$time, name, ++control_packets_sent, video_control.info());
            else
                $display("%t   DUT2MBOX : Sink object %s sent a control packet #%0d (%s with %0d garbage beats removed) to the mailbox, stream 0",$time, name,++control_packets_sent, video_control.info(), control_packet_garbage);
            `endif
               
         end
            
    end
    
    join

endtask

endclass

`undef CLASSNAME
`undef SINK
`undef SINK_HIERARCHY_NAME
