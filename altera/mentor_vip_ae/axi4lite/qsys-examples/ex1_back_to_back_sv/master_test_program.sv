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
    This is a simple example of an AXI4 master to demonstrate the mgc_axi4_master BFM configured as axi4lite usage. 

    This master performs a directed test, initiating 4 sequential writes, followed by 4 sequential reads. It then verifies that the data read out matches the data written.

*/

import mgc_axi4_pkg::*;
module master_test_program #(int AXI4_ADDRESS_WIDTH = 32, int AXI4_RDATA_WIDTH = 1024, int AXI4_WDATA_WIDTH = 1024)
(
    mgc_axi4_master bfm
);

  // Enum type for master ready delay mode
  // AXI4_VALID2READY - Ready delay for a phase will be applied from
  //                    start of phase (Means from when VALID is asserted).
  // AXI4_TRANS2READY - Ready delay will be applied from the end of
  //                    previous phase. This might result in ready before valid.
  typedef enum bit
  {
    AXI4_VALID2READY = 1'b0,
    AXI4_TRANS2READY = 1'b1
  } axi4_master_ready_delay_mode_e;

  /////////////////////////////////////////////////
  // Code user could edit according to requirements
  /////////////////////////////////////////////////

  // Variable : m_wr_resp_phase_ready_delay
  int m_wr_resp_phase_ready_delay = 2;

  // Variable : m_rd_data_phase_ready_delay
  int m_rd_data_phase_ready_delay = 2;

  // Master ready delay mode seclection : default it is VALID2READY
  axi4_master_ready_delay_mode_e master_ready_delay_mode = AXI4_VALID2READY;

