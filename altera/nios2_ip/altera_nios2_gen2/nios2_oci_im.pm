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
use nios_sdp_ram;
use europa_all;
use strict;











sub make_nios2_oci_im
{
  my $Opt = shift;

  my $is_oci_version2 = ($Opt->{oci_version} == 2) ? 1 : 0;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_im",
  });

  my $ext_a_data_width    = $Opt->{oci_tm_width}; # (36)
  my $ext_a_address_width = $Opt->{oci_trace_addr_width};
  my $ext_b_data_width    = $Opt->{oci_tm_width}; # (36)
  my $ext_b_address_width = $Opt->{oci_trace_addr_width};
  my $oci_onchip_trace = $Opt->{oci_onchip_trace} ? 1 : 0;
  my $oci_offchip_trace = $Opt->{oci_offchip_trace} ? 1 : 0;



  $module->add_contents (

    e_signal->news (
      ["trc_im_addr",        $Opt->{oci_trace_addr_width},  1],
      ["trc_wrap",           1,                    1], # used in itrace, jtag
      ["xbrk_wrap_traceoff", 1,                    1], # used in itrace
    ),

    e_signal->news (
      ["tw",        $Opt->{oci_tm_width}, 0],
    ),

  );
  
  if ($oci_onchip_trace || $oci_offchip_trace) {
    $module->add_contents (

      e_signal->news (
        ["trc_enb", 1,                    1], # used in itrace
      ),
    );
  }
  if ($is_oci_version2) {
    $module->add_contents (

      e_signal->news (
        ["trace_control_reg_writedata",       13,      0],
      ),
    );
  } else {
    $module->add_contents (

      e_signal->news (
        ["tracemem_trcdata",   $Opt->{oci_tm_width}, 1],
        ["tracemem_tw",        1,                    1],
        ["tracemem_on",        1,                    1],
      ),

      e_signal->news (
        ["jdo",       $TRACEMEM_WIDTH,      0],
      ),
    );
  }





  $module->add_contents (

    e_signal->news (
      ["trc_im_data",    $Opt->{oci_tm_width},          0, 1],
      ["trc_on_chip",    1,                             0, 1], # local signal
    ),
    e_assign->new (["trc_im_data", "tw"]),
  );






  my $process_hash;
  if ($Opt->{oci_onchip_trace}) {
  $process_hash = {
    clock     => "clk",
    reset     => "jrst_n",
    asynchronous_contents => [
      e_assign->news (
        ["trc_im_addr" => "0"],
        ["trc_wrap" => "0"],
      ),
    ],
    contents => [
      e_if->new ({
          condition => $is_oci_version2 ?
                      "trace_control_reg_write && 
                      (trace_control_reg_writedata[$TRACE_CONTROL_TAAR_POS] | trace_control_reg_writedata[$TRACE_CONTROL_TWR_POS])" :
                      "take_action_tracectrl && 
                      (jdo[$TRACECTRL_TAAR_POS] | jdo[$TRACECTRL_TWR_POS])", 
          then => [
            e_if->new ({
              condition => $is_oci_version2 ? "trace_control_reg_writedata[$TRACE_CONTROL_TAAR_POS]" : "jdo[$TRACECTRL_TAAR_POS]",
              then => [ ["trc_im_addr" => "0"] ],
            }),
            e_if->new ({
              condition => $is_oci_version2 ? "trace_control_reg_writedata[$TRACE_CONTROL_TWR_POS]" : "jdo[$TRACECTRL_TWR_POS]",
              then => [ ["trc_wrap" => "0"] ],
            }),
          ],
          elsif  => {
            condition => 
              "(trc_enb & trc_on_chip & tw_valid)",     # recording
            then  => [
              ["trc_im_addr" => "trc_im_addr+1"],
              e_if->new ({
                condition => "&trc_im_addr",
                then => [ 
                  e_assign->news (
                    ["trc_wrap" => "1"], 
                  ),
                ],
              }),
            ],
          } # end elsif
      }),
    ],
  };
  } else {
  $process_hash = {
    clock     => "clk",
    reset     => "jrst_n",
    asynchronous_contents => [
      e_assign->news (
        ["trc_im_addr" => "0"],
        ["trc_wrap" => "0"],
      ),
    ],
    contents => [
      e_assign->news (
        ["trc_im_addr" => "0"],
        ["trc_wrap" => "0"],
      ),
    ],
  };
  }

  my $register_hash;
  if (!$is_oci_version2) {
    $register_hash = {
      out => ["trc_jtag_addr",  $TRACEMEM_A_TRCADDR_MSB_POS -
                                $TRACEMEM_A_TRCADDR_LSB_POS + 1, 
                                0, 1],
      in  => "take_action_tracemem_a ? 
            jdo[$TRACEMEM_A_TRCADDR_MSB_POS : $TRACEMEM_A_TRCADDR_LSB_POS] : 
            trc_jtag_addr + 1",
      enable  => "take_action_tracemem_a ||
                  take_no_action_tracemem_a || 
                  take_action_tracemem_b", # anytime TRACEMEM is accessed.
    };

  }

  if (!(manditory_bool($Opt, "asic_enabled") && manditory_bool($Opt, "asic_third_party_synthesis"))) {
    $process_hash->{user_attributes_names} = ["trc_im_addr","trc_wrap"];
    if ($is_oci_version2) {
    	$process_hash->{user_attributes} = [
    	  {
    	    attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
    	    attribute_operator => '=',
    	    attribute_values => [qw(R101)],
    	  },
    	];
    } else {
    	$process_hash->{user_attributes} = [
    	  {
    	    attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
    	    attribute_operator => '=',
    	    attribute_values => [qw(D101 D103 R101)],
    	  },
    	];	
    }
    if (!$is_oci_version2) {
      $register_hash->{user_attributes} = [
        {
          attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
          attribute_operator => '=',
          attribute_values => [qw(D101)],
        },
      ];
    }
  }
  
  if ($oci_onchip_trace || $oci_offchip_trace) {
    if (!$is_oci_version2) {
        $module->add_contents (
        e_register->new($register_hash),
        
        e_assign->news ( 
          ["tracemem_tw" => "trc_wrap"],
          ["tracemem_on" => "trc_enb"],
        ),
      );  
    }
  }

  $module->add_contents (
    e_process->new($process_hash),
    e_signal->news (
      ["tw_valid",     1,    0,    1],
    ),
    e_assign->news ( 
      ["trc_on_chip" => "~trc_ctrl[$TRC_OFC_BIT]"],
      ["tw_valid" => 
        "|trc_im_data[" . $Opt->{oci_tm_width} . "-1 : " . 
        $Opt->{oci_tm_width} .  "-4]"],
      ["xbrk_wrap_traceoff" => "trc_ctrl[$TRC_FULL_BIT] & trc_wrap"],
    ),
  );
  
  if ($oci_onchip_trace || $oci_offchip_trace) {
    $module->add_contents (
      e_assign->news ( 
        ["trc_enb" => "trc_ctrl[$TRC_ENB_BIT]"],
      ),
    );    
  }



    if (!$is_oci_version2) {
        if (manditory_bool($Opt, "oci_onchip_trace")) {
          $module->add_contents (        
            e_assign->news ( 
              ["tracemem_trcdata" => "trc_jtag_data"],
            ),
          );
        } else {
          $module->add_contents (    
            e_assign->news ( 
              ["tracemem_trcdata" => "0"],
            ),
          );
        }
    }


  if (manditory_bool($Opt, "oci_onchip_trace")) {
    if (manditory_bool($Opt, "export_large_RAMs")) {
      $module->add_contents(
        e_comment->new ({
          comment => 
             ("Export trace RAM ports to top level\n" .
              "because the RAM is instantiated external to CPU.\n"),
        }),
    

        e_signal->new({name => "trc_jtag_data", width => $Opt->{oci_tm_width}}),
    
        e_assign->news (

          [["cpu_lpm_trace_ram_sdp_wraddress", $ext_a_address_width] => 
            "trc_im_addr"],
          [["cpu_lpm_trace_ram_sdp_rdaddress", $ext_b_address_width] => 
            $is_oci_version2 ? "tracemem_address[$ext_b_address_width-1: 0]" : "trc_jtag_addr[$ext_b_address_width-1: 0]"],
          [["cpu_lpm_trace_ram_sdp_write_data", $ext_a_data_width] => 
            "trc_im_data"],
          ["cpu_lpm_trace_ram_sdp_write_enable" => "tw_valid & trc_enb"],
    
        ),      
      );
      

        if ($is_oci_version2) {
          $module->add_contents(
            e_signal->new({name => "tracemem_data", width => $Opt->{oci_tm_width}}),
            e_assign->news (
              ["tracemem_data" => 
                ["cpu_lpm_trace_ram_sdp_read_data", $ext_b_data_width]],
            ),
          );
        } else {
          $module->add_contents(
            e_assign->news (
              ["trc_jtag_data" => 
                ["cpu_lpm_trace_ram_sdp_read_data", $ext_b_data_width]],
            ),
          );
        }
    } else {
      $module->add_contents(
        nios_sdp_ram->new ({
          name => $Opt->{name} . "_traceram_lpm_dram_sdp_component",
          Opt                   => $Opt,
          data_width            => $Opt->{oci_tm_width}, # (36)
          address_width         => $Opt->{oci_trace_addr_width},
          read_during_write_mode_mixed_ports => qq("OLD_DATA"),

          port_map => {

            clock      => "clk",
            wren       => "tw_valid & trc_enb",
            wraddress  => "trc_im_addr",
            data       => "trc_im_data",
      

            rdaddress => $is_oci_version2 ? "tracemem_address" : "trc_jtag_addr",
            q         => $is_oci_version2 ? "tracemem_data"    : "trc_jtag_data",
          },
        }),
      );
    }
  }

  return $module;
}


1;

