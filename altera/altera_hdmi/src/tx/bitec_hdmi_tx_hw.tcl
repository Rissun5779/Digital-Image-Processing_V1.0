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
# | ALTERA HDMI TX v14.1
# | Altera Corporation 
# | 
# +-----------------------------------

package require -exact qsys 12.0

source ../common/altera_hdmi_params.tcl
source ../common/altera_hdmi_common_proc.tcl
source ../common/altera_hdmi_interface.tcl

# +-----------------------------------
# | module HDMI TX Protocol
# | 
set_module_property DESCRIPTION "Altera HDMI TX Protocol"
set_module_property NAME bitec_hdmi_tx
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/HDMI/Altera HDMI TX Protocol"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Altera HDMI TX Protocol"
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

set_fileset_property simulation_verilog TOP_LEVEL   bitec_hdmi_tx
set_fileset_property simulation_vhdl    TOP_LEVEL   bitec_hdmi_tx
set_fileset_property synthesis_fileset  TOP_LEVEL   bitec_hdmi_tx

proc generate_files {name} {
  if {1} {
    
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc.v                               VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc.v                   {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_reset_sync.v                        VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_reset_sync.v            {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_scramble.v                          VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_scramble.v              {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_split_add.v                         VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_split_add.v             {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc_pulse.v                         VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc_pulse.v             {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_cdc_strobed.v                       VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_cdc_strobed.v           {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_dcfifo.v                            VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_dcfifo.v                {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_measure_vid.v                       VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_measure_vid.v           {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_scfifo.v                            VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_scfifo.v                {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_symb_delay.v                        VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_symb_delay.v            {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_aux_bch.v                           VERILOG_ENCRYPT PATH ../common/mentor/src_hdl/bitec_hdmi_aux_bch.v               {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx.v                                VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx.v                              {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_aux_encoder.v                    VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_aux_encoder.v                  {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v           VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v            VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v          {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_aux_mux.v                        VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_aux_mux.v                      {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                     VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                   {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_create_aux.v                     VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_create_aux.v                   {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_encode.v                         VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_encode.v                       {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_resample.v                       VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_resample.v                     {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_tmds.v                           VERILOG_ENCRYPT PATH mentor/src_hdl/bitec_hdmi_tx_tmds.v                         {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_audio.v                          VERILOG_ENCRYPT PATH mentor/src_hdl/audio/bitec_hdmi_tx_audio.v                  {MENTOR_SPECIFIC}
    add_fileset_file mentor/src_hdl/bitec_hdmi_tx_audio_mux.v                      VERILOG_ENCRYPT PATH mentor/src_hdl/audio/bitec_hdmi_tx_audio_mux.v              {MENTOR_SPECIFIC}
    
  }
  
  if {1} {
    
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc.v                                VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc.v                   {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_reset_sync.v                         VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_reset_sync.v            {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_scramble.v                           VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_scramble.v              {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_split_add.v                          VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_split_add.v             {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc_pulse.v                          VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc_pulse.v             {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_cdc_strobed.v                        VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_cdc_strobed.v           {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_dcfifo.v                             VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_dcfifo.v                {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_measure_vid.v                        VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_measure_vid.v           {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_scfifo.v                             VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_scfifo.v                {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_symb_delay.v                         VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_symb_delay.v            {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_aux_bch.v                            VERILOG_ENCRYPT PATH ../common/aldec/src_hdl/bitec_hdmi_aux_bch.v               {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx.v                                 VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx.v                              {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_aux_encoder.v                     VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_aux_encoder.v                  {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v            VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v         {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v             VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v          {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_aux_mux.v                         VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_aux_mux.v                      {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                      VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                   {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_create_aux.v                      VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_create_aux.v                   {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_encode.v                          VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_encode.v                       {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_resample.v                        VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_resample.v                     {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_tmds.v                            VERILOG_ENCRYPT PATH aldec/src_hdl/bitec_hdmi_tx_tmds.v                         {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_audio.v                           VERILOG_ENCRYPT PATH aldec/src_hdl/audio/bitec_hdmi_tx_audio.v                  {ALDEC_SPECIFIC}
    add_fileset_file aldec/src_hdl/bitec_hdmi_tx_audio_mux.v                       VERILOG_ENCRYPT PATH aldec/src_hdl/audio/bitec_hdmi_tx_audio_mux.v              {ALDEC_SPECIFIC}
  
  }
  
  if {1} {
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc.v                                VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc.v                   {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_reset_sync.v                         VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_reset_sync.v            {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_scramble.v                           VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_scramble.v              {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_split_add.v                          VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_split_add.v             {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc_pulse.v                          VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc_pulse.v             {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_cdc_strobed.v                        VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_cdc_strobed.v           {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_dcfifo.v                             VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_dcfifo.v                {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_measure_vid.v                        VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_measure_vid.v           {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_scfifo.v                             VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_scfifo.v                {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_symb_delay.v                         VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_symb_delay.v            {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_aux_bch.v                            VERILOG_ENCRYPT PATH ../common/cadence/src_hdl/bitec_hdmi_aux_bch.v               {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx.v                                 VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx.v                              {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_aux_encoder.v                     VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_aux_encoder.v                  {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v            VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v         {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v             VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v          {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_aux_mux.v                         VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_aux_mux.v                      {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                      VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                   {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_create_aux.v                      VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_create_aux.v                   {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_encode.v                          VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_encode.v                       {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_resample.v                        VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_resample.v                     {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_tmds.v                            VERILOG_ENCRYPT PATH cadence/src_hdl/bitec_hdmi_tx_tmds.v                         {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_audio.v                           VERILOG_ENCRYPT PATH cadence/src_hdl/audio/bitec_hdmi_tx_audio.v                  {CADENCE_SPECIFIC}
    add_fileset_file cadence/src_hdl/bitec_hdmi_tx_audio_mux.v                       VERILOG_ENCRYPT PATH cadence/src_hdl/audio/bitec_hdmi_tx_audio_mux.v              {CADENCE_SPECIFIC}
  
  
  
  }
  if {1} {
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc.v                               VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc.v                   {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_reset_sync.v                        VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_reset_sync.v            {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_scramble.v                          VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_scramble.v              {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_split_add.v                         VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_split_add.v             {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc_pulse.v                         VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc_pulse.v             {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_cdc_strobed.v                       VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_cdc_strobed.v           {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_dcfifo.v                            VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_dcfifo.v                {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_measure_vid.v                       VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_measure_vid.v           {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_scfifo.v                            VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_scfifo.v                {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_symb_delay.v                        VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_symb_delay.v            {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_aux_bch.v                           VERILOG_ENCRYPT PATH ../common/synopsys/src_hdl/bitec_hdmi_aux_bch.v               {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx.v                                VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx.v                              {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_aux_encoder.v                    VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_aux_encoder.v                  {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v           VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v            VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v          {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_aux_mux.v                        VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_aux_mux.v                      {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                     VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_aux_mux_x2.v                   {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_create_aux.v                     VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_create_aux.v                   {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_encode.v                         VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_encode.v                       {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_resample.v                       VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_resample.v                     {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_tmds.v                           VERILOG_ENCRYPT PATH synopsys/src_hdl/bitec_hdmi_tx_tmds.v                         {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_audio.v                          VERILOG_ENCRYPT PATH synopsys/src_hdl/audio/bitec_hdmi_tx_audio.v                  {SYNOPSYS_SPECIFIC}
    add_fileset_file synopsys/src_hdl/bitec_hdmi_tx_audio_mux.v                      VERILOG_ENCRYPT PATH synopsys/src_hdl/audio/bitec_hdmi_tx_audio_mux.v              {SYNOPSYS_SPECIFIC}
  
  
  }
}



# +-----------------------------------
# | files
# | 
proc generate_ed_files {name} {
    add_fileset_file bitec_hdmi_cdc.v                              VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_reset_sync.v                       VERILOG PATH ../common/src_hdl/bitec_hdmi_reset_sync.v            {SYNTHESIS}
    add_fileset_file bitec_hdmi_scramble.v                         VERILOG PATH ../common/src_hdl/bitec_hdmi_scramble.v              {SYNTHESIS}
    add_fileset_file bitec_hdmi_split_add.v                        VERILOG PATH ../common/src_hdl/bitec_hdmi_split_add.v             {SYNTHESIS}
    add_fileset_file bitec_hdmi_cdc_pulse.v                        VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc_pulse.v             {SYNTHESIS}
    add_fileset_file bitec_hdmi_cdc_strobed.v                      VERILOG PATH ../common/src_hdl/bitec_hdmi_cdc_strobed.v           {SYNTHESIS}
    add_fileset_file bitec_hdmi_dcfifo.v                           VERILOG PATH ../common/src_hdl/bitec_hdmi_dcfifo.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_measure_vid.v                      VERILOG PATH ../common/src_hdl/bitec_hdmi_measure_vid.v           {SYNTHESIS}
    add_fileset_file bitec_hdmi_scfifo.v                           VERILOG PATH ../common/src_hdl/bitec_hdmi_scfifo.v                {SYNTHESIS}
    add_fileset_file bitec_hdmi_symb_delay.v                       VERILOG PATH ../common/src_hdl/bitec_hdmi_symb_delay.v            {SYNTHESIS}
    add_fileset_file bitec_hdmi_aux_bch.v                          VERILOG PATH ../common/src_hdl/bitec_hdmi_aux_bch.v               {SYNTHESIS}
    add_fileset_file bitec_hdmi.sdc                                SDC     PATH ../common/src_hdl/bitec_hdmi.sdc
    add_fileset_file bitec_hdmi_tx.v                               VERILOG PATH src_hdl/bitec_hdmi_tx.v                              {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_aux_encoder.v                   VERILOG PATH src_hdl/bitec_hdmi_tx_aux_encoder.v                  {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_aux_encoder_pipeline.v          VERILOG PATH src_hdl/bitec_hdmi_tx_aux_encoder_pipeline.v         {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_aux_encoder_wop_gen.v           VERILOG PATH src_hdl/bitec_hdmi_tx_aux_encoder_wop_gen.v          {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_aux_mux.v                       VERILOG PATH src_hdl/bitec_hdmi_tx_aux_mux.v                      {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_aux_mux_x2.v                    VERILOG PATH src_hdl/bitec_hdmi_tx_aux_mux_x2.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_create_aux.v                    VERILOG PATH src_hdl/bitec_hdmi_tx_create_aux.v                   {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_encode.v                        VERILOG PATH src_hdl/bitec_hdmi_tx_encode.v                       {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_resample.v                      VERILOG PATH src_hdl/bitec_hdmi_tx_resample.v                     {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_tmds.v                          VERILOG PATH src_hdl/bitec_hdmi_tx_tmds.v                         {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_audio.v                         VERILOG PATH src_hdl/audio/bitec_hdmi_tx_audio.v                  {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx_audio_mux.v                     VERILOG PATH src_hdl/audio/bitec_hdmi_tx_audio_mux.v              {SYNTHESIS}
    add_fileset_file bitec_hdmi_tx.ocp                             OTHER   PATH src_hdl/bitec_hdmi_tx.ocp                            {SYNTHESIS}
   
}

# | 
# +-----------------------------------

altera_hdmi_common_params
set_parameter_property FAMILY HDL_PARAMETER false
set_parameter_property SCDC_IEEE_ID HDL_PARAMETER false
set_parameter_property SCDC_DEVICE_STRING HDL_PARAMETER false
set_parameter_property SCDC_HW_REVISION HDL_PARAMETER false
set_parameter_property DISABLE_ALIGN_DESKEW HDL_PARAMETER false


set common_composed_mode 0

proc elaboration_callback {} {

  set symbols_per_clock [get_parameter_value SYMBOLS_PER_CLOCK]
  add_hdmi_export_interface tx
  add_hdmi_tx_interface symbols_per_clock
  
}
