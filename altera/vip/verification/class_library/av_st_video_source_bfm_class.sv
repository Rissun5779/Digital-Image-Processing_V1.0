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
// `SOURCE
// `SOURCE_HIERARCHY_NAME
// `USE_LINES
// `TDM_IS_BY_PIXEL
// `PIXEL_DATA_WIDTH
// `BITS_PER_CHANNEL
// `CHANNELS_PER_PIXEL
// `PIXELS_IN_PARALLEL

`define CLASSNAME c_av_st_video_source_bfm_`SOURCE
`define BITS_PER_PIXEL `BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL 

class `CLASSNAME #(int unsigned no_of_streams = 1) extends c_av_st_video_source_sink_base #(no_of_streams);

// shared variables that are used for packing multiple pixels onto the bus
int pixel;
bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL*`PIXELS_IN_PARALLEL-1:0] bus_data;

int idle_count;
int busy_count;
int transaction_idles;

rand bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] garbage_data; 

typedef c_av_st_video_data #(.BITS_PER_CHANNEL(`BITS_PER_CHANNEL), .CHANNELS_PER_PIXEL(`CHANNELS_PER_PIXEL)) video_t;
typedef c_pixel #(.BITS_PER_CHANNEL(`BITS_PER_CHANNEL), .CHANNELS_PER_PIXEL(`CHANNELS_PER_PIXEL)) pixel_t;

video_t video_data[no_of_streams];

