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



//////// BFM driver classes and mailboxes ///////

// mm slave to handle reads from frame buffer :
`define IF_MEM_MASTER_RD
`define SLAVE_NAME                              mm_slave_bfm_for_vfb_reads
`define SLAVE_HIERARCHICAL_LOCATION             testbench.mm_slave_bfm_for_vfb_reads
`include "av_mm_slave_bfm_class_inc.sv"
av_mm_slave_bfm_mm_slave_bfm_for_vfb_reads #(32,  32/8, 0) slave_bfm_mm_slave_bfm_for_vfb_reads;
mailbox #(av_mm_transaction #(32,  32/8, 0)) mbox_slave_bfm_mem_master_rd_drv;
mailbox #(av_mm_transaction #(32,  32/8, 0)) mbox_slave_bfm_mem_master_rd_reply_drv;
initial begin
    mbox_slave_bfm_mem_master_rd_drv           = new(0);
    mbox_slave_bfm_mem_master_rd_reply_drv     = new(0);
    slave_bfm_mm_slave_bfm_for_vfb_reads       = new(mbox_slave_bfm_mem_master_rd_drv, mbox_slave_bfm_mem_master_rd_reply_drv);
end
`undef IF_MEM_MASTER_RD
`undef SLAVE_NAME                              
`undef SLAVE_HIERARCHICAL_LOCATION             

// mm slave to handle writes from frame buffer :
`define IF_MEM_MASTER_WR
`define SLAVE_NAME                              mm_slave_bfm_for_vfb_writes
`define SLAVE_HIERARCHICAL_LOCATION             testbench.mm_slave_bfm_for_vfb_writes
`include "av_mm_slave_bfm_class_inc.sv"
av_mm_slave_bfm_mm_slave_bfm_for_vfb_writes #(32,  32/8, 0) slave_bfm_mm_slave_bfm_for_vfb_writes;
mailbox #(av_mm_transaction #(32,  32/8, 0)) mbox_slave_bfm_mem_master_wr_drv;
mailbox #(av_mm_transaction #(32,  32/8, 0)) mbox_slave_bfm_mem_master_wr_reply_drv;
initial begin
    mbox_slave_bfm_mem_master_wr_drv           = new(0);
    mbox_slave_bfm_mem_master_wr_reply_drv     = new(0);
    slave_bfm_mm_slave_bfm_for_vfb_writes      = new(mbox_slave_bfm_mem_master_wr_drv,mbox_slave_bfm_mem_master_wr_reply_drv);
end
`undef IF_MEM_MASTER_RD
`undef SLAVE_NAME                              
`undef SLAVE_HIERARCHICAL_LOCATION    






//bfm_control_drv is an object of the unique class c_av_mm_control_bfm_control_drv - unique because
//it has the MASTER_HIERARCHY_NAME baked into it :
`define MASTER                                  mixer_control_drv
`define MASTER_HIERARCHY_NAME                   testbench.mm_master_bfm_for_mixer_control
`include "av_mm_control_bfm_class.sv"
c_av_mm_control_bfm_mixer_control_drv    bfm_mixer_control_drv;
mailbox #(c_av_mm_control_register) m_register_items_for_mixer_control_bfm = new(0);
mailbox #(c_av_mm_control_register) m_readdata_from_mixer_control_bfm = new(0);
initial begin
    bfm_mixer_control_drv               = new(m_register_items_for_mixer_control_bfm, m_readdata_from_mixer_control_bfm);
    bfm_mixer_control_drv.set_name("system_inst_mixer_control_bfm");
end
`undef MASTER
`undef MASTER_HIERARCHY_NAME

//bfm_control_drv is an object of the unique class c_av_mm_control_bfm_control_drv - unique because
//it has the MASTER_HIERARCHY_NAME baked into it :
`define MASTER                                  vfb_control_drv
`define MASTER_HIERARCHY_NAME                   testbench.mm_master_bfm_for_vfb_control
`include "av_mm_control_bfm_class.sv"
c_av_mm_control_bfm_vfb_control_drv     bfm_vfb_control_drv;
mailbox #(c_av_mm_control_register) m_register_items_for_vfb_control_bfm = new(0);
mailbox #(c_av_mm_control_register) m_readdata_from_vfb_control_bfm = new(0);
initial begin
    bfm_vfb_control_drv                = new(m_register_items_for_vfb_control_bfm, m_readdata_from_vfb_control_bfm);
    bfm_vfb_control_drv.set_name("system_inst_vfb_control_bfm");
end
`undef MASTER
`undef MASTER_HIERARCHY_NAME





// This creates a class with a names specific to `SOURCE0, which is needed because the
// class calls functions for that specific `SOURCE0.  A class is used so that individual mailboxes
// can be easily associated with individual sources/sinks :


// Video SOURCE bus functional model :
// declares an object of name `SOURCE of class av_st_video_source_bfm_`SOURCE :
`define SOURCE st_source_bfm_0 
`define SOURCE_STR "st_source_bfm_0"
`define SOURCE_HIERARCHY_NAME `TESTBENCH.`SOURCE
`include "av_st_video_source_bfm_class.sv"
`define SOURCE st_source_bfm_0 
`define CLASSNAME c_av_st_video_source_bfm_`SOURCE
`CLASSNAME `SOURCE;
`undef CLASSNAME



// Video SINK bus functional model :
// Create an object of name `SINK of class av_st_video_sink_bfm_`SINK :
`define SINK st_sink_bfm_0 
`define SINK_STR "st_sink_bfm_0"
`define SINK_HIERARCHY_NAME `TESTBENCH.`SINK
`include "av_st_video_sink_bfm_class.sv"
`define SINK st_sink_bfm_0 
`define CLASSNAME c_av_st_video_sink_bfm_`SINK
`CLASSNAME `SINK;
`undef CLASSNAME


// 1x1 array of mailboxes
mailbox #(c_av_st_video_item) m_video_items_for_src_bfm[1][1];
mailbox #(c_av_st_video_item) m_video_items_for_sink_bfm[1][1];


initial
begin

    m_video_items_for_src_bfm[0][0] = new(0); //construct mailbox array element (0,0)
    st_source_bfm_0 = new (m_video_items_for_src_bfm[0]); // Construct our BFM driver object, passing it the 1D mailbox element array handle

    m_video_items_for_sink_bfm[0][0]        = new(0); // Construct unlimited size mailbox 
    st_sink_bfm_0  = new(m_video_items_for_sink_bfm[0]); // Construct our BFM driver object, passing it the 1D mailbox element array  handle

end    

// Now create file I/O objects to read and write :
`ifdef QUESTA
c_av_st_video_file_io #(`BITS_PER_CHANNEL, `CHANNELS_PER_PIXEL) video_file_reader;
c_av_st_video_file_io #(`BITS_PER_CHANNEL, `CHANNELS_PER_PIXEL) video_file_writer;
`endif