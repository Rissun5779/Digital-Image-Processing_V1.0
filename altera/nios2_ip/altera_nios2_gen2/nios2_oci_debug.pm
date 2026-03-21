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
use nios_common;
use europa_all;
use strict;

sub make_nios2_oci_debug
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_debug",
  });

  my $is_oci_version2 = ($Opt->{oci_version} == 2) ? 1 : 0;



  my $oci_reset_sync_depth = 2; 



  $module->add_contents (

    e_signal->news (
      ["resetrequest",          1,    1],   # export past top level?
      ["debugack",         1,    1],
    ),

    e_signal->news (
      ["reset",                 1,    0],
    ),

    
  );

  if ($is_oci_version2) {
    $module->add_contents (

      e_signal->news (
        ["host_break",            1,    1],
        ["host_reset",            1,    1],
        ["host_sticky_reset",     1,    1],
        ["host_break_on_reset",   1,    1],
        ["host_idisable",          1,    1],
        ["host_single_step_mode", 1,    1],
        ["host_wait",             1,    1],
        ["host_present",          1,    1],
        ["host_debug_mode_exc",   1,    1],
        ["debug_go",   1,    0],
      ),     
    );
  } else {
    $module->add_contents (

      e_signal->news (
        ["resetlatch",            1,    1],
        ["monitor_error",         1,    1],
        ["monitor_ready",         1,    1],
        ["monitor_go",            1,    1],
        ["ir",            $IR_WIDTH,    0],
        ["jdo",           $SR_WIDTH,    0],
      ),     
    );
  }

  if ($advanced_exc||$is_oci_version2) {
    $module->add_contents (
      e_signal->news (
        ["E_oci_sync_hbreak_req",        1,    1],
        ["oci_async_hbreak_req",        1,    1],
      ),
    ),
  } else {
    $module->add_contents (
      e_signal->news (
        ["oci_hbreak_req",        1,    1],
      ),
    ),
  }






  my @reset_irq_dbg_mode_async = (
    ["resetrequest" => "1'b0"],
  );

  if ($is_oci_version2) {
    push(@reset_irq_dbg_mode_async,
      ["host_break_on_reset"  => "1'b0"],
      ["host_sticky_reset" => "1'b0"],
      ["host_present" => "1'b0"],
      ["host_break"   => "1'b0"],
      ["host_single_step_mode"   => "1'b0"],
      ["host_idisable"   => "1'b0"],
      ["host_trigger_break_on_reset" => "1'b0"],
    );

  } else {
    push(@reset_irq_dbg_mode_async,
        ["break_on_reset"  => "1'b0"],
        ["jtag_break"   => "1'b0"],
    );

    if (manditory_bool($Opt, "asic_enabled")) {


      push(@reset_irq_dbg_mode_async,
        ["resetlatch"   => "1'b0"],
      );
    }
  }















  my @user_attributes_D101;
  my @user_attributes_D101_R101;
  
  if (!(manditory_bool($Opt, "asic_enabled") && manditory_bool($Opt, "asic_third_party_synthesis"))) {
  	  if ($is_oci_version2) {
      	push(@user_attributes_D101_R101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(R101)],
      	     },
      	   ],
      	 );
      } else {
      	push(@user_attributes_D101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(D101)],
      	     },
      	   ],
      	 );
      	push(@user_attributes_D101_R101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(D101 R101)],
      	     },
      	   ],
      	 );
      }
  }

    if ($is_oci_version2) {
        $module->add_contents (         
          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => [
              "host_trigger_break_on_reset","host_break_on_reset","resetrequest","host_break","host_idisable","host_single_step_mode","host_sticky_reset","host_present"
            ],
            @user_attributes_D101_R101,
            asynchronous_contents => [
              e_assign->news ( @reset_irq_dbg_mode_async ),
            ],
            contents  => [
              e_if->new ({ condition => "host_control_register_write", then => [ 
                  e_assign->news (
        



                      ["host_break" => "host_control_writedata[0]"],
        














                      ["resetrequest" => "host_control_writedata[1]"],
                      


                      ["host_sticky_reset" => "host_control_writedata[8] ? host_sticky_reset : 0"],
        







                      ["host_break_on_reset" => "host_control_writedata[2]"],
                      

                      ["host_trigger_break_on_reset" => "0"],
                      

                      ["host_single_step_mode" => "host_control_writedata[4]"],
                      

                      ["host_idisable" => "host_control_writedata[5]"],
                      

                      ["host_present" => "host_control_writedata[9]"],
                  ),
              ], else => [ e_if->new ({ condition => "host_control_register_set", then => [ 

                  ["host_break" => "host_break | host_control_writedata[0]"],

                  ["resetrequest" => "resetrequest | host_control_writedata[1]"],
                  ["host_break_on_reset" => "host_break_on_reset | host_control_writedata[2]"],
                  ["host_trigger_break_on_reset" => "0"],
                  ["host_single_step_mode" => "host_single_step_mode | host_control_writedata[4]"],
                  ["host_idisable" => "host_idisable | host_control_writedata[5]"],
                  ["host_present" => "host_present | host_control_writedata[9]"],
              ], else => [ e_if->new ({ condition => "host_control_register_clear", then => [ 

                  ["host_break" => "host_break & ~host_control_writedata[0]"],
                  ["resetrequest" => "resetrequest & ~host_control_writedata[1]"],
                  ["host_break_on_reset" => "host_break_on_reset & ~host_control_writedata[2]"],
                  ["host_trigger_break_on_reset" => "0"],
                  ["host_single_step_mode" => "host_single_step_mode & ~host_control_writedata[4]"],
                  ["host_idisable" => "host_idisable & ~host_control_writedata[5]"],
                  ["host_sticky_reset" => "host_sticky_reset & ~host_control_writedata[8]"],
                  ["host_present" => "host_present & ~host_control_writedata[9]"],
              ], else => [ e_if->new ({ condition => "reset", then => [ 



                  ["host_trigger_break_on_reset" => "host_break_on_reset"],
                       




                  ["host_sticky_reset" => "1"],
              ], else => [ e_if->new ({ condition => "debugreq & ~debugack & host_break_on_reset", then => [ 














                  e_assign->new (["host_break" => "1'b1"]),
              ],
              }),   # end of if
              ],    # end of else
              }),   # end of if
              ],  # end of else
              }), # end of if
              ],  # end of else
              }), # end of if
              ],  # end of else
              }), # end of if
            ], # end of contents
          }), # end of process
        
          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_reset"],
            @user_attributes_D101,
            asynchronous_contents => [
              e_assign->news (
                ["host_reset"   => "1'b0"],
              ),
            ],
        
            contents  => [

              e_if->new ({ condition => "reset", then => [ 
                  e_assign->news (
                      ["host_reset" => "1'b1"],
                  ),
              ], else => [ 
                  e_assign->news (
                      ["host_reset" => "1'b0"],
                  ),
              ], # end else
              }),        
            ], # end of contents
          }), # end of process

          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_wait"],
            @user_attributes_D101,
            asynchronous_contents => [
              e_assign->news (
                ["host_wait"   => "1'b0"],
              ),
            ],
        
            contents  => [


              e_if->new ({ condition => "host_control_register_set && host_control_writedata[3]", then => [ 
                  e_assign->news (
                      ["host_wait" => "1'b1"],
                  ),
              ], elsif => { condition => "debug_go", then => [
                  ["host_wait" => "1'b0"],
              ],
              },
              }),        
            ], # end of contents
          }), # end of process
          
          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_debug_mode_exc"],
            @user_attributes_D101,
            asynchronous_contents => [
              e_assign->news (
                ["host_debug_mode_exc"   => "1'b0"],
              ),
            ],
        
            contents  => [


              e_if->new ({ condition => "A_exc_active_no_break & ~hbreak_enabled", then => [ 
                  e_assign->news (
                      ["host_debug_mode_exc" => "1'b1"],
                  ),
              ], elsif => { condition => "host_control_register_clear", then => [
                  ["host_debug_mode_exc" => "host_debug_mode_exc & ~host_control_writedata[6]"],
              ],
              },
              }),        
            ], # end of contents
          }), # end of process   
          

          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_trigger_break_on_reset_reg"],
            @user_attributes_D101,
            asynchronous_contents => [
              e_assign->news (
                ["host_trigger_break_on_reset_reg"   => "1'b0"],
              ),
            ],
        
            contents  => [
              e_if->new ({ condition => "reset", then => [ 
                  e_assign->news (
                      ["host_trigger_break_on_reset_reg" => "1'b0"],
                  ),
              ], else => [ 
                  e_assign->news (
                      ["host_trigger_break_on_reset_reg" => "host_trigger_break_on_reset"],
                  ),
              ], # end else
              }),        
            ], # end of contents
          }), # end of process
          
          e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_trigger_break_on_reset_reg_d1"],
            @user_attributes_D101,
            asynchronous_contents => [
              e_assign->news (
                ["host_trigger_break_on_reset_reg_d1"   => "1'b0"],
              ),
            ],
        
            contents  => [
              e_if->new ({ condition => "reset", then => [ 
                  e_assign->news (
                      ["host_trigger_break_on_reset_reg_d1" => "1'b0"],
                  ),
              ], else => [ 
                  e_assign->news (
                      ["host_trigger_break_on_reset_reg_d1" => "host_trigger_break_on_reset_reg"],
                  ),
              ], # end else
              }),        
            ], # end of contents
          }), # end of process
          e_assign->news (
           	  ["host_trigger_break_on_reset_inst_valid" => "host_trigger_break_on_reset_reg & ~host_trigger_break_on_reset_reg_d1"],
          ),
        );  # end of add_contents
    } else {
      $module->add_contents (   













          e_std_synchronizer->new({
            data_in  => "reset",
            data_out => "reset_sync",
            clock    => "clk",
            reset    => "~jrst_n",
            depth => $oci_reset_sync_depth,
          }),
    
        e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => [
            "break_on_reset","resetlatch","resetrequest","jtag_break"
          ],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->news ( @reset_irq_dbg_mode_async ),
          ],
          contents  => [
            e_if->new ({ condition => "take_action_ocimem_a", then => [ 
                e_assign->news (














                    ["resetrequest" => "jdo[$OCIMEM_A_RSTR_POS]"],
    



                    ["jtag_break" => 
                      "jdo[$OCIMEM_A_DRS_POS]     ? 1 
                        : jdo[$OCIMEM_A_DRC_POS]  ? 0 
                        : jtag_break"],
    







                    ["break_on_reset" => 
                      "jdo[$OCIMEM_A_BRSTS_POS]     ? 1
                        : jdo[$OCIMEM_A_BRSTC_POS]  ? 0
                        :  break_on_reset"],
    

                    ["resetlatch" => "jdo[$OCIMEM_A_RSTC_POS] ? 0 : resetlatch"],
                ),
            ], else => [ e_if->new ({ condition => "reset_sync", then => [ 




                ["jtag_break" => "break_on_reset"],
                     




                ["resetlatch" => "1"],
            ], else => [ e_if->new ({ condition => "debugreq & ~debugack & break_on_reset", then => [ 














                e_assign->new (["jtag_break" => "1'b1"]),
            ],
            }),   # end of if
            ],    # end of else
            }),   # end of if
            ],  # end of else
            }), # end of if
          ], # end of contents
        }), # end of process
    

        e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["monitor_ready","monitor_error","monitor_go"],
          @user_attributes_D101,
          asynchronous_contents => [
            e_assign->news (
              ["monitor_ready"  => "1'b0"],
              ["monitor_error" => "1'b0"],
              ["monitor_go"   => "1'b0"],
            ),
          ],
    
          contents  => [
            e_if->new ({ condition => "take_action_ocimem_a && jdo[$OCIMEM_A_MRC_POS]", then => [ 
                e_assign->news (
                    ["monitor_ready" => "1'b0"],
                ),
            ], elsif => { condition => "take_action_ocireg && ocireg_mrs", then => [
                ["monitor_ready" => "1'b1"],
            ],
            },
            }),
    
            e_if->new ({ condition => "take_action_ocimem_a && jdo[$OCIMEM_A_MRC_POS]", then => [ 
                e_assign->news (
                    ["monitor_error" => "1'b0"],
                ),
            ], elsif => { condition => "take_action_ocireg && ocireg_ers", then => [
                ["monitor_error" => "1'b1"],
            ],
            },
            }),
    
            e_if->new ({ condition => "take_action_ocimem_a && jdo[$OCIMEM_A_GOS_POS]", then => [ 
                e_assign->news (
                    ["monitor_go" => "1'b1"],
                ),
            ], elsif => { condition => "st_ready_test_idle", then => [
                ["monitor_go" => "1'b0"],
            ],
            },
            }),
    
          ], # end of contents
        }), # end of process
      );  # end of add_contents
    }




  
  if ($is_oci_version2) {
      
    if (manditory_bool($Opt, "asic_enabled")) {
        $module->add_contents (
        e_assign->news (
        ["oci_async_hbreak_req" => "oci_async_hbreak_req_unfiltered"],
        ["E_oci_sync_hbreak_req" => "E_oci_sync_hbreak_req_unfiltered"],
        ),
      ),
    } else {
      $module->add_contents (
        e_assign->news (
        ["oci_async_hbreak_req_unfiltered_is_x" => "^(oci_async_hbreak_req_unfiltered) === 1'bx"],
        ["E_oci_sync_hbreak_req_unfiltered_is_x" => "^(E_oci_sync_hbreak_req_unfiltered) === 1'bx"],
        ["oci_async_hbreak_req" => "(oci_async_hbreak_req_unfiltered_is_x) ? 1'b0 : oci_async_hbreak_req_unfiltered"],
        ["E_oci_sync_hbreak_req" => "(E_oci_sync_hbreak_req_unfiltered_is_x) ? 1'b0 : E_oci_sync_hbreak_req_unfiltered"],
        ),
      ),
    }

    $module->add_contents (
      e_assign->news (
        ["oci_async_hbreak_req_unfiltered" => "host_break | dbrk_break | debugreq | host_trigger_break_on_reset"],
        ["E_oci_sync_hbreak_req_unfiltered" => "xbrk_break"],

        ["debugack"       => "~hbreak_enabled"],
        
        ["oci_single_step_mode"  => "host_single_step_mode"],
        ["oci_idisable"          => "host_idisable"],
        ["oci_present"           => "host_present"],
        ["oci_wait"              => "host_wait"],
        ["oci_debug_mode_exc"    => "host_debug_mode_exc"],
        

        ["fetch_inst_cancel"    => "(oci_async_hbreak_req|E_oci_sync_hbreak_req) & ~host_single_step_mode | debugack"],
      ),
    ),
  } else {
    if ($advanced_exc) {
      $module->add_contents (
        e_assign->news (
          ["oci_async_hbreak_req" => "jtag_break | dbrk_break | debugreq"],
          ["E_oci_sync_hbreak_req" => "xbrk_break"],
          ["debugack"       => "~hbreak_enabled"],
        ),
      )
    } else {
      $module->add_contents (
        e_assign->news (
          ["oci_hbreak_req" => "jtag_break | dbrk_break | xbrk_break | debugreq"],
          ["debugack"       => "~hbreak_enabled"],
        ),
      ),
    };
  }
  return $module;
}

1;


