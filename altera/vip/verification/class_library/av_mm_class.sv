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


// The base mm transaction class, it contains storage for cmd(read/write) and adress plus dynamic arrays for arguments and byte enables
// There is a class which extends this for packing and unpacking to create a "message word"

`ifndef _AV_MM_FORMAT_CLASS_
`define _AV_MM_FORMAT_CLASS_

class av_mm_transaction #(int ADDR_WIDTH = 32, int BYTE_WIDTH = 4, bit USE_BYTE_ENABLE = 1'b0);
   const     int                                       c_max_args;

   typedef   enum { READ, WRITE } Cmd;
   
   rand      Cmd                                                    cmd;
   rand      bit                     [ADDR_WIDTH-1 : 0]            addr;
   rand      bit                     [BYTE_WIDTH*8-1 : 0] arguments [$];
   rand      byte                    byte_enable [$];
   local     bit                     print_option_one_arg_per_line = 0;


   constraint rand_constr_num_args 
   {
       this.arguments.size() inside {[1:c_max_args]};
   }
   constraint byte_enable_num_args 
   {
       USE_BYTE_ENABLE || (this.byte_enable.size() == 0);
   }

   // the max_args value passed in during new is only used for randomisation purpose, it does not affect the maximum size of the MM request
   extern function new(int max_args);

   // deep copy routine for the whole message
   extern virtual function void copy(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH , USE_BYTE_ENABLE) val_to_cpy);

   // function to return the command (read/write)
   extern function Cmd get_cmd();

   // function to set the command (read/write)
   extern function void set_cmd(Cmd cmd);

   // function to return the read/write address
   extern function longint get_address();

   // function to set the read/write address
   extern function void set_address(longint addr);
   
   // function to return the number of agruments in this message
   extern function int num_args();
   
   // function to set the number of agruments in this message
   extern function void set_num_args(int length);
   
   // function to return the number of agruments in this message
   extern function int byte_enable_length();
   
   // function to set the number of agruments in this message
   extern function void set_byte_enable_length(int length);
   
   // control the ps_printf.   this can change it from printing on a single line to multiple lines per message
   //    this is probaly most usefull when using it in monitors!
   extern function void print_config_one_arg_per_line(bit one_arg_per_line);
   
   // Returns a string detailing the entire message (inc arguments) fields first.
   //  1/  It will print on either a single line or multipel lines (one for the fields and one per argument)
   //                 NOTE: function void print_config_one_arg_per_line(bit one_arg_per_line); is used to control this option!
   //  2/  Each line can be prefixed with the input string <indent_each_line_with> to make comprehension easier
   extern function string ps_printf(string indent_each_line_with);

   // function to check the number of arguments and value of each argument in a message match
   extern function bit args_match(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);

   // function to check the number of arguments and value of each argument in a message match
   extern function bit byte_enable_match(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);

   // function to comapre 2 messages. it compares arguments and fields
   extern function bit equals(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);   
 
endclass: av_mm_transaction


