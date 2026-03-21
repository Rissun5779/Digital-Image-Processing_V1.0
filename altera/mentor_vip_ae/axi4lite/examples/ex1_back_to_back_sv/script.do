# Useage: "vsim -mvchome ../../../common -do script.do"

vlib work
vlog -sv -timescale 1ns/1ns \
  ../../../common/questa_mvc_svapi.svh \
  ../../../axi4/bfm/mgc_common_axi4.sv \
  ../../../axi4/bfm/mgc_axi4_master.sv \
  ../../../axi4lite/bfm/mgc_axi4lite_master.sv \
  ../../../axi4/bfm/mgc_axi4_monitor.sv \
  ../../../axi4/bfm/mgc_axi4_inline_monitor.sv \
  ../../../axi4lite/bfm/mgc_axi4lite_inline_monitor.sv \
  ../../../axi4/bfm/mgc_axi4_slave.sv \
  ../../../axi4lite/bfm/mgc_axi4lite_slave.sv \
  master_test_program.sv \
  monitor_test_program.sv \
  slave_test_program.sv \
  top.sv

vsim top
