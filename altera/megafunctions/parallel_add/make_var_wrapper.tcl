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


#+---------------------------------------------------------------------------------------
#|
#| Name: make_var_wrapper
#|
#| Purpose: get ip parameters from hw.tcl file and transfer to terp params
#|
#| Return: ip specific vhd and verilog parameters array to pass to terp file
#|
#+----------------------------------------------------------------------------------------

proc make_var_wrapper {params_ref} {

    upvar $params_ref   params

    #---------------------------------------------------------------------------------
    # loop through port_list, add all ports to module_port_list
	# module_port_list {port direction width value}
	# add all ports to port_map_list too
	# port_map_list {name_l name_r direction width}
	# all ports: "aclr" "clken" "clock" "data0x data1x data2x ..." "result"
	#---------------------------------------------------------------------------------
	set module_port_list [list]
	set port_map_list [list]
	set top_size [expr $params(size)-1]
    set top_width [expr {$params(width)-1}]
	set top_widthr [expr {$params(effective_widthr)-1}]
	set data_added_once 0

    foreach port $params(port_list) {
        if {$port eq "aclr"} {
			lappend module_port_list $port "IN" -1 0
			lappend port_map_list $port $port "IN" -1
		} elseif {$port eq "clken"} {
            lappend module_port_list $port "IN" -1 1
			lappend port_map_list $port $port "IN" -1
		} elseif {$port eq "clock"} {
            lappend module_port_list $port "IN" -1 0
			lappend port_map_list $port $port "IN" -1
		} elseif { [regexp -- {^data[0-9]+x$} $port] } {
			lappend module_port_list $port "IN" $top_width -1
			if {!$data_added_once} {
				# all data0x data1x data2x ... connect to data[] port
				lappend port_map_list "data" "sub_wire1" "IN" $top_width
				set data_added_once 1
			}
		} elseif {$port eq "result"} {
            lappend module_port_list $port "OUT" $top_widthr -1
			set index [expr $params(size)+1]
			lappend port_map_list $port sub_wire$index "OUT" $top_widthr
		}
    }

	#---------------------------------------------------------------------------------
    # add aclr, clken and clock to tri_port_list #
	# tri_port_list {num port width} #
	#---------------------------------------------------------------------------------
	set tri_port_list [list]
	# for tri0
	set range_list_0 {"aclr" "clock"}
	# for tri1
	set range_list_1 {"clken"}
	foreach port $params(port_list) {
		if {[lsearch $range_list_0 $port]>=0} {
			lappend tri_port_list 0 $port -1
		} elseif {[lsearch $range_list_1 $port]>=0} {
			lappend tri_port_list 1 $port -1
		}
	}

	#---------------------------------------------------------------------------------
	# Wire connection for Verilog
	# Print sequence:
	# sub_wire_list_verilog {name width}
	# wire_list_verilog {name_l name_r width}
	# sub_wire1_list_verilog {width namelist_r}
	# result_wire_list_verilog {name_l name_r width}
	#---------------------------------------------------------------------------------
    # add output wire connection to sub_wire_list_verilog for Verilog
	# eg. wire [1150:0] sub_wire129;
	# sub_wire_list_verilog {name width}
	#---------------------------------------------------------------------------------
    set sub_wire_list_verilog [list]
	set index [expr $params(size)+1]
	lappend sub_wire_list_verilog sub_wire$index $top_widthr
	#---------------------------------------------------------------------------------
    # add output wire connection to wire_list_verilog
	# eg. wire [127:0] sub_wire128 = data127x[127:0];
	# eg. wire [127:0] sub_wire127 = data126x[127:0];
	# eg. ...
	# eg. wire [127:0] sub_wire3 = data2x[127:0];
	# eg. wire [127:0] sub_wire2 = data1x[127:0];
	# wire_list_verilog {name_l name_r width}
	#---------------------------------------------------------------------------------
    # add more output wire connection to sub_wire1_list_verilog
	# eg. wire [16383:0] sub_wire1 = {sub_wire128, sub_wire127, ... sub_wire2, sub_wire0};
	# sub_wire1_list_verilog {width namelist_r}
	#---------------------------------------------------------------------------------
	set wire_list_verilog [list]
	set namelist_r "{"
	set index [expr $params(size)-1]
	for {set i $params(size); set j $index} {$i > 1} {incr i -1; incr index -1} {
		lappend wire_list_verilog sub_wire$i	data$index\x  $top_width
		append namelist_r	sub_wire$i
		append namelist_r	", "
	}
	#---------------------------------------------------------------------------------
	# handle sub_wire0 separately, wire_list_verilog and sub_wire1_list_verilog
	# eg. wire [127:0] sub_wire0 = data0x[127:0];
	#---------------------------------------------------------------------------------
	lappend wire_list_verilog sub_wire0	data0x  $top_width
	append namelist_r	sub_wire0
	append namelist_r	"};"
	# construct sub_wire1_list_verilog
	set sub_wire1_list_verilog [list]
	set sub_wire1_top_width [expr $params(size)*$params(width)-1]
	lappend sub_wire1_list_verilog $sub_wire1_top_width
	lappend sub_wire1_list_verilog $namelist_r
	#---------------------------------------------------------------------------------
    # add all output wire connection to result_wire_list_verilog for Verilog
	# eg. wire [1150:0] result = sub_wire129[1150:0];
	# result_wire_list_verilog {name_l name_r width}
	#---------------------------------------------------------------------------------
	set result_wire_list_verilog [list]
	set index [expr $params(size)+1]
	lappend result_wire_list_verilog result	sub_wire$index  $top_widthr

	#---------------------------------------------------------------------------------
	# Wire connection for VHDL
	# Print sequence:
	# --	type ALTERA_MF_LOGIC_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;
	# sub_wire_list_vhdl {name_l name_r width_l width_r}
	# BEGIN
	# wire_list_vhdl {name_l name_r width}
	# array2d_wire_list_vhdl {name_l x y name_r}
	# result_wire_list_vhdl {name_l name_r width}
	#---------------------------------------------------------------------------------
    # add output wire connection to sub_wire_list_vhdl for VHDL
	# eg. SIGNAL sub_wire0	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	# eg. SIGNAL sub_wire1	: ALTERA_MF_LOGIC_2D (1 DOWNTO 0, 7 DOWNTO 0);
	# sub_wire_list_vhdl {name_l name_r width_l width_r}
	#---------------------------------------------------------------------------------
    set sub_wire_list_vhdl [list]
	set index [expr $params(size)+1]
	for {set i 0} {$i <= $index} {incr i} {
		if {$i == 1} {
			# sub_wire1 with ALTERA_MF_LOGIC_2D
			# eg. SIGNAL sub_wire1	: ALTERA_MF_LOGIC_2D (127 DOWNTO 0, 127 DOWNTO 0);
			lappend sub_wire_list_vhdl sub_wire$i ALTERA_MF_LOGIC_2D $top_size $top_width
		} elseif {$i == $index} {
			# last line
			# eg. SIGNAL sub_wire129	: STD_LOGIC_VECTOR (1150 DOWNTO 0);
			lappend sub_wire_list_vhdl sub_wire$i STD_LOGIC_VECTOR $top_widthr -1
		} else {
			lappend sub_wire_list_vhdl sub_wire$i STD_LOGIC_VECTOR $top_width -1
		}
	}
	#---------------------------------------------------------------------------------
    # add output wire connection to wire_list_vhdl for VHDL
	# eg. sub_wire128    <= data0x(127 DOWNTO 0);
	# eg. sub_wire127    <= data1x(127 DOWNTO 0);
	# eg. sub_wire2    <= data126x(127 DOWNTO 0);
	# eg. sub_wire0    <= data127x(127 DOWNTO 0);
	# wire_list_vhdl {name_l name_r width}
	#---------------------------------------------------------------------------------
	set wire_list_vhdl [list]
	for {set i $params(size); set j 0} {$i > 1} {incr i -1; incr j} {
		lappend wire_list_vhdl sub_wire$i	data$j\x  $top_width
	}
	lappend wire_list_vhdl sub_wire0	data$j\x  $top_width
	#---------------------------------------------------------------------------------
    # add output wire connection to array2d_wire_list_vhdl for VHDL
	# eg. sub_wire1(127, 0)    <= sub_wire0(0);
	# eg. sub_wire1(127, 1)    <= sub_wire0(1);
	# eg. ...
	# eg. sub_wire1(127, 126)    <= sub_wire0(126);
	# eg. sub_wire1(127, 127)    <= sub_wire0(127);
	# eg. sub_wire1(126, 0)    <= sub_wire2(0);
	# eg. sub_wire1(126, 1)    <= sub_wire2(1);
	# eg. ...
	# eg. sub_wire1(0, 126)    <= sub_wire128(126);
	# eg. sub_wire1(0, 127)    <= sub_wire128(127);
	# array2d_wire_list_vhdl {name_l x y name_r}
	#---------------------------------------------------------------------------------
	set array2d_wire_list_vhdl [list]
	# handle name_r = sub_wire0 first
	for {set j 0} {$j < $params(width)} {incr j} {
		lappend array2d_wire_list_vhdl sub_wire1	$top_size	$j	sub_wire0
	}
	# handle others
	set intial_val [expr $top_size-1]
	for {set i $intial_val; set k 2} {$i >= 0} {incr i -1; incr k} {
		for {set j 0} {$j < $params(width)} {incr j} {
			lappend array2d_wire_list_vhdl sub_wire1	$i	$j	sub_wire$k
		}
	}
	#---------------------------------------------------------------------------------
    # add output wire connection to result_wire_list_vhdl for VHDL
	# eg. result    <= sub_wire129(1150 DOWNTO 0);
	# result_wire_list_vhdl {name_l name_r width}
	#---------------------------------------------------------------------------------
	set result_wire_list_vhdl [list]
	set index [expr $params(size)+1]
	lappend result_wire_list_vhdl result	sub_wire$index  $top_widthr

    #---------------------------------------------------------------------------------
    # get a list of all ports not added into ports_not_added_list #
	# ports_not_added_list {port connection} #
	#---------------------------------------------------------------------------------
	set ports_not_added_list    [list]
	# optional port list
    set ports_list_all  [list "aclr" "clken" "clock"]
    set ports_not_added_list_temp [list]
    foreach port $params(port_list) {
        set used_port_set($port)  1
    }
    foreach port $ports_list_all {
        if {![info exists used_port_set($port)]}    {
            lappend ports_not_added_list_temp  $port
        }
    }
    set ports_not_added_list_temp     [lsort -ascii $ports_not_added_list_temp]
    set connection ""
    foreach port $ports_not_added_list_temp {
        lappend ports_not_added_list $port $connection
    }

    #---------------------------------------------------------------------------------
    # add all params value to params_list #
	# params_list {name value} #
	#---------------------------------------------------------------------------------
    set params_list [list]
	if {$params(msw_subtract) == "Sub"} {
		# GUI_MSW_SUBTRACT=Sub
		lappend	params_list		[list "msw_subtract"		"\"YES\""]
	} else {
		# GUI_MSW_SUBTRACT=Add, this is default value
		lappend	params_list		[list "msw_subtract"		"\"NO\""]
	}
	if {$params(use_latency) == "Yes I want output latency of"} {
		# GUI_USE_LATENCY=Yes I want output latency of
		# user selected want output latency, then use the specified value from GUI_PIPELINE
		lappend	params_list		[list "pipeline"			"$params(pipeline)"]
	} else {
		# GUI_USE_LATENCY=No, this is default value
		# user selected don't want output latency, then set pipeline value as 0
		lappend	params_list		[list "pipeline"			0]
	}
	lappend	params_list			[list "representation"		"\"$params(data_rep)\""]
	# Hardcoded value
	# From QT: a "braindead" obsolete option from the lpm_mult days...
	lappend	params_list			[list "result_alignment"	"\"LSB\""]
	lappend	params_list			[list "shift"				"$params(shift)"]
	lappend	params_list			[list "size"				"$params(size)"]
	lappend	params_list			[list "width"				"$params(width)"]
	lappend	params_list			[list "widthr"				"$params(effective_widthr)"]

    #---------------------------------------------------------------------------------
    # add all terp params to array params_terp #
	#---------------------------------------------------------------------------------
    set params_terp(module_port_list)			$module_port_list
	set params_terp(tri_port_list)				$tri_port_list
    set params_terp(sub_wire_list_verilog)		$sub_wire_list_verilog
	set params_terp(wire_list_verilog)			$wire_list_verilog
	set params_terp(sub_wire1_list_verilog)		$sub_wire1_list_verilog
	set params_terp(result_wire_list_verilog)	$result_wire_list_verilog
	set params_terp(sub_wire_list_vhdl)			$sub_wire_list_vhdl
	set params_terp(wire_list_vhdl)				$wire_list_vhdl
	set params_terp(array2d_wire_list_vhdl)		$array2d_wire_list_vhdl
	set params_terp(result_wire_list_vhdl)		$result_wire_list_vhdl
    set params_terp(port_map_list)				$port_map_list
    set params_terp(ports_not_added_list)		$ports_not_added_list
    set params_terp(params_list)				$params_list
    set params_terp(ip_name)					"parallel_add"

    return [array get params_terp]
}