// ******************************************************************************************************
// *****************************           Not let's implement these calls!              ****************
// *****************************                                                         ****************
// ******************************************************************************************************

   // NEW: the max_args value passed in during new is only used for randomisation.
   function av_mm_transaction::new(int max_args);
     c_max_args = max_args;
   endfunction : new

   // deep copy routine for the whole message
   function void av_mm_transaction::copy(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) val_to_cpy);
      // legality check
      if (val_to_cpy == null) begin
         $display("can't copy a object if it has a null handle (i.e. does not exist)");
         $stop();
      end
      // copy arguments
      cmd = val_to_cpy.cmd;
      addr = val_to_cpy.addr;
      arguments = val_to_cpy.arguments[0:$];
      byte_enable = val_to_cpy.byte_enable[0:$];
   endfunction: copy


   // function to return the command (read/write)
   function av_mm_transaction::Cmd av_mm_transaction::get_cmd();
      return cmd;
   endfunction : get_cmd

   // function to set the command (read/write)
   function void av_mm_transaction::set_cmd(av_mm_transaction::Cmd cmd);
       this.cmd = cmd;
   endfunction : set_cmd

   // function to return the read/write address
   function longint av_mm_transaction::get_address();
      return addr;
   endfunction : get_address

   // function to set the read/write address
   function void av_mm_transaction::set_address(longint addr);
       this.addr = addr;
   endfunction : set_address
   
   // function to return the number of agruments in thsi message
   function int av_mm_transaction::num_args();
      return arguments.size();
   endfunction : num_args

   // function to set the number of agruments in this message
   function void av_mm_transaction::set_num_args(int length);
      if (arguments.size() > length) begin
         arguments = arguments[0:length];
      end else begin
         while (arguments.size() < length) begin
             arguments.push_back(0);
         end
      end
   endfunction : set_num_args
   
   // function to return the number of byte_enable values in this message (note that this is a cyclical pattern that may be repeated to mask the arguments and its size could be anything)
   function int av_mm_transaction::byte_enable_length();
      return byte_enable.size();
   endfunction : byte_enable_length

   // function to set the number of byte_enable values in this message (note that this is a cyclical pattern that may be repeated to mask the arguments and its size could be anything)
   function void av_mm_transaction::set_byte_enable_length(int length);
      if (USE_BYTE_ENABLE) begin
         if (length == 0) begin
            byte_enable = {};
         end else begin
            if (byte_enable.size() == 0) byte_enable = {8'hFF}; // seeding if necessary
            while (byte_enable.size() < length) begin
               byte_enable = {byte_enable, byte_enable};
            end
            if (byte_enable.size() > length) begin
               byte_enable = byte_enable[0:length];
            end
         end
      end
   endfunction : set_byte_enable_length
   
    
   // control the ps_printf.   this can change it from printing on a single line to multiple lines per message
   //    this is probaly most usefull when using it in monitors!
   function void av_mm_transaction::print_config_one_arg_per_line(bit one_arg_per_line);
      print_option_one_arg_per_line = one_arg_per_line;
   endfunction : print_config_one_arg_per_line


   // Returns a string detailing the entire message (inc arguments) fields first.
   //  1/  It will print on either a single line or multiple lines (one per argument)
   //                 NOTE: function void print_config_one_arg_per_line(bit one_arg_per_line); is used to control this option!
   //  2/  Each line can be prefixed with the input string <indent_each_line_with> to make comprehension easier
   function string av_mm_transaction::ps_printf(string indent_each_line_with);
      string retval;
      string byteen;
      bit byteen_active = 0;
      if (print_option_one_arg_per_line) begin
         $sformat(retval, "Command type = %s, addr=0x%x\n", get_cmd(), get_address());
         foreach(arguments[i]) begin
            $sformat(byteen, "");
            $sformat(retval, "%s\n%s Argument[%2d] = 0x%0x", retval, indent_each_line_with, i, arguments[i]);
            if (USE_BYTE_ENABLE) begin
               for (int b = i*BYTE_WIDTH; b < (i+1)*BYTE_WIDTH; b++) begin
                   byte be_val = (byte_enable.size() != 0) ? byte_enable[b%byte_enable.size()] : 8'hFF;
                   $sformat(byteen, "%s%0x", byteen, be_val);
                   byteen_active = byteen_active | (be_val != 8'hFF);
               end
               if (((i+1)*BYTE_WIDTH) >= byte_enable.size()) $sformat(byteen, "%s (extrapolated)", byteen);
               if (byteen_active) begin
                   $sformat(retval, "%s, byte_enable = 0x%s", retval, byteen);
               end
            end
         end
      end else begin
         $sformat(retval, "%s", indent_each_line_with);
         $sformat(retval, "%s, command type = %s, addr=0x%x", retval, get_cmd(), get_address());
         foreach(arguments[i]) begin
            $sformat(byteen, "");
            $sformat(retval, "%s; Argument[%2d] = 0x%0x", retval, i, arguments[i]);
            if (USE_BYTE_ENABLE) begin
               for (int b = i*BYTE_WIDTH; b < (i+1)*BYTE_WIDTH; b++) begin
                   byte be_val = (byte_enable.size() != 0) ? byte_enable[b%byte_enable.size()] : 8'hFF;
                   $sformat(byteen, "%s%0x", byteen, be_val);
                   byteen_active = byteen_active | (be_val != 8'hFF);
               end
               if (((i+1)*BYTE_WIDTH) >= byte_enable.size()) $sformat(byteen, "%s (extrapolated)", byteen);
               if (byteen_active) begin
                   $sformat(retval, "%s, byte_enable = 0x%s", retval, byteen);
               end
            end
         end
      end
      return(retval);
   endfunction: ps_printf

   // function to check the number of arguments and value of each argument in a message match
   function bit av_mm_transaction::args_match(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);
      bit retval = 1'b1;
      if (arguments.size() != cmp.arguments.size()) begin
         retval = 1'b0;
         $display("compare failed as there are different numbers of arguments");           
      end
      foreach(arguments[i]) begin
         if (arguments[i] !== cmp.arguments[i]) begin
            retval = 1'b0;
            $display("comparing message arguments failed with arg %d, ref = 0x%0x, tst = 0x%0x", i, this.arguments[i],cmp.arguments[i]);
         end
      end
      return(retval);
   endfunction: args_match

   // function to check the number of arguments and value of each argument in a message match
   function bit av_mm_transaction::byte_enable_match(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);
      bit retval = 1'b1;
      // Ideally, compare the byte_enables array directly if they are the same length. Otherwise compare over the length of arguments
      if (byte_enable.size() == cmp.byte_enable.size()) begin
         foreach(byte_enable[i]) begin
            if (byte_enable[i] !== cmp.byte_enable[i]) begin
               retval = 1'b0;
               $display("comparing message arguments failed with byte_enable %d, ref = 0x%0x, tst = 0x%0x", i, this.byte_enable[i], cmp.byte_enable[i]);
            end
         end
      end else begin
         for (int b = 0; b < arguments.size()*BYTE_WIDTH; ++b) begin
            byte val = (byte_enable.size() != 0) ? byte_enable[b%byte_enable.size()] : 8'hFF;
            byte cmp_val = (cmp.byte_enable.size() != 0) ? cmp.byte_enable[b%cmp.byte_enable.size()] : 8'hFF;
            if (val !== cmp_val) begin
                retval = 1'b0;        
                $display("comparing message arguments failed with byte_enable %d, ref = 0x%0x%s, tst = 0x%0x%s", b, val, (b < byte_enable.size()) ? "" : " (extrapolated)",
                                                                                                             cmp_val, (b < cmp.byte_enable.size()) ? "" : " (extrapolated)");
            end
         end
      end
      return(retval);
   endfunction: byte_enable_match


   // function to comapre 2 messages. it compares arguments and fields
   function bit av_mm_transaction::equals(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) cmp);
       if (cmd != cmp.cmd) begin
            $display("compare failed as the commands are not the same ref = %d, tst = %d", cmd, cmp.cmd);
       end
       if (addr != cmp.addr) begin
            $display("compare failed as the addresses are not the same ref = 0x%0x, tst = 0x%0x", addr, cmp.addr);
       end
       return (cmd == cmp.cmd) & (addr == cmp.addr) & args_match(cmp) & byte_enable_match(cmp);
   endfunction: equals


`endif
