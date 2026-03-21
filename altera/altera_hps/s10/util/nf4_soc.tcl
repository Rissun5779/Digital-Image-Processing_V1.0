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


# usage quartus_cdb -t <This TCL>

package require ::quartus::advanced_device
set part ND5_PART4
load_device -part $part

set total_pads [get_pad_data INT_PAD_COUNT]

puts "$total_pads"

for { set pad 0 } { $pad < $total_pads } { incr pad } {
    set is_hps_pad 0
    catch { set is_hps_pad [ get_pad_data BOOL_IS_HPS_PAD -pad $pad ] }
    if {$is_hps_pad}  {
        set string_hps_periphery_select "0"
        catch {set string_hps_periphery_select [get_pad_data STRING_HPS_PERIPHERY_SELECT -pad $pad]}

        if {  $string_hps_periphery_select != "0" } {
            puts "$pad, $string_hps_periphery_select,"
        }
    } 
}
unload_device