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














package nios_register_file_ram;

use cpu_utils;
use europa_utils;
use e_instance;
use nios_isa;

@ISA = qw (e_instance);

use strict;

my %fields =
(

  data_width => 32,
  address_width => 5,
  rf_num_reg => 32,
  shadow_present => 0,
  shadow_num_set => 0,
  shadow_set_sz => 0,
  register_file_por => 0,
 

  Opt => undef,
);

my %pointers =
(
);

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

sub 
new 
{
  my $this = shift;
  my $self = $this->SUPER::new(@_);


  &$error("Data width not specified") if $self->data_width() == 0;
  &$error("Address width not specified") if $self->address_width() == 0;
  
  $self->_create_module();

  return $self;
}

sub 
_byteenable_width
{
  my $this = shift;
  
  return ceil($this->data_width() / 8.0);
}

sub 
_create_module
{
  my $this = shift;

  my $proto_name = $this->name() . "_module";
  my $module = e_module->new({name => $proto_name, });

  $module->do_black_box(0);


















  

  for my $required_port (qw(clk rdaddress_a rdaddress_b q_a q_b wren wraddress data))
  {
    if (!defined $this->port_map()->{$required_port})
    {
      &$error("required port '$required_port' not specified in port map");
    }
  }
  

  my @allowed_ports = qw(
    clk
    reset_n
    rdaddress_a
    rdaddress_b
    rdshadow_set
    q_a
    q_b
    wren
    wraddress
    wrshadow_set
    data
  );

  for my $port_name (keys %{$this->port_map()}) {
    &$error ("Illegal port '$port_name'") if !grep {/$port_name/} @allowed_ports;
    
    my $port = e_port->new({
      name => $port_name,
    });
    
    $module->add_contents($port);
    
    $port_name eq 'clk' and do {
      next;
    };

    $port_name eq 'reset_n' and do {
      next;
    };
    
    $port_name =~ 'rdaddress_a' and do {
      $port->width($this->address_width()); next;
    };

    $port_name =~ 'rdaddress_b' and do {
      $port->width($this->address_width()); next;
    };

    $port_name =~ 'rdshadow_set' and do {
      $port->width($this->shadow_set_sz()); next;
    };
    
    $port_name eq 'q_a' and do {
      $port->width($this->data_width()); $port->direction('out'); next;
    };
    
    $port_name eq 'q_b' and do {
      $port->width($this->data_width()); $port->direction('out'); next;
    };
   
    $port_name eq 'wren' and do {
      next;
    };
    
    $port_name eq 'data' and do {
      $port->width($this->data_width()); next;
    };
  
    $port_name =~ 'wraddress' and do {
      $port->width($this->address_width()); next;
    };
    
    $port_name =~ 'wrshadow_set' and do {
      $port->width($this->shadow_set_sz()); next;
    };
   
    &$error("Failed to handle port '$port_name'");
  }

  $this->module($module);
}


sub 
update
{
  my $this = shift;  
  $this->parent(@_);

  $this->add_objects();

  my $ret = $this->SUPER::update(@_);
  
  return $ret;
}

sub 
add_objects
{
  my ($this, $type) = (@_);
  
  my $module = $this->module();

  &$error("bad usage") if (!$module or !$this);

  my @things;
       
  push(@things, $this->create_register_file_instance());
  
  map {$_->tag($type)} @things if $type;

  $module->add_contents(@things);
}

