# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.




package provide altera_pcie_s10_hip_avmm_bridge::fileset 18.1

package require alt_xcvr::ip_tcl::ip_module
package require altera_pcie_s10_hip_avmm_bridge::parameters

package require altera_terp

namespace eval ::altera_pcie_s10_hip_avmm_bridge::fileset:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_filesets \
    declare_files

  variable filesets

  set filesets {\
    { NAME            TYPE            CALLBACK                                                                     TOP_LEVEL    }\
    { quartus_synth   QUARTUS_SYNTH   ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_quartus_synth    altera_pcie_s10_hip_avmm_bridge  }\
    { sim_verilog     SIM_VERILOG     ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_sim_verilog      altera_pcie_s10_hip_avmm_bridge  }\
    { sim_vhdl        SIM_VHDL        ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_sim_vhdl         altera_pcie_s10_hip_avmm_bridge  }\
    { example_design  EXAMPLE_DESIGN  ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_example_design   altera_pcie_s10_hip_avmm_bridge  }\
  }

}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::declare_filesets {} {
   variable filesets
   declare_tb_partner
   ip_declare_filesets $filesets
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::declare_tb_partner {} {
   set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_s10_tbed
   set_module_assignment testbench.partner.pcie_tb.version 18.1
   set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial
}






proc ::altera_pcie_s10_hip_avmm_bridge::fileset::avmm_synth_fileset_list {} {
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   set altera_pcie_s10_avst_sch_files {
      "altera_pcie_s10_avst_sch.sv"
      "altera_pcie_s10_avst_sch_delay.sv"
      "altera_pcie_s10_avst_sch_rx.sv"
      "altera_pcie_s10_avst_sch_rx_hipif.sv"
      "altera_pcie_s10_avst_sch_rx_obuf.sv"
      "altera_pcie_s10_avst_sch_rx_obuf_mlab.sv"
      "altera_pcie_s10_avst_sch_rx_parser.sv"
      "altera_pcie_s10_avst_sch_rxtag_obuf.sv"
      "altera_pcie_s10_avst_sch_rxtag_obuf_mlab.sv"
      "altera_pcie_s10_avst_sch_tx.sv"
      "altera_pcie_s10_avst_sch_tx_hipif.sv"
      "altera_pcie_s10_avst_sch_tx_ibuf.sv"
      "altera_pcie_s10_avst_sch_tx_ibuf_mlab.sv"
      "altera_pcie_s10_avst_sch_txsch.sv"
      "altera_pcie_s10_avst_sch_txsch_rd.sv"
      "altera_pcie_s10_avst_sch_txsch_wr.sv"
      "altera_pcie_s10_avst_sch_tx_ptr_mngr.sv"
      "altera_pcie_s10_avst_sch_rx_ptr_mngr.sv"
      "altera_pcie_s10_avst_sch_rx_ibuf.sv"
   }

   set altera_pcie_s10_writedatamover_files {
      "altera_pcie_s10_avmmread.sv"
      "altera_pcie_s10_descriptorcontrol.sv"
      "altera_pcie_s10_headeralign.sv"
      "altera_pcie_s10_mps.sv"
      "altera_pcie_s10_payloadalign.sv"
      "altera_pcie_s10_pciecommandsize.sv"
      "altera_pcie_s10_pcietxstreaming.sv"
      "altera_pcie_s10_pciewritecontrol.sv"
      "altera_pcie_s10_pciewritecontrol_pipe.sv"
      "altera_pcie_s10_pciewritecontrol_top.sv"
      "altera_pcie_s10_pciewritedescriptor.sv"
      "altera_pcie_s10_sclkfifo.sv"
      "altera_pcie_s10_spaceavailableflag.sv"
      "altera_pcie_s10_writedatamover.sv"
      "altera_pcie_s10_pciewritecontrol_command.sv"
   }

   set altera_pcie_s10_readdatamover_files {
      "altera_pcie_s10_readdatamover.sv"
   }


   set altera_pcie_s10_dma_controller_files {
      "altera_pcie_s10_dma_controller.sv"
      "altera_pcie_s10_dynamic_control.sv"
   }

   set altera_pcie_s10_cra_files {
      "altera_pcie_s10_attreg.sv"
      "altera_pcie_s10_cfgreg.sv"
      "altera_pcie_s10_cra.sv"
      "altera_pcie_s10_ctrlstatus_avmmread.sv"
      "altera_pcie_s10_ctrlstatus_avmmwrite.sv"
      "altera_pcie_s10_intren.sv"
      "altera_pcie_s10_intrstatus.sv"
      "altera_pcie_s10_mail_box.sv"
   }

   set altera_pcie_s10_rxm_files {
      "altera_pcie_s10_rxm.sv"
   }

   set altera_pcie_s10_hprxm_files {
      "altera_pcie_s10_fifo.sv"
      "altera_pcie_s10_hprxm.sv"
      "altera_pcie_s10_hprxm_cpl.sv"
      "altera_pcie_s10_hprxm_rdwr.sv"
      "altera_pcie_s10_hprxm_txctrl.sv"
   }

   set altera_pcie_s10_txs_files {
      "altera_pcie_s10_txs.sv"
   }

   set altera_pcie_s10_hptxs_files {
      "altera_pcie_s10_hptxs.sv"
   }

   set components_files {
      "altera_pcie_s10_int_controller.v"
      "altera_pcie_s10_reset_sync.v"
   }

   set top_level_files {
      "altera_pcie_s10_hip_avmm_bridge.v"
      "altera_pcie_s10_avmm_bridge_dcore.v"
   }





   foreach vf $altera_pcie_s10_avst_sch_files {
      add_fileset_file  altera_pcie_s10_avst_sch/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_avst_sch/$vf
   }
   foreach vf $altera_pcie_s10_writedatamover_files {
      add_fileset_file  altera_pcie_s10_writedatamover/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_writedatamover/$vf
   }
   foreach vf $altera_pcie_s10_readdatamover_files {
      add_fileset_file  altera_pcie_s10_readdatamover/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_readdatamover/$vf
   }
   foreach vf $altera_pcie_s10_dma_controller_files {
      add_fileset_file  altera_pcie_s10_dma_controller/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/$vf
   }
   foreach vf $altera_pcie_s10_cra_files {
      add_fileset_file  altera_pcie_s10_cra/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_cra/$vf
   }
   foreach vf $altera_pcie_s10_rxm_files {
      add_fileset_file  altera_pcie_s10_rxm/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_rxm/$vf
   }
   foreach vf $altera_pcie_s10_hprxm_files {
      add_fileset_file  altera_pcie_s10_hprxm/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_hprxm/$vf
   }
   foreach vf $altera_pcie_s10_txs_files {
      add_fileset_file  altera_pcie_s10_txs/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_txs/$vf
   }
   foreach vf $altera_pcie_s10_hptxs_files {
      add_fileset_file  altera_pcie_s10_hptxs/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_hptxs/$vf
   }
   foreach vf $components_files {
      add_fileset_file  components/$vf   VERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/components/$vf
   }
   foreach vf $top_level_files {
      add_fileset_file  $vf   VERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/$vf
   }

}



proc ::altera_pcie_s10_hip_avmm_bridge::fileset::avmm_sim_encrypt_fileset_list {} {
   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   set altera_pcie_s10_avst_sch_files {
      "altera_pcie_s10_avst_sch.sv"
      "altera_pcie_s10_avst_sch_delay.sv"
      "altera_pcie_s10_avst_sch_rx.sv"
      "altera_pcie_s10_avst_sch_rx_hipif.sv"
      "altera_pcie_s10_avst_sch_rx_obuf.sv"
      "altera_pcie_s10_avst_sch_rx_obuf_mlab.sv"
      "altera_pcie_s10_avst_sch_rx_parser.sv"
      "altera_pcie_s10_avst_sch_rxtag_obuf.sv"
      "altera_pcie_s10_avst_sch_rxtag_obuf_mlab.sv"
      "altera_pcie_s10_avst_sch_tx.sv"
      "altera_pcie_s10_avst_sch_tx_hipif.sv"
      "altera_pcie_s10_avst_sch_tx_ibuf.sv"
      "altera_pcie_s10_avst_sch_tx_ibuf_mlab.sv"
      "altera_pcie_s10_avst_sch_txsch.sv"
      "altera_pcie_s10_avst_sch_txsch_rd.sv"
      "altera_pcie_s10_avst_sch_txsch_wr.sv"
      "altera_pcie_s10_avst_sch_tx_ptr_mngr.sv"
      "altera_pcie_s10_avst_sch_rx_ptr_mngr.sv"
      "altera_pcie_s10_avst_sch_rx_ibuf.sv"
   }

   set altera_pcie_s10_writedatamover_files {
      "altera_pcie_s10_avmmread.sv"
      "altera_pcie_s10_descriptorcontrol.sv"
      "altera_pcie_s10_headeralign.sv"
      "altera_pcie_s10_mps.sv"
      "altera_pcie_s10_payloadalign.sv"
      "altera_pcie_s10_pciecommandsize.sv"
      "altera_pcie_s10_pcietxstreaming.sv"
      "altera_pcie_s10_pciewritecontrol.sv"
      "altera_pcie_s10_pciewritecontrol_pipe.sv"
      "altera_pcie_s10_pciewritecontrol_top.sv"
      "altera_pcie_s10_pciewritedescriptor.sv"
      "altera_pcie_s10_sclkfifo.sv"
      "altera_pcie_s10_spaceavailableflag.sv"
      "altera_pcie_s10_writedatamover.sv"
      "altera_pcie_s10_pciewritecontrol_command.sv"
   }

   set altera_pcie_s10_readdatamover_files {
      "altera_pcie_s10_readdatamover.sv"
   }


   set altera_pcie_s10_dma_controller_files {
      "altera_pcie_s10_dma_controller.sv"
      "altera_pcie_s10_dynamic_control.sv"
   }

   set altera_pcie_s10_cra_files {
      "altera_pcie_s10_attreg.sv"
      "altera_pcie_s10_cfgreg.sv"
      "altera_pcie_s10_cra.sv"
      "altera_pcie_s10_ctrlstatus_avmmread.sv"
      "altera_pcie_s10_ctrlstatus_avmmwrite.sv"
      "altera_pcie_s10_intren.sv"
      "altera_pcie_s10_intrstatus.sv"
      "altera_pcie_s10_mail_box.sv"
   }

   set altera_pcie_s10_rxm_files {
      "altera_pcie_s10_rxm.sv"
   }

   set altera_pcie_s10_hprxm_files {
      "altera_pcie_s10_fifo.sv"
      "altera_pcie_s10_hprxm.sv"
      "altera_pcie_s10_hprxm_cpl.sv"
      "altera_pcie_s10_hprxm_rdwr.sv"
      "altera_pcie_s10_hprxm_txctrl.sv"
   }

   set altera_pcie_s10_txs_files {
      "altera_pcie_s10_txs.sv"
   }

   set altera_pcie_s10_hptxs_files {
      "altera_pcie_s10_hptxs.sv"
   }

   set components_files {
      "altera_pcie_s10_int_controller.v"
      "altera_pcie_s10_reset_sync.v"
   }

   set top_level_unencrypted_files {
      "altera_pcie_s10_hip_avmm_bridge.v"
   }

   set top_level_encrypted_files {
      "altera_pcie_s10_avmm_bridge_dcore.v"
   }

   set std_sync_path [file join .. .. primitives altera_std_synchronizer altera_std_synchronizer_nocut.v]
   add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH $std_sync_path


   foreach vf $top_level_unencrypted_files {
      add_fileset_file  $vf   VERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/$vf
   }

   foreach vf $altera_pcie_s10_dma_controller_files {
      add_fileset_file  altera_pcie_s10_dma_controller/$vf   SYSTEMVERILOG    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/altera_pcie_s10_dma_controller/$vf
   }



      foreach vf $altera_pcie_s10_avst_sch_files {
         add_fileset_file  mentor/altera_pcie_s10_avst_sch/$vf         SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_avst_sch/$vf         MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_writedatamover_files {
         add_fileset_file  mentor/altera_pcie_s10_writedatamover/$vf   SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_writedatamover/$vf   MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_readdatamover_files {
         add_fileset_file  mentor/altera_pcie_s10_readdatamover/$vf    SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_readdatamover/$vf    MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_cra_files {
         add_fileset_file  mentor/altera_pcie_s10_cra/$vf              SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_cra/$vf              MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_rxm_files {
         add_fileset_file  mentor/altera_pcie_s10_rxm/$vf              SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_rxm/$vf              MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hprxm_files {
         add_fileset_file  mentor/altera_pcie_s10_hprxm/$vf            SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_hprxm/$vf            MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_txs_files {
         add_fileset_file  mentor/altera_pcie_s10_txs/$vf              SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_txs/$vf              MENTOR_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hptxs_files {
         add_fileset_file  mentor/altera_pcie_s10_hptxs/$vf            SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/altera_pcie_s10_hptxs/$vf            MENTOR_SPECIFIC
      }
      foreach vf $components_files {
         add_fileset_file  mentor/components/$vf                       SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/components/$vf                       MENTOR_SPECIFIC
      }

      foreach vf $top_level_encrypted_files {
         add_fileset_file  mentor/$vf                                  SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/mentor/$vf                                  MENTOR_SPECIFIC
      }




      foreach vf $altera_pcie_s10_avst_sch_files {
         add_fileset_file  synopsys/altera_pcie_s10_avst_sch/$vf            SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_avst_sch/$vf               SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_writedatamover_files {
         add_fileset_file  synopsys/altera_pcie_s10_writedatamover/$vf      SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_writedatamover/$vf         SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_readdatamover_files {
         add_fileset_file  synopsys/altera_pcie_s10_readdatamover/$vf       SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_readdatamover/$vf          SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_cra_files {
         add_fileset_file  synopsys/altera_pcie_s10_cra/$vf                 SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_cra/$vf                    SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_rxm_files {
         add_fileset_file  synopsys/altera_pcie_s10_rxm/$vf                 SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_rxm/$vf                    SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hprxm_files {
         add_fileset_file  synopsys/altera_pcie_s10_hprxm/$vf               SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_hprxm/$vf                  SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_txs_files {
         add_fileset_file  synopsys/altera_pcie_s10_txs/$vf                 SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_txs/$vf                    SYNOPSYS_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hptxs_files {
         add_fileset_file  synopsys/altera_pcie_s10_hptxs/$vf               SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/altera_pcie_s10_hptxs/$vf                  SYNOPSYS_SPECIFIC
      }
      foreach vf $components_files {
         add_fileset_file  synopsys/components/$vf                          SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/components/$vf                             SYNOPSYS_SPECIFIC
      }

      foreach vf $top_level_encrypted_files {
         add_fileset_file  synopsys/$vf                                     SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/synopsys/$vf                                        SYNOPSYS_SPECIFIC
      }




      foreach vf $altera_pcie_s10_avst_sch_files {
         add_fileset_file  cadence/altera_pcie_s10_avst_sch/$vf           SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_avst_sch/$vf             CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_writedatamover_files {
         add_fileset_file  cadence/altera_pcie_s10_writedatamover/$vf     SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_writedatamover/$vf       CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_readdatamover_files {
         add_fileset_file  cadence/altera_pcie_s10_readdatamover/$vf      SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_readdatamover/$vf        CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_cra_files {
         add_fileset_file  cadence/altera_pcie_s10_cra/$vf                SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_cra/$vf                  CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_rxm_files {
         add_fileset_file  cadence/altera_pcie_s10_rxm/$vf                SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_rxm/$vf                  CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hprxm_files {
         add_fileset_file  cadence/altera_pcie_s10_hprxm/$vf              SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_hprxm/$vf                CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_txs_files {
         add_fileset_file  cadence/altera_pcie_s10_txs/$vf                SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_txs/$vf                  CADENCE_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hptxs_files {
         add_fileset_file  cadence/altera_pcie_s10_hptxs/$vf              SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/altera_pcie_s10_hptxs/$vf                CADENCE_SPECIFIC
      }
      foreach vf $components_files {
         add_fileset_file  cadence/components/$vf                         SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/components/$vf                           CADENCE_SPECIFIC
      }

      foreach vf $top_level_encrypted_files {
         add_fileset_file  cadence/$vf                                    SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/cadence/$vf                                      CADENCE_SPECIFIC
      }




      foreach vf $altera_pcie_s10_avst_sch_files {
         add_fileset_file  aldec/altera_pcie_s10_avst_sch/$vf             SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_avst_sch/$vf               ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_writedatamover_files {
         add_fileset_file  aldec/altera_pcie_s10_writedatamover/$vf       SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_writedatamover/$vf         ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_readdatamover_files {
         add_fileset_file aldec/altera_pcie_s10_readdatamover/$vf         SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_readdatamover/$vf          ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_cra_files {
         add_fileset_file  aldec/altera_pcie_s10_cra/$vf                  SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_cra/$vf                    ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_rxm_files {
         add_fileset_file  aldec/altera_pcie_s10_rxm/$vf                  SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_rxm/$vf                    ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hprxm_files {
         add_fileset_file  aldec/altera_pcie_s10_hprxm/$vf                SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_hprxm/$vf                  ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_txs_files {
         add_fileset_file  aldec/altera_pcie_s10_txs/$vf                  SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_txs/$vf                    ALDEC_SPECIFIC
      }
      foreach vf $altera_pcie_s10_hptxs_files {
         add_fileset_file  aldec/altera_pcie_s10_hptxs/$vf                SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/altera_pcie_s10_hptxs/$vf                  ALDEC_SPECIFIC
      }
      foreach vf $components_files {
         add_fileset_file  aldec/components/$vf                           SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/components/$vf                             ALDEC_SPECIFIC
      }

      foreach vf $top_level_encrypted_files {
         add_fileset_file  aldec/$vf                                      SYSTEMVERILOG_ENCRYPT    PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_s10_hip_avmm_bridge/aldec/$vf                                        ALDEC_SPECIFIC
      }




}




proc ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_quartus_synth {output_name} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   ::altera_pcie_s10_hip_avmm_bridge::fileset::avmm_synth_fileset_list
   ::altera_pcie_s10_hip_common::quartus_synth_common_fileset
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_sim_verilog {output_name} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   ::altera_pcie_s10_hip_avmm_bridge::fileset::avmm_sim_encrypt_fileset_list
   ::altera_pcie_s10_hip_common::sim_verilog_common_fileset
}


proc ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_sim_vhdl {output_name} {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

   ::altera_pcie_s10_hip_avmm_bridge::fileset::avmm_sim_encrypt_fileset_list
   ::altera_pcie_s10_hip_common::sim_vhdl_common_fileset
}


proc ::altera_pcie_s10_hip_avmm_bridge::fileset::declare_pllnphy_fileset {} {
    ::altera_pcie_s10_hip_common::declare_pllnphy_fileset
}





proc ::altera_pcie_s10_hip_avmm_bridge::fileset::callback_example_design {ip_name} {
    ::altera_pcie_s10_hip_avmm_bridge::dynamic_example_design
}



proc ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::filedelete { item } {
   if { [ file exist $item ] == 1 } {
      file delete $item
   }
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker { item } {
   foreach top_item [glob -directory [file join [pwd] $item] -tails *] {
      set relative_item [file join $item $top_item]
      set absolute_path [file join [pwd] $relative_item]
      if {[file isdirectory $relative_item] == 1 } {
         ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker $relative_item
      } else {
         add_fileset_file $relative_item [ ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $relative_item "
      }
   }
}



proc ::altera_pcie_s10_hip_avmm_bridge::fileset::add_files_recursive { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      if {[file isdirectory $top_item] == 1 } {
         ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker $top_item
      } else {
         add_fileset_file $top_item [ ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $top_item "
      }
   }
   cd $old_path
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::empty_dir { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      file delete -force $absolute_path
   }
   cd $old_path
}











proc ::altera_pcie_s10_hip_avmm_bridge::dynamic_example_design {} {

   send_message info "Auto-generation of QSYS example design parameter checking"

   set virtual_link_width_integer_hwtcl     [ip_get "parameter.virtual_link_width_integer_hwtcl.value"]
   set virtual_rp_ep_mode_integer_hwtcl     [ip_get "parameter.virtual_rp_ep_mode_integer_hwtcl.value"]
   set virtual_link_rate_integer_hwtcl      [ip_get "parameter.virtual_link_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]

   # This block of code uses these unique variables; we'll initialize those here
   set strInterfaceType  ""
   set intInterfaceWidth ""
   set strPortType       ""
   set strParamValue     ""
   set strParamValue     ""
   set strDesignName     ""
   set strBaseDesign     ""
   set strGenerationPossible "True"
   set strParameterException ""

   #####################################################################
   # BEGIN
   # Example design Parameter Exception
   # Step 1; let's determine what the Interface type (AvST, AVMM)
   #
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   set ACDSVERSION 18.1
   foreach param $nf_hip_parameters {
      set strParamName ${param}
      set strParamValue [ip_get "parameter.${param}.value"]
      set intInterfaceWidth "256"

      if {$strParamName=="interface_type_hwtcl"} {
         set strInterfaceType $strParamValue
      }
      if {$strParamName=="port_type_hwtcl"} {
         set strPortType $strParamValue
      }
      #Check exception parameters that will cause the generated example designs to fail.  The current list of
      #exceptions includes the following parameters and values:

      #2.2 "Enable dynamic reconfiguration of PCIe read-only registers":  hip_reconfig_hwtcl = 1
      if {$strParamName=="hip_reconfig_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException " ${strParameterException} Enable dynamic reconfiguration of PCIe read-only registers"
      }
      #6   "Implement MSI-X" : enable_function_msix_support_hwtcl = 1
      if {$strParamName=="enable_function_msix_support_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Implement MSI-X"
      }
#      #7.   "Enable High Performance bursting Avalon-MM Slave interface (HPTXS).":  hptxs_enabled_hwtcl = 1
#      if {$strParamName=="hptxs_enabled_hwtc" && $strParamValue=="1"} {
#         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
#         set strGenerationPossible "False"
#         set strParameterException "${strParameterException} Enable completer-only Endpoint"
#      }
      #9.  "Export MSI/MSI-X conduit interfaces":     enable_advanced_interrupt_hwtcl = 1
      if {$strParamName=="enable_advanced_interrupt_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Export MSI/MSI-X conduit interfaces"
      }
      #10.  "Enable Hard IP Status Bus when using the AVMM interface":  enable_hip_status_for_avmm_hwtcl = 1
      if {$strParamName=="enable_hip_status_for_avmm_hwtcl" && $strParamValue=="1"} {
         set strParameterException [expr ($strGenerationPossible=="False")?"${strParameterException},":""]
         set strGenerationPossible "False"
         set strParameterException "${strParameterException} Enable Hard IP Status Bus when using the AVMM interface"
      }
   }
   # Example design Parameter Exception
   # END
   #####################################################################


   set valid_design_example [ ::altera_pcie_s10_hip_avmm_bridge::validate_design_example ]
   #Note:  In the standard message window, 60characters can be seen on the first line and 89 characters on the following lines.


   if {$strGenerationPossible=="False"} {

      global env
      set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
      set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
      send_message error "The example design cannot be generated with the following parameter settings: <br/>
      ${strParameterException}."
                send_message info "To obtain an example design please disable the invalid option(s) and try again.  <br/>
                Alternatively, you can select an example design from one of several available in the ACDS Installation <br/>
                Directory here: ${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_s10_ed/example_design/s10.  <br/>
                Information on using those designs can be found in the IP QuickStart/IP User Guide."

   } elseif { $valid_design_example != 1 } {
      send_message error "$valid_design_example"
   } else {
      ::altera_pcie_s10_hip_avmm_bridge::generate_dynamic_qsys
   }

}


proc ::altera_pcie_s10_hip_avmm_bridge::validate_design_example {} {

   send_message info "Validating example design selection"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set dma_enabled_hwtcl            [ip_get "parameter.dma_enabled_hwtcl.value" ]
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]
   set data_width_integer_hwtcl     256

   set valid 1
   set recommend_design "PIO"
   # Validate Example design TAB
   if { $dma_enabled_hwtcl == 0 } {
      if { $select_design_example_hwtcl == "DMA" }  {
         set valid 0
         set recommend_design "PIO"
      }
   } else {
      if { $select_design_example_hwtcl == "PIO" }  {
         set valid 0
         set recommend_design "DMA"
      }
   }

   if { $valid == 0 } {
          return "Please select ${recommend_design} from the \"Available example designs\", the $select_design_example_hwtcl example design is not available when selecting \"Application interface type\"=$interface_type_hwtcl and \"Application data width\"= $data_width_integer_hwtcl bit."
   } else {
      return $valid
   }
}




proc ::altera_pcie_s10_hip_avmm_bridge::generate_dynamic_qsys {} {

   send_message info "Auto-generation of QSYS example design in progress based on variant parameter settings"

   set interface_type_hwtcl         [ip_get "parameter.interface_type_hwtcl.value" ]
   set dma_enabled_hwtcl            [ip_get "parameter.dma_enabled_hwtcl.value" ]
   set dma_controller_enabled_hwtcl [ip_get "parameter.dma_controller_enabled_hwtcl.value" ]
   set data_width_integer_hwtcl     256
   set select_design_example_hwtcl  [ip_get "parameter.select_design_example_hwtcl.value"]

   set virtual_link_width_integer_hwtcl     [ip_get "parameter.virtual_link_width_integer_hwtcl.value"]
   set virtual_rp_ep_mode_integer_hwtcl     [ip_get "parameter.virtual_rp_ep_mode_integer_hwtcl.value"]
   set virtual_link_rate_integer_hwtcl      [ip_get "parameter.virtual_link_rate_integer_hwtcl.value"]
   set interface_type_integer_hwtcl         [ip_get "parameter.interface_type_integer_hwtcl.value"]

   set pld_clk_mhz_integer_hwtcl    [ip_get "parameter.pld_clk_mhz_integer_hwtcl.value"]
   set targeted_devkit_hwtcl        [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set pf0_bar2_type_integer_hwtcl      [ip_get "parameter.pf0_bar2_type_integer_hwtcl.value"]
   set pf0_bar2_address_width_hwtcl  7
   set ACDSVERSION 18.1


   # QSYS script to auto-generate QSYS system
   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set QSYSTemName "pcie_example_design"
   set QSYSTem "${QSYSTemName}.qsys"
   set QSYSTemPath "${TEMPPATH}${QSYSTem}"
   set QSYSScript "pcie_example_design.tcl"
   set QSYSScriptCC "pcie_example_design_cc.tcl"
   set QSYSScriptPath "${TEMPPATH}${QSYSScript}"
   set QSYSScriptBACKUPPath "${TEMPPATH}${QSYSScriptCC}"

   # Corrected variant parameter
   set enable_avst_reset_hwtcl 1

   if { [ file exist $QSYSScriptPath ] == 1 } {
      file delete $QSYSScriptPath
   }

   set ScriptFile [open $QSYSScriptPath "w"]
   catch { cd $TEMPPATH}

   set instance "DUT"
   set DeviceQSF "ND5_40_PART1"


   puts $ScriptFile "package require -exact qsys 16.0"
   puts $ScriptFile "set qsys_system ${QSYSTem}"
   puts $ScriptFile "set_project_property DEVICE_FAMILY {Stratix 10}"
   puts $ScriptFile "set_project_property DEVICE ${DeviceQSF}"

   puts $ScriptFile "# Adding Avalon-MM Stratix 10 PCIe IP"
   puts $ScriptFile "add_instance ${instance} altera_pcie_s10_hip_avmm_bridge"
   puts $ScriptFile "# Setting Parameters to Avalon-MM Stratix 10 PCIe IP"
   set nf_hip_parameters [ip_get_matching_parameters [dict set criteria Visible 1]]
   set use_tx_cons_cred_sel_hwtcl 0
   set enable_avst_reset_hwtcl 0
   set pf0_bar2_address_width_hwtcl 0
   set pf0_bar0_type_hwtcl "Disabled"
   set internal_controller_hwtcl 0
   foreach param $nf_hip_parameters {
      set derived [ ip_get "parameter.${param}.DERIVED" ]
      if { $derived == 0 } {
         set value [ip_get "parameter.${param}.value"]
         puts $ScriptFile "set_instance_parameter_value ${instance} ${param} {${value}}"
         if { [ regexp enable_avst_reset_hwtcl $param ] } {
            set enable_avst_reset_hwtcl $value
         }
         if { [ regexp pf0_bar2_address_width_hwtcl $param ] } {
            set pf0_bar2_address_width_hwtcl $value
         }
         if { [ regexp pf0_bar0_type_hwtcl $param ] } {
            set pf0_bar0_type_hwtcl $value
         }
         if { [ regexp use_tx_cons_cred_sel_hwtcl $param ] } {
            set use_tx_cons_cred_sel_hwtcl $value
         }
      }
   }

   puts $ScriptFile "# Enabling Devkit component to support Stratix FPGA Development kit"
   puts $ScriptFile "#add_instance DK altpcie_devkit"
   puts $ScriptFile "#add_interface          board_pins conduit end"
   puts $ScriptFile ""

   puts $ScriptFile "# PCIe serial/pipe interface"
   puts $ScriptFile "add_interface          refclk clock end"
   puts $ScriptFile "set_interface_property refclk EXPORT_OF ${instance}.refclk"
   puts $ScriptFile "add_interface          pcie_rstn conduit end"
   puts $ScriptFile "set_interface_property pcie_rstn EXPORT_OF ${instance}.npor"
   puts $ScriptFile "add_interface          xcvr conduit end"
   puts $ScriptFile "set_interface_property xcvr EXPORT_OF ${instance}.hip_serial"
   puts $ScriptFile "add_interface          pipe_sim_only conduit end"
   puts $ScriptFile "set_interface_property pipe_sim_only EXPORT_OF ${instance}.hip_pipe"
   puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 0"


   if { $dma_enabled_hwtcl == 0  } {
      # AVMM with DMA only Parameters - Set to Zero when non AVMM with DMA
      puts $ScriptFile "set_instance_parameter_value ${instance} dma_controller_enabled_hwtcl        {0}"
   } else {
      # AVMM only Parameters - Set to Zero when non AVMM
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_advanced_interrupt_hwtcl     {0}"
      puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl              {64}"
   }




   if { $dma_enabled_hwtcl == 0  } {
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "# Adding on-chip memory"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "# Set TB BFM to 3 apps_type_hwtcl config only             1"
      puts $ScriptFile "#               3  apps_type_hwtcl chaining_dma           2"
      puts $ScriptFile "#               3  apps_type_hwtcl Target only            3"
      puts $ScriptFile "#               3  apps_type_hwtcl simple_ep_downstream   11"
      puts $ScriptFile "set_instance_parameter_value ${instance} apps_type_hwtcl 3"
      puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
      puts $ScriptFile "set_instance_parameter_value MEM blockType                  {AUTO}             "
      puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
      puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {Stratix 10}         "
      puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
      puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {256}              "
      puts $ScriptFile "set_instance_parameter_value MEM readDuringWriteMode        {DONT_CARE}        "
      puts $ScriptFile "set_instance_parameter_value MEM resetrequest_enabled       {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM singleClockOperation       {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM slave1Latency              {2}                "
      puts $ScriptFile "set_instance_parameter_value MEM slave2Latency              {1}                "
      puts $ScriptFile "set_instance_parameter_value MEM useNonDefaultInitFile      {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM useShallowMemBlocks        {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM writable                   {true}             "
      puts $ScriptFile "# Connection Section"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset1"
      set HPTxSConnected 0
      set TxSConnected 0
      set CRAConnected 0
      set hptxs_enabled_hwtcl [ip_get "parameter.hptxs_enabled_hwtcl.value"]
      set txs_enabled_hwtcl [ip_get "parameter.txs_enabled_hwtcl.value"]
      set enable_cra_slave_port_hwtcl [ip_get "parameter.enable_cra_slave_port_hwtcl.value"]


      if { ${hptxs_enabled_hwtcl} == 1} {
         puts $ScriptFile "# Limit HPTxS Address Space"
         set avmm_addr_width_hwtcl    [ip_get "parameter.avmm_addr_width_hwtcl.value"]
         if { $avmm_addr_width_hwtcl == 64 } {
            puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl {${avmm_addr_width_hwtcl}}"
            puts $ScriptFile "set_instance_parameter_value ${instance} hptxs_enabled_hwtcl   {1}"
            puts $ScriptFile "set_instance_parameter_value ${instance} user_hptxs_address_width_hwtcl {48}"

#            puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl {32}"
#            ::altera_pcie_s10_hip_common::alteracion_ed_message "change Avalon-MM address width to 32 bit."
#             send_message info "The Avalon-MM generated example design application operates with Avalon-MM address width of 32-bit."
         } else {
            puts $ScriptFile "set_instance_parameter_value ${instance} avmm_addr_width_hwtcl {${avmm_addr_width_hwtcl}}"
            puts $ScriptFile "set_instance_parameter_value ${instance} hptxs_enabled_hwtcl   {1}"
            puts $ScriptFile "set_instance_parameter_value ${instance} hptxs_address_translation_table_address_width_hwtcl    {2}"
            puts $ScriptFile "set_instance_parameter_value ${instance} hptxs_address_translation_window_address_width_hwtcl   {12}"
#         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_pass_thru_bits_hwtcl {12}"
#         puts $ScriptFile "set_instance_parameter_value ${instance} cg_a2p_addr_map_num_entries_hwtcl {2}"
#         puts $ScriptFile "set_instance_parameter_value ${instance} cg_impl_cra_av_slave_port_hwtcl {1}"
         }
      }

      if { ${txs_enabled_hwtcl} == 1} {
         puts $ScriptFile "# Limit TxS Address Space"
         puts $ScriptFile "set_instance_parameter_value ${instance} txs_enabled_hwtcl   {1}"
         puts $ScriptFile "set_instance_parameter_value ${instance} user_txs_address_width_hwtcl {48}"
      }


      if { ${enable_cra_slave_port_hwtcl} == 1 } {
         puts $ScriptFile "add_connection ${instance}.rxm_irq ${instance}.cra_irq"
         puts $ScriptFile "auto_assign_irqs ${instance}"
      }

      for { set i 0 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.pf0_bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar 1
         }
         if { $bar == 1 } {
            if { ${hptxs_enabled_hwtcl} == 1} {
               if {$HPTxSConnected == 0} {
                  puts $ScriptFile "add_connection ${instance}.rxm_bar${i} ${instance}.hptxs"
                  set HPTxSConnected 1
               }
            }
            if { ${txs_enabled_hwtcl} == 1} {
               if {$TxSConnected == 0} {
                  puts $ScriptFile "add_connection ${instance}.rxm_bar${i} ${instance}.txs"
                  set TxSConnected 1
               }
            }

            puts $ScriptFile "add_connection ${instance}.rxm_bar${i} MEM.s1"
            puts $ScriptFile "set_connection_parameter_value ${instance}.rxm_bar${i}/MEM.s1 baseAddress {0}"

            if { ${enable_cra_slave_port_hwtcl} == 1 } {
               puts $ScriptFile "add_connection ${instance}.rxm_bar${i} ${instance}.cra"
               if { $CRAConnected == 0} {
                  set CRAConnected 1
               }
            }
         }
      }
      set dynamic_reconfig [ip_get "parameter.hip_reconfig_hwtcl.value"]
      if { $dynamic_reconfig ==1 } {
         puts $ScriptFile "add_connection ${instance}.coreclkout_hip ${instance}.hip_reconfig_clk"
         puts $ScriptFile "add_connection ${instance}.app_nreset_status ${instance}.hip_reconfig_rst"
      }
      puts $ScriptFile "lock_avalon_base_address MEM.s1"

   } else {
      puts $ScriptFile "add_interface          hip_ctrl conduit end"
      puts $ScriptFile "set_interface_property hip_ctrl EXPORT_OF ${instance}.hip_ctrl"
      puts $ScriptFile "set_instance_parameter_value ${instance} enable_devkit_conduit_hwtcl 1"
      puts $ScriptFile "# Adding on-chip memory"
      puts $ScriptFile "add_instance MEM altera_avalon_onchip_memory2"
      puts $ScriptFile "set_instance_parameter_value MEM dataWidth                  {${data_width_integer_hwtcl}}"
      puts $ScriptFile "set_instance_parameter_value MEM deviceFamily               {Stratix 10}         "
      puts $ScriptFile "set_instance_parameter_value MEM dualPort                   {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM ecc_enabled                {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM initMemContent             {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM initializationFileName     {onchip_mem.hex}   "
      puts $ScriptFile "set_instance_parameter_value MEM memorySize                 {8192}             "
      puts $ScriptFile "set_instance_parameter_value MEM readDuringWriteMode        {DONT_CARE}        "
      puts $ScriptFile "set_instance_parameter_value MEM resetrequest_enabled       {true}             "
      puts $ScriptFile "set_instance_parameter_value MEM singleClockOperation       {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM slave1Latency              {2}                "
      puts $ScriptFile "set_instance_parameter_value MEM slave2Latency              {1}                "
      puts $ScriptFile "set_instance_parameter_value MEM useNonDefaultInitFile      {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM useShallowMemBlocks        {false}            "
      puts $ScriptFile "set_instance_parameter_value MEM writable                   {true}             "

      puts $ScriptFile ""
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk1"
      puts $ScriptFile "add_connection ${instance}.coreclkout_hip MEM.clk2"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset1"
      puts $ScriptFile "add_connection ${instance}.app_nreset_status MEM.reset2"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master MEM.s1"
      puts $ScriptFile "add_connection ${instance}.dma_wr_master MEM.s2"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master ${instance}.rd_dts_slave"
      puts $ScriptFile "add_connection ${instance}.dma_rd_master ${instance}.wr_dts_slave"

      puts $ScriptFile "add_connection ${instance}.rd_dcm_master ${instance}.txs"
      puts $ScriptFile "add_connection ${instance}.wr_dcm_master ${instance}.txs"

      puts $ScriptFile "# DMA Controller uses BAR 0-1 (64-bits)"
      if { $pf0_bar0_type_hwtcl != "64-bit prefetchable memory" } {
         puts $ScriptFile "set_instance_parameter_value ${instance} pf0_bar0_type_hwtcl   {64-bit prefetchable memory}"
         puts $ScriptFile "set_instance_parameter_value ${instance} pf0_bar1_type_hwtcl   {Disabled}"
         ::altera_pcie_s10_hip_common::alteracion_ed_message "the option BAR0 is set to 64-bit prefetchable memory when using the Avalon-MM DMA Interface"
      }
      if { $dma_controller_enabled_hwtcl == 0 } {
         puts $ScriptFile "set_instance_parameter_value ${instance} internal_controller_hwtcl 1"
         ::altera_pcie_s10_hip_common::alteracion_ed_message "the option \"Instantiate internal descriptor controller\" is enabled when using the Avalon-MM DMA Interface."
      }

      puts $ScriptFile "# Non DMA Controller BAR"
      set CRAConnected 0
      set NoAppBAR 1
      set enable_cra_slave_port_hwtcl [ip_get "parameter.enable_cra_slave_port_hwtcl.value"]
      if { ${enable_cra_slave_port_hwtcl} == 0 } {
         set CRAConnected 1
      }
      for { set i 2 } { $i < 6 } { incr i } {
         set bar [ip_get "parameter.pf0_bar${i}_type_hwtcl.value"]
         if { $bar == "Disabled" } {
            set bar 0
         } else {
            set bar 1
         }
         if { $bar == 1 } {
            puts $ScriptFile "add_connection DUT.rxm_bar${i} MEM.s1"
            set NoAppBAR 0
            if { ${CRAConnected} == 0 } {
               puts $ScriptFile "add_connection DUT.rxm_bar${i} DUT.cra"
               set CRAConnected 1
            }
         }
      }
      if { ${NoAppBAR} == 1 && ${CRAConnected} == 0 } {
         puts $ScriptFile "set_instance_parameter_value DUT pf0_bar2_type_hwtcl   {64-bit prefetchable memory}"
         puts $ScriptFile "add_connection DUT.rxm_bar2 DUT.cra"
         send_message info "Adding BAR2 to enable CRA access from RX Master"
      }

      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/DUT.rd_dts_slave baseAddress {0x01000000}"
      puts $ScriptFile "lock_avalon_base_address DUT.rd_dts_slave"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/DUT.wr_dts_slave baseAddress {0x01002000}"
      puts $ScriptFile "lock_avalon_base_address DUT.wr_dts_slave"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_rd_master/MEM.s1 baseAddress {0}"
      puts $ScriptFile "lock_avalon_base_address MEM.s1"
      puts $ScriptFile "set_connection_parameter_value DUT.dma_wr_master/MEM.s2 baseAddress {0}"
      puts $ScriptFile "lock_avalon_base_address MEM.s2"
      puts $ScriptFile "auto_assign_system_base_addresses"
   }
   puts $ScriptFile "#set_interface_property board_pins EXPORT_OF DK.dk_board"
   puts $ScriptFile "#add_connection DK.dk_hip ${instance}.dk_hip"
   puts $ScriptFile "#add_connection ${instance}.coreclkout_hip DK.clock"

   puts $ScriptFile "auto_assign_system_base_addresses"
   puts $ScriptFile "remove_dangling_connections"
   send_message info "save_system ${QSYSTem}"
   puts $ScriptFile "save_system ${QSYSTem}"
   close $ScriptFile

   global env
   set QSYS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set QSYS_ROOTDIR "${QSYS_ROOTDIR}/sopc_builder/bin/"

   if { [ file exist $QSYSScriptPath ] == 1 } {
      if { [ file exist ${QSYSScriptBACKUPPath}  ] == 1 } {
         file delete ${QSYSScriptBACKUPPath}
      }
      file copy ${QSYSScriptPath} ${QSYSScriptBACKUPPath}
      send_message info "Generating QSYS system ${QSYSTem}"
      send_message info "Running: qsys-script --pro --script=${QSYSScript}"
      set foo [catch  "exec ${QSYS_ROOTDIR}qsys-script --pro --script=${QSYSScriptPath}"]
   } else {
      send_message error "ERROR:Unable to locate ${QSYSScriptPath}"
   }
   catch { cd $ORIDIR}
   if { [ file exist $QSYSTemPath ] == 1 } {
      file delete ${QSYSScriptPath}
      if { [ file exist ${QSYSScriptBACKUPPath}  ] == 1 } {
         file copy ${QSYSScriptBACKUPPath} ${QSYSScriptPath}
         file delete ${QSYSScriptBACKUPPath}
      }
      ::altera_pcie_s10_hip_avmm_bridge::generate_design_example_files  ${QSYSTemPath} ${QSYSTemName}
   } else {
      add_fileset_file ${QSYSScript} OTHER PATH ${QSYSScriptPath}
      send_message info "Unable to create ${QSYSTem}"
      send_message info "Copied ${QSYSScript} in the example design directory, exiting ........."
   }
}




proc ::altera_pcie_s10_hip_avmm_bridge::generate_design_example_files { qsys_design_example_fullpath exdes_prj } {

   global env
   set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
   set IP_ROOTDIR "${IP_ROOTDIR}/../ip"

   send_message info "Fileset generation"

   set ed_qii_hwtcl           1
   set ed_synth_hwtcl         [ip_get "parameter.enable_example_design_synth_hwtcl.value"]
   set targeted_devkit_hwtcl  [ip_get "parameter.targeted_devkit_hwtcl.value"]
   set ed_tb_hwtcl            [ip_get "parameter.enable_example_design_tb_hwtcl.value"   ]
   set ed_sim_hwtcl           [ip_get "parameter.enable_example_design_sim_hwtcl.value"  ]

   if { $ed_sim_hwtcl >0 } {
      send_message info "Generating the example design simulation files"
      set ed_tb_hwtcl  1
   } else {
      send_message info "Skip the generation of the example design simulation files"
      set ed_tb_hwtcl  0
   }

   if { $ed_synth_hwtcl >0 } {
      send_message info "Generating the example design synthesis files"
   } else {
      send_message info "Skip the generation of the example synthesis simulation files"
   }

   set ORIDIR [pwd]
   set TEMPPATH [create_temp_file ""]
   set s10pcie_devkit_prj "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_s10_ed/example_design/s10-pcie-devkit-prj.tcl"
   #
   # Copy QSYS system and qshell/qsys script to temp directory
   #
   if { [ file exist $qsys_design_example_fullpath ] == 0 } {
      file copy "${qsys_design_example_fullpath}"  "${TEMPPATH}/${exdes_prj}.qsys"
   }
   send_message info "Targeting Stratix 10 FPGA Development kit ...."
   #::altera_pcie_s10_hip::fileset::check_support_hw_s10_devkit
   set DeviceQSF "ND5_40_PART1"
   #
   # Generate required file in Temp directory
   #
   catch { cd $TEMPPATH}
   #
   # Generate required file in Temp directory
   #
   set    GScript [open "${exdes_prj}_script.sh" w]
   puts  $GScript "#################################################################################################"
   puts  $GScript "#                                                                                       "
   puts  $GScript "# Generate quartus project from a QSYS file                                             "
   puts  $GScript "quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   puts  $GScript "#                                                                                       "
   puts  $GScript "# IP Upgrade                                                                            "
   puts  $GScript "quartus_sh --ip_upgrade -variation_files ${exdes_prj}.qsys ${exdes_prj}                 "
   puts  $GScript "#                                                                                       "
   puts  $GScript "# Compile generate QUARTUS project                                                      "
   puts  $GScript "quartus_sh --flow compile ${exdes_prj}.qpf                                              "
   puts  $GScript "#                                                                                       "
   close $GScript
   send_message info "Running: quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"
   set foo [catch  "exec quartus_sh -t ${s10pcie_devkit_prj} ${exdes_prj} ${ed_qii_hwtcl} ${ed_synth_hwtcl} ${ed_sim_hwtcl} ${DeviceQSF}"]
   set FAILGEN "${TEMPPATH}/${exdes_prj}_fail.txt"

   if { [ file exist $FAILGEN ] == 1 } {
      add_fileset_file ${exdes_prj}.qsys OTHER PATH ${qsys_design_example_fullpath}
      send_message info "adding ${exdes_prj}.qsys"
      send_message error "Unable to generate HDL files for the system ${exdes_prj}.qsys "
   } else {
      # Copy all generated file to the example design user directory
      #
      ::altera_pcie_s10_hip_avmm_bridge::fileset::add_files_recursive [ pwd ]
   }
   catch { cd $ORIDIR}
}












proc ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::filedelete { item } {
   if { [ file exist $item ] == 1 } {
      file delete $item
   }
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker { item } {
   foreach top_item [glob -directory [file join [pwd] $item] -tails *] {
      set relative_item [file join $item $top_item]
      set absolute_path [file join [pwd] $relative_item]
      if {[file isdirectory $relative_item] == 1 } {
         ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker $relative_item
      } else {
         add_fileset_file $relative_item [ ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $relative_item "
      }
   }
}



proc ::altera_pcie_s10_hip_avmm_bridge::fileset::add_files_recursive { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      if {[file isdirectory $top_item] == 1 } {
         ::altera_pcie_s10_hip_avmm_bridge::fileset::folder_worker $top_item
      } else {
         add_fileset_file $top_item [ ::altera_pcie_s10_hip_avmm_bridge::fileset::filetype $absolute_path ] PATH $absolute_path
         send_message info "adding $top_item "
      }
   }
   cd $old_path
}

proc ::altera_pcie_s10_hip_avmm_bridge::fileset::empty_dir { root } {
   set old_path [pwd]
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      file delete -force $absolute_path
   }
   cd $old_path
}

