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



//  The following must be defined before including this class :
// `MASTER
// `MASTER_HIERARCHY_NAME


`define CLASSNAME c_av_mm_control_bfm_`MASTER

class `CLASSNAME #(int unsigned AV_ADDRESS_W = 32, int unsigned AV_DATA_W = 32) extends c_av_mm_control_base #(.AV_ADDRESS_W(AV_ADDRESS_W), .AV_DATA_W(AV_DATA_W));

event transactions_started;
mailbox #(c_av_mm_control_register) m_response = new(0);

int transactions_outstanding;

// The constructor 'connects' the output mailbox to the object's mailbox :
function new(mailbox #(c_av_mm_control_register) m_register, mailbox #(c_av_mm_control_register) m_readdata);
    super.new(m_register, m_readdata);
endfunction

task start;
    transactions_outstanding = 0;

    wait (`MASTER_HIERARCHY_NAME.reset == 0)

    `MASTER_HIERARCHY_NAME.init();

    fork
        get_responses();
        send_control();
    join

endtask

task send_control;
    forever
    begin
        // Local objects :
        c_av_mm_control_register register_item;

        // Pull a register update out of the mailbox  :
        this.m_register_items.get(register_item);
        if(register_item.use_event) begin
           // $display("%t %s Wait for the events address = %0d data = %0h",$time, name, register_item.address, register_item.value);
            fork
                begin : wait_events_isolating_thread
                    for(int i = 0; i < register_item.trigger.size(); i++) begin : wait_loop
                        automatic int trigger_no = i;
                        if(register_item.trigger_enable[trigger_no]) begin
                            fork begin
                                wait(register_item.trigger[trigger_no]);
                             //   $display("%t %s Trigger number %d of %d fired ",$time, name, trigger_no, register_item.trigger.size());
                            end
                            join_none;
                        end
                    end : wait_loop
                    wait fork;
                end : wait_events_isolating_thread;
            join;
        end

       // $display("%t    CONTROL : %s Sending command, write = %0d, address = %0d data = %0h use_event = %0d ",$time, name, register_item.write, register_item.address, register_item.value, register_item.use_event);

        `MASTER_HIERARCHY_NAME.set_command_init_latency(register_item.init_latency);

        if(register_item.write) begin
            `MASTER_HIERARCHY_NAME.set_command_request(REQ_WRITE);
            `MASTER_HIERARCHY_NAME.set_command_byte_enable(255,0);
            `MASTER_HIERARCHY_NAME.set_command_data(register_item.value, 0);
        end else
        begin
            `MASTER_HIERARCHY_NAME.set_command_request(REQ_READ);
            `MASTER_HIERARCHY_NAME.set_command_byte_enable(0,0);
            m_response.put(register_item);
        end

        `MASTER_HIERARCHY_NAME.set_command_address(register_item.address);
        `MASTER_HIERARCHY_NAME.set_command_burst_count(1); //todo confirm this is always ok
        `MASTER_HIERARCHY_NAME.set_command_burst_size(1); //todo confirm this is always ok

        `MASTER_HIERARCHY_NAME.push_command();

        transactions_outstanding++;

        ->transactions_started;
    end
endtask

task get_responses();
    forever
    begin
        c_av_mm_control_register register_item;

        @(`MASTER_HIERARCHY_NAME.signal_response_complete);

        `MASTER_HIERARCHY_NAME.pop_response();

        if(`MASTER_HIERARCHY_NAME.get_response_request() == REQ_READ) begin
            m_response.get(register_item);
            register_item.value = `MASTER_HIERARCHY_NAME.get_response_data(0);
            m_readdata.put(register_item);
           // $display("%t    CONTROL : %s Receiving read reply = %0d for read at %d", $time, name, register_item.value, register_item.address);
        end

        transactions_outstanding--;
    end
endtask

task wait_for_transactions_to_start();
    wait(transactions_started);
endtask

task wait_for_transactions_to_complete();
    wait(transactions_outstanding == 0);
endtask

endclass

`undef CLASSNAME
`undef MASTER
`undef MASTER_HIERARCHY_NAME
