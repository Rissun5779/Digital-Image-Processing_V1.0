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
# Saved on Tue Jun 23 10:12:43 2015
# Designs open: 1
#   V1: result.vpd
# Toplevel windows open: 3
# 	TopLevel.1
# 	TopLevel.2
# 	TopLevel.3
#   Source.1: tb_top
#   Wave.1: 47 signals
#   Group count = 1
#   Group channel0 signal count = 47
# End_DVE_Session_Save_Info

# DVE version: I-2014.03-SP1
# DVE build date: Aug 27 2014 20:50:39


#<Session mode="Full" path="/data/scchan/system_design/scalable_de/15.1/dynamic_generation_ed/test_local_overlay/alt_em10g32_0_EXAMPLE_DESIGN/LL10G_Ethernet_A10_LINESIDE_1588v2/simulation/ed_sim/synopsys/vcs/vcs_wave.tcl" type="Debug">

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
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{0 18} {2715 1015}}

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
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 743]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 743
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value 944
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 742} {height 804} {dock_state left} {dock_on_new_line true} {child_hier_colhier 590} {child_hier_coltype 166} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 122]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1591
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 122
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 2715} {height 121} {dock_state bottom} {dock_on_new_line true}}
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
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 348} {child_data_colvalue 247} {child_data_coltype 247} {child_data_col1 1} {child_data_col2 0} {child_data_col3 2}}

# End MDI window settings


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state maximized -rect {{0 0} {2497 997}}

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
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

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
gui_show_window -window ${TopLevel.3} -show_state maximized -rect {{1440 22} {2719 983}}

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
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.3}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 574} {child_wave_right 700} {child_wave_colname 466} {child_wave_colvalue 104} {child_wave_col1 0} {child_wave_col2 1}}

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

if { ![gui_is_db_opened -db {result.vpd}] } {
	gui_open_db -design V1 -file result.vpd -nosource
}
gui_set_precision 1fs
gui_set_time_units 1fs
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst}


set _session_group_1 channel0
gui_sg_create "$_session_group_1"
set channel0 "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_address} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_waitrequest} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_read} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_readdata} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_write} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.csr_writedata} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_valid} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_ready} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_startofpacket} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_endofpacket} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_empty} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_error} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_valid} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_ready} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_startofpacket} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_endofpacket} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_empty} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_error} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_status_valid} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_status_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_tx_status_error} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_status_valid} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_status_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_rx_status_error} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_link_fault_status_xgmii_rx_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.mac_avalon_st_pause_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_usr_seq_reset} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_tx_serial_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_serial_data} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_led_an} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_led_char_err} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_led_disp_err} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_led_link} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_syncstatus} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_data_ready} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_block_lock} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_hi_ber} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_rlv} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rxeq_done} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_pcfifo_error_1g} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_tx_pcfifo_error_1g} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_clkslip} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_lcl_rf} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_en_lcl_rxeq} {tb_top.genblk1.dut.CHANNEL[0].altera_eth_channel_1588_inst.phy_rx_recovered_clk} }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 46305918552



# Save global setting...

# Wave/List view global setting
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
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active tb_top /data/scchan/system_design/scalable_de/15.1/dynamic_generation_ed/test_local_overlay/alt_em10g32_0_EXAMPLE_DESIGN/LL10G_Ethernet_A10_LINESIDE_1588v2/simulation/ed_sim/models/tb_top_n_1588.sv
gui_view_scroll -id ${Source.1} -vertical -set 465
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
gui_wv_zoom_timerange -id ${Wave.1} 0 61802418507
gui_list_add_group -id ${Wave.1} -after {New Group} {channel0}
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
gui_list_set_insertion_bar  -id ${Wave.1} -group {New Group} -position in

gui_marker_move -id ${Wave.1} {C1} 46305918552
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Source.1}
}
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${DLPane.1}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

