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


# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Dec 15 17:50:13 2015
# Designs open: 1
#   Sim: simv
# Toplevel windows open: 3
# 	TopLevel.1
# 	TopLevel.2
# 	TopLevel.3
#   Source.1: tb_top.U_TESTCASE.unnamed$$_13
#   Wave.1: 55 signals
#   Group count = 14
#   Group Channel-0 signal count = 13
# End_DVE_Session_Save_Info

# DVE version: J-2014.12-SP1
# DVE build date: Feb 26 2015 21:06:57


#<Session mode="Full" path="/backup/usr1/data/sxsaw/regtest_storage/93860265/regtest/ip/ethernet/alt_em10g32/example_design/arria_10_lineside_10g_usxgmii_sim_gate_test/alt_em10g32/LL10G_Ethernet_A10_10G_USXGMII/simulation/ed_sim/synopsys/vcs/vcs_wave.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{0 48} {1279 991}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 325]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 325
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value 944
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 324} {height 727} {dock_state left} {dock_on_new_line true} {child_hier_colhier 329} {child_hier_coltype 10} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 118]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1591
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 118
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1279} {height 117} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set DLPane.1 [gui_create_window -type {DLPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${DLPane.1} -type Data] == {}} {
        set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
} else {
        set Data.1  [gui_get_shared_view -id ${DLPane.1} -type Data]
}

gui_show_window -window ${DLPane.1} -show_state maximized
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 379} {child_data_colvalue 277} {child_data_coltype 277} {child_data_col1 1} {child_data_col2 0} {child_data_col3 2}}

# End MDI window settings


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state maximized -rect {{0 48} {1279 991}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.2}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level window: TopLevel.3

if {![gui_exist_window -window TopLevel.3]} {
    set TopLevel.3 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.3 TopLevel.3
}
gui_show_window -window ${TopLevel.3} -show_state maximized -rect {{1292 84} {2891 1262}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.3}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 718} {child_wave_right 876} {child_wave_colname 583} {child_wave_colvalue 131} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}
gui_update_statusbar_target_frame ${TopLevel.2}
gui_update_statusbar_target_frame ${TopLevel.3}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{ -ucligui}}
gui_set_env SIMSETUP::SIMEXE {simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {simv}] } {
gui_sim_run Ucli -exe simv -args { -ucligui} -dir ../vcs -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1fs
gui_set_time_units 1fs
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy}
gui_load_child_values {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac}


set _session_group_43 Channel-0
gui_sg_create "$_session_group_43"
set Channel-0 "$_session_group_43"

gui_sg_addsignal -group "$_session_group_43" { }

set _session_group_44 $_session_group_43|
append _session_group_44 {PHY Serial Interface}
gui_sg_create "$_session_group_44"
set {Channel-0|PHY Serial Interface} "$_session_group_44"

gui_sg_addsignal -group "$_session_group_44" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.tx_serial_clk} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.rx_cdr_refclk_1} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.tx_serial_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.rx_serial_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.rx_pma_clkout} }

gui_sg_move "$_session_group_44" -after "$_session_group_43" -pos 11 

set _session_group_45 $_session_group_43|
append _session_group_45 {PHY Speed}
gui_sg_create "$_session_group_45"
set {Channel-0|PHY Speed} "$_session_group_45"

gui_sg_addsignal -group "$_session_group_45" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.operating_speed} }

gui_sg_move "$_session_group_45" -after "$_session_group_43" -pos 10 

set _session_group_46 $_session_group_43|
append _session_group_46 {PHY Avalon-MM CSR}
gui_sg_create "$_session_group_46"
set {Channel-0|PHY Avalon-MM CSR} "$_session_group_46"

gui_sg_addsignal -group "$_session_group_46" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_address} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_read} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_write} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_writedata} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_readdata} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.csr_waitrequest} }

gui_sg_move "$_session_group_46" -after "$_session_group_43" -pos 9 

set _session_group_47 $_session_group_43|
append _session_group_47 {XGMII RX}
gui_sg_create "$_session_group_47"
set {Channel-0|XGMII RX} "$_session_group_47"

gui_sg_addsignal -group "$_session_group_47" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_control} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_data} }

gui_sg_move "$_session_group_47" -after "$_session_group_43" -pos 8 

set _session_group_48 $_session_group_43|
append _session_group_48 {XGMII TX}
gui_sg_create "$_session_group_48"
set {Channel-0|XGMII TX} "$_session_group_48"

gui_sg_addsignal -group "$_session_group_48" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_control} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.xgmii_tx_data} }

gui_sg_move "$_session_group_48" -after "$_session_group_43" -pos 7 

set _session_group_49 $_session_group_43|
append _session_group_49 {MAC TX Status}
gui_sg_create "$_session_group_49"
set {Channel-0|MAC TX Status} "$_session_group_49"

gui_sg_addsignal -group "$_session_group_49" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_txstatus_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_txstatus_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_txstatus_error} }

gui_sg_move "$_session_group_49" -after "$_session_group_43" -pos 6 

set _session_group_50 $_session_group_43|
append _session_group_50 {MAC RX Status}
gui_sg_create "$_session_group_50"
set {Channel-0|MAC RX Status} "$_session_group_50"

