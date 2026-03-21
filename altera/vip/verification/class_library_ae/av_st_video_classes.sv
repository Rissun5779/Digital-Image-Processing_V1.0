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


`ifndef _ALT_VIP_VID_CLASSES_
`define _ALT_VIP_VID_CLASSES_

package av_st_video_classes;

typedef enum {video_packet, control_packet, user_packet, generic_packet, line_packet, end_of_frame_packet, undefined} t_packet_types;
typedef enum {parallel, serial}                                                                  t_pixel_format;
typedef enum {on, off, random}                                                                   t_packet_control;
typedef enum {read, write}                                                                       t_rw;
typedef enum {normal, inverse}                                                                   t_ycbcr_order;
typedef enum {big, little}                                                                       t_endianism;
typedef enum {frame, line}                                                                       t_video_format;
typedef enum {never, sop, middle, eop}                                                                  t_sync_point;

function string display_video_item_type (t_packet_types t);
begin

    case (t) 
    video_packet    : return      "video_packet";
    control_packet  : return    "control_packet";
    user_packet     : return       "user_packet";
    generic_packet  : return    "generic_packet";
    undefined       : return         "undefined";
    endcase

end
endfunction : display_video_item_type

// The mailboxes which source/sink video packets hold 'queue items'
// which may be Av-st video packets, control packets or user packets :
class c_av_st_video_item  ;

    t_packet_types packet_type;
    event event_to_trigger;
    t_sync_point time_to_trigger_event;
    int id;
    
    function new();
       packet_type = generic_packet;
       time_to_trigger_event = never;
    endfunction : new;
    
    function compare(c_av_st_video_item c);
    endfunction : compare;
    
    function silent_compare(c_av_st_video_item c);
    endfunction : silent_compare;    
    
    function void copy(c_av_st_video_item c);
       this.packet_type = c.packet_type;
       this.event_to_trigger = c.event_to_trigger;
       this.time_to_trigger_event = c.time_to_trigger_event;
       this.id = c.id;
    endfunction : copy;

    // Getters and setters :
    function void set_packet_type(t_packet_types ptype);
        packet_type = ptype;
    endfunction : set_packet_type 

    function t_packet_types get_packet_type ();
        return packet_type;
    endfunction : get_packet_type 
    
    function t_sync_point get_sync_point ();
        return time_to_trigger_event;
    endfunction : get_sync_point
    
    function void trigger ();
        ->event_to_trigger;
    endfunction : trigger 
    
    function event get_trigger ();
        return event_to_trigger;
    endfunction : get_trigger
    
    function void set_id(int id);
        this.id = id;
    endfunction : set_id 

    function int get_id();
        return id;
    endfunction : get_id 
   
endclass

class c_pixel #(parameter BITS_PER_CHANNEL = 8, CHANNELS_PER_PIXEL = 3) ;
    
    // Each pixel is an array of CHANNELS_PER_PIXEL channels, each channel of BITS_PER_CHANNEL precision :
    bit  [0:CHANNELS_PER_PIXEL-1] [BITS_PER_CHANNEL-1:0]channel ;
        
    // Default constructor :
    function new();
        for (int i=0; i<CHANNELS_PER_PIXEL; i++ )
            channel[i] = 'hx;
       //$display("c_pixel NEW called with CHANNELS_PER_PIXEL=",CHANNELS_PER_PIXEL);
    endfunction : new;

    // Copy constructor :
    function void copy(c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pix);
        for (int i=0; i<CHANNELS_PER_PIXEL; i++ )
            this.channel[i] = pix.get_data(i);
    endfunction : copy
    
    // Pixel channel "Getters" and "Setters" :
    function bit[BITS_PER_CHANNEL-1:0] get_data(int id);
        return channel[id];
    endfunction : get_data
    
    // Setter :
    function void set_data(int id, bit [BITS_PER_CHANNEL-1:0] data);
        channel[id] = data;
    endfunction : set_data
    
    function bit[(BITS_PER_CHANNEL * CHANNELS_PER_PIXEL) - 1:0] get_data_bus();
        bit[(BITS_PER_CHANNEL * CHANNELS_PER_PIXEL) - 1:0] data_bus;
        
        for (int i=0; i<CHANNELS_PER_PIXEL; i++)
            data_bus[i * BITS_PER_CHANNEL +: BITS_PER_CHANNEL] = channel[i];
        
        return data_bus;
    endfunction
            
