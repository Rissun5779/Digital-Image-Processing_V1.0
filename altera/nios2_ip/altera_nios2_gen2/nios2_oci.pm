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






















package nios2_oci;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &make_nios2_oci
);

use cpu_utils;
use nios_avalon_masters;
use nios2_insts;
use nios2_common;
use nios2_oci_cfg;
use nios2_oci_debug_host_slave_control;
use nios2_oci_jtag_wrapper;
use nios2_oci_jtag_avalon_debug_wrapper;
use nios2_oci_debug;
use nios2_oci_ocimem;
use nios2_oci_avalon_reg;
use nios2_oci_sdc;
use nios2_oci_break;
use nios2_oci_xbrk;
use nios2_oci_dbrk;
use nios2_oci_itrace;
use nios2_oci_dtrace;
use nios2_oci_fifo;
use nios2_oci_pib;
use nios2_oci_im;
use nios2_oci_performance_monitors;
use europa_utils;   # for validate_parameter
use europa_all;
use strict;





sub 
make_nios2_oci
{
  my ($Opt, $top_module) = @_;

  my $make_submodule = 1;
  my $module = e_module->new({name => $Opt->{name}."_nios2_oci"}) ;
  my $marker = e_default_module_marker->new($module);
  my $sub_export = $make_submodule && $force_export;
  my $is_oci_version2 = ($Opt->{oci_version} == 2) ? 1 : 0;

  &validate_nios2_oci_parameters ($Opt);
 
  my @submodules = (
    &make_nios2_oci_debug ($Opt),
    &make_nios2_oci_break ($Opt),
    &make_nios2_oci_xbrk ($Opt),
    &make_nios2_oci_dbrk ($Opt),
    &make_nios2_oci_itrace ($Opt),
    &make_nios2_oci_dtrace ($Opt),
    &make_nios2_oci_fifo ($Opt),
    &make_nios2_oci_pib ($Opt),
    &make_nios2_oci_im ($Opt),
    &make_nios2_oci_performance_monitors ($Opt),
  );

  if ($is_oci_version2) {
      push(@submodules, &make_nios2_oci_debug_host_slave_control ($Opt),);
  } else {
      push(@submodules,
           &make_nios2_oci_avalon_reg ($Opt),
           &make_nios2_ocimem ($Opt),
      );
  }


  if ($make_submodule) {
    foreach my $submod (@submodules) { 
      e_instance->add ({
        module  => $submod->name(),
      }); 
    }
  }

  my $export = 0;
  if (manditory_bool($Opt, "altium_jtag")) {
    $export = 1;
  }
  my $never_export = $export ^ 1;

  my @nios2_oci_jtag_extra_contents = (
    e_signal->news ( 
      ["resetrequest",  1,  1],
    ),

    e_assign->news (
      [["trigout", 1,],       "dbrk_trigout | xbrk_trigout"],
    ),
  );

  if ($is_oci_version2) {

      $module->add_contents (
        e_assign->news (
          [["jrst_n",  1,], "~debug_reset"],
        ),
    );
  }

  if (!$is_oci_version2) {
      push(@nios2_oci_jtag_extra_contents,


        e_signal->news ( 
          ["tck",           1,  $export,  $never_export],
          ["tdi",           1,  $export,  $never_export],
          ["ir_in",         2,  $export,  $never_export],
          ["tdo",           1,  $export,  $never_export],
          ["ir_out",        2,  $export,  $never_export],
          ["vs_udr",        1,  $export,  $never_export],
          ["vs_cdr",        1,  $export,  $never_export],
          ["vs_sdr",        1,  $export,  $never_export],
          ["vs_uir",        1,  $export,  $never_export],
          ["jtag_state_rti",1,  $export,  $never_export],
         ),
        
         e_assign->news (

           [["debug_mem_slave_debugaccess_to_roms", 1, 1],  "debugack"],
         ),
         

         e_signal->news ( 
           ["waitrequest",  1,  1],
         ),
         
         e_register->news (

           {out => "address",     in => "address_nxt",     enable => "1'b1", reset => "jrst_n"},
           {out => "byteenable",  in => "byteenable_nxt",  enable => "1'b1", reset => "jrst_n"},
           {out => "writedata",   in => "writedata_nxt",   enable => "1'b1", reset => "jrst_n"},
           {out => "debugaccess", in => "debugaccess_nxt", enable => "1'b1", reset => "jrst_n"},
         




           {out => "read",        
            in => "read ? waitrequest : read_nxt",        
            enable => "1'b1", reset => "jrst_n"},
           {out => "write",       
            in => "write ? waitrequest : write_nxt",       
            enable => "1'b1", reset => "jrst_n"},
         



           {out => ["readdata", 32],      
            in => "address[$DBG_SLAVE_ADDR_MSB] ? oci_reg_readdata : ociram_readdata",
            enable => "1'b1", reset => "jrst_n"},
         ),
     );
  
     my $jtag_wrapper_module;
     
     unless ($Opt->{avalon_debug_port_present}) {




       $jtag_wrapper_module = &make_nios2_oci_jtag_wrapper ($Opt);
     }
     if ($Opt->{avalon_debug_port_present}) {


       $jtag_wrapper_module = &make_nios2_oci_jtag_avalon_debug_wrapper ($Opt);
     }
     
     push(@nios2_oci_jtag_extra_contents,
        e_instance->new ({
          module  => $jtag_wrapper_module,
          tag => "normal",
        }),
     );
  }









  if (!$is_oci_version2) {

      &make_nios2_oci_sdc ($Opt);
  }

  $module->add_contents (@nios2_oci_jtag_extra_contents);


  if ($Opt->{oci_offchip_trace}) {

    $module->add_contents (
      e_signal->news (
        ["tr_data",               $Opt->{oci_tr_width},     1],
        ["trigout",               1,                        1],
      ),
    );

    e_assign->adds (
      { lhs => "tr_data", rhs => 0, tag => "simulation", },
      { lhs => "trigout", rhs => 0, tag => "simulation", },
    );
  } else {  

    $module->get_and_set_thing_by_name({
      thing => "mux",
      lhs   => ["dummy_sink", 1, 0, 1],
      name  => "dummy sink",
      type  => "and_or",
      add_table =>
        [   "tr_data",  "tr_data",
            "trigout",  "trigout",
        ],
    });
  }


  if ($Opt->{oci_debugreq_signals}) {

    $module->add_contents (
      e_signal->news (
        ["debugack", 1, 1],
      ),
    );
  } else {  

    $module->get_and_set_thing_by_name({
      thing => "mux",
      lhs   => ["dummy_sink", 1, 0, 1],
      name  => "dummy sink",
      type  => "and_or",
      add_table => ["debugack", "debugack",]
    });
    $module->add_contents (
      e_assign->news (
        [["debugreq",  1,], 0],
      ),
    );
  }

  if ($is_oci_version2) {

  $top_module->add_contents (
    e_instance->new ({
      module => $module,


      port_map  => {

        clk               => "clk",
        reset             => "reset",
        resetrequest      => "debug_reset_request",
        oci_idisable                  => "oci_idisable",
        oci_single_step_mode          => "oci_single_step_mode",
        host_data_reg_write           => "host_data_reg_write",
        host_data_reg_writedata       => "host_data_reg_writedata",
        host_data_reg                 => "host_data_reg",
        host_data_reg_valid           => "host_data_reg_valid",
        host_present                  => "host_present",
        A_eic_rha                     => "A_eic_rha",
        W_valid						  => "W_valid_from_M",


        debugreq      => "debug_req",
        debugack      => "debug_ack",
        trigout       => "debug_trigout", 
        tr_data       => "debug_offchip_trace_data",
      },
    }), 
    e_avalon_slave->new ({
      name  => "debug_mem_slave",
      type_map  => {

        debug_reset_request           => "resetrequest",
        oci_idisable                  => "oci_idisable",
        oci_single_step_mode          => "oci_single_step_mode",
        host_data_reg_write           => "host_data_reg_write",
        host_data_reg_writedata       => "host_data_reg_writedata",
        host_data_reg                 => "host_data_reg",
        host_data_reg_valid           => "host_data_reg_valid",
        host_debug_mode_exc           => "host_debug_mode_exc",
        host_present                  => "host_present",
        W_valid						  => "W_valid_from_M",
      },
    }),
    
    e_register->news (
      {out => "oci_cpu_reset_sampler",     in => "reset_n",                   enable => "1'b1", reset => "debug_reset", reset_level => "1'b1"},
      {out => "oci_cpu_reset_sampler_d1",  in => "oci_cpu_reset_sampler",     enable => "1'b1", reset => "debug_reset", reset_level => "1'b1"},
    ),
    
    e_assign->news (
      ["oci_idisable","host_idisable"],
      ["oci_debug_mode_exc","host_debug_mode_exc"],
      ["oci_single_step_mode","host_single_step_mode"],
      ["reset","~oci_cpu_reset_sampler_d1"],
      [["host_data_reg", 32 ],"W_host_data_register"],
    ),
  );
  } else {

  $top_module->add_contents (
    e_instance->new ({
      module => $module,


      port_map  => {


        clk               => "debug_mem_slave_clk",
        reset             => "debug_mem_slave_reset",
        address_nxt       => "debug_mem_slave_address",
        byteenable_nxt    => "debug_mem_slave_byteenable",
        read_nxt          => "debug_mem_slave_read",
        write_nxt         => "debug_mem_slave_write",
        writedata_nxt     => "debug_mem_slave_writedata",
        debugaccess_nxt   => "debug_mem_slave_debugaccess",
        waitrequest       => "debug_mem_slave_waitrequest",
        readdata          => "debug_mem_slave_readdata",
        resetrequest      => "debug_reset_request",


        debugreq      => "debug_req",
        debugack      => "debug_ack",
        trigout       => "debug_trigout", 
        tr_data       => "debug_offchip_trace_data",
      },
    }), 
    e_avalon_slave->new ({
      name  => "debug_mem_slave",
      type_map  => {

        debug_mem_slave_address       => "address",
        debug_mem_slave_byteenable    => "byteenable",
        debug_mem_slave_read          => "read",
        debug_mem_slave_write         => "write",
        debug_mem_slave_writedata     => "writedata",
        debug_mem_slave_debugaccess   => "debugaccess",
        debug_mem_slave_waitrequest   => "waitrequest",
        debug_mem_slave_readdata      => "readdata",
        debug_reset_request           => "resetrequest",
      },
    }),
    e_assign->news (
      ["debug_mem_slave_clk","clk"],
      ["debug_mem_slave_reset","~reset_n"],
    ),
  );
  }
  

  if ($Opt->{avalon_debug_port_present}) {
       print "\nINFO: debug_mem_slave is creating an avalon port " .
         "instead of its jtag connections.\n";
       my @nios2_oci_debug_extra_contents = (

       e_avalon_slave->new ({
          name => "avalon_debug_port",
          type_map => {
              avalon_debug_port_address       => "address",
              avalon_debug_port_readdata      => "readdata",
              avalon_debug_port_write         => "write",
              avalon_debug_port_read          => "read",
              avalon_debug_port_writedata     => "writedata",
          }
       }),
      );
      $top_module->add_contents (@nios2_oci_debug_extra_contents);
  }
  

  if ($is_oci_version2) {
      my @nios2_oci_debug_extra_contents = (
    
        e_avalon_slave->new ({
          name => "debug_host_slave",
          type_map => {
              debug_host_slave_address       => "address",
              debug_host_slave_readdata      => "readdata",
              debug_host_slave_write         => "write",
              debug_host_slave_writedata     => "writedata",
              debug_host_slave_read          => "read",
              debug_host_slave_waitrequest   => "waitrequest",
          }
       }),
      );
      
      if (manditory_bool($Opt, "oci_onchip_trace")) {
        push(@nios2_oci_debug_extra_contents,
        
          e_avalon_slave->new ({
            name => "debug_trace_slave",
            type_map => {
                debug_trace_slave_address       => "address",
                debug_trace_slave_readdata      => "readdata",
                debug_trace_slave_read          => "read",
            }
         }),
        );
      }
    $top_module->add_contents (@nios2_oci_debug_extra_contents);
  }
  return $module;
}