// The constructor 'connects' the output mailbox to the object's mailbox :
function new(mailbox #(c_av_st_video_item) m_vid[no_of_streams]);
    super.new(m_vid);

    this.idle_count = 0;
    this.busy_count = 0;
    this.transaction_idles = 1;
endfunction

task start;

    wait (`SOURCE_HIERARCHY_NAME.reset == 0)
    `SOURCE_HIERARCHY_NAME.set_response_timeout(5000);
    forever 
        send_video;

endtask

task send_symbol(int stream_number, bit last_data, bit complete_pixel, bit [`BITS_PER_CHANNEL-1:0] channel_data, inout int channel, inout bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transaction_data, inout bit data_sent); 
        
    if (pixel_transport == parallel)
    begin
        transaction_data = transaction_data | (channel_data << `BITS_PER_CHANNEL*channel) ;
    end
    else
    begin
        transaction_data = channel_data;
    end
    
    if(pixel_transport == serial || channel == `CHANNELS_PER_PIXEL - 1 || (last_data && !complete_pixel)) begin                    
        send_data(stream_number, last_data, complete_pixel, channel, transaction_data, data_sent);
        transaction_data = 'h0;
    end else        
        data_sent = 0;
    
    channel++;
    if(channel == `CHANNELS_PER_PIXEL)
        channel = 0;
    
endtask
        
//      ____        ____        _
//     /    \      /    \      /
//    /      \____/      \____/
//
//      __________  __________  _
//  0  /  pixel0  \/  pixel2  \/      `CHANNELS_PER_PIXEL == 2
//     | channel0 || channel0 || 
//     |          ||          ||      `PIXELS_IN_PARALLEL == 2
//  8  |  pixel0  ||  pixel2  || 
//     | channel1 || channel1 ||        `BITS_PER_CHANNEL == 8
//     |          ||          || 
//  16 |  pixel1  ||  pixel3  || 
//     | channel0 || channel0 || 
//     |          ||          || 
//  24 |  pixel1  ||  pixel3  || 
//     \ channel1 /\ channel1 /\ 

        
task send_data(int stream_number, bit last_data, bit complete_pixel, int channel, bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transaction_data, inout bit data_sent);
    // pack the pixels into the bus
    int base = `BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL * pixel;
    bus_data[base +:`BITS_PER_CHANNEL * `CHANNELS_PER_PIXEL] = transaction_data; 
    
    if(pixel_transport == serial || pixel == `PIXELS_IN_PARALLEL - 1 || last_data)
    begin    
    
        `SOURCE_HIERARCHY_NAME.set_transaction_data(bus_data);
        `SOURCE_HIERARCHY_NAME.set_transaction_channel(stream_number);

        if (last_data && (channel == `CHANNELS_PER_PIXEL - 1 || !complete_pixel))
        begin
            `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b1);   
            `SOURCE_HIERARCHY_NAME.set_transaction_empty((`PIXELS_IN_PARALLEL - 1 - pixel)*`CHANNELS_PER_PIXEL);
        end
        
       // $display("%t Source pushed data onto the bus : %0h",$time,bus_data );
        push_transaction();
            
        bus_data = 'h0;
        pixel = 0;
        data_sent = 1;
    end
    
    else
    begin
        pixel++;
        data_sent = 0;
      //  $display("%t Source - Data not yet pushed to bus, still assembling - %0h. Next pixel is %0d",$time,bus_data,pixel );
    end
    
endtask

task send_pixel(int stream, int line_length);
    int channel = 0;
    pixel_t pixel_data;
    
    //$display("entered send pixel!");
    
    do begin // send `PIXELS_IN_PARALLEL number of pixels
        if (`SOURCE_HIERARCHY_NAME.reset == 0)
            begin
                bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transaction_data = 'h0;
                bit [`BITS_PER_CHANNEL-1:0] channel_data; 
                bit data_sent;
                bit end_of_packet;
                bit end_of_stream_packet;
                
                int current_line_length = line_length;
                
                do begin
                    //$display("%t %s sending stream=%d channel=%d", $time, name, stream, channel[stream]);        
                    /*
                    for (pixel=0; pixel<`PIXELS_IN_PARALLEL; pixel++)
                    begin
                        if(channel == 0)
                        begin
                            pixel_data = pixel_data | (video_data[stream].pop_pixel() << `BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL*pixel);
                           // pixel_data = video_data[stream].pop_pixel();
                            current_line_length--;
                        end
                    end  
*/

                    if(channel == 0) begin
                        pixel_data = video_data[stream].pop_pixel();
                        current_line_length--;
                    end                      
                    
                    channel_data = pixel_data.get_data(channel);
                    end_of_stream_packet = video_data[stream].get_length() == 0 || (current_line_length <= 0 && video_transport == line);
                    end_of_packet = end_of_stream_packet && (stream == (no_of_streams - 1) || (`USE_LINES && !`TDM_IS_BY_PIXEL));
                    send_symbol(stream, end_of_packet, 1, channel_data, channel, transaction_data, data_sent); 
                    //$display("%d %d %d", stream, current_line_length, end_of_stream_packet);
                end while(!data_sent);
            end
        else
        begin  // if in reset then we need to empty the input mailbox 
            video_data[stream].pop_pixel();
        end
    end while ((pixel_transport == serial) && channel[no_of_streams - 1] != 0);
endtask

task push_transaction;
   automatic int nw = 0; 
   real idleness;
    
   if ($urandom_range(99999, 0) < (long_delay_probability*1000))
   begin
        nw = randomize(long_delay_duration);
       `SOURCE_HIERARCHY_NAME.set_transaction_idles(long_delay_duration);                 
   end
   else 
   begin

       if (readiness_probability<50)
       begin

          `SOURCE_HIERARCHY_NAME.set_transaction_idles(transaction_idles); 
           idle_count += transaction_idles;
           busy_count++;
           
           if (busy_count%10 == 0)
           begin
               idleness = (real'(idle_count) / (real'(busy_count)+real'(idle_count) ) ) *100; //'

               if (idleness > (100 - readiness_probability))
                  transaction_idles = (transaction_idles>1) ? transaction_idles-1 : 1;
               else
                  transaction_idles++;
           end

       end

       else
       begin

          `SOURCE_HIERARCHY_NAME.set_transaction_idles(transaction_idles); 
           idle_count += transaction_idles;
           busy_count++;
           
           if (busy_count%10 == 0)
           begin
               idleness = (real'(idle_count) / (real'(busy_count)+real'(idle_count) ) ) *100; //'
               transaction_idles = (idleness <= (100 - readiness_probability));
           end

       end

   end

   `SOURCE_HIERARCHY_NAME.push_transaction();

endtask
            
task send_video;

    bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transaction_data;
    int  length = 0;
    int  line_length = 0;
    int      nw = 0;// Warning prevention
    bit first_line;
    int stream_no = 0;
    int next_stream_no = 1;
    
    // Local objects :
    c_av_st_video_item                                                                                             item_data;
    c_av_st_video_control     #(.BITS_PER_CHANNEL(`BITS_PER_CHANNEL), .CHANNELS_PER_PIXEL(`CHANNELS_PER_PIXEL)) control_data;
    c_av_st_video_user_packet #(`PIXEL_DATA_WIDTH)    user_data;
    
    t_sync_point sync_point;
    
    bus_data = 'h0;
    pixel = 0;
    
    // Pull a video item out of the mailbox  :
    this.m_video_items[0].get(item_data);
    
    `ifdef ENABLE_STIM2BFM_MSGS
        $write("%t   STIM2BFM : Source object %s found something in its mailbox : ",$time,name);
    `endif
    
    sync_point = item_data.get_sync_point();

    `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b1);
    `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b0); 
    `SOURCE_HIERARCHY_NAME.set_transaction_empty('h0);
    `SOURCE_HIERARCHY_NAME.set_transaction_channel(0);
       
     if ($urandom_range(100, 0) < readiness_probability) 
         `SOURCE_HIERARCHY_NAME.set_transaction_idles(0); 
     else
         `SOURCE_HIERARCHY_NAME.set_transaction_idles(1);
    
    if (item_data.get_packet_type() == video_packet)
    begin
            
        //Cast the video item to a video packet :
        video_data[0] = video_t'(item_data); //'
        
        `ifdef ENABLE_STIM2BFM_MSGS
            $write("It's a video packet of length %0d!\n",video_data[0].get_length());
        `endif
            
        // Av-ST Video format requires a 4'h0 on the LSB of the first beat for video packets
        if(video_transport == frame  && (`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL !=4))
            `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL-4{1'bx}},4'h0});
        else if (video_transport != frame  && (`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL !=4))
            `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL-4{1'bx}},4'd12});
        else if (video_transport == frame  && (`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL ==4))
            `SOURCE_HIERARCHY_NAME.set_transaction_data(4'h0);
        else
            `SOURCE_HIERARCHY_NAME.set_transaction_data(4'd12);
            
        if(video_data[0].get_length() == 0)
        begin
            `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b1); 
        end
            
        push_transaction();
            
        if(sync_point == sop) begin
            @(`SOURCE_HIERARCHY_NAME.signal_src_transaction_complete);
            item_data.trigger();
            $display("%t %s SOP Trigger fired", $time, name);
        end
            
        // Reset SOP for rest of packet :
        `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b0);
        `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b0); 
        `SOURCE_HIERARCHY_NAME.set_transaction_empty('h0);

       // $display("%t Source %s - Video packet transmission of length %d started.", name, $time, video_data[0].get_length());
        
        // drop all the non-master stream control and user packets
        for(int stream = 1; stream < no_of_streams; stream++) begin        
            do begin
                if(this.m_video_items[stream].num() == 0) begin
                    $display("%t %s the master stream is waiting for the other streams.", $time, name);
                end
                
                this.m_video_items[stream].get(item_data); 
            end while(item_data.get_packet_type() != video_packet);
            
            video_data[stream] = video_t'(item_data); //'
        end
        
        // iteratively put all pixels of the video onto the bus...
        first_line = 1;
        line_length = video_data[0].get_line_length();
        
        if (no_of_streams <= 1) begin
          next_stream_no = 0;
        end //if

        while (video_data[stream_no].get_length() != 0 || video_data[next_stream_no].get_length() != 0)
        begin
          //  $display("%t Source object %s %d %d %d %d", $time, name, stream_no, next_stream_no, line_length, video_data[stream_no].get_length());
            
            if(video_transport == line && (line_length <= 0 || video_data[stream_no].get_length() == 0)) begin
                if ($urandom_range(100, 0) < readiness_probability) 
                    `SOURCE_HIERARCHY_NAME.set_transaction_idles(0); 
                else
                    `SOURCE_HIERARCHY_NAME.set_transaction_idles(1);
                
                `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b1);
                `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b0);
                `SOURCE_HIERARCHY_NAME.set_transaction_empty('h0);
                if (`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL != 4)
                    `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL-4{1'bx}},4'd12});
                else 
                    `SOURCE_HIERARCHY_NAME.set_transaction_data(4'd12);
                `SOURCE_HIERARCHY_NAME.set_transaction_channel(next_stream_no);
                push_transaction();
                
                if(sync_point == sop && first_line) begin
                    @(`SOURCE_HIERARCHY_NAME.signal_src_transaction_complete);
                    item_data.trigger();
                end
                first_line = 0;
                
                // Reset SOP for rest of packet :
                `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b0);
                
                line_length = video_data[0].get_line_length();
                
                if(!`TDM_IS_BY_PIXEL) begin
                    stream_no = next_stream_no;
                    next_stream_no++;
                    if(next_stream_no >= no_of_streams)
                        next_stream_no = 0;
                end
            end
            
            if(`TDM_IS_BY_PIXEL) begin
                for(int stream = 0; stream < no_of_streams; stream++) begin
                    send_pixel(stream, line_length);
                end
            end else begin
                send_pixel(stream_no, line_length);
            end
            
            length++;
            if(video_transport == line)
                line_length-=`PIXELS_IN_PARALLEL;
        end
        
        // finish off the frame with an end of frame packet
        if(video_transport == line) begin
            `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b1);
            `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b1);
            `SOURCE_HIERARCHY_NAME.set_transaction_empty('h0);
            `SOURCE_HIERARCHY_NAME.set_transaction_channel(0);
            if (`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL != 4)
                `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL-4{1'bx}},4'd11});
            else
                `SOURCE_HIERARCHY_NAME.set_transaction_data(4'd11);
            push_transaction();
        end
        
        `ifdef ENABLE_STIM2BFM_MSGS
            $display("%t   STIM2BFM : Source object %s sent a video packet #%0d of length %0d to the BFM.", $time, name, ++video_packets_sent,length );        
        `endif
    end 
    
    else if (item_data.get_packet_type() == control_packet)
    begin
        
        bit [15:0]                                      width;
        bit [15:0]                                      height;
        bit [3 :0]                                      interlacing;
        bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transmit_symbol = 'h0;
        int channel = 0;
        
        t_packet_control                                  append_garbage = off;
        
        int                                               garbage_probability = 0;
        bit                                               garbage_being_generated = 1'b0;
        int                                               garbage_beats_generated = 0;
         
        `ifdef ENABLE_STIM2BFM_MSGS
            $write("It's a control packet!\n");
        `endif
        
        // Av-ST Video format requires a 4'hf on the LSB of the first beat for control packets
        if (`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL != 4)
            `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_PIXEL*`PIXELS_IN_PARALLEL-4{1'bx}},4'hf}); 
        else
            `SOURCE_HIERARCHY_NAME.set_transaction_data(4'hf); 
        push_transaction();
        
        // Reset SOP for rest of packet :
        `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b0);

        //Cast the video item to a video control packet :
        control_data = c_av_st_video_control'(item_data); //'
           
        width               = control_data.get_width();
        height              = control_data.get_height();
        interlacing         = control_data.get_interlacing();
        append_garbage      = control_data.get_append_garbage();
        garbage_probability = control_data.get_garbage_probability();
                
        if (append_garbage == random)
        begin
            if ($urandom_range(100, 0) < garbage_probability)
                append_garbage = on;
            else      
                append_garbage = off;
        end
        
        for (int nibble_number = 1; nibble_number<10; nibble_number++)
        begin
        
            bit [3:0] transmit_nibble = 'h0;
            bit data_sent;
                       
            // As per table 4-5 in Video and Image Processing User Guide
            case (nibble_number)
            1 : transmit_nibble =  width[15:12];
            2 : transmit_nibble =  width[11: 8];
            3 : transmit_nibble =  width[ 7: 4];
            4 : transmit_nibble =  width[ 3: 0];
            5 : transmit_nibble = height[15:12];
            6 : transmit_nibble = height[11: 8];
            7 : transmit_nibble = height[ 7: 4];
            8 : transmit_nibble = height[ 3: 0];
            9 : transmit_nibble = interlacing;
            endcase
            
            //   stream_number,           last_data?,          complete_pixel?,     data in,   channel,  transaction_data out, data_sent flag
            send_symbol(0, (nibble_number == 9 && append_garbage == off), 0,   transmit_nibble, channel,  transmit_symbol, data_sent);
            
            if(data_sent)
                transmit_symbol = 'h0;            
           
        end //for
        
        
        
        // Control packet has been sent, now optionally append some garbage :
        if (append_garbage == on)
        begin
            
            if(channel != 0) begin
              // complete the control packet
              bit data_sent = 0;
              while(!data_sent) begin
                nw = randomize(garbage_data);
                send_symbol(0, 0, 1, garbage_data, channel, transmit_symbol, data_sent);
              end
            end
        
            garbage_beats_generated = 0;
            garbage_being_generated = 1'b1;
            
            do
            begin
                bit data_sent;
                
                // Probability of terminating garbage fixed at 10%
                if ($urandom_range(100, 0) < 10)
                    garbage_being_generated = 1'b0;
                    
                nw = randomize(garbage_data);
   
                send_data(0, !garbage_being_generated, 0, channel, garbage_data, data_sent);
                
                garbage_beats_generated++;
                
            end
            while (garbage_being_generated); 
                     
            `ifdef ENABLE_STIM2BFM_MSGS
                $display("%t   STIM2BFM : Source object %s sent a control packet #%0d (%s) with %0d garbage beats to the BFM.", $time, name, ++control_packets_sent, control_data.info(), garbage_beats_generated );        
            `endif
        
        end //if (append_garbage == on)
        
        else
        begin
            `ifdef ENABLE_STIM2BFM_MSGS
                $display("%t   STIM2BFM : Source object %s sent a control packet #%0d (%s) to the BFM.", $time, name, ++control_packets_sent, control_data.info() );                
            `endif
        end
        
     end // else-if
    
    else if (item_data.get_packet_type() == user_packet)
    begin
    
        `ifdef ENABLE_STIM2BFM_MSGS
            $write("It's a user packet!\n");
        `endif

         //Cast the video item to a video packet :
        user_data = c_av_st_video_user_packet'(item_data);
        
        if(user_data.get_length() == 0)
        begin
            `SOURCE_HIERARCHY_NAME.set_transaction_eop(1'b1);    
            `SOURCE_HIERARCHY_NAME.set_transaction_empty('h0);
        end
        
        // Av-ST Video format requires a 4'h0 on the LSB of the first beat for video packets
        if (`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL != 4)
            `SOURCE_HIERARCHY_NAME.set_transaction_data({{`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-4{1'bx}},user_data.get_identifier()}); 
        else 
            `SOURCE_HIERARCHY_NAME.set_transaction_data(user_data.get_identifier()); 
        push_transaction();
        
        // Reset SOP for rest of packet :
        `SOURCE_HIERARCHY_NAME.set_transaction_sop(1'b0);

        //$display("%t Source - User packet transmission of length %d started.", $time, user_data.get_length());
    
        // iteratively put all pixels of the video onto the bus...
        while (user_data.get_length() != 0)
        begin
        //$display("%t Source - User packet transmission beat %d.", $time, user_data.get_length());

            if (`SOURCE_HIERARCHY_NAME.reset == 0)
            begin 
                
                 bit data_sent;
                 bit [`BITS_PER_CHANNEL*`CHANNELS_PER_PIXEL-1:0] transaction_data =  user_data.pop_data();
                 int channel;
                 send_data(0, user_data.get_length() == 0, 0, channel, transaction_data, data_sent);

            end

            else
            begin  // if in reset then we need to empty the input mailbox 
                user_data.pop_data();
            end 

        length++;
        
        end
        
        `ifdef ENABLE_STIM2BFM_MSGS
            $display("%t   STIM2BFM : Source object %s sent a user packet #%0d type %0d of length %0d to the BFM.",$time, name, ++user_packets_sent, user_data.get_identifier(), length);
        `endif        
    end 
    
    else
    begin
        $fatal(1, "%t TEST FAILED : Source object %s Unrecognised packet type detected.\n",$time, name);    
    end
    
    if(sync_point == eop) begin
        @(`SOURCE_HIERARCHY_NAME.signal_src_transaction_complete);
        item_data.trigger();
        $display("%t %s EOP Trigger fired", $time, name);
    end 

endtask

task wait_for_transactions_to_complete();
    wait(`SOURCE_HIERARCHY_NAME.signal_src_transaction_complete);
endtask

endclass

`undef CLASSNAME
`undef SOURCE
`undef SOURCE_HIERARCHY_NAME
`undef USE_LINES
`undef TDM_IS_BY_PIXEL
