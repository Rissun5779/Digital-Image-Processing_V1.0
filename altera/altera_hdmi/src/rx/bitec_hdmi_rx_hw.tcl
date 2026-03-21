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


# +----------------------------------
# | 
# | ALTERA HDMI RX v14.1
# | Altera Corporation 
# | 
# +-----------------------------------

package require -exact qsys 12.0

source ../common/altera_hdmi_params.tcl
source ../common/altera_hdmi_common_proc.tcl
source ../common/altera_hdmi_interface.tcl

# +-----------------------------------
# | module HDMI RX Protocol
# | 
set_module_property DESCRIPTION "Altera HDMI RX Protocol"
set_module_property NAME bitec_hdmi_rx
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/HDMI/Altera HDMI RX Protocol"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Altera HDMI RX Protocol"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------

# +-----------------------------------
# | IEEE Encryption
# | 

add_fileset          simulation_verilog SIM_VERILOG   generate_files
add_fileset          simulation_vhdl    SIM_VHDL      generate_files
add_fileset          synthesis_fileset  QUARTUS_SYNTH generate_ed_files

set_fileset_property simulation_verilog TOP_LEVEL   bitec_hdmi_rx
set_fileset_property simulation_vhdl    TOP_LEVEL   bitec_hdmi_rx
set_fileset_property synthesis_fileset  TOP_LEVEL   bitec_hdmi_rx