endclass



class c_av_st_video_data #(parameter BITS_PER_CHANNEL = 8, CHANNELS_PER_PIXEL = 3) extends c_av_st_video_item ;

    // Create a queue of pixel objects from class c_pixel.  A queue is used instead
    // of an array.  This denies random access, but improves simulation speed :    
    c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixels [$];
    c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel,new_pixel,r_pixel;
        
    int       video_length;
    int       video_min_length = 5;
    int       video_max_length = 100;
    int       video_line_length; // used to split the frame into lines for transmission 

    int unsigned pixels_in_parallel;
    int unsigned sop_empty;

    int height = 10;
    int width = 10;

    // Default constructor :
    function new(int unsigned pixels_in_parallel = 1);
        super.new();
        packet_type = video_packet;
        //pixels = new[video_length];
        video_line_length = 32;
        this.pixels_in_parallel = pixels_in_parallel;
        sop_empty = 0;
       //$display("c_av_st_video_data NEW called with CHANNELS_PER_PIXEL=",CHANNELS_PER_PIXEL);
    endfunction : new;
    
    // Copy constructor :
    function void copy(c_av_st_video_data #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) c);
        super.copy(c_av_st_video_item'(c)); //'
        packet_type = video_packet;
        video_length = c.video_length;
        video_line_length = c.video_line_length;
        sop_empty = c.sop_empty;

        for (int i=0; i<c.get_length(); i++ )
        begin
            new_pixel = new();            
            pixel = c.query_pixel(i);
            new_pixel.copy(pixel);
            pixels.push_back(new_pixel);  
        end        
                   
    endfunction : copy;
    
    function bit compare (c_av_st_video_data #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) r);
    begin
    
        int errors = 0;
        int first_error = 0;
        int last_error = 0;
        int channel_errors[0:3];
        compare = 1;
        
        channel_errors[0] = 0;
        channel_errors[1] = 0;
        channel_errors[2] = 0;
        channel_errors[3] = 0;
        
        if (pixels.size() != r.get_length())
        begin
            $display("%t    COMPARE : Image packet mismatch reference length %0d != dut length %0d", $time, pixels.size(), r.get_length());            
            compare = 0;
        end
        
        for (int j = r.get_length()-1; j>0; j--)
        begin
        
            r_pixel = r.query_pixel(j);            
            for (int i=0; i< CHANNELS_PER_PIXEL; i++)            
            begin
                if ( r_pixel.get_data(i) != pixels[j].get_data(i))
                begin
                
                    //if (errors<100)
                        $display("%t    COMPARE : FAIL - Image packet mismatch for pixel %0d, channel [%0d] : [reference value %0h != DUT value %0h]", $time, j, i, pixels[j].get_data(i), r_pixel.get_data(i));
                     
                    compare = 0;
                    errors++;
                    channel_errors[i]++;
                    
                    if (first_error == 0)
                       first_error = j;
                       
                    last_error = j;
                    
                end  

                else
                begin
                        $display("%t    COMPARE : PASS - Image packet match for pixel %0d, channel [%0d] : [value %0h]", $time, j, i,r_pixel.get_data(i));
                end

            end
            
        end
                
        if (errors > 100)
            $display("%t    COMPARE : FAIL - Remaining %0d mismatches are concatenated...", $time, errors-100);
                
        if (errors != 0)
        begin
            $display("%t    COMPARE : FAIL - First mismatched channel was for pixel #%0d", $time, first_error);
            $display("%t    COMPARE : FAIL -  Last mismatched channel was for pixel #%0d", $time, last_error);
            for (int i=0; i< CHANNELS_PER_PIXEL; i++)  
            begin
                $display("%t    COMPARE : FAIL - %0d beats of mismatched channel data on channel %0d", $time, channel_errors[i], i);            
            end          
            $display("%t    COMPARE : FAIL - %0d beats of mismatched channel data out of a total of %0d", $time, errors, r.get_length()*CHANNELS_PER_PIXEL);
        end
        
        if(sop_empty != r.sop_empty && pixels_in_parallel > 1)
        begin
            $display("%t    COMPARE : SOP empty mismatch %0d != %0d", $time, sop_empty, r.sop_empty);
            compare = 0;
        end        
        
     end
     endfunction    
    
         
    function bit is_same_size (c_av_st_video_data #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) r);
    begin    

        if (pixels.size() != r.get_length())
        begin
            return 0;
        end

        else
        begin
            return 1;
        end
        
    end
    endfunction       


    function bit silent_compare (c_av_st_video_data #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) r);
    begin
    
        int errors = 0;
        int first_error = 0;
        int last_error = 0;
        int channel_errors[0:3];
        silent_compare = 1;
        
        channel_errors[0] = 0;
        channel_errors[1] = 0;
        channel_errors[2] = 0;
        channel_errors[3] = 0;
        
        //rats, cannot do '99', as bit is a 2-state var & I need to be backward compaitble
        //tomorrow do size check BEFORE other checks!!
        if (pixels.size() != r.get_length())
        begin
            return 0;
        end
        
        for (int j = r.get_length()-1; j>0; j--)
        begin
        
            r_pixel = r.query_pixel(j);            
            for (int i=0; i< CHANNELS_PER_PIXEL; i++)            
            begin
                if ( r_pixel.get_data(i) != pixels[j].get_data(i))
                begin
      
                    silent_compare = 0;
                    errors++;
                    channel_errors[i]++;
                    
                    if (first_error == 0)
                       first_error = j;
                       
                    last_error = j;
                    
                end              
            end
            
        end            
        
        if(sop_empty != r.sop_empty && pixels_in_parallel > 1)
        begin
            silent_compare = 0;
        end        
        
     end
     endfunction   
    
    function bit visualise (int height, int width);
    begin
    
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel;
               
        if (height>100 || width>100)
        begin
            $error("Image too big to visualise");            
        end

        for (int j=0; j< height; j++)
        begin : vertical 

            for (int i=0; i< width; i++)
            begin : horizontal

                 // The top of the frame is the bottom of the pixel queue :
                 pixel = pixels[$ - (width*j)-i];
                 $write("%6h-",pixel.get_data_bus());                 

            end
            $write("\n");                 
        end

    end   
    endfunction    
    
    
    function bit make_test_pattern (int height, int width, int spacing);
    begin
                    
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel, pixel_template;
        int col0 = 0;
        int col1 = 1;
        int col2 = 2;
        int max = (1 << BITS_PER_CHANNEL) -1;
        int inc0 = BITS_PER_CHANNEL *12 + 12;
        int inc1 = BITS_PER_CHANNEL *21 + 21;
        int inc2 = BITS_PER_CHANNEL *39 + 39;
        
        int len = height*width;
        pixel_template = new();
        
        for (int i=0; i<len; i++ )
        begin
            // Here the randomize is performed on one object, which is then copied, in order to
            // improve simulation speed :
            pixel_template.set_data(0,col0[BITS_PER_CHANNEL-1:0]);
            if (CHANNELS_PER_PIXEL>1)
                pixel_template.set_data(1,max-col1[BITS_PER_CHANNEL-1:0]);
            if (CHANNELS_PER_PIXEL>2)
                pixel_template.set_data(2,col2[BITS_PER_CHANNEL-1:0]);
            if (i%spacing == 0)
            begin
              col0 = ( (col0 > (max - inc0)) ? 0 : (col0+inc0) );
              col1 = ( (col1 > (max - inc1)) ? 0 : (col1+inc1) );
              col2 = ( (col2 > (max - inc2)) ? 0 : (col2+inc2) );
            end
            pixel = new();
            pixel.copy(pixel_template);
            pixels.push_front(pixel);   
        end  
        $display("%t     GOLDEN : Test pattern written to video frame of length = %0d", $time, pixels.size());
        
        make_test_pattern = 1;  
                                 
     end
     endfunction    
     
    
    function bit make_random_field (int height, int width);
    begin
                    
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel, pixel_template;
        int len = height*width;
        pixel_template = new();
        
        for (int i=0; i<len; i++ )
        begin          
            pixel = new();
            pixel.copy(pixel_template);
            pixels.push_front(pixel);   
        end  
        $display("%t     GOLDEN : Random pattern written to video frame of length = %0d", $time, pixels.size());
        
        make_random_field = 1;  
                                 
     end
     endfunction    
     
           
    // Getters and setters 
    function void set_height(int h);
        height = h;
    endfunction : set_height

    function int get_height();
        return height;
    endfunction : get_height

    function void set_width(int w);
        width = w;
    endfunction : set_width

    function int get_width();
        return width;
    endfunction  : get_width

    function void set_min_length(int length);
        video_min_length = length;
    endfunction : set_min_length
    
    //set_max_length sets the maximum length of video packet that could be held by the object :
    function void set_max_length(int length);
        video_max_length = length;
    endfunction : set_max_length
    
    //get_length returns the length of the video data packet :
    function int get_length();
        return pixels.size();
    endfunction : get_length
    
    function void set_line_length(int line_length);
        video_line_length = line_length;
    endfunction : set_line_length
    
    function int get_line_length();
        return video_line_length;
    endfunction : get_line_length
    
    // pop_pixel returns an object of class c_pixel :
    function c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pop_pixel();
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel;
        //$display("popping pixel %0d", pixels.size());
        pixel = new();
        
        if (pixels.size() != 0)
            pixel = pixels.pop_back();    
        
        return pixel;
    endfunction : pop_pixel
    
    // query_pixel returns an object of class c_pixel :
    function c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) query_pixel(int i);
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel;
        pixel = new();
        pixel = pixels[i];    
        return pixel;
    endfunction : query_pixel

    // Unpopulate pops each pixel off the stream, optionaly displaying them :
    function void unpopulate(bit display);
        c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel;
        pixel = new();
        while (pixels.size() > 0)
        begin
            pixel = pixels.pop_back();
            if (display) $display("Unpopulate : %3h%3h%3h",pixel.get_data(0),pixel.get_data(1),pixel.get_data(2));
        end
    endfunction : unpopulate

    // Unpopulate pops each pixel off the stream, optionaly displaying them :
    function void delete_pixel(int index);
        if (index > pixels.size())
        begin
            $fatal("Error : Trying to delete pixel %0d of %0d",index, pixels.size());            
        end
        pixels.delete(index) ;   
    endfunction : delete_pixel
    
    //push_pixel pushes a pixel to the front of the queue :
    function void push_pixel(c_pixel #(BITS_PER_CHANNEL,CHANNELS_PER_PIXEL) pixel);
        pixels.push_front(pixel);
    endfunction : push_pixel
    
    function void set_sop_empty(int unsigned sop_empty);
        this.sop_empty = sop_empty;
    endfunction : set_sop_empty

endclass



class c_av_st_video_control #(parameter BITS_PER_CHANNEL = 8, CHANNELS_PER_PIXEL = 3) extends c_av_st_video_item ;

     bit [15:0] width;
     bit [15:0] height;
     bit [3:0]  interlace;
    int             min_width = 30;
    int             max_width = 200;
    int             min_height = 30;
    int             max_height = 200;
    int             length;
    
    // Control packets may append any number of garbage beats after the last beat.
     t_packet_control      append_garbage = off;
     int              garbage_probability = 0;

    function new();
        super.new();
        packet_type = control_packet;
        this.width = 'hx;
        this.height = 'hx;
        this.interlace = 'hx;
       //$display("c_av_st_video_control NEW called with CHANNELS_PER_PIXEL=",CHANNELS_PER_PIXEL);
    endfunction
   
    
    function bit compare (c_av_st_video_control #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) r);
    begin

        // NB. Some VIP core tests wil lexpect to get mismatches as part of the test code 
        // Eg. A frame buffer searching for a repeated contol/video pair amongst various pairs,
        // so we don't want to print out mismatches here as it makes for a confusoing log.
        if (this.width != r.get_width()) begin
          //  $display("width %0d != %0d\n", this.width, r.get_width());
            return 1'b0;
        end
        if (this.height != r.get_height()) begin
          //  $display("height %0d != %0d\n", this.height, r.get_height());
            return 1'b0;
        end
        if (this.interlace != r.get_interlacing()) begin
         //   $display("interlace %0d != %0d\n", this.interlace, r.get_interlacing());
            return 1'b0;          
        end
        
        return 1'b1;
        
    end
    endfunction
    
    function void copy(c_av_st_video_control #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) c);
        super.copy(c_av_st_video_item'(c)); //'
        width = c.width;
        height = c.height;
        interlace = c.interlace;           
    endfunction : copy;
      
    
    // Getters :
    function bit [15:0] get_width ();
        return this.width;
    endfunction :  get_width
    
    function bit [15:0] get_height ();
        return this.height;
    endfunction :  get_height
    
    function bit [3:0] get_interlacing ();
        return this.interlace;
    endfunction :  get_interlacing
    
    function t_packet_control get_append_garbage ();
        return this.append_garbage;
    endfunction :  get_append_garbage
     
    function int get_garbage_probability ();
        return this.garbage_probability;
    endfunction :  get_garbage_probability
   
    // Setters :
    
    function void set_min_width(int width);
        min_width = width;
    endfunction : set_min_width
    
    //set_max_length sets the maximum length of video packet that could be held by the object :
    function void set_max_width(int width);
        max_width = width;
    endfunction : set_max_width
    
    function void set_min_height(int height);
        min_height = height;
    endfunction : set_min_height
    
    //set_max_length sets the maximum length of video packet that could be held by the object :
    function void set_max_height(int height);
        max_height = height;
    endfunction : set_max_height
    
    function void set_width (bit [15:0] w);
        this.width = w;
    endfunction :  set_width
     
    function void set_height (bit [15:0] h);
        this.height = h;
    endfunction :  set_height
     
    function void set_interlacing (bit [3:0] i);
        this.interlace = i;
    endfunction :  set_interlacing
     
    function void set_append_garbage (t_packet_control i);
        this.append_garbage = i;
    endfunction :  set_append_garbage
      
    function void set_garbage_probability (int i);
        this.garbage_probability = i;
    endfunction :  set_garbage_probability
    
    function string info();
        string s;
        $sformat(s, "width = %0d, height = %0d, interlacing = 0x%0h", width, height, interlace);
        return s;    
    endfunction
  
endclass



class c_av_st_video_user_packet #(parameter DATA_WIDTH = 24) extends c_av_st_video_item;

     bit [DATA_WIDTH-1:0] data [$];
     bit[3:0]  identifier;
    int            min_length = 5;
    int            max_length = 10;
    
     bit [DATA_WIDTH-1:0] datum ;

    int unsigned pixels_in_parallel;

    function new(int unsigned pixels_in_parallel = 1);
        super.new();
        packet_type = user_packet;
        data = {};
        this.pixels_in_parallel = pixels_in_parallel;
        //$display("c_av_st_video_user_packet NEW called with CHANNELS_PER_PIXEL=",CHANNELS_PER_PIXEL);
    endfunction
    
    // Copy constructor :
    function void copy(c_av_st_video_user_packet #(DATA_WIDTH) c);
        super.copy(c_av_st_video_item'(c));  //'
        packet_type = user_packet;
        identifier = c.identifier;

        data = {};

        for (int i=0; i<c.get_length(); i++ )
        begin
            data.push_back(c.query_data(i));   
        end        
           
    endfunction : copy;
    
    function bit compare (c_av_st_video_user_packet #(DATA_WIDTH) r);
    begin 
               
        if (data.size() != r.get_length()) begin
            $display("User packet mismatch reference length %0d != dut length %0d", data.size(), r.get_length());
            return 1'b0;
        end
        
        if (identifier != r.get_identifier()) begin
            $display("User packet mismatch reference identifier %0d != dut identifier %0d", identifier, r.get_identifier());
            return 1'b0;
        end
        
        for (int j=0; j< r.get_length(); j++)                    
            if ( r.query_data(j) != data[j]) begin
                $display("User packet mismatch beat %0d (count from eop) reference %0h != dut %0h", j, data[j], r.query_data(j));
                return 1'b0;
            end
            
        return 1'b1;
        
     end
     endfunction : compare 
    
    function void set_min_length(int l);
        min_length = l;
    endfunction : set_min_length
    
    function void set_max_length(int l);
        max_length = l;
    endfunction : set_max_length
    
    function int get_length();
        return data.size();
    endfunction : get_length
     
    function bit[3:0] get_identifier();
        return identifier;
    endfunction : get_identifier
     
    function bit[3:0] set_identifier(int i);
        identifier = i;
    endfunction : set_identifier
   
    function bit [DATA_WIDTH-1:0] pop_data();
        return data.pop_back();    
    endfunction : pop_data
   
    function bit [DATA_WIDTH-1:0] query_data(int i);
        return data[i];    
    endfunction : query_data
    
    function void push_data(bit [DATA_WIDTH-1:0] d);
        data.push_front(d);
    endfunction : push_data 
    
       
endclass



// This package also includes a base class for the source and sink file BFMs
// which provides the various statistical metrics :
class c_av_st_video_source_sink_base #(int unsigned no_of_streams = 1);

    // The class receives video items and outputs through this mailbox :
    mailbox #(c_av_st_video_item) m_video_items[no_of_streams];

    t_pixel_format              pixel_transport = parallel;
    t_video_format              video_transport = frame;
    string                                 name = "undefined";

    int                      video_packets_sent =    0;
    int                    control_packets_sent =    0;
    int                       user_packets_sent =    0;

    int                   readiness_probability =   80;
    real                 long_delay_probability = 0.01;

     int      long_delay_duration_min_beats =  100;
     int      long_delay_duration_max_beats = 1000;
     int      long_delay_duration           =   80;

    // The constructor 'connects' the output mailbox to the object's mailbox :
    function new(mailbox #(c_av_st_video_item) m_vid[no_of_streams]);
        for(int i = 0; i < no_of_streams; i++) begin
            m_video_items[i] = new(0);
            this.m_video_items[i] = m_vid[i];
        end
    endfunction

    function void set_readiness_probability(int percentage);
        this.readiness_probability = percentage;
    endfunction

    function int get_readiness_probability();
        return this.readiness_probability;
    endfunction



    function void set_long_delay_probability(real percentage);
        this.long_delay_probability = percentage;
    endfunction : set_long_delay_probability

    function real get_long_delay_probability();
        return this.long_delay_probability;
    endfunction : get_long_delay_probability



    function void set_long_delay_duration_min_beats(int percentage);
        this.long_delay_duration_min_beats = percentage;
    endfunction : set_long_delay_duration_min_beats

    function int get_long_delay_duration_min_beats();
        return this.long_delay_duration_min_beats;
    endfunction : get_long_delay_duration_min_beats



    function void set_long_delay_duration_max_beats(int percentage);
        this.long_delay_duration_max_beats = percentage;
    endfunction : set_long_delay_duration_max_beats

    function int get_long_delay_duration_max_beats();
        return this.long_delay_duration_max_beats;
    endfunction : get_long_delay_duration_max_beats



    function void set_pixel_transport(t_pixel_format in_parallel);
        this.pixel_transport = in_parallel;
    endfunction : set_pixel_transport

    function t_pixel_format get_pixel_transport();
        return this.pixel_transport;
    endfunction : get_pixel_transport

    
    
    function void set_video_transport(t_video_format in_frames);
        this.video_transport = in_frames;
    endfunction : set_video_transport

    function t_video_format get_video_transport();
        return this.video_transport;
    endfunction : get_video_transport

    
    
    
    function void set_name(string s);
        this.name = s;
    endfunction : set_name

    function string get_name();
        return name;
    endfunction : get_name

endclass

class item_copying_class #(BITS_PER_CHANNEL = 8, CHANNELS_PER_PIXEL = 3, DATA_WIDTH = 24);
    typedef c_av_st_video_data #(.BITS_PER_CHANNEL(BITS_PER_CHANNEL), .CHANNELS_PER_PIXEL(CHANNELS_PER_PIXEL)) t_video;
    typedef c_av_st_video_control #(.BITS_PER_CHANNEL(BITS_PER_CHANNEL), .CHANNELS_PER_PIXEL(CHANNELS_PER_PIXEL)) t_control;
    typedef c_av_st_video_user_packet #(.DATA_WIDTH(DATA_WIDTH)) t_user;

    function c_av_st_video_item copy_item (c_av_st_video_item item_data);
        t_video video_data;
        t_control control_data;
        t_user user_data;
            
        if(item_data.get_packet_type() == video_packet) begin
            video_data = new();
            video_data.copy(t_video'(item_data));
            return video_data;
        end else if(item_data.get_packet_type() == control_packet) begin
            control_data = new();
            control_data.copy(t_control'(item_data));
            return control_data;
        end else begin
            user_data = new();
            user_data.copy(t_user'(item_data));
            return user_data;
        end
    endfunction

endclass

endpackage : av_st_video_classes
`endif
