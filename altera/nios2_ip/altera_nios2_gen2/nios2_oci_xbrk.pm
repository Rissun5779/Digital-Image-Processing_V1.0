#Copyright (C) 2016 Intel Corporation. All rights reserved. 
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Intel or a partner
#under Intel's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Intel.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Intel or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Intel or a
#megafunction partner, remains with Intel, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.






















use cpu_utils;
use europa_all;
use strict;






















sub make_nios2_oci_xbrk
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_xbrk",
  });
  my $marker = e_default_module_marker->new($module);

  my $xbrk_width  = $Opt->{cpu_i_address_width};
  my $max_latency = 1;


  my $is_oci_version2 = ($Opt->{oci_version} == 2) ? 1 : 0;

  my $is_fast  = ($Opt->{core_type} eq "fast") ? 1 : 0;
  my $is_small = ($Opt->{core_type} eq "small") ? 1 : 0;
  my $is_tiny  = ($Opt->{core_type} eq "tiny") ? 1 : 0;
  ($is_fast ^ $is_small ^ $is_tiny) or 
    &$error ("Unable to determine CPU Implementation ".  $Opt->{core_type});




  $module->add_contents (



    e_signal->news (




      ["xbrk_ctrl0",          8,                        0,  0],
      ["xbrk_ctrl1",          8,                        0,  0],
      ["xbrk_ctrl2",          8,                        0,  0],
      ["xbrk_ctrl3",          8,                        0,  0],
    ),

  );

  if ($is_oci_version2) {
    $module->add_contents (
    e_signal->news (
      ["xbrk_ctrl4",          8,                        0,  0],
      ["xbrk_ctrl5",          8,                        0,  0],
      ["xbrk_ctrl6",          8,                        0,  0],
      ["xbrk_ctrl7",          8,                        0,  0],
    ),

  );
  } else {
    $module->add_contents (



      e_signal->news (
        ["ir",            $IR_WIDTH,    0],
        ["jdo",           $SR_WIDTH,    0],
      ),
    );
  }











  $module->add_contents (   
    e_signal->news (    # never export these
      ["xbrk_break_hit",       1,                        0,  1],
      ["xbrk_ton_hit",         1,                        0,  1],
      ["xbrk_toff_hit",        1,                        0,  1],
      ["xbrk_tout_hit",        1,                        0,  1],
    ),
  );
  





  my $oci_num_xbrk = $Opt->{oci_num_xbrk};  # shorthand








  e_assign->add ([["cpu_i_address", $Opt->{cpu_i_address_width}, 0, 1], 
                    $is_small ? "{D_pc, 1'b0}" : "{F_pc, 2'b00}"]);

  if ($is_oci_version2) {
    if ($is_tiny) {
      e_assign->add ([["D_cpu_addr_en", 1, 0, 1], "D_valid & ~debugack"]);
      e_assign->add ([["E_cpu_addr_en", 1, 0, 1], "E_valid & ~debugack"]);
    } elsif ($is_small) {
      e_assign->add ([["D_cpu_addr_en", 1, 0, 1], "D_valid & ~debugack"]);
      e_assign->add ([["E_cpu_addr_en", 1, 0, 1], "E_en"]);
    } else {  # valid for both small and fast variants
      e_assign->add ([["D_cpu_addr_en", 1, 0, 1], "D_en & ~debugack"]);
      e_assign->add ([["E_cpu_addr_en", 1, 0, 1], "E_en & ~debugack"]);
    }  
  } else {
    if ($is_tiny) {
      e_assign->add ([["D_cpu_addr_en", 1, 0, 1], "D_valid"]);
      e_assign->add ([["E_cpu_addr_en", 1, 0, 1], "E_valid"]);
    } else {  # valid for both small and fast variants
      e_assign->add ([["D_cpu_addr_en", 1, 0, 1], "D_en"]);
      e_assign->add ([["E_cpu_addr_en", 1, 0, 1], "E_en"]);
    }
  }


  if ($oci_num_xbrk >= 1) {
    $module->add_contents (
      e_signal->news (
        ["xbrk0",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit0"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit0" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit0" => "(cpu_i_address == xbrk0[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit0" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
    	  e_register->new (
    	     { out       => ["xbrk_hit0"] ,
    	       in        => "(cpu_i_address == xbrk0[$xbrk_width-1 : 0])",
    	       enable    => "D_cpu_addr_en",
    	     },
    	  ),
    	);
    }

    $module->add_contents (
      e_assign->news (
         ["xbrk0_break_hit" => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_brk_bit])"],
         ["xbrk0_ton_hit"   => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_ton_bit])"],
         ["xbrk0_toff_hit"  => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_toff_bit])"],
         ["xbrk0_tout_hit"  => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_tout_bit])"],
         ["xbrk0_goto0_hit" => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_goto0_bit])"],
         ["xbrk0_goto1_hit" => "(xbrk_hit0 & xbrk0_armed & xbrk_ctrl0[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit0",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk0_break_hit" => "0"],
       ["xbrk0_ton_hit"   => "0"],
       ["xbrk0_toff_hit"  => "0"],
       ["xbrk0_tout_hit"  => "0"],
       ["xbrk0_goto0_hit" => "0"],
       ["xbrk0_goto1_hit" => "0"],
      ),
    );
  }
  

  if ($oci_num_xbrk >= 2) {
    $module->add_contents (
      e_signal->news (
        ["xbrk1",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit1"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit1" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit1" => "(cpu_i_address == xbrk1[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit1" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit1"] ,
      		     in        => "(cpu_i_address == xbrk1[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    $module->add_contents (
      e_assign->news (
         ["xbrk1_break_hit" => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_brk_bit])"],
         ["xbrk1_ton_hit"   => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_ton_bit])"],
         ["xbrk1_toff_hit"  => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_toff_bit])"],
         ["xbrk1_tout_hit"  => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_tout_bit])"],
         ["xbrk1_goto0_hit" => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_goto0_bit])"],
         ["xbrk1_goto1_hit" => "(xbrk_hit1 & xbrk1_armed & xbrk_ctrl1[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit1",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk1_break_hit" => "0"],
       ["xbrk1_ton_hit"   => "0"],
       ["xbrk1_toff_hit"  => "0"],
       ["xbrk1_tout_hit"  => "0"],
       ["xbrk1_goto0_hit" => "0"],
       ["xbrk1_goto1_hit" => "0"],
      ),
    );
  }


  if ($oci_num_xbrk >= 3) {
    $module->add_contents (
      e_signal->news (
        ["xbrk2",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit2"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit2" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit2" => "(cpu_i_address == xbrk2[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit2" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit2"] ,
      		     in        => "(cpu_i_address == xbrk2[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk2_break_hit" => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_brk_bit])"],
         ["xbrk2_ton_hit"   => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_ton_bit])"],
         ["xbrk2_toff_hit"  => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_toff_bit])"],
         ["xbrk2_tout_hit"  => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_tout_bit])"],
         ["xbrk2_goto0_hit" => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_goto0_bit])"],
         ["xbrk2_goto1_hit" => "(xbrk_hit2 & xbrk2_armed & xbrk_ctrl2[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit2",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk2_break_hit" => "0"],
       ["xbrk2_ton_hit"   => "0"],
       ["xbrk2_toff_hit"  => "0"],
       ["xbrk2_tout_hit"  => "0"],
       ["xbrk2_goto0_hit" => "0"],
       ["xbrk2_goto1_hit" => "0"],
      ),
    );
  }


  if ($oci_num_xbrk >= 4) {
    $module->add_contents (
      e_signal->news (
        ["xbrk3",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit3"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit3" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit3" => "(cpu_i_address == xbrk3[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit3" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit3"] ,
      		     in        => "(cpu_i_address == xbrk3[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk3_break_hit" => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_brk_bit])"],
         ["xbrk3_ton_hit"   => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_ton_bit])"],
         ["xbrk3_toff_hit"  => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_toff_bit])"],
         ["xbrk3_tout_hit"  => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_tout_bit])"],
         ["xbrk3_goto0_hit" => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_goto0_bit])"],
         ["xbrk3_goto1_hit" => "(xbrk_hit3 & xbrk3_armed & xbrk_ctrl3[$xbrk_ctrl_goto1_bit])"],
      ),
    );

    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit3",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk3_break_hit" => "0"],
       ["xbrk3_ton_hit"   => "0"],
       ["xbrk3_toff_hit"  => "0"],
       ["xbrk3_tout_hit"  => "0"],
       ["xbrk3_goto0_hit" => "0"],
       ["xbrk3_goto1_hit" => "0"],
      ),
    );
  }

  if ( $is_oci_version2 ) {

  if ($oci_num_xbrk >= 5) {
    $module->add_contents (
      e_signal->news (
        ["xbrk4",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit4"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit4" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit4" => "(cpu_i_address == xbrk4[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit4" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit4"] ,
      		     in        => "(cpu_i_address == xbrk4[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk4_break_hit" => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_brk_bit])"],
         ["xbrk4_ton_hit"   => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_ton_bit])"],
         ["xbrk4_toff_hit"  => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_toff_bit])"],
         ["xbrk4_tout_hit"  => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_tout_bit])"],
         ["xbrk4_goto0_hit" => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_goto0_bit])"],
         ["xbrk4_goto1_hit" => "(xbrk_hit4 & xbrk4_armed & xbrk_ctrl4[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit4",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk4_break_hit" => "0"],
       ["xbrk4_ton_hit"   => "0"],
       ["xbrk4_toff_hit"  => "0"],
       ["xbrk4_tout_hit"  => "0"],
       ["xbrk4_goto0_hit" => "0"],
       ["xbrk4_goto1_hit" => "0"],
      ),
    );
  }
  

  if ($oci_num_xbrk >= 6) {
    $module->add_contents (
      e_signal->news (
        ["xbrk5",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit5"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit5" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit5" => "(cpu_i_address == xbrk5[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit5" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit5"] ,
      		     in        => "(cpu_i_address == xbrk5[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
      	);
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk5_break_hit" => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_brk_bit])"],
         ["xbrk5_ton_hit"   => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_ton_bit])"],
         ["xbrk5_toff_hit"  => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_toff_bit])"],
         ["xbrk5_tout_hit"  => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_tout_bit])"],
         ["xbrk5_goto0_hit" => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_goto0_bit])"],
         ["xbrk5_goto1_hit" => "(xbrk_hit5 & xbrk5_armed & xbrk_ctrl5[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit5",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk5_break_hit" => "0"],
       ["xbrk5_ton_hit"   => "0"],
       ["xbrk5_toff_hit"  => "0"],
       ["xbrk5_tout_hit"  => "0"],
       ["xbrk5_goto0_hit" => "0"],
       ["xbrk5_goto1_hit" => "0"],
      ),
    );
  }


  if ($oci_num_xbrk >= 7) {
    $module->add_contents (
      e_signal->news (
        ["xbrk6",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit6"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit6" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit6" => "(cpu_i_address == xbrk6[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit6" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit6"] ,
      		     in        => "(cpu_i_address == xbrk6[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk6_break_hit" => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_brk_bit])"],
         ["xbrk6_ton_hit"   => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_ton_bit])"],
         ["xbrk6_toff_hit"  => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_toff_bit])"],
         ["xbrk6_tout_hit"  => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_tout_bit])"],
         ["xbrk6_goto0_hit" => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_goto0_bit])"],
         ["xbrk6_goto1_hit" => "(xbrk_hit6 & xbrk6_armed & xbrk_ctrl6[$xbrk_ctrl_goto1_bit])"],
      ),
    );
    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit6",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk6_break_hit" => "0"],
       ["xbrk6_ton_hit"   => "0"],
       ["xbrk6_toff_hit"  => "0"],
       ["xbrk6_tout_hit"  => "0"],
       ["xbrk6_goto0_hit" => "0"],
       ["xbrk6_goto1_hit" => "0"],
      ),
    );
  }


  if ($oci_num_xbrk >= 8) {
    $module->add_contents (
      e_signal->news (
    ["xbrk7",               $xbrk_width,              0,  0],
      ),
    );

    if ($is_small) {
    	$module->add_contents (
    	  e_process->new ({
    	     clock     => "clk",
    	     reset     => "reset_n",
    	     user_attributes_names => ["xbrk_hit7"],
    	     asynchronous_contents => [e_assign->news (["xbrk_hit7" => "1'b0"])],
    	     contents  => [
    	       e_if->new ({
    	         condition => "D_cpu_addr_en",
    	         then  => ["xbrk_hit7" => "(cpu_i_address == xbrk7[$xbrk_width-1 : 0])"],
    	         else => [
    	           e_if->new ({
    	             condition => "D_en",
    	             then => ["xbrk_hit7" => "0"]})],
    	       }),
    	     ],  # end contents
    	  }),
    	);
    } else {
    	$module->add_contents (
      		e_register->new (
      		   { out       => ["xbrk_hit7"] ,
      		     in        => "(cpu_i_address == xbrk7[$xbrk_width-1 : 0])",
      		     enable    => "D_cpu_addr_en",
      		   },
      		),
        );
    }
    
    $module->add_contents (
      e_assign->news (
         ["xbrk7_break_hit" => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_brk_bit])"],
         ["xbrk7_ton_hit"   => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_ton_bit])"],
         ["xbrk7_toff_hit"  => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_toff_bit])"],
         ["xbrk7_tout_hit"  => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_tout_bit])"],
         ["xbrk7_goto0_hit" => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_goto0_bit])"],
         ["xbrk7_goto1_hit" => "(xbrk_hit7 & xbrk7_armed & xbrk_ctrl7[$xbrk_ctrl_goto1_bit])"],
      ),
    );

    if ($is_oci_version2) {    
      $module->add_contents (
        e_signal->news (
          ["xbrk_hit7",           1,                        1],
        ),
      );
    }
  } else {
    $module->add_contents (
      e_assign->news (
       ["xbrk7_break_hit" => "0"],
       ["xbrk7_ton_hit"   => "0"],
       ["xbrk7_toff_hit"  => "0"],
       ["xbrk7_tout_hit"  => "0"],
       ["xbrk7_goto0_hit" => "0"],
       ["xbrk7_goto1_hit" => "0"],
      ),
    );
  }
  



  e_assign->adds (
    ["xbrk_break_hit" => 
       "(xbrk0_break_hit) | (xbrk1_break_hit) | (xbrk2_break_hit) | (xbrk3_break_hit) | (xbrk4_break_hit) | (xbrk5_break_hit) | (xbrk6_break_hit) | (xbrk7_break_hit)"], 
    ["xbrk_ton_hit"   => 
       "(xbrk0_ton_hit) | (xbrk1_ton_hit) | (xbrk2_ton_hit) | (xbrk3_ton_hit) | (xbrk4_ton_hit) | (xbrk5_ton_hit) | (xbrk6_ton_hit) | (xbrk7_ton_hit)"], 
    ["xbrk_toff_hit"  => 
       "(xbrk0_toff_hit) | (xbrk1_toff_hit) | (xbrk2_toff_hit) | (xbrk3_toff_hit) | (xbrk4_toff_hit) | (xbrk5_toff_hit) | (xbrk6_toff_hit) | (xbrk7_toff_hit)"], 
    ["xbrk_tout_hit"  => 
       "(xbrk0_tout_hit) | (xbrk1_tout_hit) | (xbrk2_tout_hit) | (xbrk3_tout_hit) | (xbrk4_tout_hit) | (xbrk5_tout_hit) | (xbrk6_tout_hit) | (xbrk7_tout_hit)"], 
    ["xbrk_goto0_hit" => 
       "(xbrk0_goto0_hit) | (xbrk1_goto0_hit) | (xbrk2_goto0_hit) | (xbrk3_goto0_hit) | (xbrk4_goto0_hit) | (xbrk5_goto0_hit) | (xbrk6_goto0_hit) | (xbrk7_goto0_hit)"], 
    ["xbrk_goto1_hit" => 
       "(xbrk0_goto1_hit) | (xbrk1_goto1_hit) | (xbrk2_goto1_hit) | (xbrk3_goto1_hit) | (xbrk4_goto1_hit) | (xbrk5_goto1_hit) | (xbrk6_goto1_hit) | (xbrk7_goto1_hit)"], 
  );
  } else {



  e_assign->adds (
    ["xbrk_break_hit" => 
       "(xbrk0_break_hit) | (xbrk1_break_hit) | (xbrk2_break_hit) | (xbrk3_break_hit)"], 
    ["xbrk_ton_hit"   => 
       "(xbrk0_ton_hit) | (xbrk1_ton_hit) | (xbrk2_ton_hit) | (xbrk3_ton_hit)"], 
    ["xbrk_toff_hit"  => 
       "(xbrk0_toff_hit) | (xbrk1_toff_hit) | (xbrk2_toff_hit) | (xbrk3_toff_hit)"], 
    ["xbrk_tout_hit"  => 
       "(xbrk0_tout_hit) | (xbrk1_tout_hit) | (xbrk2_tout_hit) | (xbrk3_tout_hit)"], 
    ["xbrk_goto0_hit" => 
       "(xbrk0_goto0_hit) | (xbrk1_goto0_hit) | (xbrk2_goto0_hit) | (xbrk3_goto0_hit)"], 
    ["xbrk_goto1_hit" => 
       "(xbrk0_goto1_hit) | (xbrk1_goto1_hit) | (xbrk2_goto1_hit) | (xbrk3_goto1_hit)"], 
  );
  }





















  


  if ($is_small) {
  	e_assign->adds (
      [["xbrk_break", 1, 1]  => "xbrk_break_hit"], 
    );
  } else {
  	e_register->adds (
  	  { out       => ["xbrk_break", 1, 1] ,
  	    in        => "xbrk_break_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	);
  }






  if ($is_small) {
  	e_assign->adds (
      [["E_xbrk_traceon", 1, 0, 1]  => "xbrk_ton_hit"],
      [["E_xbrk_traceoff", 1, 0, 1]  => "xbrk_toff_hit"],
      [["E_xbrk_trigout", 1, 0, 1]  => "xbrk_tout_hit"],
      [["E_xbrk_goto0", 1, 0, 1]  => "xbrk_goto0_hit"],
      [["E_xbrk_goto1", 1, 0, 1]  => "xbrk_goto1_hit"],
    );
  } else {
  	e_register->adds (
  	  { out       => ["E_xbrk_traceon", 1, 0, 1] ,
  	    in        => "xbrk_ton_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	  { out       => ["E_xbrk_traceoff", 1, 0, 1] ,
  	    in        => "xbrk_toff_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	  { out       => ["E_xbrk_trigout", 1, 0, 1] ,
  	    in        => "xbrk_tout_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	  { out       => ["E_xbrk_goto0", 1, 0, 1] ,
  	    in        => "xbrk_goto0_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	  { out       => ["E_xbrk_goto1", 1, 0, 1] ,
  	    in        => "xbrk_goto1_hit",
  	    enable    => "E_cpu_addr_en",
  	  },
  	);
  }





  if ($is_fast) {
    e_register->adds (
      { out       => ["M_xbrk_traceon", 1, 0, 1] ,
        in        => "E_xbrk_traceon & E_valid",
        enable    => "M_en",
      },
      { out       => ["M_xbrk_traceoff", 1, 0, 1] ,
        in        => "E_xbrk_traceoff & E_valid",
        enable    => "M_en",
      },
      { out       => ["M_xbrk_trigout", 1, 0, 1] ,
        in        => "E_xbrk_trigout & E_valid",
        enable    => "M_en",
      },
      { out       => ["M_xbrk_goto0", 1, 0, 1] ,
        in        => "E_xbrk_goto0 & E_valid",
        enable    => "M_en",
      },
      { out       => ["M_xbrk_goto1", 1, 0, 1] ,
        in        => "E_xbrk_goto1 & E_valid",
        enable    => "M_en",
      },
    );
    e_assign->adds (
      [["xbrk_traceon", 1, 0]  => "M_xbrk_traceon"], 
      [["xbrk_traceoff", 1, 0] => "M_xbrk_traceoff"], 
      [["xbrk_trigout", 1, 0]  => "M_xbrk_trigout"], 
      [["xbrk_goto0", 1, 0]    => "M_xbrk_goto0"], 
      [["xbrk_goto1", 1, 0]    => "M_xbrk_goto1"], 
    );
  } elsif ($is_small) {
    e_assign->adds (
      [["xbrk_traceon", 1, 0]  => "E_xbrk_traceon & E_valid"], 
      [["xbrk_traceoff", 1, 0] => "E_xbrk_traceoff & E_valid"], 
      [["xbrk_trigout", 1, 0]  => "E_xbrk_trigout & E_valid"], 
      [["xbrk_goto0", 1, 0]    => "E_xbrk_goto0 & E_valid"], 
      [["xbrk_goto1", 1, 0]    => "E_xbrk_goto1 & E_valid"], 
    ); 
  } else {

    e_assign->adds (
      [["xbrk_traceon", 1, 0]  => "1'b0"], 
      [["xbrk_traceoff", 1, 0] => "1'b0"], 
      [["xbrk_trigout", 1, 0]  => "1'b0"], 
      [["xbrk_goto0", 1, 0]    => "1'b0"], 
      [["xbrk_goto1", 1, 0]    => "1'b0"], 
    );
  }

  e_assign->adds (
    [["xbrk0_armed", 1, 0, 1]  =>
                     "(xbrk_ctrl0[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                      (xbrk_ctrl0[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
    ], 
    [["xbrk1_armed", 1, 0, 1]  =>
                     "(xbrk_ctrl1[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                      (xbrk_ctrl1[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
    ], 
    [["xbrk2_armed", 1, 0, 1]  =>
                     "(xbrk_ctrl2[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                      (xbrk_ctrl2[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
    ], 
    [["xbrk3_armed", 1, 0, 1]  =>
                     "(xbrk_ctrl3[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                      (xbrk_ctrl3[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
    ], 
  );

  if ( $is_oci_version2 ) {
    e_assign->adds (
      [["xbrk4_armed", 1, 0, 1]  =>
                       "(xbrk_ctrl4[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                        (xbrk_ctrl4[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
      ], 
      [["xbrk5_armed", 1, 0, 1]  =>
                       "(xbrk_ctrl5[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                        (xbrk_ctrl5[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
      ], 
      [["xbrk6_armed", 1, 0, 1]  =>
                       "(xbrk_ctrl6[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                        (xbrk_ctrl6[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
      ], 
      [["xbrk7_armed", 1, 0, 1]  =>
                       "(xbrk_ctrl7[$xbrk_ctrl_arm0_bit] & trigger_state_0) ||
                        (xbrk_ctrl7[$xbrk_ctrl_arm1_bit] & trigger_state_1)",
    ], 
    );
  }  



























  return $module;
}




1;


