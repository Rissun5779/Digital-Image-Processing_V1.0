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


proc gfm_generate {m irrpol} {

  set fieldsize [expr 2**$m]

  send_message info "Building Galois Field and inverses. Please wait..."
  
  set GF_field [GF_field_generation $irrpol $m]
  send_message info "GF_field finished"

  # the multiplicative inverse of the elements in the GF field in vector representation
  # if m=4: 1-15 maps to alpha^0-alpha^14   the 16th entry carries no meaning
  set negenum [list 1]
  for {set ind 1} {$ind<2**$m} {incr ind} {
    lappend negenum [lindex $GF_field [expr 2**$m-$ind]]
  }
  send_message info "negenum finished with length [llength $negenum]"

  # the elements in the GF field in vector representation
  # if m=4: 1-15 maps to alpha^0-alpha^14   the 16th entry carries no meaning
  set powernum [list 1]
  for {set ind 1} {$ind<2**$m-1} {incr ind} {
    lappend powernum [lindex $GF_field $ind+1]
  }
  lappend powernum 1
  send_message info "powernum finished with length [llength $powernum]"

  # the inverse of vectors in the GF field
  # if m=4: 2-16 entries map to vectors 1-15   the 1st entry carries no meaning  
  set inverses [list 1 1]
  for {set k 2} {$k<2**$m} {incr k} {
    set ind [lsearch $powernum $k]
    lappend inverses [lindex $negenum $ind]
  }
  send_message info "inverses finished with length [llength $inverses]"

  # Record the current directory before branching into the temporary file directory
  set cwd [pwd]
  # Create a null file just to get the temporary file directory path
  set temp_dir  [create_temp_file ""] 
  # Make a directory there
  file mkdir $temp_dir
  # Branching into the temporary file directory to generate the configuration file
  cd $temp_dir




  send_message info "----Writing bchp_roots.vhd"
  set file_name "$temp_dir/bchp_roots.vhd"
  lappend list_of_generated_files $file_name
  set f_handle [open $file_name w]
  set text ""

  append text "LIBRARY ieee;\nUSE ieee.std_logic_1164.all;\n\nPACKAGE bchp_roots IS\n\n"
  append text "type numarray IS ARRAY (0 TO [expr $fieldsize-1]) OF integer;\n\n"

  append text "constant negenum : numarray := ("

  set j 0
  for {set k 0} {$k<$fieldsize-1} {incr k} {
    append text "[lindex $negenum $k],"
    if {$j == 15} {
      set j 0
      append text "\n                   "
    }
    set j [expr $j+1]
  }
  append text "[lindex $negenum [expr $fieldsize-1]]);\n"



  append text "constant powernum : numarray := ("
  set j 0
  for {set k 0} {$k<$fieldsize-1} {incr k} {
    append text "[lindex $powernum $k],"
    if {$j == 15} {
      set j 0
      append text "\n                   "
    }
    set j [expr $j+1]
  }
  append text "[lindex $powernum [expr $fieldsize-1]]);\n"



  append text "constant inverses : numarray := ("
  set j 0
  for {set k 0} {$k<$fieldsize-1} {incr k} {
    append text "[lindex $inverses $k],"
    if {$j == 15} {
      set j 0
      append text "\n                   "
    }
    set j [expr $j+1]
  }
  append text "[lindex $inverses [expr $fieldsize-1]]);\n\nEND bchp_roots;\n"

  puts $f_handle $text
  close $f_handle




  send_message info "----Writing bchp_invmem.hex"
  set file_name "$temp_dir/bchp_invmem.hex"
  lappend list_of_generated_files $file_name
  set f_handle [open $file_name w]
  set text ""

  if {$m <=8 & $m > 1} {
    for {set k 0} {$k<$fieldsize} {incr k} {
      append text ":01[format %.2x [expr $k>>8]][format %.2x [expr $k&255]]00[format %.2x [expr [lindex $inverses $k]&255]]"
      set checksum [expr (256-(1+($k>>8)+($k&255)+([lindex $inverses $k]&255))&255)&255]
      append text "[format %.2x $checksum]\n"
    }
  } 

  if {$m <= 16  & $m > 8} {
    for {set k 0} {$k<$fieldsize} {incr k} {
      append text ":02[format %.2x [expr $k>>8]][format %.2x [expr $k&255]]00[format %.2x [expr [lindex $inverses $k]>>8]][format %.2x [expr [lindex $inverses $k]&255]]"
      set checksum [expr (256-(2+($k>>8)+($k&255)+([lindex $inverses $k]>>8)+([lindex $inverses $k]&255))&255)&255]
      append text "[format %.2x $checksum]\n"
    }
  } 

  if {$m<2 || $m>16} {
    send_message error "Error: m_bits outside of allowed range (2-16)"
  }

  append text ":00000001FF\n"
  
  puts $f_handle $text
  close $f_handle

  


  cd $cwd

  return $list_of_generated_files
}






proc check_speed {speed checks} {
   # need at least 20 check symbols (40 loops) to build extra pipelined tree in 8 clock processor 
   if {($speed == 8) & ($checks < 40)} {
      return 7
   } else {
      return $speed
   }
}
