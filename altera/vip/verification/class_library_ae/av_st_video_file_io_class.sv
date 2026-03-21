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


`ifndef _ALT_VIP_VID_FILE_IO_CLASSES_
`define _ALT_VIP_VID_FILE_IO_CLASSES_

package av_st_video_file_io_class;

import av_st_video_classes::*;
//import verbosity_pkg::*;

class c_av_st_video_file_io #(parameter BITS_PER_CHANNEL = 8, CHANNELS_PER_PIXEL = 3);

    typedef c_av_st_video_data        #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) video_t;
    typedef c_av_st_video_user_packet #(CHANNELS_PER_PIXEL*BITS_PER_CHANNEL)  user_t;
    
    //Private global Variables to pass info between functions :
       
    local int                      fhandle = 0;
    local int        video_packets_handled = 0;  
    local int      control_packets_handled = 0;  
    local int         user_packets_handled = 0;  
    
    local reg                        file_open;
    local reg[15:0]               image_height;
    local reg[15:0]                image_width;
    local reg[ 3:0]           image_interlaced;
    local string    image_fourcc = "UNDEFINED";
    local int                     image_stride;
    local string                      filename;      
    local string                  spc_filename;
    local string       object_name = "file_io"; 
    
            
    local int        fourcc_channels_per_pixel;
    local int          fourcc_bits_per_channel; 
    local int           fourcc_pixels_per_word; 
    local int               fourcc_channel_lsb; 

    local int       early_eop_probability = 20;      
    local int        late_eop_probability = 20; 
               
    local int     user_packet_probability = 20;      
    local int  control_packet_probability = 20;    

    mailbox #(c_av_st_video_item) m_video_item_out;

    // Public variables, accessed via methods below :
    
     t_packet_control               send_control_packets =  on;
     t_packet_control                  send_user_packets = off;
     t_packet_control             send_early_eop_packets = off;
     t_packet_control              send_late_eop_packets = off;
     t_packet_control send_garbage_after_control_packets = off;
    
     int early_eop_packet_length = 20;
     int  late_eop_packet_length = 20;
    

    function void set_send_control_packets(t_packet_control s);
        send_control_packets = s;
    endfunction : set_send_control_packets 
    
    function t_packet_control get_send_control_packets();
        return send_control_packets;
    endfunction : get_send_control_packets



    function void set_send_user_packets(t_packet_control s);
        send_user_packets = s;
    endfunction : set_send_user_packets 
    
    function t_packet_control get_send_user_packets();
        return send_user_packets;
    endfunction : get_send_user_packets



    function void set_send_early_eop_packets(t_packet_control s);
        send_early_eop_packets = s;
    endfunction : set_send_early_eop_packets 
    
    function t_packet_control get_send_early_eop_packets();
        return send_early_eop_packets;
    endfunction : get_send_early_eop_packets

    function void set_early_eop_probability(int s);
        early_eop_probability = s;
    endfunction : set_early_eop_probability 
    
    function int get_early_eop_probability();
        return early_eop_probability;
    endfunction : get_early_eop_probability



    function void set_send_late_eop_packets(t_packet_control s);
        send_late_eop_packets = s;
    endfunction : set_send_late_eop_packets 
    
    function t_packet_control get_send_late_eop_packets();
        return send_late_eop_packets;
    endfunction : get_send_late_eop_packets

    function void set_late_eop_probability(int s);
        late_eop_probability = s;
    endfunction : set_late_eop_probability 
    
    function int get_late_eop_probability();
        return late_eop_probability;
    endfunction : get_late_eop_probability


    function void set_user_packet_probability(int s);
        user_packet_probability = s;
    endfunction : set_user_packet_probability 
    
    function int get_user_packet_probability();
        return user_packet_probability;
    endfunction : get_user_packet_probability


    function void set_control_packet_probability(int s);
        control_packet_probability = s;
    endfunction : set_control_packet_probability 
    
    function int get_control_packet_probability();
        return control_packet_probability;
    endfunction : get_control_packet_probability


    function void set_send_garbage_after_control_packets(t_packet_control s);
        send_garbage_after_control_packets = s;
    endfunction : set_send_garbage_after_control_packets 
    
    function t_packet_control get_send_garbage_after_control_packets();
        return send_garbage_after_control_packets;
    endfunction : get_send_garbage_after_control_packets

 
    function void set_object_name(string s);
        object_name = s;
    endfunction : set_object_name 
    
    function string get_object_name();
        return object_name;
    endfunction : get_object_name
   

       
    function string get_filename();
        return filename;
    endfunction : get_filename
 
 
    function void set_image_height(bit[15:0] height);
        image_height = height;
    endfunction : set_image_height 
    
    function bit[15:0] get_image_height();
        return image_height;
    endfunction : get_image_height
 
     
    function int get_video_packets_handled();
        return video_packets_handled;
    endfunction : get_video_packets_handled
 
 
    function void set_image_width(bit[15:0] width);
        image_width = width;
    endfunction : set_image_width 
    
    function bit[15:0] get_image_width();
        return image_width;
    endfunction : get_image_width
    
    
    function void set_video_data_type(string s);
        image_fourcc = s;
    endfunction : set_video_data_type 
    
    function string get_video_data_type();
        return image_fourcc;
    endfunction : get_video_data_type
     
    
    // The constructor 'connects' the input mailbox to the object's mailbox :
    
    function new(mailbox #(c_av_st_video_item) m_vid_out);
   // todo use this function new(mailbox #(c_av_st_video_item) m_vid_out[no_of_streams]);
        this.m_video_item_out = m_vid_out;
    endfunction   
            
            
    //Opens a binary video frame file and sets the frame height, width and interlaced properties. 
    //`fname' specifies the full name (including file extension) of the input file to be opened
    // Checks the filename - if no extension given, look for a .bin or a .raw and an .spc file.  If
    // an extension is given, look for an equivalent .spc file :
    function void open_file(string fname,t_rw rw);
        
        int video_packets_handled = 0;
        int length = fname.len;
        int spchandle;
        int status;
        int i;        
        string spc_string;
        string core;
        
        // Determine if a file extension was specified, if not use .raw
        // Also generate the SPC filename :        
        for (i=length-1; (i>1 && (fname.substr(i,i)!=".")) ;  i--)                
           core = fname.substr(0,i-2);           

        if (i==1)
        begin
           spc_filename = {fname,".spc"};
           fname = {fname,".raw"};
        end
        
        else
           spc_filename = {core, ".spc"};
           
        filename = fname;
        
        if (rw == write) 
        begin
            fhandle = $fopen(fname,"wb");
            $display ("%t   FILE I/O : %s opened file %s for write",$time,object_name,fname);
        end
        
        else
        begin

            // Get file details from SPC file :
            spchandle = $fopen(spc_filename,"r");
            
            if (spchandle == 0)
                $fatal (1,"Cannot open SPC file %s",spc_filename);

            //Assign default values :        
            image_fourcc = "UNDEFINED";
            image_width = 0;
            image_height = 0;
            image_stride = 0;
            image_interlaced = 4'b0000;

            while (!$feof(spchandle))                                                                                                                              
            begin
                status = $fgets(spc_string, spchandle); 
                spc_hunt(spc_string);
            end

            if (image_width == 0 || image_height == 0)
                $fatal("Zero image dimension in .spc file.");

            if (file_open)
                $fclose(fhandle);

            fhandle = $fopen(fname,"rb");
            
            if (fhandle == 0)
                $fatal (1,"Cannot open file %s",fname);
                
            file_open = 1'b1;
            $display ("\n%t %s opened file %s (%0d width x %0d height)",$time,object_name,fname,image_width,image_height);
            
        end        
  
    endfunction


    //Closes the current video frame file
    function void close_file();

        if (file_open) begin
            $fclose(fhandle);
        end
        file_open = 1'b0;

    endfunction
    
    
    // Read an .spc file to get height, width etc...
    local function void spc_hunt(string read_data_str);
    
        // Search the given line in the SPC file for parameters :
        int length = read_data_str.len;
        string start,ending,clean_string;

        int i =0;
        clean_string = "                                       ";
        while (read_data_str.getc(i) > 31)         
        begin
            clean_string.putc(i,read_data_str.getc(i));
          //  $display("Char %d is %d so putting it.  clean_string now %s END",i,read_data_str.getc(i),clean_string);
            i++;
        end
        read_data_str = clean_string.substr(0,i-1);
        length = read_data_str.len;

       // $display("spc_hunt running on [%s]",read_data_str)  ;

        for (int i=0; (i<=length && (read_data_str.substr(i,i)!=" ")) ;  i++)                
        begin
        
            start  = read_data_str.substr(0,i);  
            ending = read_data_str.substr(i+4,length-1);  

           // $display("i=%d start = %s end = %s",i,start,ending)  ;
                    
            case (start) 

                "fourcc"     : image_fourcc     = ending;   
                "width"      : image_width      = ending.atoi();   
                "height"     : image_height     = ending.atoi();   
                "stride"     : image_stride     = ending.atoi();   
                "interlaced" :
                begin

                    if (ending == "yes")
                        image_interlaced = 4'b1100;
                    else
                        image_interlaced = 4'b0000;

                end

            endcase   
            
        end  

      //  $display("image_fourcc = %d",image_fourcc);
      //  $display("height = %d",image_height);
      //  $display("width = %d",image_width);

    endfunction;
    
    
    // Send all fields of a file :
    task read_file();
        
        while (!$feof(fhandle))
        begin    

            if ( send_user_packets == on )
                send_user_packet(); 
                
            if ( (video_packets_handled == 0) || (send_control_packets == on) )
                send_control_packet(); 
 
            if (send_user_packets == on) 
                send_user_packet(); 
               
            read_video_packet(); 
             
        end
                
    endtask;
    
     
        //Sends an Avalon-ST protocol control packet for the dimensions of the frame in the current input file
    // (as specified by the `set_image_dimensions' function
    local task send_control_packet();
    
        c_av_st_video_control     #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) control_data;
        c_av_st_video_item                                                 item_data;
        
    control_data = new();
           
        // Two control packets, first with junk data, second a good one :
        control_data.set_width(image_width);
        control_data.set_height(image_height);
        control_data.set_interlacing(image_interlaced);
        
        control_data.set_append_garbage(send_garbage_after_control_packets);
      
        item_data = new();       
        item_data =  video_t'(control_data)   ;   //'                                                                                                          
        m_video_item_out.put(item_data);                                                                                                                                          
        $display ("%t %s pushed    control packet #%0d (%s) to outgoing mailbox.",$time, object_name, ++control_packets_handled, control_data.info());
                  
    endtask
     
     
    local task send_user_packet();

        c_av_st_video_user_packet #(CHANNELS_PER_PIXEL*BITS_PER_CHANNEL) user_data;
        c_av_st_video_item                                               item_data;

        user_data = new();

        user_data.set_max_length(33);
       //todo user_data.randomize() ;

        item_data = new();       
        item_data = user_t'(user_data);      //'                                                                                                      
        m_video_item_out.put(item_data);                                                                                                                           
        $display ("%t %s pushed       user packet #%0d of length %0d to outgoing mailbox.",$time, object_name, ++user_packets_handled, user_data.get_length() );

    endtask
   
   
    local task decode_fourcc();
           
        case (image_fourcc)
        
        "RGB32","IYU2"  :
        begin
            fourcc_channels_per_pixel = 3;
            fourcc_pixels_per_word    = 1;
            fourcc_bits_per_channel   = 8;
            fourcc_channel_lsb        = 0;
        end
                          
        "YUY2"  :
        begin
            fourcc_channels_per_pixel = 2;
            fourcc_pixels_per_word  = 2;
            fourcc_bits_per_channel = 8;
            fourcc_channel_lsb  = 0;
        end
                          
        "Y410", "A2R10G10B10" :
        begin
            fourcc_channels_per_pixel = 3;
            fourcc_pixels_per_word  = 1;
            fourcc_bits_per_channel = 10;
            fourcc_channel_lsb  = 0;
        end
                           
        "Y210"  :
        begin
            fourcc_channels_per_pixel = 2;
            fourcc_pixels_per_word  = 1;
            fourcc_bits_per_channel = 10;
            fourcc_channel_lsb  = 6;
        end         

        default :
        begin
            $fatal (1,".spc file FOURCC code is unsupported.  Supported codes are RGB32, IYU2, YUY2,Y410,Y210,A2R10G10B10.",fourcc_channels_per_pixel);
        end                        
       
        endcase

        if (CHANNELS_PER_PIXEL != fourcc_channels_per_pixel)
            $fatal (1,"`CHANNELS_PER_PIXEL must be set to %0d for the video file specified",fourcc_channels_per_pixel);
         
        if (BITS_PER_CHANNEL != fourcc_bits_per_channel)
            $fatal (1,"`BITS_PER_CHANNEL must be set to %0d for the video file specified",fourcc_bits_per_channel);                                
        
    endtask : decode_fourcc 


    local task generate_spc_file();
    int fhandle;
    
        fhandle = $fopen(spc_filename,"wb");
        
        $fwrite(fhandle, "fourcc = %s\n", image_fourcc);  
        $fwrite(fhandle, "width = %d\n", image_width);  
        $fwrite(fhandle, "height = %d\n", image_height); 
         
        $fclose(fhandle);
    
    endtask : generate_spc_file



    // Y410 contains the Luma component in the middle 10bits - whereas Av-ST Video expects
    // Luma to be in the MS 10bits, so here the channel number of the pixel object is used 
    // to implement the switch :
    local function int channel_mapping (int channel_number,string fourcc_code);

        if (image_fourcc == "Y410")
        begin

            case (channel_number)

            0 : return 0;
            1 : return 2;
            2 : return 1;

            endcase

        end
        else
            return channel_number;    
    
    endfunction


    local task read_video_packet();

        int status;
        int bits_read;        
        int channel;
        int channels_in_word = (32 / BITS_PER_CHANNEL);
        bit unsigned [1:0] channel_in_word ;
        int channel_mask;
        int pixels_read = 0;
        string note = "";
        int nw = 0; // Warning prevention
        
        reg [31:0] read_data_str;
        reg [31:0] extracted_channel_data;
        
        bit [BITS_PER_CHANNEL-1:0] channel_data; 

        c_av_st_video_data   #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL)    video_data;
        c_av_st_video_item                                               item_data;
        c_pixel              #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL)    pixel_data;
        c_pixel              #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) discard_pixel;
        
        int pixel_in_word;
        int shift;
        
        typedef c_av_st_video_data #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL) video_t;

        video_data = new(); 
        video_data.set_line_length(image_width);
            
        bits_read = 0;
        
        // Task to decode the fourcc code :
        decode_fourcc;

        channel_mask = {BITS_PER_CHANNEL{1'b1}};
                          
        // Every fourcc code produces at least one "pixel" per word, where "pixel" is defined as either
        // an RGB triplet, or the "Y" component from a YCbCr triplet with at least one chroma component.
        //    So for every 32 bit word read from the file, I can generate either one or two pixels :        
        do                                                                                                                                                                   
        begin                                                                                                                                                                

            if (!$feof(fhandle))                                                                                                                              
                status = $fread(read_data_str, fhandle); 
            else                                                                                                                                                      
            begin
                $display("%t %s object ignored a partial field of size %0d pixels.",$time, object_name, pixels_read);                                                          
                return;
            end                       

            // Now convert raw binary data into Pixel objects by shifting the current section of the word
            // down to the LSBs to become one channel of pixel data :
            pixel_in_word = 0;
            do
            begin
            
                pixel_data = new(); // Create a pixel object                                                                                                                      

                channel_in_word = 0;
                //$display("\n");
                do
                begin

                    shift =  (fourcc_bits_per_channel+fourcc_channel_lsb) * (channel_in_word + pixel_in_word*fourcc_channels_per_pixel ) + fourcc_channel_lsb ;
                    extracted_channel_data  = ( read_data_str >> shift ) & channel_mask;  
                    channel_data  = extracted_channel_data[BITS_PER_CHANNEL-1:0];                                                                                                            

                    pixel_data.set_data(channel_mapping(channel_in_word,image_fourcc), channel_data); 

                   // $display("set channel %0d data to %0d in channel_in_word %d",channel_mapping(channel_in_word,image_fourcc),channel_data,channel_in_word);
                    channel_in_word++;
                    
                end 
                while (channel_in_word < fourcc_channels_per_pixel);  
              //  $display("Next word!");
                              
                // Pack the pixel into a video data object :                                                                                                                     
                video_data.push_pixel(pixel_data);                                                                                                                               
                pixel_in_word++;
                pixels_read++;
            end 
            while (pixel_in_word < fourcc_pixels_per_word);                
          //  $display("exiting loop as pixel_in_word(%d) < fourcc_pixels_in_word (%d)",pixel_in_word,fourcc_pixels_per_word);

            channel_in_word = CHANNELS_PER_PIXEL - 1;
            
        end                                                                                                                                                                  
        while (pixels_read < (image_width*image_height) );                                                                                                  
     //   $display("exiting MAIN loop as pixels_read(%d) < image_width*image_height (%d)",pixels_read,image_width*image_height);

        item_data = video_t'(video_data);      //'                                                                                                                              
        m_video_item_out.put(item_data);                                                                                                                                                 
        video_packets_handled = video_packets_handled + 1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

        $display("%t   FILE I/O : %s pushed video data packet #%0d of size %0d pixels %s to outgoing mailbox",$time, object_name, video_packets_handled, video_data.get_length(), note);                                                          

        if (image_interlaced[3])                                                                                                                                                  
            image_interlaced[2] = !image_interlaced[2];                                                                                                                       

    endtask
   
    
    task wait_for_and_write_video_packet_to_file();
    
        bit unsigned [1:0] channel_in_word ;
        int length = 0;
        int pixel_in_word;
        int shift;
        int words_written;
        
        c_av_st_video_data #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL)  video_data;
        c_pixel            #(BITS_PER_CHANNEL, CHANNELS_PER_PIXEL)  pixel_data;
        c_av_st_video_item                                           item_data;
                
        // Decode the fourcc code so we know what format to write in :
        decode_fourcc;
        
        // Create the correct .spc file so that the raw2avi convertor will work correctly :
        generate_spc_file;
        
        // Wait for a video item to appear in mailbox :
        m_video_item_out.get(item_data);  //NB vfb test uses this syntax

        // Check it is a video packet :
        if (item_data.packet_type == video_packet)
        begin
        
            video_data = video_t'(item_data);   //'
            length = video_data.get_length() ;
            $display("%t   FILE I/O : %s object received a video packet of length %0d pixels from its mailbox.",$time, object_name, video_data.get_length());                                                                  
            words_written = 0;
            do
            begin  
                
                reg [31:0] write_data_str = 0;                
                reg [31:0] write_data_str_endianism = 0;                

                // Generate one word for the video file, which will be comprised of either one or two pixels depending upon format :
                pixel_in_word = 0;
                channel_in_word = 0;
                do
                begin

                    pixel_data = video_data.pop_pixel();
                    do
                    begin
                        shift = (fourcc_bits_per_channel+fourcc_channel_lsb) * (channel_in_word + pixel_in_word*fourcc_channels_per_pixel) + fourcc_channel_lsb;
                        write_data_str = write_data_str | ( pixel_data.get_data(channel_mapping(channel_in_word,image_fourcc)) << shift );                    
                    end 
                    while (++channel_in_word < fourcc_channels_per_pixel);  
                    pixel_in_word++;
                    channel_in_word = 0;

                end 
                while (pixel_in_word < fourcc_pixels_per_word);             

                // Correct Endianism :
                write_data_str_endianism = write_data_str_endianism | ( (write_data_str & 32'hff000000) >> 24);
                write_data_str_endianism = write_data_str_endianism | ( (write_data_str & 32'h00ff0000) >>  8);
                write_data_str_endianism = write_data_str_endianism | ( (write_data_str & 32'h0000ff00) <<  8);
                write_data_str_endianism = write_data_str_endianism | ( (write_data_str & 32'h000000ff) << 24);                      
                
                // Write current word to file :
                $fwrite(fhandle, "%u", write_data_str_endianism);  
                words_written++;
                channel_in_word = fourcc_channels_per_pixel-1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                  
            end  
            while (video_data.get_length() > 0);             
        
            video_packets_handled = video_packets_handled + 1;
            $display("%t   FILE I/O : %s wrote video packet #%0d of length %0d pixels - written %0d bytes to file.",$time, object_name, video_packets_handled, length,words_written*4);                                                                  
        end  
        
        else if (item_data.packet_type == control_packet)
        begin   
            $display("%t   FILE I/O : %s ignored control packet from incoming mailbox.",$time, object_name);                                                                  
        end  

        else 
        begin   
            $display("%t   FILE I/O : %s ignored user or illegal packet from incoming mailbox.",$time, object_name);                                                                  
        end  
                
    endtask            
      
endclass

endpackage : av_st_video_file_io_class
`endif
