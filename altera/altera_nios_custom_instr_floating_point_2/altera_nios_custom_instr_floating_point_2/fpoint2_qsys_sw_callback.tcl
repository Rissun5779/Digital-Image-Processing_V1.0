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


proc validate { args } {
    set ciName "altera_nios_custom_instr_floating_point_2"
    set ciInterface "s1"
    array set assignments [get_custom_instruction_interface_assignments $ciName $ciInterface]
    set opcode [get_custom_instruction_interface_opcode_number $ciName $ciInterface]
    foreach assignment [array names assignments] {
    	set prefix "embeddedsw.customInstruction.$ciInterface."
    	if {[string match "$prefix*" $assignment]} { 
            set offset [string range $assignment [string length $prefix] [string length $assignment]]
            set fname ""
            if {$offset == 0} {
            	set fname "fabss"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 1} {
            	set fname "fnegs"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 2} {
            	set fname "fcmpnes"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 3} {
            	set fname "fcmpeqs"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 4} {
            	set fname "fcmpges"
                add_module_systemh_macro_helper "$assignment.name" $fname 
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 5} {
            	set fname "fcmpgts"
                add_module_systemh_macro_helper "$assignment.name" $fname 
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 6} {
            	set fname "fcmples"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 7} {
            	set fname "fcmplts"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 8} {
            	set fname "fmaxs"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_module_systemh_macro_helper "$assignment.buildin" "true"
                add_module_systemh_macro_helper "$assignment.macroName" "fmaxf" 
                add_module_systemh_macro_helper "$assignment.returnType" "float"
                add_module_systemh_macro_helper "$assignment.operandAType" "float"
                add_module_systemh_macro_helper "$assignment.operandBType" "float"
            } elseif  {$offset == 9} {
            	set fname "fmins"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_module_systemh_macro_helper "$assignment.buildin" "true"
                add_module_systemh_macro_helper "$assignment.macroName" "fminf" 
                add_module_systemh_macro_helper "$assignment.returnType" "float"
                add_module_systemh_macro_helper "$assignment.operandAType" "float"
                add_module_systemh_macro_helper "$assignment.operandBType" "float"
            }
        }
    }
    

    set ciInterface "s2"
    array set assignments [get_custom_instruction_interface_assignments $ciName $ciInterface]
    set opcode [get_custom_instruction_interface_opcode_number $ciName $ciInterface]
    foreach assignment [array names assignments] {
    	set prefix "embeddedsw.customInstruction.$ciInterface."
    	if {[string match "$prefix*" $assignment]} { 
            set offset [string range $assignment [string length $prefix] [string length $assignment]]
            set fname ""
            if {$offset == 0} {
            	set fname "round"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_module_systemh_macro_helper "$assignment.buildin" "true"
                add_module_systemh_macro_helper "$assignment.macroName" "lroundf"    
                add_module_systemh_macro_helper "$assignment.returnType" "integer"
                add_module_systemh_macro_helper "$assignment.operandAType" "float"
            } elseif  {$offset == 1} {
            	set fname "fixsi"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 2} {
            	set fname "floatis"
                add_module_systemh_macro_helper "$assignment.name" $fname
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 3} {
            	set fname "fsqrts"
                add_module_systemh_macro_helper "$assignment.name" $fname 
                add_module_systemh_macro_helper "$assignment.buildin" "true"
                add_module_systemh_macro_helper "$assignment.macroName" "sqrtf"
                add_module_systemh_macro_helper "$assignment.returnType" "float"
                add_module_systemh_macro_helper "$assignment.operandAType" "float"
            } elseif  {$offset == 4} {
            	set fname "fmuls"
                add_module_systemh_macro_helper "$assignment.name" $fname 
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 5} {
            	set fname "fadds"
                add_module_systemh_macro_helper "$assignment.name" $fname 
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 6} {
            	set fname "fsubs"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            } elseif  {$offset == 7} {
            	set fname "fdivs"
                add_module_systemh_macro_helper "$assignment.name" $fname  
                add_callback_sw_property alt_cflags_addition -mcustom-$fname=[expr $opcode+$offset]
            }
        }
    }
}
