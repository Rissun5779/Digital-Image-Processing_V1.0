// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************

/* 
    This is a simple example of an axi4stream master to demonstrate the mgc_axi4stream_master BFM usage. 

    This master performs a directed test, initiating 10 sequential packets at higher abstraction level 
    followed by 10 transfer at phase level.

*/

import mgc_axi4stream_pkg::*;
module master_test_program #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024)
(
    mgc_axi4stream_master bfm
);

initial
begin
    axi4stream_transaction trans;    
    static int byte_count = AXI4_DATA_WIDTH/8;
    int transfer_count;
    bit last;
    /*******************
    ** Initialisation **
    *******************/
    bfm.wait_on(AXI4STREAM_RESET_POSEDGE);
    bfm.wait_on(AXI4STREAM_CLOCK_POSEDGE);

    /************************
    ** Traffic generation: **
    ************************/    
    // 10 x packet with 
    // Number of transfer = i % 10. Values : 1, 2 .. 10 
    // id = i % 15. Values 0, 1, 2 .. 14
    // dest = i %20. Values 0, 1, 2 .. 19
    for(int i = 0; i < 10; ++i)
    begin
      transfer_count = (i % 10) + 1;
      trans = bfm.create_master_transaction(transfer_count);
      trans.id = i % 15;
      trans.dest = i % 20;
      for(int j = 0; j < (transfer_count * byte_count); ++j)
      begin
        trans.set_data(i + j, j);
        if(((i + j)% 5) == 0)
        begin
          trans.set_byte_type(AXI4STREAM_NULL_BYTE, j);
        end
        else if(((i + j)% 5) == 1)
        begin
          trans.set_byte_type(AXI4STREAM_POS_BYTE, j);
        end
        else
        begin
          trans.set_byte_type(AXI4STREAM_DATA_BYTE, j);
        end
      end
      bfm.execute_transaction(trans);
    end  
 
    // 10 x packet at transfer level with 
    // Number of transfer = i % 10. Values : 1, 2 .. 10 
    // id = i % 15. Values 0, 1, 2 .. 14
    // dest = i %20. Values 0, 1, 2 .. 19
    for(int i = 0; i < 10; ++i)
    begin
      transfer_count = (i % 10) + 1;
      trans = bfm.create_master_transaction(transfer_count);
      trans.id = i % 15;
      trans.dest = i % 20;
      for(int j = 0; j < transfer_count; ++j)
      begin
        for(int k = 0; k < byte_count; ++k)
        begin
          trans.set_data(k+j, ((j*byte_count)+k));
          if(((i + j)% 5) == 0)
          begin
            trans.set_byte_type(AXI4STREAM_NULL_BYTE, ((j*byte_count)+k));
          end
          else if(((i + j)% 5) == 1)
          begin
            trans.set_byte_type(AXI4STREAM_POS_BYTE, ((j*byte_count)+k));
          end
          else
          begin
            trans.set_byte_type(AXI4STREAM_DATA_BYTE, ((j*byte_count)+k));
          end
        end  
        bfm.execute_transfer(trans, j, last);
      end
    end

    #100
    $finish();
end
endmodule