gui_sg_addsignal -group "$_session_group_50" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rxstatus_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rxstatus_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rxstatus_error} }

gui_sg_move "$_session_group_50" -after "$_session_group_43" -pos 5 

set _session_group_51 $_session_group_43|
append _session_group_51 {MAC Avalon-ST RX}
gui_sg_create "$_session_group_51"
set {Channel-0|MAC Avalon-ST RX} "$_session_group_51"

gui_sg_addsignal -group "$_session_group_51" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_ready} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_startofpacket} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_endofpacket} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_empty} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_rx_error} }

gui_sg_move "$_session_group_51" -after "$_session_group_43" -pos 4 

set _session_group_52 $_session_group_43|
append _session_group_52 {MAC Avalon-ST TX}
gui_sg_create "$_session_group_52"
set {Channel-0|MAC Avalon-ST TX} "$_session_group_52"

gui_sg_addsignal -group "$_session_group_52" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_valid} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_ready} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_startofpacket} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_endofpacket} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_data} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_empty} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.avalon_st_tx_error} }

gui_sg_move "$_session_group_52" -after "$_session_group_43" -pos 3 

set _session_group_53 $_session_group_43|
append _session_group_53 {MAC Avalon-MM CSR}
gui_sg_create "$_session_group_53"
set {Channel-0|MAC Avalon-MM CSR} "$_session_group_53"

gui_sg_addsignal -group "$_session_group_53" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_address} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_read} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_write} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_writedata} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_readdata} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac.csr_waitrequest} }

gui_sg_move "$_session_group_53" -after "$_session_group_43" -pos 2 

set _session_group_54 $_session_group_43|
append _session_group_54 Reset
gui_sg_create "$_session_group_54"
set Channel-0|Reset "$_session_group_54"

gui_sg_addsignal -group "$_session_group_54" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.reset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.tx_digitalreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.rx_digitalreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.tx_analogreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.rx_analogreset} }

gui_sg_move "$_session_group_54" -after "$_session_group_43" -pos 1 

set _session_group_55 $_session_group_43|
append _session_group_55 Clock
gui_sg_create "$_session_group_55"
set Channel-0|Clock "$_session_group_55"

gui_sg_addsignal -group "$_session_group_55" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.csr_clk} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac32b_clk} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac64b_clk} }

set _session_group_56 $_session_group_43|
append _session_group_56 {PHY Status}
gui_sg_create "$_session_group_56"
set {Channel-0|PHY Status} "$_session_group_56"

gui_sg_addsignal -group "$_session_group_56" { {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.rx_block_lock} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.led_an} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.phy.rx_is_lockedtodata} }

gui_sg_move "$_session_group_56" -after "$_session_group_43" -pos 12 

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 62943084112



# Save global setting...

# Wave/List view global setting
gui_list_create_group_when_add -wave -enable
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} tb_top}
catch {gui_list_expand -id ${Hier.1} tb_top.DUT}
catch {gui_list_select -id ${Hier.1} {{tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel}}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*reset*}
gui_list_show_data -id ${Data.1} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {{tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.reset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.tx_digitalreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.rx_analogreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.tx_analogreset} {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.rx_digitalreset} }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active {tb_top.U_TESTCASE.unnamed$$_13} /backup/usr1/data/sxsaw/regtest_storage/93860265/regtest/ip/ethernet/alt_em10g32/example_design/arria_10_lineside_10g_usxgmii_sim_gate_test/alt_em10g32/LL10G_Ethernet_A10_10G_USXGMII/simulation/ed_sim/models/tb_testcase.sv
gui_view_scroll -id ${Source.1} -vertical -set 2025
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 10000
gui_list_add_group -id ${Wave.1} -after {New Group} {Channel-0}
gui_list_add_group -id ${Wave.1}  -after Channel-0 {Channel-0|Clock}
gui_list_add_group -id ${Wave.1} -after Channel-0|Clock {Channel-0|Reset}
gui_list_add_group -id ${Wave.1} -after Channel-0|Reset {{Channel-0|MAC Avalon-MM CSR}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|MAC Avalon-MM CSR} {{Channel-0|MAC Avalon-ST TX}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|MAC Avalon-ST TX} {{Channel-0|MAC Avalon-ST RX}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|MAC Avalon-ST RX} {{Channel-0|MAC RX Status}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|MAC RX Status} {{Channel-0|MAC TX Status}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|MAC TX Status} {{Channel-0|XGMII TX}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|XGMII TX} {{Channel-0|XGMII RX}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|XGMII RX} {{Channel-0|PHY Avalon-MM CSR}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|PHY Avalon-MM CSR} {{Channel-0|PHY Speed}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|PHY Speed} {{Channel-0|PHY Serial Interface}}
gui_list_add_group -id ${Wave.1} -after {Channel-0|PHY Serial Interface} {{Channel-0|PHY Status}}
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Channel-0|Clock  -item {tb_top.DUT.CHANNEL_GEN[0].genblk1.u_channel.mac64b_clk} -position below

gui_marker_move -id ${Wave.1} {C1} 62943084112
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${DLPane.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Source.1}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

