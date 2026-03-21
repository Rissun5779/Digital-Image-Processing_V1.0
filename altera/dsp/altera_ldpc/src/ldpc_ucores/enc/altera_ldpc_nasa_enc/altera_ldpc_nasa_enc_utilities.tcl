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




proc generate_enc_ROM_rtl {entity} {

    set nbcheckgroup        [ get_parameter_value NBCHECKGROUP]
    set nbvargroup          [ get_parameter_value NBVARGROUP]


    set nbparitygroup $nbcheckgroup
    set nbparityvar   $nbvargroup

    
    set nb_addr_per_code 14
    set Z 511
    if {$Z%4==0} {
        set nbchar_per_parity [expr $Z>>2]
    } else {
        set nbchar_per_parity [expr ($Z>>2) + 1]
    }


    
    
    
    
    set list_of_generated_files [list ]

    set cwd [pwd]

    set text ""

    append text     "module altera_ldpc_nasa_enc_ROMs(\n"
    append text     "    clk, \n"
    append text     "    rst, \n"
    append text     "    in_addr, \n"
    append text     "    out_data_ROM \n"
    append text     ");\n\n"
    append text     "parameter   NB_ADDR        = 3;\n\n"
    append text     "localparam  Z              = 511;\n"
    append text     "localparam  OUTDATA_WIDTH  = $nbcheckgroup;\n\n"
    append text     "input                                      clk;\n"
    append text     "input                                      rst;\n";     
    append text     "input   \[NB_ADDR-1:0\]\[ADDR_WIDTH-1:0\]  in_addr;\n"
    append text     "output  \[OUTDATA_WIDTH-1:0\]\[Z-1:0\]     out_data_ROM;\n\n"
    
    
        set nb_addr $nb_addr_per_code
        set nb_addr_pow2 [expr 1<<[clog2 $nb_addr]]
        set addr_width [clog2 [expr $nb_addr_pow2]]
    
        for {set jj 0} {$jj < $nbparitygroup} {incr jj} {

            append text     "        altsyncram #(.operation_mode(\"ROM\"), \n"
            append text     "            .numwords_a($nb_addr_pow2),\n"
            append text     "            .width_a(Z),\n"
            append text     "            .widthad_a($addr_width),\n"
            append text     "            .outdata_reg_a(\"CLOCK0\"),\n"
            append text     "            .outdata_aclr_a(\"CLEAR0\"),   \n"                     
            append text     "            .clock_enable_input_a(\"NORMAL\"),  \n"                      
            append text     "            .power_up_uninitialized (\"FALSE\"), \n"                       
            append text     "            .ram_block_type(\"AUTO\"),\n"
            append text     "            .init_file(\"${entity}_rom_${jj}_data.hex\"),\n"
            append text     "            .init_file_layout(\"PORT_A\")\n"
            append text     "            ) ROM_PARITY_${jj}( \n"
            append text     "            .clock0(clk),\n"
            append text     "            .aclr0(),\n"
            append text     "            .address_a(in_addr\[(${jj})%NB_ADDR\]\[$addr_width-1:0\]),\n"
            append text     "            .q_a(out_data_ROM\[${jj}\]),\n"
            append text     "            .address_b(),\n"
            append text     "            .clock1(),\n"
            append text     "            .clocken1(),\n"
            append text     "            .data_a(),\n"
            append text     "            .q_b(), \n"
            append text     "            .wren_a(),\n"
            append text     "            .eccstatus(),\n"
            append text     "            .aclr1(),\n"
            append text     "            .addressstall_a(),\n"
            append text     "            .addressstall_b(),\n"
            append text     "            .byteena_a(),\n"
            append text     "            .byteena_b(),\n"
            append text     "            .clocken0(),\n"
            append text     "            .clocken2(),\n"
            append text     "            .clocken3(),\n"
            append text     "            .data_b(),\n"
            append text     "            .rden_a(),\n"
            append text     "            .rden_b(),\n"
            append text     "            .wren_b()\n"
            append text     "        );\n"
        }  
        
     
    append text     "endmodule\n"
    add_fileset_file "altera_auto_nasa_enc_ROM.sv" SYSTEM_VERILOG TEXT $text


    
    
    
    

    set fp [open "$cwd/code_ROM.hex" r]
    set file_data [read $fp]
    close $fp

    # grouping DATA
    set grouped_data [list ]
    set strmatch ""
    for {set ii 0} {$ii<$nbchar_per_parity} {incr ii} {
        append strmatch "."
    }
    lappend grouped_data  [regexp -all -inline $strmatch $file_data]



    

    set nb_addr $nb_addr_per_code
    set nb_addr_pow2 [expr 1<<[clog2 $nb_addr]]


    for {set jj 0} {$jj < $nbparitygroup} {incr jj} {

        set parity_list [list ]
        set offset [expr $jj*$nbparityvar]

        for {set ll 0} {$ll < $nbparityvar} {incr ll} {
            lappend parity_list [lindex $grouped_data  [expr $ll+$offset] ]
        }

        # filing up with zeros
        if {$nbparityvar!=$nb_addr_per_code} {
            for {set ll 0} {$ll < $nb_addr_per_code-$nbparityvar} {incr ll} {
                lappend parity_list [string repeat 0 $nbchar_per_parity] 
            }
        }

        
        # filing up with zeros up to the next power of 2
        for {set ll 0} {$ll < $nb_addr_pow2-$nb_addr} {incr ll} {
            lappend parity_list [string repeat 0 $nbchar_per_parity] 
        }
        
        set parity_hex [convert_hexa_to_HEX $parity_list]
        add_fileset_file "${entity}_rom_${jj}_data.hex"  HEX TEXT $parity_hex

        
    }

    
    
    
    
return $list_of_generated_files



}


proc convert_hexa_to_HEX {hexa_list} {
    # this function convert a list of hexadecimal number into a
    # Intel HEX format list used in ROM initialisation
    # 
    # 
    # 
    
    set HEX_list [list ]
    set length [llength $hexa_list]
    set HexacharPerWord     [llength [regexp -all -inline . [lindex $hexa_list 0]]]

    if {$HexacharPerWord%2!=0} {
        set append_char 0 
        incr HexacharPerWord
    } else {
        set append_char ""
    }
    
    
    for {set ii 0} {$ii<$length} {incr ii} {
        #
        set nb_byte [format %02X [expr $HexacharPerWord>>1] ]
        
        set address [format %04X [expr $ii] ] 
        set record_type "00"
        set data $append_char[lindex $hexa_list $ii]
        set crc [format %02X [ihex_crc  [regexp -all -inline .. $nb_byte$address$record_type$data]] ] 
        append HEX_list ":${nb_byte}${address}${record_type}${data}${crc}\n"
    
    }
    append HEX_list ":00000001FF"

    return $HEX_list

}


proc ihex_crc {bytes} {
    # Calculate Intel-hex CRC for list of bytes
    set sum 0
    foreach b $bytes {
        incr sum 0x$b
    }
    set sum [expr {(1 + ~$sum) & 0xFF}] ;# bcb
    return $sum
}

proc clog2 {nb} {

    set x [expr $nb-1]
    set l 1
    
    if {$nb<2} {
        return 0
    }
    
    for {set ii 1} {$ii<33} {incr ii} {
        if {$x>1} {
            set x [expr $x/2]
            
            incr l
        } else {
            break
        }
    }
    return $l
}


