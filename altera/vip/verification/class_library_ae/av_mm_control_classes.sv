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


`ifndef _ALT_VIP_CONTROL_CLASSES_
`define _ALT_VIP_CONTROL_CLASSES_

package av_mm_control_classes;

class c_av_mm_control_register;
    
    bit write;
    int unsigned address;
    int unsigned value;
    int unsigned init_latency;
    bit use_event;
    event trigger[];
    bit trigger_enable[];
    
    function new(int unsigned no_of_triggers);
        if(no_of_triggers > 0) begin
            trigger = new[no_of_triggers];
            trigger_enable = new[no_of_triggers];
        end
        use_event = 0;
        init_latency = 0;
    endfunction
    
    function void copy(c_av_mm_control_register c);
        write = c.write;
        address = c.address;
        value = c.value;
        use_event = c.use_event;
        init_latency = c.init_latency;
        for(int i = 0; i < trigger.size(); i++) begin
            trigger[i] = c.trigger[i];
            trigger_enable[i] = c.trigger_enable[i];
        end
    endfunction : copy;

endclass

class c_av_mm_control_base #(int unsigned AV_ADDRESS_W = 32, int unsigned AV_DATA_W = 32);
    
    string name = "undefined";
    mailbox #(c_av_mm_control_register) m_register_items;
    mailbox #(c_av_mm_control_register) m_readdata;
    
    int idleness_probability = 50;
    
    function new(mailbox #(c_av_mm_control_register) m_register, mailbox #(c_av_mm_control_register) m_readdata);
        this.m_register_items = m_register;
        this.m_readdata = m_readdata;
    endfunction
    
    function void set_name(string s);
        this.name = s;
    endfunction : set_name

    function string get_name();
        return name;
    endfunction : get_name
    
    function void set_idleness_probability(int percentage);
        this.idleness_probability = percentage;
    endfunction
    
endclass
    
endpackage : av_mm_control_classes
`endif
