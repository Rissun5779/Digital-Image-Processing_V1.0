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

   This is a simple example of an AXI4STREAM monitor to demonstrate the usage of the mgc_axi4stream_monitor BFM. 
    
*/

import mgc_axi4stream_pkg::*;

module monitor_test_program #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024) 
(
    mgc_axi4stream_monitor bfm
);

  initial
  begin
    int i;
    bit last;
    axi4stream_transaction trans;    
    /*******************
    ** Initialisation **
    *******************/
    bfm.wait_on(AXI4STREAM_RESET_POSEDGE);
    bfm.wait_on(AXI4STREAM_CLOCK_POSEDGE);

    // Packet receiving
    forever
    begin
      trans = bfm.create_monitor_transaction();

      i = 0;
      last = 0;
      while(!last)
      begin
        bfm.get_transfer(trans, i, last);
        ++i;
      end  
      trans.print();
    end
  end

endmodule

