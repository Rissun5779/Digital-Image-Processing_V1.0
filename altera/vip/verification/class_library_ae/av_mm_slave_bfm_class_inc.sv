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


// This file is intended to be `included after having set 2 `defines to specialise the name of the class based on the HIERARCHICAL location it is being used to talk to...
//   The required `defines are:
//      SLAVE_NAME                       is used to define part of the unique class name
//      SLAVE_HIERARCHICAL_LOCATION      is used to define the hierarchical path to the source in the QSYS system.
//   NOTE: they are undefined at the end of this file!
//   NOTE: the object must be "started" before use

`include "av_mm_class.sv"

import avalon_mm_pkg::*;

`define IF_NAME(name)          `"name`"

`define create_classname(__prefix, __suffix) __prefix``__suffix
`define AV_MM_SLAVE_CLASSNAME `create_classname(av_mm_slave_bfm_, `SLAVE_NAME)

class `AV_MM_SLAVE_CLASSNAME  #(int ADDR_WIDTH = 32, int BYTE_WIDTH = 4, bit USE_BYTE_ENABLE = 1'b0);

    mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) transaction_out_mailbox;
    mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) read_reply_in_mailbox;

    string verbosity_msg = "";

    function new(mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) mbox_transaction_out  = null,
                 mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) mbox_read_reply_in  = null);
        if (mbox_transaction_out == null) transaction_out_mailbox = new(0); else transaction_out_mailbox = mbox_transaction_out;
        if (mbox_read_reply_in == null) read_reply_in_mailbox = new(0); else read_reply_in_mailbox = mbox_read_reply_in;
    endfunction
    
    function mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) get_transaction_mbox_handle();
        return transaction_out_mailbox;
    endfunction
    function mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) get_read_reply_mbox_handle();
        return read_reply_in_mailbox;
    endfunction


    function void set_response_timeout(input int new_response_timeout);
        `SLAVE_HIERARCHICAL_LOCATION.set_response_timeout(new_response_timeout);
    endfunction
    
    task start();
        $sformat(verbosity_msg, "Starting BFM slave driver %s", `IF_NAME(`SLAVE_NAME));
        print(VERBOSITY_INFO, verbosity_msg);
        fork
            transaction_process();
            read_reply_process();
        join_none
    endtask
 

    // Start the monitor and leave it running
    task transaction_process();
        import avalon_mm_pkg::*;
        import avalon_utilities_pkg::*;

        av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) mm_trans;
        
        av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::Cmd cmd;

        bit [BYTE_WIDTH-1:0] b_en;
        
        `SLAVE_HIERARCHICAL_LOCATION.set_command_transaction_mode(0); // consolidates write burst commands into a single command transaction
        `SLAVE_HIERARCHICAL_LOCATION.set_idle_state_waitrequest_configuration(LOW);


        forever begin
            // set backpressure cycles for next command
            for (int i = 0; i < `SLAVE_HIERARCHICAL_LOCATION.MAX_BURST_SIZE; i++) begin
                `SLAVE_HIERARCHICAL_LOCATION.set_interface_wait_time(0, i);
            end
        
            // Stall until we actually get a transaction
            @(`SLAVE_HIERARCHICAL_LOCATION.signal_command_received);

            // Get the new transaction from the model
            `SLAVE_HIERARCHICAL_LOCATION.pop_command();

            mm_trans = new(`SLAVE_HIERARCHICAL_LOCATION.get_command_burst_count());
            cmd = (`SLAVE_HIERARCHICAL_LOCATION.get_command_request() == avalon_mm_pkg::REQ_WRITE) ? av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::WRITE :
                                                                                                                   av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::READ;

            mm_trans.set_cmd(cmd);
            mm_trans.set_address(`SLAVE_HIERARCHICAL_LOCATION.get_command_address());
            mm_trans.set_num_args(`SLAVE_HIERARCHICAL_LOCATION.get_command_burst_count());
            if (cmd == av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::WRITE) begin
                //if (`SLAVE_HIERARCHICAL_LOCATION.get_command_burst_count() != `SLAVE_HIERARCHICAL_LOCATION.get_command_count_size()) begin
                //    $display("%d, ERROR: slave %s: write command size (%d) did not match the announced burst size (%d)\n", $time(), `IF_NAME(`SLAVE_NAME),
                //                                       `SLAVE_HIERARCHICAL_LOCATION.get_command_count_size() != `SLAVE_HIERARCHICAL_LOCATION.get_command_burst_count());  // HDL error... not handled here
                //    $stop();
                //end
                
                if (USE_BYTE_ENABLE) begin
                    mm_trans.set_byte_enable_length(mm_trans.num_args()*BYTE_WIDTH);
                end

                foreach (mm_trans.arguments[i]) begin
                    mm_trans.arguments[i] = `SLAVE_HIERARCHICAL_LOCATION.get_command_data(i);
                    if (USE_BYTE_ENABLE) begin
                        b_en = `SLAVE_HIERARCHICAL_LOCATION.get_command_byte_enable(i);
                        for (int b = 0; b < BYTE_WIDTH; ++b) begin
                            mm_trans.byte_enable[i*BYTE_WIDTH + b] = b_en[b] ? 8'hFF : 8'h00;
                        end
                    end
                end
            end else begin
                foreach (mm_trans.arguments[i]) begin
                    mm_trans.arguments[i] = 0;
                end
            end
            transaction_out_mailbox.put(mm_trans);
        end
    endtask

    task read_reply_process();
        av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) mm_trans;
        
        forever begin
            // Pull a read reply out of the mailbox
            read_reply_in_mailbox.get(mm_trans);
            
            assert (mm_trans.cmd == av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::READ) else
                $fatal(1, "Invalid Av-MM transaction in the $s read_reply mailbox: TEST_FAIL", `IF_NAME(`SLAVE_NAME));

            `SLAVE_HIERARCHICAL_LOCATION.set_response_request(avalon_mm_pkg::REQ_READ);
            `SLAVE_HIERARCHICAL_LOCATION.set_response_burst_size(mm_trans.num_args());
            foreach (mm_trans.arguments[i]) begin
                `SLAVE_HIERARCHICAL_LOCATION.set_response_data(mm_trans.arguments[i], i);
                `SLAVE_HIERARCHICAL_LOCATION.set_response_latency(0, i);  // Delay between beats
                `SLAVE_HIERARCHICAL_LOCATION.set_interface_wait_time(0, i);  // Delay between beats
            end
            `SLAVE_HIERARCHICAL_LOCATION.push_response();
            
            @(`SLAVE_HIERARCHICAL_LOCATION.signal_response_issued);
        end
    endtask 
endclass

`undef IF_NAME
`undef AV_MM_SLAVE_CLASSNAME
`undef SLAVE_NAME
`undef SLAVE_HIERARCHICAL_LOCATION
