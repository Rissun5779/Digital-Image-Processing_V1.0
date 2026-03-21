set TOP_LEVEL_NAME   top
set SYSTEM_NAME      ex1_back_to_back_vhd
set ARRIA10_OR_NEWER 0 ;# Device family Arria 10 and newer have a different output structure


if {$ARRIA10_OR_NEWER} {
  set QSYS_SIMDIR [file join $SYSTEM_NAME sim]
} else {
  set QSYS_SIMDIR [file join $SYSTEM_NAME simulation]
}

source $QSYS_SIMDIR/mentor/msim_setup.tcl

if {![info exists env(MENTOR_VIP_AE)]} {
  set env(MENTOR_VIP_AE) $env(QUARTUS_ROOTDIR)/../ip/altera/mentor_vip_ae
}

  ensure_lib libraries
  ensure_lib libraries/work
  vmap work  libraries/work
  
  vlog -work work -sv +incdir+$env(MENTOR_VIP_AE)/axi3/bfm +define+_MGC_VIP_VHDL_INTERFACE \
    $env(MENTOR_VIP_AE)/common/questa_mvc_svapi.svh \
    $env(MENTOR_VIP_AE)/axi3/bfm/mgc_common_axi.sv \
    $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_monitor.sv \
    $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_inline_monitor.sv \
    $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_master.sv \
    $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_slave.sv

  vcom -work work $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_bfm_pkg.vhd
  vcom -work work $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_monitor.vhd
  vcom -work work $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_inline_monitor.vhd
  vcom -work work $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_slave.vhd
  vcom -work work $env(MENTOR_VIP_AE)/axi3/bfm/mgc_axi_master.vhd

# Compile
# dev_com

# Compile
com

# Compile
vcom  master_test_program.vhd
vcom   slave_test_program.vhd
vcom monitor_test_program.vhd

# Compile
vcom top.vhd

# Simulate
elab