sub
create_register_file_instance
{
    my $this = shift;

    my $rf_a_mux_table = [];
    my $rf_b_mux_table = [];
    my $rf_dst_mux_table = [];
    
    my @register_file_instance;
    my @reg_init_values;


    for (my $rf = 1; $rf < $this->rf_num_reg() ; $rf ++) {
        my $rf_minus1 = ($rf - 1);
        push(@$rf_dst_mux_table, "${rf}" => "1<<${rf_minus1}", );
    }
    
    push(@$rf_dst_mux_table, "0" => "0", );

    
    push(@register_file_instance,
        e_mux->add({
          lhs   => ["wr_regnum_decode", 31],
          selecto => "wraddress",
          table => $rf_dst_mux_table,
        }),
    );
    
    my $reg_num_set = $this->shadow_num_set();
    my $reg_set_sz = $this->shadow_set_sz();

    if ($this->shadow_present()) {
        my $rf_regset_a_mux_table = [];
        my $rf_regset_b_mux_table = [];
        my $rf_dst_regset_mux_table = [];
    

        for (my $rf_set = 0; $rf_set <= $reg_num_set ; $rf_set ++) {
            push(@$rf_dst_regset_mux_table, "${rf_set}" => "1'b1 << ${rf_set}", );
        }

        push(@register_file_instance,
            e_mux->add({
               lhs   => ["wraddress_set_decode", $reg_num_set],
               selecto => "wrshadow_set",
               table => $rf_dst_regset_mux_table,
            }),
        );
    
        for (my $rf_set = 0; $rf_set < $reg_num_set ; $rf_set ++) {
            $rf_a_mux_table = [];
            $rf_b_mux_table = [];
            $rf_dst_mux_table = [];
            for (my $rf = 1; $rf < $rf_num_reg ; $rf ++) {
                my $rf_minus1 = ($rf - 1);
                if ($this->register_file_por()) {
                push(@register_file_instance,
                    e_register->adds(

                      {out => ["reg_rf_${rf_set}_${rf}", 32], 
                      in => "data",     enable => "wren & wr_regnum_decode[${rf_minus1}] & wraddress_set_decode[${rf_set}]",
                      },
                    ),
                );
                } else {
                push(@register_file_instance,
                    e_register->adds(

                      {out => ["reg_rf_${rf_set}_${rf}", 32], 
                      in => "data",     enable => "wren & wr_regnum_decode[${rf_minus1}] & wraddress_set_decode[${rf_set}]",
                      reset => ""},
                    ),
                );	
                }
                push(@$rf_a_mux_table, "${rf}" => "reg_rf_${rf_set}_${rf}", );
                push(@$rf_b_mux_table, "${rf}" => "reg_rf_${rf_set}_${rf}", );
                push(@reg_init_values, "reg_rf_${rf_set}_${rf}" );
            }
            
            push(@$rf_a_mux_table, "0" => "0", );
            push(@$rf_b_mux_table, "0" => "0", );
    

            push(@register_file_instance,            
                e_mux->add({
                  lhs   => ["rd_rf_${rf_set}_a", $datapath_sz],
                  selecto => "rdaddress_a",
                  table => $rf_a_mux_table,
                }),
                e_mux->add({
                  lhs   => ["rd_rf_${rf_set}_b", $datapath_sz],
                  selecto => "rdaddress_b",
                  table => $rf_b_mux_table,
                }),
            );
            push(@$rf_regset_a_mux_table, "${rf_set}" => "rd_rf_${rf_set}_a", );
            push(@$rf_regset_b_mux_table, "${rf_set}" => "rd_rf_${rf_set}_b", );            
        }
        

        push(@register_file_instance,
            e_mux->add({
              lhs   => ["q_a", $datapath_sz],
              selecto => "rdshadow_set",
              table => $rf_regset_a_mux_table,
            }),
            e_mux->add({
              lhs   => ["q_b", $datapath_sz],
              selecto => "rdshadow_set",
              table => $rf_regset_b_mux_table,
            }),
        );
      } else {
        for (my $rf = 1; $rf < $this->rf_num_reg() ; $rf ++) {
            my $rf_minus1 = ($rf - 1);
            push(@register_file_instance,
                e_assign->adds(


                   [["reg_rf_${rf}_wren", 1], "wren & wr_regnum_decode[${rf_minus1}]"],
                ),
            );
            
                if ($this->register_file_por()) {
                push(@register_file_instance,
                e_register->adds(
                  {out => ["reg_rf_${rf}", $this->data_width()], 
                   in => "data",     enable => "reg_rf_${rf}_wren",
                  },
                ),
                );
                } else {
                push(@register_file_instance,
                e_register->adds(
                  {out => ["reg_rf_${rf}", $this->data_width()], 
                   in => "data",     enable => "reg_rf_${rf}_wren",
                   reset => "",
                  },
                ),
                );
                }
            
        
            push(@$rf_a_mux_table, "${rf}" => "reg_rf_${rf}", );
            push(@$rf_b_mux_table, "${rf}" => "reg_rf_${rf}", );
            push(@reg_init_values, "reg_rf_${rf}" );
        }
        
        push(@$rf_a_mux_table, "0" => "0", );
        push(@$rf_b_mux_table, "0" => "0", );
        
        push(@register_file_instance,
            e_mux->add({
              lhs   => ["q_a", $this->data_width()],
              selecto => "rdaddress_a",
              table => $rf_a_mux_table,
            }),
            
            e_mux->add({
              lhs   => ["q_b", $this->data_width()],
              selecto => "rdaddress_b",
              table => $rf_b_mux_table,
            }),
        );
    }



    if (!$this->register_file_por()) {
    my @initial_block_statement;
    foreach (@reg_init_values) {
        push(@initial_block_statement, e_assign->new([$_ => "32'hdeadbeef"]))    
    }

    push(@register_file_instance,
         e_initial_block->new ({
            comment => "Initial block for simulation ",
            tag => "simulation",
            contents => [@initial_block_statement],
        }),
    );
    }

    return @register_file_instance;
}

__PACKAGE__->DONE();

1;