initial
begin
    axi4_transaction trans;
    bit [AXI4_WDATA_WIDTH-1:0] data_word;

    /*******************
    ** Initialisation **
    *******************/
    bfm.wait_on(AXI4_RESET_0_TO_1);
    bfm.wait_on(AXI4_CLOCK_POSEDGE);

    /*******************
    ** **
    *******************/
    fork
      handle_write_resp_ready;
      handle_read_data_ready;
    join_none

    /************************
    ** Traffic generation: **
    ************************/    
    // 4 x Writes
    // Write data value 1 on byte lanes 1 to address 1.
    trans = bfm.create_write_transaction(1);
    trans.set_data_words(32'h0000_0100,0);
    trans.set_write_strobes(4'b0010,0);
    $display ( "@ %t, master_test_program: Writing data (1) to address (1)", $time);    

    // By default it will run in Blocking mode 
    bfm.execute_transaction(trans); 
    
    // Write data value 2 on byte lane 2 to address 2.
    trans = bfm.create_write_transaction(2);
    trans.set_data_words(32'h0002_0000,0);
    trans.set_write_strobes(4'b0100,0);
    $display ( "@ %t, master_test_program: Writing data (2) to address (2)", $time);        

    bfm.execute_transaction(trans);

    // Write data value 3 on byte lane 3 to address 3.
    trans = bfm.create_write_transaction(3);
    trans.set_data_words(32'h0300_0000,0);
    trans.set_write_strobes(4'b1000,0);
    $display ( "@ %t, master_test_program: Writing data (3) to address (3)", $time);        

    bfm.execute_transaction(trans);
    
    // Write data value 4 to address 0 on byte lane 0.
    trans = bfm.create_write_transaction(0);
    trans.set_data_words(32'h0000_0004,0);
    trans.set_write_strobes(4'b0001,0);
    $display ( "@ %t, master_test_program: Writing data (4) to address (0)", $time);        

    bfm.execute_transaction(trans);

    // 4 x Reads
    // Read data from address 1.
    trans = bfm.create_read_transaction(1);

    bfm.execute_transaction(trans);
    data_word = trans.get_data_words();
    if (data_word[15:8] == 8'h01)
        $display ( "@ %t, master_test_program: Read correct data (1) at address (1)", $time);
    else
        $display ( "@ %t master_test_program: Error: Expected data (1) at address 1, but got %d", $time, data_word[15:8]);

    // Read data from address 2. 
    trans = bfm.create_read_transaction(2);

    bfm.execute_transaction(trans);
    data_word = trans.get_data_words();
    if (data_word[23:16] == 8'h02)
        $display ( "@ %t, master_test_program: Read correct data (2) at address (2)", $time);
    else
        $display ( "@ %t, master_test_program: Error: Expected data (2) at address 2, but got %d", $time, data_word[23:16]);
    
    // Read data from address 3.
    trans = bfm.create_read_transaction(3);

    bfm.execute_transaction(trans);
    data_word = trans.get_data_words();
    if (data_word[31:24] == 8'h03)
      $display ( "@ %t, master_test_program: Read correct data (3) at address (3)", $time);
    else
        $display ( "@ %t, master_test_program: Error: Expected data (3) at address 3, but got %d", $time, data_word[31:24]);

    // Read data from address 4.
    trans = bfm.create_read_transaction(0);

    bfm.execute_transaction(trans);
    data_word = trans.get_data_words();
    if (data_word[7:0] == 8'h04)
        $display ( "@ %t, master_test_program: Read correct data (4) at address (0)", $time);
    else
        $display ( "@ %t, master_test_program: Error: Expected data (4) at address 0, but got %d", $time, data_word[7:0]);

    #100
    $finish();
end

  // Task : handle_write_resp_ready
  // This method assert/de-assert the write response channel ready signal.
  // Assertion and de-assertion is done based on following variable's value:
  // m_wr_resp_phase_ready_delay
  // master_ready_delay_mode
  task automatic handle_write_resp_ready;
    bit seen_valid_ready;

    int tmp_ready_delay;
    axi4_master_ready_delay_mode_e tmp_mode;

    forever
    begin
      wait(m_wr_resp_phase_ready_delay > 0);
      tmp_ready_delay = m_wr_resp_phase_ready_delay;
      tmp_mode        = master_ready_delay_mode;

      if (tmp_mode == AXI4_VALID2READY)
      begin
        fork
          bfm.execute_write_resp_ready(1'b0);
        join_none

        bfm.get_write_response_cycle;
        repeat(tmp_ready_delay - 1) bfm.wait_on(AXI4_CLOCK_POSEDGE);
  
        bfm.execute_write_resp_ready(1'b1);
        seen_valid_ready = 1'b1;
      end
      else  // AXI4_TRANS2READY
      begin
        if (seen_valid_ready == 1'b0)
        begin
          do
            bfm.wait_on(AXI4_CLOCK_POSEDGE);
          while (!((bfm.BVALID === 1'b1) && (bfm.BREADY === 1'b1)));
        end

        fork
          bfm.execute_write_resp_ready(1'b0);
        join_none

        repeat(tmp_ready_delay) bfm.wait_on(AXI4_CLOCK_POSEDGE);

        fork
          bfm.execute_write_resp_ready(1'b1);
        join_none
        seen_valid_ready = 1'b0;
      end
    end
  endtask

  // Task : handle_read_data_ready
  // This method assert/de-assert the read data/response channel ready signal.
  // Assertion and de-assertion is done based on following variable's value:
  // m_rd_data_phase_ready_delay
  // master_ready_delay_mode
  task automatic handle_read_data_ready;
    bit seen_valid_ready;

    int tmp_ready_delay;
    axi4_master_ready_delay_mode_e tmp_mode;

    forever
    begin
      wait(m_rd_data_phase_ready_delay > 0);
      tmp_ready_delay = m_rd_data_phase_ready_delay;
      tmp_mode        = master_ready_delay_mode;

      if (tmp_mode == AXI4_VALID2READY)
      begin
        fork
          bfm.execute_read_data_ready(1'b0);
        join_none

        bfm.get_read_data_cycle;
        repeat(tmp_ready_delay - 1) bfm.wait_on(AXI4_CLOCK_POSEDGE);
  
        bfm.execute_read_data_ready(1'b1);
        seen_valid_ready = 1'b1;
      end
      else  // AXI4_TRANS2READY
      begin
        if (seen_valid_ready == 1'b0)
        begin
          do
            bfm.wait_on(AXI4_CLOCK_POSEDGE);
          while (!((bfm.RVALID === 1'b1) && (bfm.RREADY === 1'b1)));
        end

        fork
          bfm.execute_read_data_ready(1'b0);
        join_none

        repeat(tmp_ready_delay) bfm.wait_on(AXI4_CLOCK_POSEDGE);

        fork
          bfm.execute_read_data_ready(1'b1);
        join_none
        seen_valid_ready = 1'b0;
      end
    end
  endtask

endmodule
