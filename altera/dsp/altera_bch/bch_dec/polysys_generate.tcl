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


proc polysys_generate {code_clocks polys_per_pe pes full_pes last_polys round_clocks t optimize} {
   # Record the current directory before branching into the temporary file directory
   set cwd [pwd]
   # Create a null file just to get the temporary file directory path
   set temp_dir  [create_temp_file ""] 
   # Make a directory there
   file mkdir $temp_dir
   # Branching into the temporary file directory to generate the configuration file
   cd $temp_dir


   send_message info "----Writing bchp_mb_system.vhd"
   set file_name "$temp_dir/bchp_mb_system.vhd"
   lappend list_of_generated_files $file_name
   set f_handle [open $file_name w]
   set text ""

   append text "LIBRARY ieee;\nUSE ieee.std_logic_1164.all;\nUSE ieee.std_logic_unsigned.all;\nUSE ieee.std_logic_arith.all;\n\n"
   append text "USE work.bchp_parameters.all;\nUSE work.bchp_package.all;\nUSE work.bchp_roots.all;\n\n"
   append text "ENTITY bchp_mb_system IS\nPORT (\n      sysclk, reset, enable : IN STD_LOGIC;\n      start : IN STD_LOGIC;\n      syndromes : IN syndromevector;\n\n"
   append text "      bd : OUT errorvector;\n      errors : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);\n      done : OUT STD_LOGIC\n);\nEND bchp_mb_system;\n\n"
   append text "ARCHITECTURE rtl OF bchp_mb_system IS\n\n"
   
   append text "  signal zerosyndromes : syndromevector;\n  signal zerobds, zerobdsprev : errorvector;\n\n"
   append text "  signal zeroll : STD_LOGIC_VECTOR (8 DOWNTO 1);\n  signal zerodelta : STD_LOGIC_VECTOR (m_bits DOWNTO 1);\n\n"

   for {set k 1} {$k <= $pes} {incr k} {
     append text "  signal syndromes_$k : syndromevector;\n  signal bds_$k, bdsprev_$k : errorvector;\n"
     append text "  signal delta_$k : STD_LOGIC_VECTOR (m_bits DOWNTO 1);\n  signal ll_$k : STD_LOGIC_VECTOR (8 DOWNTO 1);\n"
     append text "  signal onebit_$k : STD_LOGIC;\n  signal done_$k : STD_LOGIC;\n\n"
   }

   append text "  signal bdff : errorvector;\n  signal llff : STD_LOGIC_VECTOR (8 DOWNTO 1);\n  signal doneff : STD_LOGIC;\n\nBEGIN\n\n"
   

   append text "  zerosyndromes(1)(m_bits DOWNTO 1) <= syndromes(check_symbols-1)(m_bits DOWNTO 1);\n"
   append text "  zerosyndromes(2)(m_bits DOWNTO 1) <= syndromes(check_symbols)(m_bits DOWNTO 1);\n"
   append text "  gen_zerosyn: FOR k IN 1 TO check_symbols-2 GENERATE\n    zerosyndromes(k+2)(m_bits DOWNTO 1) <= syndromes(k)(m_bits DOWNTO 1);\n  END GENERATE;\n"

   append text "  gen_zerobds: FOR k IN 1 TO t_symbols GENERATE\n    zerobds(k)(m_bits DOWNTO 1) <= conv_std_logic_vector (0,m_bits);\n  END GENERATE;\n"
   append text "  zerobdsprev(1)(m_bits DOWNTO 1) <= conv_std_logic_vector (1,m_bits);\n"
   append text "  gen_zerobdprevs: FOR k IN 2 TO t_symbols GENERATE\n    zerobdsprev(k)(m_bits DOWNTO 1) <= conv_std_logic_vector (0,m_bits);\n  END GENERATE;\n"
   append text "  zeroll <= conv_std_logic_vector (0,8);\n"
   append text "  zerodelta <= conv_std_logic_vector (0,m_bits);\n\n"

   set speed [check_speed $round_clocks [expr $polys_per_pe-1]]
   set delay [expr $speed*$polys_per_pe]


   append text "  comp_01: bchp_mb_pex \n  GENERIC MAP (speed=>$speed,startloop=>0,endloop=>[expr 2*($polys_per_pe-1)])\n"
   append text "  PORT MAP (sysclk=>sysclk,reset=>reset,enable=>enable,start=>start,syndromesin=>zerosyndromes,\n"
   append text "            bdsin=>zerobds,bdsprevin=>zerobdsprev,llnumberin=>zeroll,deltain=>zerodelta,\n\n"
   append text "            syndromesout=>syndromes_1,bdsout=>bds_1,bdsprevout=>bdsprev_1,llnumberout=>ll_1,deltaout=>delta_1,\n"
   append text "            nextstage=>done_1);\n\n"

   if {$pes>2} {
     for {set k 1} {$k < $pes-1} {incr k} {
        set speed [check_speed $round_clocks [expr ($k+1)*$polys_per_pe-1]]
	set delay [expr $delay + $speed*$polys_per_pe]
        
        if {$k<9} {
           append text "  comp_0[expr $k + 1]: bchp_mb_pex \n  GENERIC MAP (speed=>$speed,startloop=>[expr 2*($k*$polys_per_pe)],endloop=>[expr 2*(($k+1)*$polys_per_pe-1)])\n"
        } else {
           append text "  comp_[expr $k + 1]: bchp_mb_pex \n  GENERIC MAP (speed=>$speed,startloop=>[expr 2*($k*$polys_per_pe)],endloop=>[expr 2*(($k+1)*$polys_per_pe-1)])\n"
        }

        append text "  PORT MAP (sysclk=>sysclk,reset=>reset,enable=>enable,start=>done_$k,syndromesin=>syndromes_$k,\n"
        append text "            bdsin=>bds_$k,bdsprevin=>bdsprev_$k,llnumberin=>ll_$k,deltain=>delta_$k,\n\n"
        append text "            syndromesout=>syndromes_[expr $k+1],bdsout=>bds_[expr $k+1],bdsprevout=>bdsprev_[expr $k+1],llnumberout=>ll_[expr $k+1],deltaout=>delta_[expr $k+1],\n"
        append text "            nextstage=>done_[expr $k+1]);\n\n"
     }
   }

   if {$pes>1} {
     set speed [check_speed $round_clocks [expr 2*$t-1]]
     set delay [expr $delay + $speed*$last_polys]

     if {$pes<10} {
        append text "  comp_0$pes: bchp_mb_pex \n  GENERIC MAP (speed=>$speed,startloop=>[expr 2*(($pes-1)*$polys_per_pe)],endloop=>[expr 2*(($pes-1)*$polys_per_pe+$last_polys-1)])\n"
     } else {
        append text "  comp_$pes: bchp_mb_pex \n  GENERIC MAP (speed=>$speed,startloop=>[expr 2*(($pes-1)*$polys_per_pe)],endloop=>[expr 2*(($pes-1)*$polys_per_pe+$last_polys-1)])\n"
     }

     append text "  PORT MAP (sysclk=>sysclk,reset=>reset,enable=>enable,start=>done_[expr $pes-1],syndromesin=>syndromes_[expr $pes-1],\n"
     append text "            bdsin=>bds_[expr $pes-1],bdsprevin=>bdsprev_[expr $pes-1],llnumberin=>ll_[expr $pes-1],deltain=>delta_[expr $pes-1],\n\n"
     append text "            syndromesout=>open,bdsout=>bds_$pes,bdsprevout=>open,llnumberout=>ll_$pes,deltaout=>open,\n"
     append text "            nextstage=>done_$pes);\n\n"
   }
 
  set delay [expr $delay + 1]

  append text "  prc_hold: PROCESS (sysclk)\n  BEGIN\n"
  append text "    IF (rising_edge(sysclk)) THEN\n"
  append text "      IF (reset = '1') THEN\n"
  append text "      FOR k IN 1 TO t_symbols LOOP\n"
  append text "        bdff(k)(m_bits DOWNTO 1) <= conv_std_logic_vector (0,m_bits);\n"
  append text "      END LOOP;\n      llff <= conv_std_logic_vector (0,8);\n"
  append text "      doneff <= '0';\n"
  append text "      ELSIF (enable = '1') THEN\n        IF (done_$pes = '1') THEN\n"
  append text "          FOR k IN 1 TO t_symbols LOOP\n            bdff(k)(m_bits DOWNTO 1) <= bds_[expr $pes](k)(m_bits DOWNTO 1);\n          END LOOP;\n"
  append text "          llff <= ll_$pes;\n        END IF;\n        doneff <= done_$pes;\n      END IF;\n    END IF;\n  END PROCESS;\n\n"
  append text "  bd <= bdff;\n  errors <= llff;\n  done <= doneff;\n\nEND rtl;\n\n"

  puts $f_handle $text
  close $f_handle




  send_message info "----Writing bchp_auto_package.vhd"
  set file_name "$temp_dir/bchp_auto_package.vhd"
  lappend list_of_generated_files $file_name
  set f_handle [open $file_name w]
  set text ""
  
  append text "LIBRARY ieee;\nUSE ieee.std_logic_1164.all;\n\nPACKAGE bchp_auto_package IS\n\n"
  append text "  constant poly_cores : positive := $pes;\n  constant poly_delay : positive := $delay;\n  constant poly_optimize : integer := $optimize;\n\n"
  append text "END bchp_auto_package;\n\n"

  puts $f_handle $text
  close $f_handle



  cd $cwd



  return $list_of_generated_files
}
