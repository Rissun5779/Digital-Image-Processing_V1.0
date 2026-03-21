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


proc parameter_generate {n_bits k_bits m t irrpol data_width} {


   # Record the current directory before branching into the temporary file directory
   set cwd [pwd]
   # Create a null file just to get the temporary file directory path
   set temp_dir  [create_temp_file ""] 
   # Make a directory there
   file mkdir $temp_dir
   # Branching into the temporary file directory to generate the configuration file
   cd $temp_dir


   send_message info "----Writing bchp_parameters.vhd"
   set file_name "$temp_dir/bchp_parameters.vhd"
   lappend list_of_generated_files $file_name
   set f_handle [open $file_name w]
   set text ""


   append text "LIBRARY ieee;\n"
   append text "USE ieee.std_logic_1164.all;\n\n"

   append text "PACKAGE bchp_parameters IS\n\n"

   append text "  constant n_symbols : positive := $n_bits;\n"
   append text "  constant k_symbols : positive := $k_bits;\n"
   append text "  constant t_symbols : positive := $t;\n"
   append text "  constant m_bits : positive := $m;\n"
   append text "  constant polynomial : positive := $irrpol;\n"
   append text "  constant parallel_bits : positive := $data_width;\n\n"

   append text "  constant power_save : integer := 1; -- 0 search always on, 1 search selective\n\n"
    
   append text "END bchp_parameters;\n"


   puts $f_handle $text
   close $f_handle



   cd $cwd



   return $list_of_generated_files

}
