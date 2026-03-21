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
    This is a simple example of an AXI4STREAM Slave to demonstrate the mgc_axi4stream_slave BFM usage. 
*/


import mgc_axi4stream_pkg::*;

module slave_test_program #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024)
(
    mgc_axi4stream_slave bfm
);

  /////////////////////////////////////////////////
  // Code user could edit according to requirements
  /////////////////////////////////////////////////

  // This member controls the wait insertion in axi4 stream transfers coming from master.
  // Making ~m_insert_wait~ to 0 truns off the wait insertion.
  bit m_insert_wait = 1;

  // Task : ready_delay
  // This is used to set ready delay to extend the transfer
  task ready_delay();
    // Making TREADY '0'. This will consume one cycle.
    bfm.execute_stream_ready(0);
    // Two clock cycle wait. In total 3 clock wait.
    repeat(2) bfm.wait_on(AXI4STREAM_CLOCK_POSEDGE);
    // Making TREADY '1'.
    bfm.execute_stream_ready(1);
  endtask

  ///////////////////////////////////////////////////////////////////////
  // Code user do not need to edit
  ///////////////////////////////////////////////////////////////////////
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
      trans = bfm.create_slave_transaction();
      i = 0;
      last = 0;
      while(!last)
      begin
        if(m_insert_wait)
        begin
          ready_delay();
        end  
        bfm.get_transfer(trans, i, last);
        ++i;
      end
    end
  end

endmodule

