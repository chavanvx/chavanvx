# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Mon Oct 23 07:23:18 2023
# Designs open: 1
#   V1: /nfs/site/disks/swuser_work_chavanvx/FILTER_RELAY/verification/sim/basic_bmc_side_rw_test.9/vcdplus.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: top_tb.u_smbus_filtered_relay_1
#   Wave.1: 24 signals
#   Group count = 5
#   Group Group1 signal count = 8
#   Group Group2 signal count = 2
#   Group Group3 signal count = 6
#   Group Group4 signal count = 0
#   Group Group5 signal count = 8
# End_DVE_Session_Save_Info

# DVE version: R-2020.12_Full64
# DVE build date: Dec  7 2020 21:32:09


#<Session mode="Full" path="/nfs/site/disks/swuser_work_chavanvx/FILTER_RELAY/verification/scripts/DVEfiles/session.tcl" type="Debug">

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
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{0 22} {1899 949}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
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
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 468]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 468
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 467} {height 679} {dock_state left} {dock_on_new_line true} {child_hier_colhier 385} {child_hier_coltype 73} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 500]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 500
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 678
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 499} {height 679} {dock_state left} {dock_on_new_line true} {child_data_colvariable 281} {child_data_colvalue 84} {child_data_coltype 109} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 177]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1840
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 177
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1899} {height 176} {dock_state bottom} {dock_on_new_line true}}
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
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 395} {child_wave_right 531} {child_wave_colname 352} {child_wave_colvalue 42} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/nfs/site/disks/swuser_work_chavanvx/FILTER_RELAY/verification/sim/basic_bmc_side_rw_test.9/vcdplus.vpd}] } {
	gui_open_db -design V1 -file /nfs/site/disks/swuser_work_chavanvx/FILTER_RELAY/verification/sim/basic_bmc_side_rw_test.9/vcdplus.vpd -nosource
}
gui_set_precision 1ps
gui_set_time_units 1ps
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups


set _session_group_1 Group1
gui_sg_create "$_session_group_1"
set Group1 "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { top_tb.u_smbus_filtered_relay_1.ia_master_scl top_tb.u_smbus_filtered_relay_1.o_master_scl_oe top_tb.u_smbus_filtered_relay_1.ia_master_sda top_tb.u_smbus_filtered_relay_1.o_master_sda_oe top_tb.u_smbus_filtered_relay_1.ia_slave_scl top_tb.u_smbus_filtered_relay_1.o_slave_scl_oe top_tb.u_smbus_filtered_relay_1.ia_slave_sda top_tb.u_smbus_filtered_relay_1.o_slave_sda_oe }

set _session_group_2 Group2
gui_sg_create "$_session_group_2"
set Group2 "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { top_tb.u_smbus_filtered_relay_1.address_match_index top_tb.u_smbus_filtered_relay_1.relay_state }

set _session_group_3 Group3
gui_sg_create "$_session_group_3"
set Group3 "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { top_tb.i2c_slv1_slave0.if_port.CLK top_tb.i2c_slv1_slave0.if_port.RST top_tb.i2c_slv1_slave0.if_port.SCL top_tb.i2c_slv1_slave0.if_port.SDA top_tb.i2c_slv1_slave0.if_port.SMBALRT {top_tb.i2c_slv1_slave0.if_port.slave_if[0].address} }

set _session_group_4 Group4
gui_sg_create "$_session_group_4"
set Group4 "$_session_group_4"


set _session_group_5 Group5
gui_sg_create "$_session_group_5"
set Group5 "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_byte top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_count top_tb.i2c_slv1_slave0.Slave.monitor_slave.if_mon.read_write_slv top_tb.i2c_slv1_slave0.Slave.monitor_slave.if_mon.scrbrd_master_data top_tb.i2c_slv1_slave0.Slave.monitor_slave.if_mon.scrbrd_slave_data top_tb.i2c_slv1_slave0.Slave.Slave.eeprom_8bit top_tb.i2c_slv1_slave0.Slave.Slave.eeprom_mem_ptr_8bit {top_tb.i2c_slv1_slave0.if_port.slave_if[0].data} }
gui_set_radix -radix {decimal} -signals {V1:top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_count}
gui_set_radix -radix {twosComplement} -signals {V1:top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_count}
gui_set_radix -radix {decimal} -signals {V1:top_tb.i2c_slv1_slave0.Slave.Slave.eeprom_8bit}
gui_set_radix -radix {twosComplement} -signals {V1:top_tb.i2c_slv1_slave0.Slave.Slave.eeprom_8bit}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 395795001



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
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} top_tb}
catch {gui_list_expand -id ${Hier.1} top_tb.i2c_slv1_slave0}
catch {gui_list_expand -id ${Hier.1} top_tb.i2c_slv1_slave0.Slave}
catch {gui_list_expand -id ${Hier.1} top_tb.i2c_slv1_slave0.Slave.monitor_slave}
catch {gui_list_select -id ${Hier.1} {top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor}}
gui_view_scroll -id ${Hier.1} -vertical -set 160
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_count }}
gui_view_scroll -id ${Data.1} -vertical -set 720
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 160
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active top_tb.u_smbus_filtered_relay_1 /nfs/site/disks/swuser_work_chavanvx/FILTER_RELAY/src/smbus_filtered_relay/smbus_filtered_relay.sv
gui_src_value_annotate -id ${Source.1} -switch true
gui_set_env TOGGLE::VALUEANNOTATE 1
gui_view_scroll -id ${Source.1} -vertical -set 1560
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
gui_wv_zoom_timerange -id ${Wave.1} 233818644 572292659
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group2}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group3}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group4}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group5}
gui_list_select -id ${Wave.1} {top_tb.i2c_slv1_slave0.Slave.monitor_slave.if_mon.scrbrd_slave_data }
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
gui_list_set_insertion_bar  -id ${Wave.1} -group Group5  -item {top_tb.i2c_slv1_slave0.Slave.monitor_slave.Monitor.data_count[31:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 395795001
gui_view_scroll -id ${Wave.1} -vertical -set 149
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

