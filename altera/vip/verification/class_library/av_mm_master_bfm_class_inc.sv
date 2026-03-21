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
//      MASTER_NAME                       is used to define part of the unique class name
//      MASTER_HIERARCHICAL_LOCATION      is used to define the hierarchical path to the master in the QSYS system.
//   NOTE: they are undefined at the end of this file!
//   NOTE: the object must be "started" before use

`include "av_mm_class.sv"

import verbosity_pkg::*;

`define IF_NAME(name)          `"name`"

`define create_classname(__prefix, __suffix) __prefix``__suffix
`define AV_MM_MASTER_CLASSNAME `create_classname(av_mm_master_bfm_, `MASTER_NAME)

class `AV_MM_MASTER_CLASSNAME  #(int ADDR_WIDTH = 32, int BYTE_WIDTH = 4, bit USE_BYTE_ENABLE = 1'b0 );                   

    mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) transaction_in_mailbox;
    mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) read_reply_out_mailbox;
    mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) internal_mailbox;
    
    string verbosity_msg = "";
 
    function new(mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) mbox_transaction_in  = null,
                 mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) mbox_read_reply_out  = null);
        if (mbox_transaction_in == null) transaction_in_mailbox = new(0); else transaction_in_mailbox = mbox_transaction_in;
        if (mbox_read_reply_out == null) read_reply_out_mailbox = new(0); else read_reply_out_mailbox = mbox_read_reply_out;
        internal_mailbox = new(0);
    endfunction  

    function mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) get_transaction_mbox_handle();
        return transaction_in_mailbox;
    endfunction
    function mailbox #(av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)) get_read_reply_mbox_handle();
        return read_reply_out_mailbox;
    endfunction

    function void set_response_timeout(input int new_response_timeout);
        `MASTER_HIERARCHICAL_LOCATION.set_response_timeout(new_response_timeout);
    endfunction

    function void set_command_timeout(input int new_command_timeout);
        `MASTER_HIERARCHICAL_LOCATION.set_command_timeout(new_command_timeout);
    endfunction
    
    task start();
        $sformat(verbosity_msg, "Starting BFM master driver %s", `IF_NAME(`MASTER_NAME));
        print(VERBOSITY_INFO, verbosity_msg);
        fork
            transaction_process();
            read_reply_process();
        join_none
    endtask
    
    task transaction_process();
        av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) mm_trans;

        int unsigned cmd;
        int unsigned length;
        longint unsigned addr;

        bit [BYTE_WIDTH-1:0] b_en;
        byte b_en_val;

        forever begin
            // Pull a request out of the mailbox
            transaction_in_mailbox.get(mm_trans);
            `MASTER_HIERARCHICAL_LOCATION.set_command_request((mm_trans.cmd == mm_trans.WRITE) ? avalon_mm_pkg::REQ_WRITE : avalon_mm_pkg::REQ_READ);
            `MASTER_HIERARCHICAL_LOCATION.set_command_address(mm_trans.num_args());
            if (`MASTER_HIERARCHICAL_LOCATION.USE_BURSTCOUNT) begin
                `MASTER_HIERARCHICAL_LOCATION.set_command_burst_count(mm_trans.num_args());
            end
            `MASTER_HIERARCHICAL_LOCATION.set_command_address(mm_trans.addr);
            `MASTER_HIERARCHICAL_LOCATION.set_command_init_latency(0);           // Delay before the command is sent on the bus
				
            if (mm_trans.cmd == av_mm_transaction#(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE)::WRITE) begin
                // Generate a valid transaction and keep burst_count and burst_size in sync
                `MASTER_HIERARCHICAL_LOCATION.set_command_burst_size(mm_trans.num_args());
                `MASTER_HIERARCHICAL_LOCATION.set_command_burst_count(mm_trans.num_args());
                foreach (mm_trans.arguments[i]) begin
                    `MASTER_HIERARCHICAL_LOCATION.set_command_data(mm_trans.arguments[i], i);
                    if (USE_BYTE_ENABLE) begin
                        for (int b = 0; b < BYTE_WIDTH; ++b) begin
                            b_en_val = (mm_trans.byte_enable_length() != 0) ? mm_trans.byte_enable[(i*BYTE_WIDTH + b)%mm_trans.byte_enable_length()] : 8'hFF;
                            b_en[b] = (b_en_val == 8'hFF) ? 1'b1 : 1'b0;
                        end
                        `MASTER_HIERARCHICAL_LOCATION.set_command_byte_enable(b_en, i);
                    end
                    `MASTER_HIERARCHICAL_LOCATION.set_command_idle(0, i);   // Delay before the next beat
                end
            end else begin
               `MASTER_HIERARCHICAL_LOCATION.set_command_burst_size(1);
               `MASTER_HIERARCHICAL_LOCATION.set_command_burst_count(1);
               `MASTER_HIERARCHICAL_LOCATION.set_command_idle(0, 0);   // Delay after the command
               internal_mailbox.put(mm_trans);
			end
			`MASTER_HIERARCHICAL_LOCATION.push_command();
        end  // forever
    endtask
    
    task read_reply_process();
        av_mm_transaction #(ADDR_WIDTH, BYTE_WIDTH, USE_BYTE_ENABLE) mm_trans;

        byte symbol[BYTE_WIDTH];
        bit [BYTE_WIDTH*8-1 : 0] symb;

        forever begin
            // Wait for the next response from the BFM
            if (`MASTER_HIERARCHICAL_LOCATION.get_response_queue_size() == 0) begin
                @(`MASTER_HIERARCHICAL_LOCATION.signal_read_response_complete or `MASTER_HIERARCHICAL_LOCATION.signal_write_response_complete);
            end
            `MASTER_HIERARCHICAL_LOCATION.pop_response();
            
            // Flush a write response and post a read response to the read_reply mailbox
            if (`MASTER_HIERARCHICAL_LOCATION.get_response_request() == avalon_mm_pkg::REQ_READ) begin
                // Pull a read request to service out of the internal mailbox
                assert (internal_mailbox.num() != 0) else
                    $fatal(1, "%d, ERROR: master %s: read response received without a matching request sent", $time(), `IF_NAME(`MASTER_NAME));  // unsollicited response ?

                internal_mailbox.get(mm_trans);
                assert (mm_trans.num_args() == `MASTER_HIERARCHICAL_LOCATION.get_response_burst_size()) else
                    $fatal(1, "%d, ERROR: master %s: read response size (%d) not compatible with the read request sent (%d)", $time(), `IF_NAME(`MASTER_NAME),
                                                        `MASTER_HIERARCHICAL_LOCATION.get_response_burst_size(), mm_trans.num_args());  // response size mismatch?
                
                mm_trans.set_byte_enable_length(0);
                foreach (mm_trans.arguments[i]) begin
                    mm_trans.arguments[i] = `MASTER_HIERARCHICAL_LOCATION.get_response_data(i);
                end

                read_reply_out_mailbox.put(mm_trans);
            end
        end  // forever
    endtask

endclass

`undef IF_NAME
`undef AV_MM_MASTER_CLASSNAME
`undef MASTER_NAME
`undef MASTER_HIERARCHICAL_LOCATION
