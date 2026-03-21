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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on




localparam SKIP_LINK = 0 ;

// ==========================
// Hardware Design Based Constants
// Maximum number of Descriptors Supported by Hardware
localparam MAX_HARDWARE_DESC = 128 ;
// Length of the descriptors in memory
localparam DESC_BYTE_LEN = 32;
// Alignment requirement on descriptor table
localparam DESC_TABLE_ALIGNMENT = 32;
// Alignment requirement on rc data addresses (DWORD aligned)
localparam RC_DATA_ADDR_ALIGNMENT = 4 ;
// Alignment requirement on ep data addresses (DWORD aligned)
localparam EP_DATA_ADDR_ALIGNMENT = 4 ;
// Addresses of DMA Controller Registers relative to specified BAR
localparam bit [63:0] DMARD_CNTLR_BASE_ADDR = 64'h0000_0000_0000_0000 ;
localparam bit [63:0] DMAWR_CNTLR_BASE_ADDR = 64'h0000_0000_0000_0100 ;
localparam integer DMA_CNTLR_BAR = 0 ;
// Internal AvMM Addresses DMA Controller uses for writing fetched descriptors to
localparam bit [63:0] RD_DEST_DESCRIPTOR_ADDR = 64'h0000_0000_0100_0000;
localparam bit [63:0] WR_DEST_DESCRIPTOR_ADDR = 64'h0000_0000_0100_2000;
// Internal AvMM Address for Data Buffer, and it's length
localparam bit [63:0] EP_DATA_BUFFER_ADDR = 64'h0000_0000_0000_0000 ;
localparam bit [19:0] EP_DATA_BUFFER_DW_LEN = 20'h0_2000 ;
// Offset from start of Status Address to start of descriptors
localparam integer DESC_INST_OFFSET = 64'h200 ;

// ===============================================
// Test Constraints
// Max and Min Total Data Transfer
localparam MAX_RAND_DESC = 16 ;
localparam MIN_RAND_DESC = 1 ;
localparam MAX_DATA_MOVEMENTS = 8 ; // Set Higher Once Debugged
localparam MIN_DATA_MOVEMENTS = 1 ;
localparam MIN_EP_BUFFER_AVAIL_FOR_NEW_DATA_MOVEMENT_DW = EP_DATA_BUFFER_DW_LEN/4 ;


const int MAX_DESC_DW_LENGTH = EP_DATA_BUFFER_DW_LEN ;
const int MIN_DESC_DW_LENGTH = 1 ;
const int SINGLE_MOVE_RAND_ORDER = 1 ;

// How Much "Padding" before and after the destination buffer
const int DEST_BUFFER_PREFIX_PAD = 64 ;
const int DEST_BUFFER_POSTFIX_PAD = 64 ;

// What we store as no status, and expect to change by the DMA completion
const int DMA_NO_STATUS = 0 ;

// Some timeout values
const int RD_DMA_TIMEOUT_NS = (SKIP_LINK == 1) ? 10000 : 60000 ;
const int WR_DMA_TIMEOUT_NS = (SKIP_LINK == 1) ? 10000 : 60000 ;


// Structure to describe individual descriptors
typedef struct {
   bit [63:0]  source_addr ;
   bit [63:0]  dest_addr ;
   bit [17:0]  length_dword ;
   shortint    num;
} single_desc_struct ;