proc generate_files {name} {
  if {1} {
        
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc.v                        VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc.v                          {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_reset_sync.v                 VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_reset_sync.v                   {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_scramble.v                   VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_scramble.v                     {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_split_add.v                  VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_split_add.v                    {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc_pulse.v                  VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc_pulse.v                    {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc_strobed.v                VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc_strobed.v                  {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_dcfifo.v                     VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_dcfifo.v                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_dd.v                         VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_dd.v                           {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_measure_vid.v                VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_measure_vid.v                  {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_scfifo.v                     VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_scfifo.v                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_symb_delay.v                 VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_symb_delay.v                   {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_aux_bch.v                    VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_aux_bch.v                      {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx.v                         VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx.v                                     {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_aux_decoder.v             VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_aux_decoder.v                         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/altera_hdmi_rx_aligner.v                VERILOG_ENCRYPT PATH mentor/src_hdl/altera_hdmi_rx_aligner.v                            {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_align_deskew.v            VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_align_deskew.v                        {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_aux_crc_check.v           VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_aux_crc_check.v                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_bitslip.v                 VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_bitslip.v                             {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_capture_aux.v             VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_capture_aux.v                         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_error_detection_channel.v VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_error_detection_channel.v             {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_error_detection.v         VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_error_detection.v                     {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_hdmi_decode.v             VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_hdmi_decode.v                         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_resample.v                VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_rx_resample.v                            {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_rx_audio.v                   VERILOG_ENCRYPT PATH mentor/src_hdl/audio/bitec_hdmi_rx_audio.v                         {MENTOR_SPECIFIC}
   
  }
  
  if {1} {
    
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc.v                         VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc.v                          {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_reset_sync.v                  VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_reset_sync.v                   {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_scramble.v                    VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_scramble.v                     {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_split_add.v                   VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_split_add.v                    {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc_pulse.v                   VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc_pulse.v                    {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc_strobed.v                 VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc_strobed.v                  {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_dcfifo.v                      VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_dcfifo.v                       {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_dd.v                          VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_dd.v                           {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_measure_vid.v                 VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_measure_vid.v                  {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_scfifo.v                      VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_scfifo.v                       {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_symb_delay.v                  VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_symb_delay.v                   {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_aux_bch.v                     VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_aux_bch.v                      {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx.v                          VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx.v                                     {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_aux_decoder.v              VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_aux_decoder.v                         {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/altera_hdmi_rx_aligner.v                 VERILOG_ENCRYPT PATH aldec/src_hdl/altera_hdmi_rx_aligner.v                            {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_align_deskew.v             VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_align_deskew.v                        {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_aux_crc_check.v            VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_aux_crc_check.v                       {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_bitslip.v                  VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_bitslip.v                             {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_capture_aux.v              VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_capture_aux.v                         {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_error_detection_channel.v  VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_error_detection_channel.v             {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_error_detection.v          VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_error_detection.v                     {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_hdmi_decode.v              VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_hdmi_decode.v                         {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_resample.v                 VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_rx_resample.v                            {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_rx_audio.v                    VERILOG_ENCRYPT PATH aldec/src_hdl/audio/bitec_hdmi_rx_audio.v                         {ALDEC_SPECIFIC}
   
  }
  
  if {1} {
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc.v                           VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc.v                          {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_reset_sync.v                    VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_reset_sync.v                   {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_scramble.v                      VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_scramble.v                     {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_split_add.v                     VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_split_add.v                    {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc_pulse.v                     VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc_pulse.v                    {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc_strobed.v                   VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc_strobed.v                  {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_dcfifo.v                        VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_dcfifo.v                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_dd.v                            VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_dd.v                           {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_measure_vid.v                   VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_measure_vid.v                  {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_scfifo.v                        VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_scfifo.v                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_symb_delay.v                    VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_symb_delay.v                   {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_aux_bch.v                       VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_aux_bch.v                      {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx.v                            VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx.v                                     {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_aux_decoder.v                VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_aux_decoder.v                         {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/altera_hdmi_rx_aligner.v                   VERILOG_ENCRYPT PATH cadence/src_hdl/altera_hdmi_rx_aligner.v                            {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_align_deskew.v               VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_align_deskew.v                        {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_aux_crc_check.v              VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_aux_crc_check.v                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_bitslip.v                    VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_bitslip.v                             {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_capture_aux.v                VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_capture_aux.v                         {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_error_detection_channel.v    VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_error_detection_channel.v             {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_error_detection.v            VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_error_detection.v                     {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_hdmi_decode.v                VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_hdmi_decode.v                         {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_resample.v                   VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_rx_resample.v                            {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_rx_audio.v                      VERILOG_ENCRYPT PATH cadence/src_hdl/audio/bitec_hdmi_rx_audio.v                         {CADENCE_SPECIFIC}
  
  }
  
  if {1} {
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc.v                          VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc.v                          {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_reset_sync.v                   VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_reset_sync.v                   {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_scramble.v                     VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_scramble.v                     {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_split_add.v                    VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_split_add.v                    {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc_pulse.v                    VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc_pulse.v                    {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc_strobed.v                  VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc_strobed.v                  {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_dcfifo.v                       VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_dcfifo.v                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_dd.v                           VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_dd.v                           {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_measure_vid.v                  VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_measure_vid.v                  {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_scfifo.v                       VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_scfifo.v                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_symb_delay.v                   VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_symb_delay.v                   {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_aux_bch.v                      VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_aux_bch.v                      {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx.v                           VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx.v                                     {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_aux_decoder.v               VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_aux_decoder.v                         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/altera_hdmi_rx_aligner.v                  VERILOG_ENCRYPT PATH synopsys/src_hdl/altera_hdmi_rx_aligner.v                            {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_align_deskew.v              VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_align_deskew.v                        {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_aux_crc_check.v             VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_aux_crc_check.v                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_bitslip.v                   VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_bitslip.v                             {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_capture_aux.v               VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_capture_aux.v                         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_error_detection_channel.v   VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_error_detection_channel.v             {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_error_detection.v           VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_error_detection.v                     {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_hdmi_decode.v               VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_hdmi_decode.v                         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_resample.v                  VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_rx_resample.v                            {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_rx_audio.v                     VERILOG_ENCRYPT PATH synopsys/src_hdl/audio/bitec_hdmi_rx_audio.v                         {SYNOPSYS_SPECIFIC}
 
  }
}

# +-----------------------------------
# | files
# | 
proc generate_ed_files {name} {
    add_fileset_file bitec_hdmi_cdc.v                           VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc.v                  {SYNTHESIS}
    add_fileset_file bitec_hdmi_reset_sync.v                    VERILOG PATH ../common/src_hdl/bitec_hdmi_reset_sync.v           {SYNTHESIS}
    add_fileset_file bitec_hdmi_scramble.v                      VERILOG PATH ../common/src_hdl/bitec_hdmi_scramble.v             {SYNTHESIS}
    add_fileset_file bitec_hdmi_split_add.v                     VERILOG PATH ../common/src_hdl/bitec_hdmi_split_add.v            {SYNTHESIS}
    add_fileset_file bitec_hdmi_cdc_pulse.v                     VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc_pulse.v            {SYNTHESIS}
    add_fileset_file bitec_hdmi_cdc_strobed.v                   VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc_strobed.v          {SYNTHESIS}
    add_fileset_file bitec_hdmi_dcfifo.v                        VERILOG PATH ../common/src_hdl/bitec_hdmi_dcfifo.v               {SYNTHESIS}
    add_fileset_file bitec_hdmi_dd.v                            VERILOG PATH ../common/src_hdl/bitec_hdmi_dd.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_measure_vid.v                   VERILOG PATH ../common/src_hdl/bitec_hdmi_measure_vid.v          {SYNTHESIS}
    add_fileset_file bitec_hdmi_scfifo.v                        VERILOG PATH ../common/src_hdl/bitec_hdmi_scfifo.v               {SYNTHESIS}
    add_fileset_file bitec_hdmi_symb_delay.v                    VERILOG PATH ../common/src_hdl/bitec_hdmi_symb_delay.v           {SYNTHESIS}
    add_fileset_file bitec_hdmi_aux_bch.v                       VERILOG PATH ../common/src_hdl/bitec_hdmi_aux_bch.v              {SYNTHESIS}
    add_fileset_file bitec_hdmi.sdc                             SDC     PATH ../common/src_hdl/bitec_hdmi.sdc
    add_fileset_file bitec_hdmi_rx.v                            VERILOG PATH src_hdl/bitec_hdmi_rx.v                            {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_aux_decoder.v                VERILOG PATH src_hdl/bitec_hdmi_rx_aux_decoder.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_align_deskew.v               VERILOG PATH src_hdl/bitec_hdmi_rx_align_deskew.v               {SYNTHESIS}
    add_fileset_file altera_hdmi_rx_aligner.v                   VERILOG PATH src_hdl/altera_hdmi_rx_aligner.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_aux_crc_check.v              VERILOG PATH src_hdl/bitec_hdmi_rx_aux_crc_check.v              {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_bitslip.v                    VERILOG PATH src_hdl/bitec_hdmi_rx_bitslip.v                    {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_capture_aux.v                VERILOG PATH src_hdl/bitec_hdmi_rx_capture_aux.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_error_detection_channel.v    VERILOG PATH src_hdl/bitec_hdmi_rx_error_detection_channel.v    {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_error_detection.v            VERILOG PATH src_hdl/bitec_hdmi_rx_error_detection.v            {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_hdmi_decode.v                VERILOG PATH src_hdl/bitec_hdmi_rx_hdmi_decode.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_resample.v                   VERILOG PATH src_hdl/bitec_hdmi_rx_resample.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx_audio.v                      VERILOG PATH src_hdl/audio/bitec_hdmi_rx_audio.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_rx.ocp                          OTHER PATH   src_hdl/bitec_hdmi_rx.ocp                          {SYNTHESIS}
  
}

# | 
# +-----------------------------------

altera_hdmi_common_params
set_parameter_property FAMILY HDL_PARAMETER true
set_parameter_property SCDC_IEEE_ID HDL_PARAMETER true
set_parameter_property SCDC_DEVICE_STRING HDL_PARAMETER true
set_parameter_property SCDC_HW_REVISION HDL_PARAMETER true
set_parameter_property DISABLE_ALIGN_DESKEW HDL_PARAMETER true


set common_composed_mode 0

proc elaboration_callback {} {

  set symbols_per_clock [get_parameter_value SYMBOLS_PER_CLOCK]
  add_hdmi_export_interface rx
  add_hdmi_rx_interface symbols_per_clock
  
}
