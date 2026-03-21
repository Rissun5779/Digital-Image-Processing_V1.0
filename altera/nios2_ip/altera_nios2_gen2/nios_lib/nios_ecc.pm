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












package nios_ecc;

use cpu_utils;
use europa_utils;
use e_instance;
use e_blind_instance;

@ISA = qw (e_instance);

use strict;

my %fields =
(

  codeword_width => 0,
  dataword_width => 0,

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


  &$error("Codeword width not specified") if $self->codeword_width() == 0;
  &$error("Dataword width not specified") if $self->dataword_width() == 0;
  
  $self->_create_module();

  return $self;
}

sub 
_create_module
{
  my $this = shift;

  my $proto_name = $this->name() . "_module";
  my $module = e_module->new({name => $proto_name, });

  $module->do_black_box(0);

















  for my $required_port (qw(clk reset_n q data ram_data ram_q one_bit_err two_bit_err one_two_or_three_bit_err))
  {
    if (!defined $this->port_map()->{$required_port})
    {
      &$error("required port '$required_port' not specified in port map");
    }
  }
  

  my @allowed_ports = qw(
    clk
    reset_n
    data
    ram_q
    q
    ram_data
    one_bit_err
    two_bit_err
    one_two_or_three_bit_err
    injs
    injd
  );

  for my $port_name (keys %{$this->port_map()})
  {
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

    $port_name eq 'data' and do {
      $port->width($this->dataword_width()); next;
    };

    $port_name eq 'ram_q' and do {
      $port->width($this->codeword_width()); next;
    };

    $port_name eq 'q' and do {
      $port->width($this->dataword_width()); $port->direction('out'); next;
    };

    $port_name eq 'ram_data' and do {
      $port->width($this->codeword_width()); $port->direction('out'); next;
    };

    $port_name eq 'one_bit_err' and do {
      $port->direction('out'); next;
    };

    $port_name eq 'two_bit_err' and do {
      $port->direction('out'); next;
    };

    $port_name eq 'one_two_or_three_bit_err' and do {
      $port->direction('out'); next;
    };
    
    $port_name eq 'injs' and do {
      next;
    };
    
    $port_name eq 'injd' and do {
      next;
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

      push(@things,       

        e_signal->new({
         name => "aclr",
         width => 1,
         never_export => 1,
        }),

        e_assign->new(['aclr', '~reset_n']),
    );

  push(@things, $this->create_altecc_encoder_instance());
  push(@things, $this->create_altecc_decoder_instance());
  
  map {$_->tag($type)} @things if $type;

  $module->add_contents(@things);
}

sub
create_altecc_encoder_instance
{

    my $this = shift;
    my @things;
    
    my $ecc_bits= $this->codeword_width() - $this->dataword_width();

    push(@things,
        e_comment->add({ comment => "ECC Encoder\n", }),
        e_signal->new({
            name => "parity_bits",
            width => $ecc_bits,
            never_export => 1,
        }),

        e_signal->new({
            name => "data_out",
            width => $this->dataword_width(),
            never_export => 1,
        }),
    );



    push(@things,
        e_assign->adds(
           [["data_inj_bit0", 1],  "(injs | injd) ^ data[0]"],
        ),
    );

    if ($this->dataword_width() > 1) {
        push(@things,
            e_assign->adds(
               [["data_inj_bit1", 1],  "injd ^ data[1]"],
            ),
        );
    }
    my $in_port_map = {
        clock    => 'clk',
        clocken  => "1'b1",
        aclr     => 'aclr',
        data     => 'data',
    };

    my $out_port_map = {
        q        => '{parity_bits,data_out}',
    };

    my $parameter_map = {
        lpm_pipeline          => 0,
        width_codeword        => $this->codeword_width(),
        width_dataword        => $this->dataword_width(),
        lpm_type              => "\"altecc_encoder\"",
        lpm_hint              => "\"unused\"",
    };

    my $data_msb = $this->dataword_width() - 1;
    push(@things,
         e_blind_instance->new({
          use_sim_models => 1,
          name => 'the_ecc_encoder',
          module => 'altecc_encoder',
          in_port_map => $in_port_map,
          out_port_map => $out_port_map,
          parameter_map => $parameter_map,
        }),
    );

    if ($this->dataword_width() == 1) {
        push(@things,
            e_assign->new(["ram_data", "wrsel? corrected_output : {parity_bits,data_inj_bit0}"]),
        );
    } elsif ($this->dataword_width() == 2) {
        push(@things,
            e_assign->new(["ram_data", "wrsel? corrected_output : {parity_bits,data_inj_bit1,data_inj_bit0}"]),
        );
    } else {
        push(@things,
            e_assign->new(["ram_data", "wrsel? corrected_output : {parity_bits,data[${data_msb}:2],data_inj_bit1,data_inj_bit0}"]),
        );
    }

     return @things;
        
}


sub
create_altecc_decoder_instance
{
    my $this = shift;

    my @things;

    my $ecc_bits= $this->codeword_width() - $this->dataword_width();
    my $ecc_msb = $ecc_bits - 1;
    my $ecc_msb_minus1 = $ecc_msb - 1;
    my $data_msb = $this->dataword_width() - 1;
    my $code_msb = $this->codeword_width() - 1;
    my $code_lsb = $this->codeword_width() - $ecc_bits;
    
    push(@things,
        e_comment->add({ comment => "ECC Decoder\n", }),
        e_signal->new({
            name => "ecc_expected_bits",
            width => $ecc_bits,
            never_export => 1,
        }),
        e_signal->new({
            name => "ecc_calculated_bits",
            width => $ecc_bits-1,
            never_export => 1,
        }),
        e_signal->new({
            name => "data_in",
            width => $this->dataword_width(),
            never_export => 1,
        }),
      

        e_signal->new({
            name => "data_out",
            width => $this->dataword_width(),
            never_export => 1,
        }),
        e_signal->new({
            name => "ecc_dummy_msb",
            width => 1,
            never_export => 1,
        }),
     

      e_assign->adds(
          [["ecc_expected_bits",$ecc_bits],      "ram_q[${code_msb}:${code_lsb}]"],
          [["data_in",$this->dataword_width()],  "ram_q[${data_msb}:0]"],
      ),
    );

    my $expected_parity = "ecc_expected_bits[0]";
    for (my $count=1; $count < ($ecc_bits -1) ; $count++ ) {
        $expected_parity = "ecc_expected_bits[${count}] ^" . $expected_parity;
    }


    push(@things,    

      e_assign->adds(
          [["data_in_parity",1],  "^data_in"],
          [["ecc_parity",1],  "${expected_parity}"],           
          [["ecc_calculated_msb",1],  "data_in_parity ^ ecc_parity"],
      ),
      



      e_assign->adds(
          [["syndrome",$ecc_bits-1],  "ecc_expected_bits[${ecc_msb_minus1}:0] ^ ecc_calculated_bits"],
          [["syndrome_err",1],  "syndrome != 0"],
          [["extra_parity_err",1],  "ecc_expected_bits[${ecc_msb}] ^ ecc_calculated_msb"],
      ),
      



      e_assign->adds(
          [["one_bit_err",1],  "syndrome_err & extra_parity_err"],
          [["two_bit_err",1],  "syndrome_err & ~extra_parity_err"],
          [["one_two_or_three_bit_err",1],  "syndrome_err | extra_parity_err"],
      ),
    );


    
    my @case_contents;
    my $powerof2 = 0;
    my $data_bit_count = 0;

    for (my $count=1; $count < $code_msb ; $count++ ) {
        my $count_powerof2 = 2 ** $powerof2;
        my $binarynum = dec2bin($count);
        if ( $count == $count_powerof2) {
            push(@case_contents,
                 "${ecc_msb}'b${binarynum}" => [ ["corrected_parity[${powerof2}]" => "~ecc_expected_bits[${powerof2}]"], ],
            );
            $powerof2++;
        } else {
            push(@case_contents,
                 "${ecc_msb}'b${binarynum}" => [ ["corrected_data[${data_bit_count}]" => "~data_in[${data_bit_count}]"], ],
            );
            $data_bit_count++
        }
    }
    
    push(@case_contents,
        default => [ ["corrected_data[${data_bit_count}]" => "~data_in[${data_bit_count}]"], ],
    );
     push(@things, 
      e_signal->new({
        name => "corrected_parity",
        width => $ecc_bits,
        never_export => 1,
      }),
      e_signal->new({
        name => "corrected_data",
        width => $this->dataword_width(),
        never_export => 1,
      }),
          e_case->new ({
             switch    => "syndrome",
             parallel  => 0,
             full      => 0,
             contents  => {@case_contents},
          }), 
    );
    my $in_port_map = {
        clock    => 'clk',
        clocken  => "1'b1",
        aclr     => 'aclr',
        data     => 'data_in',
    };

    my $out_port_map = {
        q             => '{ecc_dummy_msb,ecc_calculated_bits,data_out}',
    };

    my $parameter_map = {
        lpm_pipeline          => 0,
        width_codeword        => $this->codeword_width(),
        width_dataword        => $this->dataword_width(),
        lpm_type              => "\"altecc_encoder\"",
        lpm_hint              => "\"unused\"",
    };

    push(@things,
        e_blind_instance->new({
          use_sim_models => 1,
          name => 'ecc_encoder_for_decoder',
          module => 'altecc_encoder',
          in_port_map => $in_port_map,
          out_port_map => $out_port_map,
          parameter_map => $parameter_map,
        }),
     );
    

     push(@things,
         e_assign->new(["q", "data_in"]),
         e_assign->new(["corrected_output", "{corrected_parity,corrected_data}"]),
     );
     return @things;
}


sub dec2bin {
	my $str = unpack("B32", pack("N", shift));
	$str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
	return $str;
}


__PACKAGE__->DONE();

1;