class LogAll ;
   integer     memdump_file ;
   integer     genlog_file ;
   function new ;
      memdump_file = $fopen("avmmdma_rdwr_memdump.log","w") ;
      if (!memdump_file) void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"Could not open avmmdma_rdwr_memdump.log file"));

      genlog_file = $fopen("avmmdma_rdwr_general.log","w") ;
      if (!genlog_file) void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"Could not open avmmdma_rdwr_general.log file"));
   endfunction // new

   function void close ;
      $fclose(memdump_file) ;
      $fclose(genlog_file) ;
   endfunction //

   function void mem_dump(string header,
                          int    addr,
                          int    len,
                          string tag_label = "", // Don't show anything
                          int    init_tag = 0,
                          int    inc_mode = 0, // Don't display by default
                          bit    hex_tag = 1'b0) ;
      int      offset ;
      int      aladdr ;
      int      tag ;
      int      sub_inc ;
      string   dw0, dw1, dw2, dw3 ;
      begin
         $fdisplay(memdump_file,"%s",header) ;
         $fdisplay(memdump_file,"Dump Address: %08x, Length: %d bytes",addr,len) ;
         $fdisplay(memdump_file,"Time: %10d ns",($time/1000)) ;
         $fdisplay(memdump_file,"Address   DW0(+0)  DW1(+4)  DW2 (+8) DW3(+C)  %s",tag_label) ;
         //                      01234567: 01234567 01234567 01234567 01234567 :012345
         offset = 0 ;
         aladdr = addr - (addr %16) ;
         tag = init_tag ;
         sub_inc = 0 ;
         while (offset < len)
           begin
              if ( (offset == 0) && ((aladdr+3) < addr) )
                dw0 = "        " ;
              else
                dw0 = $sformatf("%08x",shmem_read(addr+offset+0,4)) ;
              if ( (offset == 0) && ((aladdr+7) < addr) )
                dw1 = "        " ;
              else
                if ( (offset + 4) > len)
                  dw1 = "        " ;
                else
                  dw1 = $sformatf("%08x",shmem_read(addr+offset+4,4)) ;
              if ( (offset == 0) && ((aladdr+11) < addr) )
                dw2 = "        " ;
              else
                if ( (offset + 8) > len)
                  dw2 = "        " ;
                else
                  dw2 = $sformatf("%08x",shmem_read(addr+offset+8,4)) ;
              if ( (offset == 0) && ((aladdr+15) < addr) )
                dw3 = "        " ;
              else
                if ( (offset + 12) > len)
                  dw3 = "        " ;
                else
                  dw3 = $sformatf("%08x",shmem_read(addr+offset+12,4)) ;
              if (inc_mode == 0)
                begin
                   // No Tag
                   $fdisplay(memdump_file,"%8x: %8s %8s %8s %8s",(aladdr+offset),dw0,dw1,dw2,dw3) ;
                end
              else
                if (hex_tag == 1'b1)
                  begin
                     $fdisplay(memdump_file,"%8x: %8s %8s %8s %8s : %x",(aladdr+offset),dw0,dw1,dw2,dw3,tag) ;
                  end
                else
                  begin
                     $fdisplay(memdump_file,"%8x: %8s %8s %8s %8s : %d",(aladdr+offset),dw0,dw1,dw2,dw3,tag) ;
                  end
              if (inc_mode > 0)
                begin
                   tag = tag + inc_mode ;
                end
              else
                begin
                   if (sub_inc == (inc_mode+1))
                     begin
                        tag = tag + 1 ;
                        sub_inc = 0 ;
                     end
                   else
                     begin
                        sub_inc = sub_inc - 1;
                     end
                end
              offset = offset + 16 ;
           end
         $fdisplay(memdump_file,"");
      end
   endfunction : mem_dump

   function void detail_dump(integer msg_type, logic [EBFM_MSG_MAX_LEN*8:1] msg) ;
      logic [9*8:1] prefix ;
      string        smsg ="" ;
      case (msg_type)
        EBFM_MSG_ERROR_FATAL_TB_ERR : prefix = "FATAL:   ";
        EBFM_MSG_ERROR_FATAL        : prefix = "FATAL:   ";
        EBFM_MSG_ERROR_CONTINUE     : prefix = "ERROR:   ";
        EBFM_MSG_ERROR_INFO         : prefix = "ERROR:   ";
        EBFM_MSG_WARNING            : prefix = "WARNING: ";
        EBFM_MSG_INFO               : prefix = "INFO:    ";
        EBFM_MSG_DEBUG              : prefix = "DEBUG:   ";
        default                     : prefix = "UNKNOWN: ";
      endcase // case (msg_type)
      smsg = string'(msg) ;
      $fdisplay(genlog_file,"%9s %10d ns %s",prefix,($time/1000),smsg) ;
   endfunction
   function void display(integer msg_type, logic [EBFM_MSG_MAX_LEN*8:1] msg) ;
      detail_dump(msg_type,msg) ;
      if (msg_type >= EBFM_MSG_ERROR_FATAL)
        this.close();
      void'(ebfm_display(msg_type,msg));
   endfunction
endclass

// Ways to allocate buffer space
// First_Avail - Start from beginning and pick the first available
// Sequential - Keep allocating in sequential order, as long as a fit can be found
// Random - Pick a random allocation
typedef enum {FIRST_AVAIL, SEQUENTIAL, RANDOM} buffer_allocation_mode ;

class BufferSpaceTracker ;
   // Array that tracks allocated memory blocks, index is the allocated start address
   int allocated_len[int] ;
   int base_offset ;
   int max_index_p1 ;
   int last_allocated = 0 ;
   LogAll alog ;

   function new(LogAll plog, int start_addr, int end_addr_p1) ;
      begin
         base_offset = start_addr ;
         max_index_p1 = end_addr_p1 - start_addr ;
         alog = plog ;
      end
   endfunction // new

   function int largest_avail(int alignment = 4);
      int search_idx ;
      int cur_avail_idx ;
      int cur_avail_size ;
      int largest ;
      begin
         largest = 0 ;
         cur_avail_idx = 0 ;
         if (allocated_len.first(search_idx) == 1)
           begin
              do begin
                 if ( (cur_avail_idx % alignment) != 0)
                   begin
                      cur_avail_idx = cur_avail_idx + alignment - (cur_avail_idx % alignment) ;
                   end
                 cur_avail_size = search_idx - cur_avail_idx ;
                 if (cur_avail_size > largest)
                   begin
                      largest = cur_avail_size ;
                   end
                 cur_avail_idx = allocated_len[search_idx] + search_idx ;
              end while (allocated_len.next(search_idx) == 1) ;
           end // if (allocated_len.first(search_idx) == 1)
         cur_avail_size = max_index_p1 - cur_avail_idx ;
         if (cur_avail_size > largest)
           begin
              largest = cur_avail_size ;
           end
         largest_avail = largest ;
      end
   endfunction

   function int allocate_block(int size,
                               int alignment = 4,
                               buffer_allocation_mode alloc = FIRST_AVAIL) ;
      int search_idx ;
      int cur_avail_idx ;
      int alloc_idx ;
      int cur_avail_size ;
      begin
         cur_avail_idx = 0;
         if (allocated_len.first(search_idx) == 1)
           begin
              do begin
                 if ( (cur_avail_idx % alignment) != 0)
                   begin
                      cur_avail_idx = cur_avail_idx + alignment - (cur_avail_idx % alignment) ;
                   end
                 cur_avail_size = search_idx - cur_avail_idx ;
                 if (cur_avail_size >= size)
                   begin
                      if (alloc == RANDOM)
                        begin
                           if (!std::randomize(alloc_idx) with {alloc_idx >= cur_avail_idx;
                                                               alloc_idx <= search_idx - size;
                                                               (alloc_idx % alignment) == 0;} )
                             begin
                                alog.display(EBFM_MSG_ERROR_FATAL,
                                             {"Unable to pick random allocation index. Size: ",dimage6(size),
                                              " Avail: ",dimage6(cur_avail_size),
                                              " Current Index: ",dimage6(cur_avail_idx),
                                              " Search Index: ",dimage6(search_idx),
                                              " Alignment:",dimage6(alignment),
                                              " Allocate Index: ",dimage6(alloc_idx)}) ;
                             end
                        end
                      else
                        begin
                           alloc_idx = cur_avail_idx ;
                        end
                      allocated_len[alloc_idx] = size;
                      return(alloc_idx) ;
                   end
                 cur_avail_idx = allocated_len[search_idx] + search_idx ;
              end while (allocated_len.next(search_idx) == 1) ;
           end // if (allocated_len.first(search_idx) == 1)
         cur_avail_size = max_index_p1 - cur_avail_idx ;
         if (cur_avail_size >= size)
           begin
              if (alloc == RANDOM)
                begin
                   if (!std::randomize(alloc_idx) with {alloc_idx >= cur_avail_idx;
                                                       alloc_idx <= max_index_p1 - size;
                                                       (alloc_idx % alignment) == 0;} )
                     begin
                        alog.display(EBFM_MSG_ERROR_FATAL,
                                     {"Unable to pick random allocation index. Size: ",dimage6(size),
                                      " Avail: ",dimage6(cur_avail_size),
                                      " Current Index: ",dimage6(cur_avail_idx),
                                      " Max Index+1: ",dimage6(max_index_p1),
                                      " Alignment:",dimage6(alignment),
                                      " Allocate Index: ",dimage6(alloc_idx)}) ;
                     end
                end
              else
                begin
                   alloc_idx = cur_avail_idx ;
                end
              allocated_len[alloc_idx] = size;
              return(alloc_idx) ;
           end
         else
           begin
              return(-1) ;
           end
      end
   endfunction

   function int free_block(int index, int size) ;
      if (allocated_len[index] == size)
        begin
           allocated_len.delete(index) ;
           free_block = 1 ;
        end
      else
        begin
           free_block = 0 ;
        end
   endfunction // free_block

   function void dump([EBFM_MSG_MAX_LEN*8:1] hdr) ;
      int search_idx ;
      int cur_avail_idx ;
      begin
         alog.detail_dump(EBFM_MSG_INFO,"") ;
         alog.detail_dump(EBFM_MSG_INFO,hdr) ;
         alog.detail_dump(EBFM_MSG_INFO,"Address     Size       Status") ;
         //                              0x01234567  0x89abcdef Allocated
         cur_avail_idx = 0 ;
         if (allocated_len.first(search_idx) == 1)
           begin
              do begin
                 if (search_idx > cur_avail_idx)
                   begin
                      alog.detail_dump
                        (EBFM_MSG_INFO,{"0x",himage8(cur_avail_idx+base_offset),
                                        "  0x", himage8(search_idx - cur_avail_idx),
                                        " Free Space"}) ;
                      alog.detail_dump
                        (EBFM_MSG_INFO,{"0x",himage8(search_idx+base_offset),
                                        "  0x", himage8(allocated_len[search_idx]),
                                        " Allocated"}) ;
                   end // if (search_idx > cur_avail_idx)
                 else
                   begin
                      alog.detail_dump
                        (EBFM_MSG_INFO,{"0x",himage8(search_idx+base_offset),
                                        "  0x", himage8(allocated_len[search_idx]),
                                        " Allocated"}) ;
                   end // else: !if(search_idx > cur_avail_idx)

                 cur_avail_idx = allocated_len[search_idx] + search_idx ;
              end while (allocated_len.next(search_idx) == 1) ;
           end // if (allocated_len.first(search_idx) == 1)
         if ( max_index_p1 - cur_avail_idx > 0)
           begin
              alog.detail_dump
                (EBFM_MSG_INFO,{"0x",himage8(cur_avail_idx+base_offset),
                                "  0x", himage8(max_index_p1 - cur_avail_idx),
                                " Free Space"}) ;
           end
         alog.detail_dump(EBFM_MSG_INFO,"") ;
      end
   endfunction

endclass

class DescArray ;
   LogAll alog ;
   rand bit [17:0] len_dword_list [] ;
   single_desc_struct pending_desc_list [$] ;
   single_desc_struct posted_desc_list [$] ;
   single_desc_struct complete_desc_list [$] ;
   bit [63:0]  source_addr_list [] ;
   bit [63:0]  dest_addr_list [] ;
   bit [29:0]  move_length_dw ;
   bit [63:0]  start_source_addr ;
   bit [63:0]  start_dest_addr ;

   function new(LogAll alog,
                bit [29:0]  move_length_dw ,
                bit [63:0]  start_source_addr ,
                bit [63:0]  start_dest_addr
                ) ;
      this.alog = alog ;
      this.move_length_dw = move_length_dw ;
      this.start_source_addr = start_source_addr ;
      this.start_dest_addr = start_dest_addr ;
   endfunction // new

   function void free_resources ;
      pending_desc_list.delete();
      posted_desc_list.delete();
      complete_desc_list.delete();
   endfunction : free_resources

   constraint size_c {
      len_dword_list.size() <= MAX_RAND_DESC ;
      len_dword_list.size() >= MIN_RAND_DESC ;
   }
   constraint len_c {
      move_length_dw == len_dword_list.sum();
      foreach (len_dword_list[i]) len_dword_list[i] >= (MIN_DESC_DW_LENGTH) ;
      foreach (len_dword_list[i]) len_dword_list[i] <= (MAX_DESC_DW_LENGTH) ;
   }
   function void post_randomize ;
      single_desc_struct desc ;
      foreach (len_dword_list[i]) begin
         desc.length_dword = len_dword_list[i] ;
         desc.num = -1 ;
         if (i == 0)
           begin
              desc.source_addr = start_source_addr ;
              desc.dest_addr = start_dest_addr ;
           end
         else
           begin
              desc.source_addr = desc.source_addr +
                                 (len_dword_list[i-1] * 4) ;
              desc.dest_addr   = desc.dest_addr +
                                 (len_dword_list[i-1] * 4) ;
           end // else: !if(i == 0)
         pending_desc_list.push_back(desc) ;
      end // foreach desc_list[i]
      if (SINGLE_MOVE_RAND_ORDER > 0)
        begin
           pending_desc_list.shuffle ;
        end
   endfunction : post_randomize

   function bit find_completed_desc(shortint desc_num) ;

   endfunction : find_completed_desc


   function void display([EBFM_MSG_MAX_LEN*8:1] hdr) ;
      alog.detail_dump(EBFM_MSG_INFO,"") ;
      alog.detail_dump(EBFM_MSG_INFO,hdr) ;
      alog.detail_dump(EBFM_MSG_INFO, {"  Number of Descriptors: 0d", dimage4(len_dword_list.size()) });
      alog.detail_dump(EBFM_MSG_INFO, {"      Total Byte Length: 0d", dimage6(move_length_dw*4),
                                       " (0x", himage4(move_length_dw*4), ")"});


      alog.detail_dump(EBFM_MSG_INFO,"") ;
      alog.detail_dump(EBFM_MSG_INFO,{"Pending Descriptors (",dimage3(pending_desc_list.size()),")"}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                                   "                                          Length Length");
      alog.detail_dump(EBFM_MSG_INFO,
                                   "Source Address       Destination Address  (hexBy)(decBy)");
      //                            01234567 01234567    01234567 01234567    01234  012345
      foreach (pending_desc_list[i]) begin
         alog.detail_dump(EBFM_MSG_INFO,
                                      {himage8(pending_desc_list[i].source_addr[63:32]), "  ",
                                       himage8(pending_desc_list[i].source_addr[31:0]),  "   ",
                                       himage8(pending_desc_list[i].dest_addr[63:32]),   "  ",
                                       himage8(pending_desc_list[i].dest_addr[31:0]),    "   ",
                                       himage1(pending_desc_list[i].length_dword[17:14]),
                                       himage4({pending_desc_list[i].length_dword[13:0],2'b00}), "  ",
                                       dimage6({pending_desc_list[i].length_dword[17:0],2'b00})
                                       }
                                      ) ;
      end
      alog.detail_dump(EBFM_MSG_INFO,"") ;
      alog.detail_dump(EBFM_MSG_INFO,{"Descriptors Previously Posted to DMA (",
                       dimage3(posted_desc_list.size()),")"}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                                   "                                          Length Length  Desc");
      alog.detail_dump(EBFM_MSG_INFO,
                                   "Source Address       Destination Address  (hexBy)(decBy) Num");
      //                            01234567 01234567    01234567 01234567    01234  012345
      foreach (posted_desc_list[i]) begin
         alog.detail_dump(EBFM_MSG_INFO,
                                      {himage8(posted_desc_list[i].source_addr[63:32]), "  ",
                                       himage8(posted_desc_list[i].source_addr[31:0]),  "   ",
                                       himage8(posted_desc_list[i].dest_addr[63:32]),   "  ",
                                       himage8(posted_desc_list[i].dest_addr[31:0]),    "   ",
                                       himage1(posted_desc_list[i].length_dword[17:14]),
                                       himage4({posted_desc_list[i].length_dword[13:0],2'b00}), "  ",
                                       dimage6({posted_desc_list[i].length_dword[17:0],2'b00}), "  ",
                                       dimage3(posted_desc_list[i].num)
                                       }
                                      ) ;
      end
      alog.detail_dump(EBFM_MSG_INFO,{"Descriptors that have completed (",
                       dimage3(complete_desc_list.size()),")"}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                                   "                                          Length Length  Desc");
      alog.detail_dump(EBFM_MSG_INFO,
                                   "Source Address       Destination Address  (hexBy)(decBy) Num");
      //                            01234567 01234567    01234567 01234567    01234  012345
      foreach (complete_desc_list[i]) begin
         alog.detail_dump(EBFM_MSG_INFO,
                                      {himage8(complete_desc_list[i].source_addr[63:32]), "  ",
                                       himage8(complete_desc_list[i].source_addr[31:0]),  "   ",
                                       himage8(complete_desc_list[i].dest_addr[63:32]),   "  ",
                                       himage8(complete_desc_list[i].dest_addr[31:0]),    "   ",
                                       himage1(complete_desc_list[i].length_dword[17:14]),
                                       himage4({complete_desc_list[i].length_dword[13:0],2'b00}), "  ",
                                       dimage6({complete_desc_list[i].length_dword[17:0],2'b00}), "  ",
                                       dimage3(complete_desc_list[i].num)
                                       }
                                      ) ;
      end
      alog.detail_dump(EBFM_MSG_INFO,"");
   endfunction // display

   function int num_pending_desc ;
      return pending_desc_list.size() ;
   endfunction

   function int num_posted_desc ;
      return posted_desc_list.size() ;
   endfunction

   function bit desc_list_is_empty ;
      if (pending_desc_list.size() == 0)
        desc_list_is_empty = 1'b1 ;
      else
        desc_list_is_empty = 1'b0 ;
   endfunction // if

   function single_desc_struct pop_desc(shortint desc_num) ;
      single_desc_struct desc ;
      desc = pending_desc_list.pop_front() ;
      desc.num = desc_num ;
      posted_desc_list.push_back(desc) ;
      return desc ;
   endfunction

   task write_desc_to_shmem (input bit [63:0] desc_addr,
                             input int start_desc_num,
                             input int num_to_write );
      single_desc_struct desc ;
      if ( (start_desc_num >= MAX_HARDWARE_DESC) ||
           (num_to_write > MAX_HARDWARE_DESC) ||
           (num_to_write == 0) )
        begin
           alog.display(EBFM_MSG_ERROR_FATAL,{"Bad request to write descriptors. Start: ",dimage3(start_desc_num),
                                              ", Number: ",dimage3(num_to_write)});
        end
      for (int i = 0 ; i < num_to_write ; i++ )
        begin
           if (desc_list_is_empty())
             alog.display(EBFM_MSG_ERROR_FATAL,"Attempt to write more descriptors than available") ;
           desc = pop_desc((start_desc_num + i)) ;
           if ( (desc.length_dword == 0) || (desc.length_dword > EP_DATA_BUFFER_DW_LEN) )
             begin
                display("Bad descriptor when writing to descriptor table") ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Writing descriptors, found bad length: ",dimage6(desc.length_dword)}) ;
             end
           // TODO the alignment should be based on actual type of address
           if ( (desc.source_addr % EP_DATA_ADDR_ALIGNMENT) != 0)
             begin
                display("Bad descriptor when writing to descriptor table") ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Writing descriptors, found bad source addr alignment: 0x",himage8(desc.source_addr[31:0])}) ;
             end
           if ( (desc.dest_addr % EP_DATA_ADDR_ALIGNMENT) != 0)
             begin
                display("Bad descriptor when writing to descriptor table") ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Writing descriptors, found bad dest addr alignment: 0x",himage8(desc.dest_addr[31:0])}) ;
             end
           shmem_write(desc_addr+(i*DESC_BYTE_LEN)+0,  desc.source_addr[31:0] , 4) ;
           shmem_write(desc_addr+(i*DESC_BYTE_LEN)+4,  desc.source_addr[63:32],4) ;
           shmem_write(desc_addr+(i*DESC_BYTE_LEN)+8,  desc.dest_addr[31:0], 4) ;
           shmem_write(desc_addr+(i*DESC_BYTE_LEN)+12, desc.dest_addr[63:32],4) ;
           shmem_write(desc_addr+(i*DESC_BYTE_LEN)+16, {desc.num[13:0],desc.length_dword[17:0]},4) ;
        end
   endtask // write_desc_to_shmem

endclass

class EmulateDma ;
   LogAll alog ;

   const int dma_engine_wait_ns = 50 ; // Make the DMA appear to take some time

   // Enum for Read and Write
   typedef enum bit {ReadDMA, WriteDMA} dma_type_e ;

   // Variables to track the software visible registers
   bit [ReadDMA:WriteDMA][63:0] rc_status_table_addr ;
   bit [ReadDMA:WriteDMA][63:0] rc_desc_table_addr ;
   bit [ReadDMA:WriteDMA][31:0] last_desc ;

   // Internal State Tracking Variables
   int                          last_dnum[ReadDMA:WriteDMA] ;


   //Internal Bits for tracking validated descriptors and which ones we need to report status for
   bit [ReadDMA:WriteDMA][(MAX_HARDWARE_DESC-1):0] desc_valid ;
   bit [ReadDMA:WriteDMA][(MAX_HARDWARE_DESC-1):0] desc_sts_req ;

   // Bits tracking the running state of the DMA Engines
   bit                                             dma_enable [ReadDMA:WriteDMA];
   byte                                            next_desc [ReadDMA:WriteDMA]  ;

   // Emulated memory of the DMA engine
   logic [31:0] emu_ep_buffer_mem [(EP_DATA_BUFFER_ADDR/4):(EP_DATA_BUFFER_ADDR/4)+(EP_DATA_BUFFER_DW_LEN-1)] ;
   function reg [64:1] dma_type_to_oldstr(dma_type_e dma_type) ;
      begin
         if (dma_type == ReadDMA)
           dma_type_to_oldstr = "ReadDMA " ;
         else
           dma_type_to_oldstr = "WriteDMA" ;
      end
   endfunction : dma_type_to_oldstr ;

   task execute_desc(dma_type_e dma_type,byte desc_num) ;
      logic [63:0] buff_addr ;
      logic [63:0] shmem_addr ;
      int          num_dword ;
      int          desc_id ;
      if (dma_type == ReadDMA)
        begin
           shmem_addr[31:0]  = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+0,4);
           shmem_addr[63:32] = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+4,4);
           buff_addr[31:0]   = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+8,4);
           buff_addr[63:32]  = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+12,4);
        end
      else
        begin
           buff_addr[31:0]   = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+0,4);
           buff_addr[63:32]  = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+4,4);
           shmem_addr[31:0]  = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+8,4);
           shmem_addr[63:32] = shmem_read(rc_desc_table_addr[dma_type]+
                                          (desc_num*DESC_BYTE_LEN)+12,4);
        end
      num_dword         = shmem_read(rc_desc_table_addr[dma_type]+
                                     (desc_num*DESC_BYTE_LEN)+16,4) && 32'h0003FFFF;
      desc_id           = shmem_read(rc_desc_table_addr[dma_type]+
                                     (desc_num*DESC_BYTE_LEN)+16,4)>> 18;
      if ( desc_id != desc_num )
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Number:              ",
                         dimage3(desc_num)});
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Source (RC) Addr:  0x",
                         himage8(shmem_addr[63:32]),"_",
                         himage8(shmem_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Dest (EP) Addr:    0x",
                         himage8(buff_addr[63:32]),"_",
                         himage8(buff_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Num Dwords:          ",
                         dimage6(num_dword)}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor ID:                  ",
                         dimage6(desc_id)}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {dma_type_to_oldstr(dma_type)," Descriptor Desc ID not equal to Desc Num."}) ;
        end
      if ( (num_dword <= 0) || (num_dword > EP_DATA_BUFFER_DW_LEN) )
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Number:              ",
                         dimage3(desc_num)});
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Source (RC) Addr:  0x",
                         himage8(shmem_addr[63:32]),"_",
                         himage8(shmem_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Dest (EP) Addr:    0x",
                         himage8(buff_addr[63:32]),"_",
                         himage8(buff_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Num Dwords:          ",
                         dimage6(num_dword)}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor ID:                  ",
                         dimage6(desc_id)}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {dma_type_to_oldstr(dma_type)," Descriptor Num Dwords Error."}) ;
        end
      if ( (shmem_addr % RC_DATA_ADDR_ALIGNMENT) != 0 )
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Number:              ",
                         dimage3(desc_num)});
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Source (RC) Addr:  0x",
                         himage8(shmem_addr[63:32]),"_",
                         himage8(shmem_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Dest (EP) Addr:    0x",
                         himage8(buff_addr[63:32]),"_",
                         himage8(buff_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Num Dwords:          ",
                         dimage6(num_dword)}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor ID:                  ",
                         dimage6(desc_id)}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {dma_type_to_oldstr(dma_type)," Descriptor Source (RC) Address Alignment Error."}) ;
        end
      if ( (buff_addr % EP_DATA_ADDR_ALIGNMENT) != 0 )
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Number:              ",
                         dimage3(desc_num)});
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Source (RC) Addr:  0x",
                         himage8(shmem_addr[63:32]),"_",
                         himage8(shmem_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Dest (EP) Addr:    0x",
                         himage8(buff_addr[63:32]),"_",
                                   himage8(buff_addr[31:0])}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor Num Dwords:          ",
                         dimage6(num_dword)}) ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type)," Descriptor ID:                  ",
                         dimage6(desc_id)}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {dma_type_to_oldstr(dma_type)," Descriptor Dest (EP) Address Alignment Error."}) ;
        end
      // Now that we did all of that checking, move the data!!!
      buff_addr = buff_addr >> 2 ; // Make Dword Addr
      for (int i = 0;i < num_dword; i++)
        begin
           if (dma_type == ReadDMA)
             begin
                emu_ep_buffer_mem[buff_addr] = shmem_read(shmem_addr,4) ;
             end
           else
             begin
                shmem_write(shmem_addr,emu_ep_buffer_mem[buff_addr],4) ;
             end
           buff_addr = buff_addr + 1 ; // dword addr
           shmem_addr = shmem_addr + 4 ; // byte addr
        end // for (int i = 0;i < num_dword; i++)

   endtask : execute_desc ;

   function bit is_desc_valid(dma_type_e dma_type, byte desc_num) ;
      if ( (desc_num < 0) || (desc_num >= MAX_HARDWARE_DESC) )
        return 1'b0 ;
      else
        return desc_valid[dma_type][desc_num] ;
   endfunction : is_desc_valid

   task DmaEngine(dma_type_e dma_type) ;
      byte act_desc ;
      int  old_sts ;
      next_desc[dma_type] = 0 ;
      do begin
         if (desc_valid[dma_type][next_desc[dma_type]])
           begin
              // TODO need to make this programmable on out of order execution....
              if (1'b0)
                begin
                   if (!std::randomize(act_desc) with
                       // Have to use a function call here to get around an error message from Modelsim on
                       // direct access to the array
                       {act_desc >= 0; act_desc < MAX_HARDWARE_DESC ;is_desc_valid(dma_type,act_desc) == 1'b1;})
                     act_desc = next_desc[dma_type] ;
                end // if (1'b0)
              else
                begin
                   act_desc = next_desc[dma_type] ;
                end
              // Execute the descriptor
              execute_desc(dma_type,act_desc) ;
              // Store status if requested
              if (desc_sts_req[dma_type][act_desc])
                begin
                   old_sts = shmem_read(rc_status_table_addr[dma_type]+(act_desc*4),4) ;
                   if (old_sts != 32'h00000000)
                     begin
                        alog.display(EBFM_MSG_WARNING,
                                     {dma_type_to_oldstr(dma_type),
                                      " Descriptor Number: ",dimage3(act_desc),
                                      " Status not 0's before storing. Was: 0x",himage8(old_sts)}) ;
                     end
                   shmem_write(rc_status_table_addr[dma_type]+(act_desc*4),32'h00000001,4) ;
                   // Clear the status request
                   desc_sts_req[dma_type][act_desc] = 1'b0 ;
                end
              // Clear the desc_valid since we executed it
              desc_valid[dma_type][act_desc] = 1'b0 ;
              // Search ahead to see what to wait for
              if (desc_valid[dma_type] == {MAX_HARDWARE_DESC{1'b0}})
                begin
                   // If there is nothing valid, just increment
                   next_desc[dma_type]++ ;
                   if (next_desc[dma_type] > last_desc[dma_type])
                     next_desc[dma_type] = 0 ;
                end
              else
                // Need to search for the next one valid, in case the one we completed was out of order
                // and next several completed previously
                while (desc_valid[dma_type][next_desc[dma_type]] == 1'b0)
                  begin
                     next_desc[dma_type]++ ;
                     if (next_desc[dma_type] > last_desc[dma_type])
                       next_desc[dma_type] = 0 ;
                  end
           end
         # (dma_engine_wait_ns * 1000) ;
      end while (dma_enable[dma_type]) ;

   endtask : DmaEngine

   function new(LogAll plog) ;
      alog = plog ;
      foreach (last_dnum[i])
        begin
           last_dnum[i] = -1;
           dma_enable[i] = 1'b1 ;
           for (int j = 0 ; j < MAX_HARDWARE_DESC ; j++)
             begin
                desc_valid[i][j] = 1'b0 ;
                desc_sts_req[i][j] = 1'b0 ;
             end
        end
      fork
         DmaEngine(ReadDMA) ;
         DmaEngine(WriteDMA) ;
      join_none;
   endfunction // new


   function void setup(   bit [63:0] ext_rc_rd_status_table_addr ,
                          bit [63:0] ext_rc_rd_desc_table_addr ,
                          bit [31:0] ext_last_rd_desc ,
                          bit [63:0] ext_rc_wr_status_table_addr ,
                          bit [63:0] ext_rc_wr_desc_table_addr,
                          bit [31:0] ext_last_wr_desc ) ;
      rc_status_table_addr[ReadDMA] = ext_rc_rd_status_table_addr ;
      rc_desc_table_addr[ReadDMA] = ext_rc_rd_desc_table_addr ;
      last_desc[ReadDMA] = ext_last_rd_desc ;
      rc_status_table_addr[WriteDMA] = ext_rc_wr_status_table_addr ;
      rc_desc_table_addr[WriteDMA] = ext_rc_wr_desc_table_addr ;
      last_desc[WriteDMA] = ext_last_wr_desc ;
   endfunction // setup

   task start_dma(dma_type_e dma_type,int last_desc_num) ;
      if ( (last_desc_num == last_dnum[dma_type]) ||
           ( (last_desc_num < last_dnum[dma_type]) &&
             (last_dnum[dma_type] != last_desc[dma_type] ) ) )
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,
                        {dma_type_to_oldstr(dma_type),"start error, tried to wrap desc_num around."}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,
                              {"  Prev Desc_Num: ",
                               himage4(last_dnum[dma_type]),
                               "  New Desc_Num: ",
                               himage4(last_desc_num)}) ;
        end
      else
        begin
           // Set all of the new valid bits
           for ( int i = (last_dnum[dma_type]+1) ; i <= last_desc_num ; i++)
             begin
                if (desc_valid[dma_type][i] == 1'b1)
                  begin
                     alog.display(EBFM_MSG_ERROR_FATAL,
                              {dma_type_to_oldstr(dma_type)," tried to enable already valid descriptor: " ,
                               himage4(i)}) ;

                  end
                desc_valid[dma_type][i] = 1'b1 ;
             end
           desc_sts_req[dma_type][last_desc_num] = 1'b1 ;
           // Update last_dnum
           last_dnum[dma_type] = last_desc_num ;
           // if we finished with last enabled one, need to wrap
           if (last_dnum[dma_type] >= last_desc[dma_type])
             last_dnum[dma_type] = -1 ;
        end // else: !if( (last_desc_num == last_dnum[dma_type]) ||...
   endtask : start_dma

   task read_dma(integer last_desc_num) ;
      start_dma(ReadDMA,last_desc_num);
   endtask : read_dma

   task write_dma(integer last_desc_num) ;
      start_dma(WriteDMA,last_desc_num);
   endtask : write_dma

   function void display ;
      alog.detail_dump(EBFM_MSG_INFO,"") ;
      alog.detail_dump(EBFM_MSG_INFO,"DMA Emulator Internal State") ;
      alog.detail_dump(EBFM_MSG_INFO,"---------------------------") ;
      foreach(last_dnum[i])
        begin
           alog.detail_dump(EBFM_MSG_INFO,{dma_type_to_oldstr(dma_type_e'(i))," Internal state...."});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"RC Status Table Address: 0x",himage8(rc_status_table_addr[i][63:32]),
                             "_",himage8(rc_status_table_addr[i][31:0])});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"RC Desc Table Address:   0x",himage8(rc_desc_table_addr[i][63:32]),
                             "_",himage8(rc_desc_table_addr[i][31:0])});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Max Descriptor Num:      0d",dimage3(last_desc[i])});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Last written Desc Num:   0d",dimage3(last_dnum[i])});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Desc Valid Array:        0x",himage8(desc_valid[i][127:96]),
                             "_",himage8(desc_valid[i][95:64]),
                             "_",himage8(desc_valid[i][63:32]),
                             "_",himage8(desc_valid[i][31:0])
                             });
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Status Request Array:    0x",himage8(desc_sts_req[i][127:96]),
                             "_",himage8(desc_sts_req[i][95:64]),
                             "_",himage8(desc_sts_req[i][63:32]),
                             "_",himage8(desc_sts_req[i][31:0])
                             });
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Engine enable:             ",dimage1(dma_enable[i])});
           alog.detail_dump(EBFM_MSG_INFO,
                            {"Engine next desc:          ",dimage3(next_desc[i])});
           alog.detail_dump(EBFM_MSG_INFO,"") ;
        end
      alog.detail_dump(EBFM_MSG_INFO,"") ;

   endfunction : display

endclass // EmulateDma

class DataMovement ;
   // Pointers to other classes we rely on...
   LogAll alog ;
   BufferSpaceTracker ep_buffer;
   BufferSpaceTracker rc_buffer;
   // Description of the data movement
   bit [63:0]  rc_source_addr ; // Not rand, because have to track allocation (randomized at allocate time)
   bit [63:0]  ep_buffer_addr ; // Not rand, because have to carefully allocate to conserve space
   bit [63:0]  rc_dest_addr ;   // Not rand, because have to track allocation (randomized at allocate time)
   rand bit [29:0]  move_length_dw ; // Randomized
   // The array of descriptors to be created to do read and write dma for this movement
   DescArray read_desc_list ;
   DescArray write_desc_list ;
   // The number of read and write descriptors
   // int    num_read_desc ;  DELETE THIS
   // int    num_write_desc ;  DELETE THIS
   // Largest amount of space left in ep_buffer, used to randomize length
   int    ep_largest_available_dw ;
   // Randomized starting data Dword value, increments
   rand bit[31:0] start_dw_data;

   constraint size_c { move_length_dw <= ep_largest_available_dw ;
      move_length_dw >= (ep_largest_available_dw / 8) ; }
   function void pre_randomize ;
      ep_largest_available_dw = ep_buffer.largest_avail(EP_DATA_ADDR_ALIGNMENT)/4 ;
   endfunction

   function void post_randomize ;
      if ( (move_length_dw > (ep_buffer.largest_avail(EP_DATA_ADDR_ALIGNMENT)/4)) ||
           (move_length_dw > EP_DATA_BUFFER_DW_LEN) )
        begin
           alog.display(EBFM_MSG_INFO,{"pre_randomize largest available dw: 0d",
                                       dimage6(ep_largest_available_dw)}) ;
           alog.display(EBFM_MSG_INFO,{"current post_randomize largest available dw: 0d",
                                       dimage6(ep_buffer.largest_avail(EP_DATA_ADDR_ALIGNMENT)/4)}) ;
           alog.display(EBFM_MSG_ERROR_FATAL,{"Selected Random Length that is too big: 0d",
                                              dimage6(move_length_dw)});
        end
      ep_buffer_addr = ep_buffer.allocate_block(move_length_dw*4,EP_DATA_ADDR_ALIGNMENT,FIRST_AVAIL) ;
      if ( (ep_buffer_addr % EP_DATA_ADDR_ALIGNMENT) != 0)
        begin
           ep_buffer.dump("Bad Alignment") ;
           alog.display(EBFM_MSG_ERROR_FATAL,{"Badly aligned ep_buffer_addr allocated: 0x",
                                              himage8(ep_buffer_addr)});
        end
      rc_source_addr = rc_buffer.allocate_block(move_length_dw*4,RC_DATA_ADDR_ALIGNMENT,RANDOM) ;
      if ( (rc_source_addr % RC_DATA_ADDR_ALIGNMENT) != 0)
        begin
           rc_buffer.dump("Bad Alignment") ;
           alog.display(EBFM_MSG_ERROR_FATAL,{"Badly aligned rc_source_addr allocated: 0x",
                                              himage8(rc_source_addr)});
        end
      rc_dest_addr = rc_buffer.allocate_block(
                                              (move_length_dw*4)+DEST_BUFFER_PREFIX_PAD+DEST_BUFFER_POSTFIX_PAD,
                                              RC_DATA_ADDR_ALIGNMENT,RANDOM) ;
      rc_dest_addr = rc_dest_addr + DEST_BUFFER_PREFIX_PAD ;
      if ( (rc_dest_addr % RC_DATA_ADDR_ALIGNMENT) != 0)
        begin
           rc_buffer.dump("Bad Alignment") ;
           alog.display(EBFM_MSG_ERROR_FATAL,{"Badly aligned rc_dest_addr allocated: 0x",
                                              himage8(rc_dest_addr)});
        end
      // Create Random Read Descriptor List for this movement
      read_desc_list = new(alog,move_length_dw,rc_source_addr,ep_buffer_addr) ;
      if (read_desc_list.randomize() == 0)
        alog.display(EBFM_MSG_ERROR_FATAL, "Unable to randomize Read Descriptors");
      // Create Random Write Descriptor List for this movement
      write_desc_list = new(alog,move_length_dw,ep_buffer_addr,rc_dest_addr);
      if (write_desc_list.randomize() == 0)
        alog.display(EBFM_MSG_ERROR_FATAL, "Unable to randomize Write Descriptors");

   endfunction

   function void display;
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.detail_dump(EBFM_MSG_INFO,"Randomized Data Movement Description");
      alog.detail_dump(EBFM_MSG_INFO,"------------------------------------");
      alog.detail_dump(EBFM_MSG_INFO,
                       {"RC Source Data Address: 0x",
                        himage8(rc_source_addr[63:32]),"_",
                        himage8(rc_source_addr[31:0])}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                       {"EP Buffer Data Address: 0x",
                        himage8(ep_buffer_addr[63:32]),"_",
                        himage8(ep_buffer_addr[31:0])}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                       {"RC Dest Data Address:   0x",
                        himage8(rc_dest_addr[63:32]),"_",
                        himage8(rc_dest_addr[31:0])}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                       {"Move length in DWords:  0x",
                        himage8(move_length_dw[29:0])}) ;
      alog.detail_dump(EBFM_MSG_INFO,
                       {"Starting Dword Data:    0x",
                        himage8(start_dw_data[31:0])}) ;
      read_desc_list.display("Read Descriptor List") ;
      write_desc_list.display("Write Descriptor List") ;
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.mem_dump("RC Source Data....",
                    rc_source_addr,
                    move_length_dw*4);
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.mem_dump("RC Destination Prefix Data....",
                    rc_dest_addr-DEST_BUFFER_PREFIX_PAD,
                    DEST_BUFFER_PREFIX_PAD);
      alog.mem_dump("RC Destination Data....",
                    rc_dest_addr,
                    move_length_dw*4);
      alog.mem_dump("RC Destination Postfix Data....",
                    rc_dest_addr+(move_length_dw*4),
                    DEST_BUFFER_POSTFIX_PAD);
      alog.detail_dump(EBFM_MSG_INFO,"");
   endfunction

   task setup_dm_data ;
      // Setup data in the buffers
      shmem_fill(rc_source_addr, SHMEM_FILL_DWORD_INC, move_length_dw*4,start_dw_data);
      shmem_fill(rc_dest_addr-DEST_BUFFER_PREFIX_PAD, SHMEM_FILL_ZERO, DEST_BUFFER_PREFIX_PAD,32'h0) ;
      shmem_fill(rc_dest_addr, SHMEM_FILL_ONE, move_length_dw*4,32'h0) ;
      shmem_fill(rc_dest_addr+(move_length_dw*4), SHMEM_FILL_ZERO, DEST_BUFFER_POSTFIX_PAD,32'h0) ;
   endtask // setup_dm_data

   function new(LogAll alog,
                BufferSpaceTracker ep_buffer,
                BufferSpaceTracker rc_buffer) ;
      this.alog = alog ;
      this.ep_buffer = ep_buffer ;
      this.rc_buffer = rc_buffer ;
   endfunction // new

   function void free_resources ;
      // Free up the memory resources we were using
      if (!ep_buffer.free_block(ep_buffer_addr,move_length_dw*4))
        alog.display(EBFM_MSG_ERROR_FATAL,"Error freeing ep_buffer data block allocation") ;
      if (!rc_buffer.free_block(rc_source_addr,move_length_dw*4))
        alog.display(EBFM_MSG_ERROR_FATAL,"Error freeing rc_buffer source data block allocation") ;
      if (!rc_buffer.free_block(rc_dest_addr-DEST_BUFFER_PREFIX_PAD,
                           (move_length_dw*4) + DEST_BUFFER_PREFIX_PAD + DEST_BUFFER_POSTFIX_PAD))
        alog.display(EBFM_MSG_ERROR_FATAL,"Error freeing rc_buffer destination data block allocation") ;
      // Delete all of the elements from the descriptor queues
      read_desc_list.free_resources();
      write_desc_list.free_resources();
   endfunction : free_resources

   function void miscompare_display
     (
      bit [63:0] start_addr,
      bit [63:0] chk_addr ,
      bit [31:0] exp_data ,
      bit [31:0] chk_data
      ) ;
      alog.display(EBFM_MSG_ERROR_CONTINUE,{"   Buffer Start Addr: 0x",
                   himage8(start_addr[63:32]),"_",
                   himage8(start_addr[31:0])});
      alog.display(EBFM_MSG_ERROR_CONTINUE,{"     Miscompare Addr: 0x",
        himage8(chk_addr[63:32]),"_",
        himage8(chk_addr[31:0])});
      alog.display(EBFM_MSG_ERROR_CONTINUE,{"       Expected Data: 0x",
        himage8(exp_data)});
      alog.display(EBFM_MSG_ERROR_CONTINUE,{"         Actual Data: 0x",
        himage8(chk_data)});
   endfunction : miscompare_display

   function bit check_data_ok ;
      bit okay = 1'b1 ;
      bit [31:0] chk_data ;
      bit [31:0] exp_data = start_dw_data ;
      bit [63:0] chk_addr ;
      begin : main_data_chk
         for (int i = 0 ; i < move_length_dw ; i++)
           begin
              chk_addr = (rc_dest_addr+(i*4)) ;
              chk_data = shmem_read(chk_addr,4) ;
              if (chk_data != exp_data)
                begin
                   alog.display(EBFM_MSG_ERROR_CONTINUE,"Data Miscompare in Destination Buffer") ;
                   miscompare_display(rc_dest_addr,chk_addr,exp_data,chk_data) ;
                   okay = 1'b0;
                   disable main_data_chk ;
                end
              exp_data = exp_data + 1 ;
           end // for (int i = 0 ; i < move_length_dw ; i++)
         exp_data = 32'h00000000 ;
         for (int i = 0 ; i < (DEST_BUFFER_PREFIX_PAD/4) ; i++)
           begin
              chk_addr = (rc_dest_addr - DEST_BUFFER_PREFIX_PAD + (i*4)) ;
              chk_data = shmem_read(chk_addr,4) ;
              if (chk_data != exp_data)
                begin
                   alog.display(EBFM_MSG_ERROR_CONTINUE,"Data Miscompare in Destination Buffer Prefix area") ;
                   miscompare_display(rc_dest_addr-DEST_BUFFER_PREFIX_PAD,chk_addr,exp_data,chk_data) ;
                   okay = 1'b0;
                   disable main_data_chk ;
                end
           end // for (int i = 0 ; i < (DEST_BUFFER_PREFIX_PAD/4) ; i++)

         for (int i = 0 ; i < (DEST_BUFFER_POSTFIX_PAD/4) ; i++)
           begin
              chk_addr = (rc_dest_addr + (move_length_dw*4) + (i*4)) ;
              chk_data = shmem_read(chk_addr,4) ; //
              if (chk_data != exp_data)
                begin
                   alog.display(EBFM_MSG_ERROR_CONTINUE,"Data Miscompare in Destination Buffer Prefix area") ;
                   miscompare_display(rc_dest_addr+(move_length_dw*4),chk_addr,exp_data,chk_data) ;
                   okay = 1'b0;
                   disable main_data_chk ;
                end
           end // for (int i = 0 ; i < (DEST_BUFFER_POSTFIX_PAD/4) ; i++)
      end // block: main_data_chk
      return (okay) ;

   endfunction

endclass // DataMovement

class SysSetup ;
   LogAll alog ;
   BufferSpaceTracker ep_buffer ;
   BufferSpaceTracker rc_buffer ;
   EmulateDma emulator ;
   integer bar_table ;

   // Track where the DMA Desc Pointers are
   int     curr_rd_desc ;
   int     curr_wr_desc ;
   int     sts_rd_desc ;
   int     sts_wr_desc ;

   // Queues for tracking the data movements
   DataMovement rd_pending_queue[$] ;
   DataMovement rd_in_prog_queue[$] ;
   DataMovement wr_pending_queue[$] ;
   DataMovement wr_in_prog_queue[$] ;

   // The DMA controller setup parameters that are constant for this test
   bit [63:0] rc_rd_status_table_addr ;
   bit [63:0] rc_rd_desc_table_addr ;
   bit [63:0] rc_wr_status_table_addr ;
   bit [63:0] rc_wr_desc_table_addr ;
   rand int num_rd_desc ;
   rand int num_wr_desc ;

   // Number of Data Movements to do for this test
   rand int num_data_movements ;

   // Tracking for each sub-test
   int     test_dm_created ;
   int     test_dm_read_dma_started ;
   int     test_dm_read_dma_completed ;
   int     test_dm_write_dma_started ;
   int     test_dm_write_dma_completed ;
   bit     read_dma_in_prog ;
   bit     write_dma_in_prog ;
   int     rd_start_time_ns ;
   int     wr_start_time_ns ;

   constraint desc_num_c {
      num_rd_desc >= 1 ;
      num_wr_desc >= 1 ;
      num_rd_desc <= MAX_HARDWARE_DESC ;
      num_wr_desc <= MAX_HARDWARE_DESC ;
   }

   constraint data_movements_c {
      num_data_movements >= MIN_DATA_MOVEMENTS ;
      num_data_movements <= MAX_DATA_MOVEMENTS ;
   }

   function void post_randomize ;
      rc_rd_status_table_addr = rc_buffer.allocate_block(DESC_INST_OFFSET+(num_rd_desc*DESC_BYTE_LEN),
                                                         DESC_TABLE_ALIGNMENT,RANDOM) ;
      rc_wr_status_table_addr = rc_buffer.allocate_block(DESC_INST_OFFSET+(num_wr_desc*DESC_BYTE_LEN),
                                                         DESC_TABLE_ALIGNMENT,RANDOM) ;
      rc_rd_desc_table_addr = rc_rd_status_table_addr + DESC_INST_OFFSET ;
      rc_wr_desc_table_addr = rc_wr_status_table_addr + DESC_INST_OFFSET ;
      curr_rd_desc = num_rd_desc - 1;
      curr_wr_desc = num_wr_desc - 1;
   endfunction // setup

   function new(LogAll alog,
                BufferSpaceTracker rc_buffer,
                BufferSpaceTracker ep_buffer,
                EmulateDma emulator,
                integer bar_table);
      this.alog = alog ;
      this.emulator = emulator;
      this.rc_buffer = rc_buffer ;
      this.ep_buffer = ep_buffer ;
      this.bar_table = bar_table;
   endfunction

   task setup_hardware ;

      // Some checking to make sure things setup per Hardware Requirements
      if ( (rc_rd_status_table_addr + DESC_INST_OFFSET) != rc_rd_desc_table_addr)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Read Descriptor Table not offset ", dimage3(DESC_INST_OFFSET),
                         " bytes from Read Status Table."}) ;
        end // if ( (rc_rd_status_table_addr + DESC_INST_OFFSET) != rc_rd_desc_table_addr)
      if ( (rc_wr_status_table_addr + DESC_INST_OFFSET) != rc_wr_desc_table_addr)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Write Descriptor Table not offset ", dimage3(DESC_INST_OFFSET),
                         " bytes from Write Status Table."}) ;
        end // if ( (rc_wr_status_table_addr + DESC_INST_OFFSET) != rc_wr_desc_table_addr)
      if ( (rc_rd_desc_table_addr % DESC_TABLE_ALIGNMENT) != 0)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Read Descriptor Table not aligned to ", dimage3(DESC_TABLE_ALIGNMENT),
                         " byte boundary."}) ;
        end
      if ( (rc_wr_desc_table_addr % DESC_TABLE_ALIGNMENT) != 0)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Write Descriptor Table not aligned to ", dimage3(DESC_TABLE_ALIGNMENT),
                         " byte boundary."}) ;
        end
      if (num_rd_desc > MAX_HARDWARE_DESC)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Number of Read Descriptors greater than hardware limit of ",
                         dimage3(MAX_HARDWARE_DESC),"."}) ;
        end
      if (num_wr_desc > MAX_HARDWARE_DESC)
        begin
           display() ; // Display everything about system setup
           alog.display(EBFM_MSG_ERROR_FATAL,
                        {"Number of Write Descriptors greater than hardware limit of ",
                         dimage3(MAX_HARDWARE_DESC),"."}) ;
        end
      if (SKIP_LINK == 0)
        begin
           //=============================================================
           // Basic DMA Controller Setup
           alog.display(EBFM_MSG_INFO, "Setting up constant DMA controller registers");
           // DMA Read Controller / RC Location of DMA Status / Descriptors
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR,
                          rc_rd_status_table_addr[31: 0], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+4,
                          rc_rd_status_table_addr[63: 32], 4, 0);
           // DMA Read Controller / Location of where fetched descriptors go in EP AvMM memory space
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+8,
                          RD_DEST_DESCRIPTOR_ADDR[31: 0], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+12,
                          RD_DEST_DESCRIPTOR_ADDR[63: 32], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+20,
                          (num_rd_desc-1), 4, 0);
           // DMA Write Controller / RC Location of DMA Status / Descriptors
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR,
                          rc_wr_status_table_addr[31: 0], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+4,
                          rc_wr_status_table_addr[63:32], 4, 0);
           // DMA Write Controller / Location of where fetched descriptors go in EP AvMM memory space
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+8,
                          WR_DEST_DESCRIPTOR_ADDR[31:0], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+12,
                          WR_DEST_DESCRIPTOR_ADDR[63:32], 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+20,
                          (num_wr_desc-1), 4, 0);
        end // if (SKIP_LINK == 0)
      else
        begin
           emulator.setup(rc_rd_status_table_addr ,
                          rc_rd_desc_table_addr ,
                          (num_rd_desc-1) ,
                          rc_wr_status_table_addr ,
                          rc_wr_desc_table_addr ,
                          (num_wr_desc-1) ) ;
        end // else: !if(SKIP_LINK == 0)
   endtask

   task clear_hardware_and_resources ;
      // Clear the DMA Controller Registers back to assumed defaults, so future use is somewhat predictable
      if (SKIP_LINK == 0)
        begin
           //=============================================================
           // Basic DMA Controller Setup
           alog.display(EBFM_MSG_INFO, "Clearing constant DMA controller registers");
           // DMA Read Controller / RC Location of DMA Status / Descriptors
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+4,
                          32'h00000000, 4, 0);
           // DMA Read Controller / Location of where fetched descriptors go in EP AvMM memory space
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+8,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+12,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+20,
                          32'h0000007F, 4, 0);
           // DMA Write Controller / RC Location of DMA Status / Descriptors
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+4,
                          32'h00000000, 4, 0);
           // DMA Write Controller / Location of where fetched descriptors go in EP AvMM memory space
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+8,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+12,
                          32'h00000000, 4, 0);
           ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+20,
                          32'h0000007F, 4, 0);
        end // if (SKIP_LINK == 0)
      else
        begin
           emulator.setup(64'h00000000_00000000,
                          64'h00000000_00000000,
                          32'h0000007F,
                          64'h00000000_00000000,
                          64'h00000000_00000000,
                          32'h0000007F) ;
        end // else: !if(SKIP_LINK == 0)

      // Free up the meemory allocated for the status/descriptor tables
      if (!rc_buffer.free_block(rc_rd_status_table_addr,DESC_INST_OFFSET+(num_rd_desc*DESC_BYTE_LEN)))
        begin
           alog.display(EBFM_MSG_ERROR_FATAL,"Error trying to free memory for Read Status/Descriptor Table") ;
        end
      if (!rc_buffer.free_block(rc_wr_status_table_addr,DESC_INST_OFFSET+(num_wr_desc*DESC_BYTE_LEN)))
        begin
           alog.display(EBFM_MSG_ERROR_FATAL,"Error trying to free memory for Write Status/Descriptor Table") ;
        end
      // Be nice to simulator and delete these queues (though should be empty already)
      rd_pending_queue.delete();
      rd_in_prog_queue.delete() ;
      wr_pending_queue.delete() ;
      wr_in_prog_queue.delete() ;

   endtask : clear_hardware_and_resources ;

   task create_data_movements;
      DataMovement dm ;

      while ( (ep_buffer.largest_avail(EP_DATA_ADDR_ALIGNMENT)/4 >
               MIN_EP_BUFFER_AVAIL_FOR_NEW_DATA_MOVEMENT_DW) &&
              (test_dm_created < num_data_movements) )
        begin
           dm = new(alog,ep_buffer,rc_buffer) ;
           if (dm.randomize() == 0)
             alog.display(EBFM_MSG_ERROR_FATAL, "Unable to randomize the Data Movement Setup");
           // Setup the data buffers
           rd_pending_queue.push_back(dm) ;
           dm.setup_dm_data ;
           test_dm_created = test_dm_created + 1 ;
           alog.display(EBFM_MSG_INFO,{"Created Data Movement: ",
                                       dimage6(dm.move_length_dw*4)," (0x",
                                       himage4(dm.move_length_dw*4),") Bytes."}) ;
           alog.display(EBFM_MSG_INFO,{""}) ;
        end
   endtask : create_data_movements

   task start_read_dma ;
      int max_new_rd_desc ;
      int num_new_rd_desc ;
      int num_dm_posted = 0 ;
      int partial_dm_posted = 0 ;
      int prev_rd_desc ;
      if (curr_rd_desc >= (num_rd_desc-1))
        begin
           if (!std::randomize(max_new_rd_desc) with {max_new_rd_desc > 0 ; max_new_rd_desc <= num_rd_desc;} )
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"Unable to pick rand number of new read descriptors.") ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Number of Read Desc: ",dimage3(num_rd_desc)}) ;

             end
           curr_rd_desc = -1 ; // Wrap it around
        end
      else
        begin
           if (!std::randomize(max_new_rd_desc) with
               {max_new_rd_desc > 0 ; max_new_rd_desc <= (num_rd_desc - curr_rd_desc - 1); } )
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"Unable to pick rand number of new read descriptors.") ;
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"Current Read Desc: ",dimage3(curr_rd_desc)}) ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Number of Read Desc: ",dimage3(num_rd_desc)}) ;
             end
        end // else: !if(curr_rd_desc >= (num_rd_desc-1))
      prev_rd_desc = curr_rd_desc ;
      while (max_new_rd_desc > 0)
        begin
           if (rd_pending_queue.size() > 0)
             begin
                num_new_rd_desc = rd_pending_queue[0].read_desc_list.num_pending_desc();
                if (num_new_rd_desc <= max_new_rd_desc)
                  begin
                     rd_pending_queue[0].read_desc_list.write_desc_to_shmem
                       ((rc_rd_desc_table_addr+((curr_rd_desc+1)*DESC_BYTE_LEN)),
                        curr_rd_desc+1,
                        num_new_rd_desc) ;
                     rd_in_prog_queue.push_back(rd_pending_queue.pop_front()) ;
                     test_dm_read_dma_started = test_dm_read_dma_started + 1 ;
                     max_new_rd_desc = max_new_rd_desc - num_new_rd_desc ;
                     curr_rd_desc = curr_rd_desc + num_new_rd_desc ;
                     num_dm_posted = num_dm_posted + 1 ;
                  end // if (num_new_rd_desc > max_new_rd_desc)
                else
                  begin
                     rd_pending_queue[0].read_desc_list.write_desc_to_shmem
                       ((rc_rd_desc_table_addr+((curr_rd_desc+1)*DESC_BYTE_LEN)),
                        curr_rd_desc+1,
                        max_new_rd_desc) ;
                     curr_rd_desc = curr_rd_desc + max_new_rd_desc ;
                     max_new_rd_desc = 0 ;
                     partial_dm_posted = 1 ;
                  end // else: !if(num_new_rd_desc > max_new_rd_desc)
             end // if (rd_pending_queue.size() > 0)
           else
             begin
                max_new_rd_desc = 0;
             end // else: !if(rd_pending_queue.size() > 0)
        end // while (max_new_rd_desc > 0)
      alog.display(EBFM_MSG_INFO,
                   {"Starting DMA Read.  New Desc Num: ",dimage3(curr_rd_desc)});
      if (partial_dm_posted > 0)
        alog.display(EBFM_MSG_INFO,
                     {"    Num Data Movement OPs Posted: ",dimage3(num_dm_posted), " plus partial."});
      else
        alog.display(EBFM_MSG_INFO,
                     {"    Num Data Movement OPs Posted: ",dimage3(num_dm_posted)});
      // Workaround for FB case 193300, need to ask for status on each desc...
      for (shortint i = (prev_rd_desc+1) ; i <= curr_rd_desc ; i++ )
        begin
           shmem_write(rc_rd_status_table_addr+(i*4),DMA_NO_STATUS,4) ;
           if (SKIP_LINK == 0)
             begin
                // Start the DMA Read
                ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMARD_CNTLR_BASE_ADDR+16, {18'h00000,i}, 4, 0);
             end // if (SKIP_LINK == 0)
           else
             begin
                emulator.read_dma(i) ;
             end
        end
      read_dma_in_prog = 1'b1 ;
      rd_start_time_ns = $time/1000 ;

   endtask : start_read_dma ;

   function bit check_read_dma ;
      bit chk_ok = 1'b1;
      int dma_sts ;
      DataMovement dm ;
      dma_sts = shmem_read(rc_rd_status_table_addr+(curr_rd_desc*4),4);
      if (dma_sts != DMA_NO_STATUS)
        begin
           alog.display(EBFM_MSG_INFO, {"DMA Read Completed Desc Num: ",dimage3(curr_rd_desc)});
           while (rd_in_prog_queue.size() > 0)
             begin
                wr_pending_queue.push_back(rd_in_prog_queue.pop_front()) ;
                test_dm_read_dma_completed = test_dm_read_dma_completed + 1 ;
             end
           read_dma_in_prog = 1'b0 ;
        end
      else
        begin
           if ((($time/1000) - rd_start_time_ns) > RD_DMA_TIMEOUT_NS)
             begin
                display_read_status_desc() ;
                alog.display(EBFM_MSG_ERROR_CONTINUE, {"DMA Read: Timeout Waiting for Status at: 0x",
                                                       himage8((rc_rd_status_table_addr+(curr_rd_desc*4))),
                                                       " ,for desc id: ",dimage3(curr_rd_desc)});
                chk_ok = 1'b0;
             end
        end // else: !if(dma_sts != DMA_NO_STATUS)
      return chk_ok;
   endfunction : check_read_dma

   function bit check_read_dma_fb193300 ;
      bit chk_ok = 1'b1;
      int dma_sts ;
      for (byte i = sts_rd_desc ; i <= curr_rd_desc ; i++)
        begin
           dma_sts = shmem_read(rc_rd_status_table_addr+(i*4),4);
           if (dma_sts != DMA_NO_STATUS)
             begin
                // Now we need to find who that descriptor belonged to...
             end
        end
      if (dma_sts != DMA_NO_STATUS)
        begin
           while (rd_in_prog_queue.size() > 0)
             begin
                alog.display(EBFM_MSG_INFO, {"DMA Read Completed Desc Num: ",dimage3(curr_rd_desc)});
                wr_pending_queue.push_back(rd_in_prog_queue.pop_front()) ;
                test_dm_read_dma_completed = test_dm_read_dma_completed + 1 ;
             end
           read_dma_in_prog = 1'b0 ;
        end
      else
        begin
           if ((($time/1000) - rd_start_time_ns) > RD_DMA_TIMEOUT_NS)
             begin
                display_read_status_desc() ;
                alog.display(EBFM_MSG_ERROR_CONTINUE, {"DMA Read: Timeout Waiting for Status at: 0x",
                                                       himage8((rc_rd_status_table_addr+(curr_rd_desc*4))),
                                                       " ,for desc id: ",dimage3(curr_rd_desc)});
                chk_ok = 1'b0;
             end
        end // else: !if(dma_sts != DMA_NO_STATUS)
      return chk_ok;
   endfunction : check_read_dma_fb193300


   task start_write_dma ;
      int max_new_wr_desc ;
      int num_new_wr_desc ;
      int num_dm_posted = 0 ;
      int partial_dm_posted = 0 ;
      int prev_wr_desc ;
      if (curr_wr_desc >= (num_wr_desc-1))
        begin
           if (!std::randomize(max_new_wr_desc) with {max_new_wr_desc > 0 ; max_new_wr_desc <= num_wr_desc;} )
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"Unable to pick rand number of new write descriptors.") ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Number of Write Desc: ",dimage3(num_wr_desc)}) ;
             end
           curr_wr_desc = -1 ; // Wrap it around
        end
      else
        begin
           if (!std::randomize(max_new_wr_desc) with
               {max_new_wr_desc > 0 ; max_new_wr_desc <= (num_wr_desc - curr_wr_desc - 1); } )
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"Unable to pick rand number of new write descriptors.") ;
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"Current Write Desc: ",dimage3(curr_wr_desc)}) ;
                alog.display(EBFM_MSG_ERROR_FATAL,{"Number of Write Desc: ",dimage3(num_wr_desc)}) ;
             end
        end // else: !if(curr_wr_desc >= (num_wr_desc-1))
      prev_wr_desc = curr_wr_desc ;
      while (max_new_wr_desc > 0)
        begin
           if (wr_pending_queue.size() > 0)
             begin
                num_new_wr_desc = wr_pending_queue[0].write_desc_list.num_pending_desc() ;
                if (num_new_wr_desc <= max_new_wr_desc)
                  begin
                     wr_pending_queue[0].write_desc_list.write_desc_to_shmem
                       ((rc_wr_desc_table_addr+((curr_wr_desc+1)*DESC_BYTE_LEN)),
                        (curr_wr_desc+1),
                        num_new_wr_desc) ;
                     wr_in_prog_queue.push_back(wr_pending_queue.pop_front()) ;
                     test_dm_write_dma_started = test_dm_write_dma_started + 1 ;
                     max_new_wr_desc = max_new_wr_desc - num_new_wr_desc ;
                     curr_wr_desc = curr_wr_desc + num_new_wr_desc ;
                     num_dm_posted = num_dm_posted + 1 ;
                  end
                else
                  begin
                     wr_pending_queue[0].write_desc_list.write_desc_to_shmem
                       ((rc_wr_desc_table_addr+((curr_wr_desc+1)*DESC_BYTE_LEN)),
                        (curr_wr_desc+1),
                        max_new_wr_desc) ;
                     curr_wr_desc = curr_wr_desc + max_new_wr_desc ;
                     max_new_wr_desc = 0;
                     partial_dm_posted = 1 ;
                  end // else: !if(num_new_wr_desc <= max_new_wr_desc)
             end // if (wr_pending_queue.size() > 0)
           else
             begin
                max_new_wr_desc = 0;
             end // else: !if(wr_pending_queue.size() > 0)
        end // while (max_new_wr_desc > 0)
      alog.display(EBFM_MSG_INFO,
                   {"Starting DMA Write. New Desc Num: ",dimage3(curr_wr_desc)});
      if (partial_dm_posted > 0)
        alog.display(EBFM_MSG_INFO,
                     {"    Num Data Movement OPs Posted: ",dimage3(num_dm_posted), " plus partial."});
      else
        alog.display(EBFM_MSG_INFO,
                     {"    Num Data Movement OPs Posted: ",dimage3(num_dm_posted)});
      // Workaround for FB case 193300, need to ask for status on each desc...
      for (byte i = (prev_wr_desc+1) ; i <= curr_wr_desc ; i++ )
        begin
           shmem_write(rc_wr_status_table_addr+(i*4),DMA_NO_STATUS,4) ;
           if (SKIP_LINK == 0)
             begin
                // Start the DMA Write
                ebfm_barwr_imm(bar_table, DMA_CNTLR_BAR, DMAWR_CNTLR_BASE_ADDR+16, {18'h00000,i}, 4, 0);
             end // if (SKIP_LINK == 0)
           else
             begin
                emulator.write_dma(i) ;
             end
        end
      write_dma_in_prog = 1'b1 ;
      wr_start_time_ns = $time/1000 ;

   endtask : start_write_dma ;

   function bit check_write_dma ;
      int dma_sts ;
      bit chk_ok = 1'b1;
      DataMovement dm ;
      dma_sts = shmem_read(rc_wr_status_table_addr+(curr_wr_desc*4),4);
      if (dma_sts != DMA_NO_STATUS)
        begin
           alog.display(EBFM_MSG_INFO, {"DMA Write Completed Desc Num: ",dimage3(curr_wr_desc)});
           while (wr_in_prog_queue.size() > 0)
             begin
                dm = wr_in_prog_queue.pop_front() ;
                test_dm_write_dma_completed = test_dm_write_dma_completed + 1 ;
                chk_ok = dm.check_data_ok();
                if (!chk_ok)
                  dm.display() ;
                else
                  alog.display(EBFM_MSG_INFO,
                    {"Data Movement Completed Successfully, ",
                    dimage6(dm.move_length_dw*4),
                    " bytes moved ok."}) ;
                alog.display(EBFM_MSG_INFO,"");
                dm.free_resources() ;
             end
           write_dma_in_prog = 1'b0 ;
        end
      else
        begin
           if ((($time/1000) - wr_start_time_ns) > WR_DMA_TIMEOUT_NS)
             begin
                while (wr_in_prog_queue.size() > 0)
                  begin
                     dm = wr_in_prog_queue.pop_front() ;
                     dm.display() ;
                  end
                display_write_status_desc() ;
                alog.display(EBFM_MSG_ERROR_CONTINUE, {"DMA Write: Timeout Waiting for Status: 0x",
                                                       himage8((rc_wr_status_table_addr+(curr_wr_desc*4))),
                                                       " ,for desc id: ",dimage3(curr_wr_desc)});
                chk_ok = 1'b0 ;
             end
        end // else: !if(dma_sts != DMA_NO_STATUS)
      return chk_ok ;
   endfunction : check_write_dma

   task main_test (output bit test_ok) ;
      bit done = 1'b0 ;
      bit chk_ok = 1'b1 ;
      test_dm_created = 0;
      test_dm_read_dma_started = 0 ;
      test_dm_read_dma_completed = 0 ;
      test_dm_write_dma_started = 0 ;
      test_dm_write_dma_completed = 0;
      read_dma_in_prog = 1'b0;
      write_dma_in_prog = 1'b0;

      // Initialize the hardware
      setup_hardware() ;

      begin : main_test_loop
         // Main Test Loop
         while (!done)
           begin
              done = 1'b1 ;
              if (test_dm_created < num_data_movements)
                begin
                   done = 1'b0 ;
                   create_data_movements();
                end
              if (test_dm_read_dma_completed < num_data_movements)
                begin
                   done = 1'b0 ;
                   if (read_dma_in_prog == 1'b1)
                     begin
                        chk_ok = check_read_dma() ;
                        if (!chk_ok)
                          disable main_test_loop ;
                     end
                end
              if (test_dm_read_dma_started < num_data_movements)
                begin
                   done = 1'b0 ;
                   if ( (read_dma_in_prog == 1'b0) &&
                        (rd_pending_queue.size() > 0) )
                     begin
                        start_read_dma();
                     end
                end
              if (test_dm_write_dma_completed < num_data_movements)
                begin
                   done = 1'b0 ;
                   if (write_dma_in_prog == 1'b1)
                     begin
                        chk_ok = check_write_dma() ;
                        if (!chk_ok)
                          disable main_test_loop ;
                     end
                end
              if (test_dm_write_dma_started < num_data_movements)
                begin
                   done = 1'b0 ;
                   if ( (write_dma_in_prog == 1'b0) &&
                        (wr_pending_queue.size() > 0) )
                     begin
                        start_write_dma();
                     end
                end
              #10 ; // Need better idea of how long to wait
           end // while (!done)
      end // block: main_test_loop

      // If test was not ok and running with emulator, dump it
      if ((!chk_ok) && (SKIP_LINK > 0))
        emulator.display() ;

      // Clear the hardware and resources
      clear_hardware_and_resources() ;

      test_ok = chk_ok ;
   endtask : main_test


   function void display ;
      alog.detail_dump(EBFM_MSG_INFO,"Randomized System Setup");
      alog.detail_dump(EBFM_MSG_INFO,"-----------------------");
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.detail_dump(EBFM_MSG_INFO,
                         {"Memory Block            Address Hi/Low"}) ;
      //                                           0x01234567_89ABCDEF
      alog.detail_dump(EBFM_MSG_INFO,
                         {"------------            --------------"});
      alog.detail_dump(EBFM_MSG_INFO,
                         {"Write DMA Status Table: 0x",
                          himage8(rc_wr_status_table_addr[63:32]), "_",
                          himage8(rc_wr_status_table_addr[31:0])});
      alog.detail_dump(EBFM_MSG_INFO,
                         {"Write DMA Desc Table:   0x",
                          himage8(rc_wr_desc_table_addr[63:32]), "_",
                          himage8(rc_wr_desc_table_addr[31:0])});
      alog.detail_dump(EBFM_MSG_INFO,
                         {"Read  DMA Status Table: 0x",
                          himage8(rc_rd_status_table_addr[63:32]), "_",
                          himage8(rc_rd_status_table_addr[31:0])});
      alog.detail_dump(EBFM_MSG_INFO,
                         {"Read  DMA Desc Table:   0x",
                          himage8(rc_rd_desc_table_addr[63:32]), "_",
                          himage8(rc_rd_desc_table_addr[31:0])});
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.detail_dump(EBFM_MSG_INFO,{"Number of Write Descriptors:  ",dimage3(num_wr_desc)});
      alog.detail_dump(EBFM_MSG_INFO,{"Number of Read  Descriptors:  ",dimage3(num_rd_desc)});
      alog.detail_dump(EBFM_MSG_INFO,"");
      alog.detail_dump(EBFM_MSG_INFO,{"Number of Data Movements:    ",dimage4(num_data_movements)});
      alog.detail_dump(EBFM_MSG_INFO,"");

   endfunction

   function void display_read_status_desc ;
      alog.mem_dump("DMA Read Status",rc_rd_status_table_addr,DESC_INST_OFFSET,
                             "Desc Num",0,4,1'b0) ;
      alog.mem_dump("DMA Read Descriptors",rc_rd_desc_table_addr,num_rd_desc*DESC_BYTE_LEN,
                             "Desc Num",0,-2,1'b0) ;
   endfunction

   function void display_write_status_desc ;
      alog.mem_dump("DMA Write Status",rc_wr_status_table_addr,DESC_INST_OFFSET,
                             "Desc Num",0,4,1'b0) ;
      alog.mem_dump("DMA Write Descriptors",rc_wr_desc_table_addr,num_wr_desc*DESC_BYTE_LEN,
                             "Desc Num",0,-2,1'b0) ;
   endfunction



endclass // SysSetup


task checkout_buffer_tracker(LogAll alog, BufferSpaceTracker ep_buffer);
   int    allocated[8] , size[8];

   ep_buffer.dump("Start") ;
   alog.display(EBFM_MSG_INFO,{"Largest Free: 0x", himage8(ep_buffer.largest_avail())}) ;
   size[0] = 16'h0800 ;
   size[1] = 16'h1001 ;
   size[2] = 16'h1404 ;

   allocated[0] = ep_buffer.allocate_block(size[0],4,RANDOM) ;
   allocated[1] = ep_buffer.allocate_block(size[1],4,RANDOM) ;
   allocated[2] = ep_buffer.allocate_block(size[2],4,RANDOM) ;
   size[3] = ep_buffer.largest_avail() ;
   allocated[3] = ep_buffer.allocate_block(size[3],4,RANDOM) ;
   ep_buffer.dump("Full Allocation") ;
   alog.display(EBFM_MSG_INFO,{"Largest Free: 0x", himage8(ep_buffer.largest_avail())}) ;
   allocated[4] = ep_buffer.allocate_block(size[3],4,RANDOM) ;
   if (allocated[4] > 0) void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"Incorrect allocation!!!"));
   void'(ep_buffer.free_block(allocated[2],size[2]));
   ep_buffer.dump("Deleted 2") ;
   alog.display(EBFM_MSG_INFO,{"Largest Free: 0x", himage8(ep_buffer.largest_avail())}) ;
   allocated[4] = ep_buffer.allocate_block(size[3],4,RANDOM) ;
   if (allocated[4] > 0) void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"Incorrect allocation!!!"));
   void'(ep_buffer.free_block(allocated[3],size[3]));
   void'(ep_buffer.free_block(allocated[1],size[1]));
   void'(ep_buffer.free_block(allocated[0],size[0]));
   ep_buffer.dump("Final") ;
   alog.display(EBFM_MSG_INFO,{"Largest Free: 0x", himage8(ep_buffer.largest_avail())}) ;
endtask



task avmmdma_rdwr_test;
   input bar_table;
   integer bar_table;

   time    rd_start_time_ns ;
   time    wr_start_time_ns ;

   integer i;

   reg [31:0] dma_sts;

   reg [31:0] desc_ctrl;
   reg [63:0] rc_addr, ep_addr;
   bit [14:0] num_read_desc ;
   bit [14:0] num_write_desc ;


   // Randomized System Setup of addresses
   SysSetup sys ;
   // Emulator for running without link
   EmulateDma emulator ;

   // Logger
   LogAll alog ;

   // Space Trackers
   BufferSpaceTracker ep_buffer ;
   BufferSpaceTracker rc_buffer ;
   int        init_ep_buffer_largest ;
   int        init_rc_buffer_largest ;

   // Test Status
   bit        test_ok ;

   begin
      alog = new() ;

      emulator = new(alog) ;

      // Setup Buffer Space Trackers
      ep_buffer = new(alog,EP_DATA_BUFFER_ADDR,EP_DATA_BUFFER_DW_LEN*4) ;
      init_ep_buffer_largest = ep_buffer.largest_avail(1);
      rc_buffer = new(alog,0,CFG_SCRATCH_SPACE) ;
      init_rc_buffer_largest = rc_buffer.largest_avail(1);

      // TODO move this ugly stuff to a function or something
      if (init_ep_buffer_largest != EP_DATA_BUFFER_DW_LEN*4)
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,"ep_buffer space tracker not initialized correctly.") ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,{"  Expected Largest Avail: 0x",
                                                 himage8(EP_DATA_BUFFER_DW_LEN*4)});
           alog.display(EBFM_MSG_ERROR_FATAL,   {"    Actual Largest Avail: 0x",
                                                 himage8(init_ep_buffer_largest)});
        end
      if (init_rc_buffer_largest != CFG_SCRATCH_SPACE)
        begin
           alog.display(EBFM_MSG_ERROR_CONTINUE,"rc_buffer space tracker not initialized correctly.") ;
           alog.display(EBFM_MSG_ERROR_CONTINUE,{"  Expected Largest Avail: 0x",
                                                 himage8(CFG_SCRATCH_SPACE)});
           alog.display(EBFM_MSG_ERROR_FATAL,   {"    Actual Largest Avail: 0x",
                                                 himage8(init_rc_buffer_largest)});
        end

      // Setup our basic system address map
      // TODO Can we just move this into the test?
      sys = new(alog,rc_buffer,ep_buffer,emulator,bar_table) ;
      if (sys.randomize() == 0)
        alog.display(EBFM_MSG_ERROR_FATAL, "Unable to randomize system address setup");
      sys.display();

      sys.main_test(test_ok) ;

      if (test_ok)
        begin
           // TODO move this ugly stuff to a function or something
           if (ep_buffer.largest_avail(1) != init_ep_buffer_largest)
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"After test completion not all ep_buffer space freed") ;
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"  Expected Largest Avail: 0x",
                                                      himage8(init_ep_buffer_largest)});
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"    Actual Largest Avail: 0x",
                                                      himage8(ep_buffer.largest_avail(1))});
                ep_buffer.dump("EP Buffer Space at Test Completion") ;
                test_ok = 0 ;
             end


           if (rc_buffer.largest_avail(1) != init_rc_buffer_largest)
             begin
                alog.display(EBFM_MSG_ERROR_CONTINUE,"After test completion not all rc_buffer space freed") ;
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"  Expected Largest Avail: 0x",
                                                      himage8(init_rc_buffer_largest)});
                alog.display(EBFM_MSG_ERROR_CONTINUE,{"    Actual Largest Avail: 0x",
                                                      himage8(rc_buffer.largest_avail(1))});
                rc_buffer.dump("RC Buffer Space at Test Completion") ;
                test_ok = 0 ;
             end

        end

      alog.close ;

      if (test_ok)
        void'(ebfm_display(EBFM_MSG_INFO,"SUCCESS: All tests completed ok")) ;
      else
        begin
           void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"FAILURE: There were test errors")) ;
        end
   end
endtask // unmatched end(function|task|module|primitive|interface|package|class|clocking)