sub validate_nios2_oci_parameters 
{
  my $Opt = shift;

  &validate_parameter ({  # width of cpu inst addr bus
    hash    => $Opt,
    name    => "cpu_i_address_width",
    type    => "integer",
    default => $pcb_sz,
  });
  &validate_parameter ({  # width of cpu inst data bus
    hash    => $Opt,
    name    => "cpu_i_data_width",
    type    => "integer",
    default => 32,
  });
  &validate_parameter ({  # width of cpu data addr bus
    hash    => $Opt,
    name    => "cpu_d_address_width",
    type    => "integer",
    default => $mem_baddr_sz,
  });
  &validate_parameter ({  # width of cpu data data bus
    hash    => $Opt,
    name    => "cpu_d_data_width",
    type    => "integer",
    default => 32,
  });
  &validate_parameter ({  # number of xbrks
    hash    => $Opt,
    name    => "oci_num_xbrk",
    type    => "integer",
    default => 0,
  });
  &validate_parameter ({  # number of dbrks
    hash    => $Opt,
    name    => "oci_num_dbrk",
    type    => "integer",
    default => 0,
  });
  &validate_parameter ({  # do we support trigger states?
    hash    => $Opt,
    name    => "oci_trigger_arming",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # can dbrks control trace collection?
    hash    => $Opt,
    name    => "oci_dbrk_trace",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # can dbrks be combined into pairs?
    hash    => $Opt,
    name    => "oci_dbrk_pairs",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # capability to do data trace?
    hash    => $Opt,
    name    => "oci_data_trace",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # on-chip trace memory present
    hash    => $Opt,
    name    => "oci_onchip_trace",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # off-chip trace port present
    hash    => $Opt,
    name    => "oci_offchip_trace",
    type    => "boolean",
    default => 0,
  });
  &validate_parameter ({  # 7 = 128 trace words
    hash    => $Opt,
    name    => "oci_trace_addr_width",
    type    => "integer",
    default => 7,
  });
  &validate_parameter ({  # extra external signals?
    hash    => $Opt,      # (usefill if off-chip trace port present)
    name    => "oci_debugreq_signals",
    type    => "integer",
    default => 0,
  });
  &validate_parameter ({  # 4 = 16 words oci trace fifo
    hash    => $Opt,
    name    => "oci_fifo_addr_width",
    type    => "integer",
    default => 4,
  });

  &validate_parameter ({  # width of trace message
    hash    => $Opt,
    name    => "oci_tm_width",
    type    => "integer",
    default => ($Opt->{cpu_d_data_width} + 4),
  });
  &validate_parameter ({  # off-chip trace port width
    hash    => $Opt,
    name    => "oci_tr_width",
    type    => "integer",
    default => ($Opt->{cpu_d_data_width} + 4),
  });
  &validate_parameter ({  # Number of Performance Monitors?
    hash    => $Opt,      # 0 == no performance monitor support.
    name    => "oci_num_pm",
    type    => "integer",
    default => 0,
  });
  &validate_parameter ({  # What is the width of the
    hash    => $Opt,      # Performance Monitors counters?
    name    => "oci_pm_width",
    type    => "integer",
    default => 40,
  });
  &validate_parameter ({  # num of synchronizer stages for tck to sysclk
    hash    => $Opt,      
    name    => "oci_sync_depth",
    type    => "integer",
    default => 2,
  });
  &validate_parameter ({  # debug test
    hash    => $Opt,      
    name    => "avalon_debug_port_present",
    type    => "boolean",
    default => 0,
  });
}

1;
