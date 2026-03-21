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


























package nios_avalon_masters;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $dmaster_bursts
    $dmaster_burstcount_max
    $dmaster_burstcount_sz

    $imaster_bursts
    $imaster_burstcount_max
    $imaster_burstcount_sz

    $itcm_present
    $dtcm_present
    $ihp_present
    $dhp_present

    $pcb_sz
    $pch_sz
    $pc_sz
    $pc_nibbles
    $mem_baddr_sz
    $max_paddr_sz
);

use cpu_utils;
use strict;





our $dmaster_bursts;
our $dmaster_burstcount_max;
our $dmaster_burstcount_sz;

our $imaster_bursts;
our $imaster_burstcount_max;
our $imaster_burstcount_sz;

our $itcm_present;
our $dtcm_present;
our $ihp_present;
our $dhp_present;

our $pcb_sz;
our $pch_sz;
our $pc_sz;
our $pc_nibbles;
our $mem_baddr_sz;
our $max_paddr_sz;






sub
get_test_avalon_master_info
{
    my $test_avalon_master_info = {
        avalon_masters => {
          data_master => {
            type => "data",
            access_type => "normal",
            paddr_base => 0x40000,
            paddr_top => 0x82047,
          },
          instruction_master => {
            type => "instruction",
            access_type => "normal",
            paddr_base => 0x40000,
            paddr_top => 0x81fff,
          },
          flash_instruction_master => {
            type => "instruction",
            access_type => "flash",
            paddr_base => 0x40000,
            paddr_top => 0x81fff,
          },
          tightly_coupled_data_master_0 => {
            type => "data",
            access_type => "tcm",
            paddr_base => 0x90000,
            paddr_top => 0x90fff,
          },
          tightly_coupled_instruction_master_0 => {
            type => "instruction",
            access_type => "tcm",
            paddr_base => 0x90000,
            paddr_top => 0x90fff,
          },
          instruction_master_high_performance => {
            type => "instruction",
            access_type => "highperformance",
            paddr_base => 0x00000,
            paddr_top => 0x00fff,
          },
          data_master_high_performance => {
            type => "data",
            access_type => "highperformance",
            paddr_base => 0x00000,
            paddr_top => 0x00fff,
          },
        },
      };

    return $test_avalon_master_info;
}



sub
create_avalon_master_args_from_infos
{
    my $avalon_master_info = shift;         # Hash reference
    my $test_info = shift;
    my $mmu_present = shift;
    my $mpu_present = shift;
    my $fa_present = shift;

    assert_scalar($mmu_present, "mmu_present") || return undef;
    assert_scalar($mpu_present, "mpu_present") || return undef;
    assert_scalar($fa_present, "fa_present") || return undef;

    my $avalon_master_args = {
        avalon_master_info    => $avalon_master_info,
        bit_31_bypass_dcache  => manditory_bool($test_info, "bit_31_bypass_dcache"),
        mmu_present           => $mmu_present,
        mpu_present           => $mpu_present,
        fa_present            => $fa_present,
    };

    return $avalon_master_args;
}




sub
create_avalon_master_args_default_configuration
{
    my $avalon_master_info = shift;         # Hash reference

    my $avalon_master_args = {
        avalon_master_info    => get_test_avalon_master_info(),
        bit_31_bypass_dcache  => 1,
        mmu_present           => 1,
        mpu_present           => 0,
        fa_present            => 0,
    };

    return $avalon_master_args;
}




sub
validate_and_elaborate
{
    my $avalon_master_args = shift; # Hash reference containing all args

    my $avalon_master_info = 
      manditory_hash($avalon_master_args, "avalon_master_info");
    my $mmu_present = manditory_bool($avalon_master_args, "mmu_present");
    my $mpu_present = manditory_bool($avalon_master_args, "mpu_present");
    my $bit_31_bypass_dcache = manditory_bool($avalon_master_args, "bit_31_bypass_dcache");
    my $fa_present = manditory_bool($avalon_master_args, "fa_present");

    my $ret = {};   # The return value



    $ret->{avalon_master_list} = [];
    $ret->{avalon_data_master_list} = [];
    $ret->{avalon_instruction_master_list} = [];
    if ($fa_present) {
        $ret->{avalon_flash_accelerator_master_list} = [];
    }
    $ret->{avalon_tightly_coupled_data_master_list} = [];
    $ret->{avalon_tightly_coupled_instruction_master_list} = [];
    $ret->{avalon_data_master_high_performance_list} = [];
    $ret->{avalon_instruction_master_high_performance_list} = [];

    my $max_data_paddr_top;
    my $max_inst_paddr_top;

    foreach my $master_name 
      (sort(keys(%{$avalon_master_info->{avalon_masters}}))) {
        validate_master_name($master_name);

        my $avalon_master = $avalon_master_info->{avalon_masters}{$master_name};
        my $paddr_base = $avalon_master->{paddr_base};
        my $paddr_top = $avalon_master->{paddr_top};


        if ($master_name eq "flash_instruction_master" && !$fa_present) {

        } else {
        push(@{$ret->{avalon_master_list}}, $master_name);
        }
        if ($avalon_master->{type} eq "data") {
            push(@{$ret->{avalon_data_master_list}}, $master_name);

            if ($avalon_master->{access_type} eq "tcm") {
                push(@{$ret->{avalon_tightly_coupled_data_master_list}},
                  $master_name);
            }

            if ($avalon_master->{access_type} eq "highperformance") {
                push(@{$ret->{avalon_data_master_high_performance_list}},
                  $master_name);
            }


            if (!defined($max_data_paddr_top) || 
              ($paddr_top > $max_data_paddr_top)) {
                $max_data_paddr_top = $paddr_top;
            }
        } elsif ($avalon_master->{type} eq "instruction") {
            push(@{$ret->{avalon_instruction_master_list}}, $master_name);

            if ($avalon_master->{access_type} eq "tcm") {
                push(@{$ret->{avalon_tightly_coupled_instruction_master_list}},
                  $master_name);
            }
            
            if ($avalon_master->{access_type} eq "highperformance") {
                push(@{$ret->{avalon_instruction_master_high_performance_list}},
                  $master_name);
            }
            
            if ($fa_present) {
                if ($avalon_master->{access_type} eq "flash") {
                    push(@{$ret->{avalon_flash_accelerator_master_list}},
                      $master_name);
                }
            }


            if (!defined($max_inst_paddr_top) || 
              ($paddr_top > $max_inst_paddr_top)) {
                $max_inst_paddr_top = $paddr_top;
            }
        } else {
            &$error("Master $master_name of type '" . $avalon_master->{type} .
              "' isn't a data or instruction Avalon master");
        }


        $ret->{$master_name} = {};

        $ret->{$master_name}{name} = $master_name;
        $ret->{$master_name}{Paddr_Base} = $paddr_base;
        $ret->{$master_name}{Paddr_Top} = $paddr_top;

        $ret->{$master_name}{Address_Width} = compute_address_width(
          $bit_31_bypass_dcache, $paddr_top, "master $master_name");
    



        $ret->{$master_name}{Slave_Address_Width} = 
          compute_address_width($bit_31_bypass_dcache, $paddr_top - $paddr_base,
            "master $master_name");
    
        my $base_addr_top_bits_width = 
          $ret->{$master_name}{Address_Width} - 
          $ret->{$master_name}{Slave_Address_Width};
    
        if ($base_addr_top_bits_width > 0) {
            $ret->{$master_name}{Paddr_Base_Top_Bits} = 
              sprintf("%d'h%x", 
                $base_addr_top_bits_width,
                $ret->{$master_name}{Paddr_Base} >> 
                $ret->{$master_name}{Slave_Address_Width});
        }
    }

    if (scalar(@{$ret->{avalon_instruction_master_list}}) == 0) {
        &$error("Must have at least one Avalon instruction master");
    }

    if (scalar(@{$ret->{avalon_data_master_list}}) == 0) {
        &$error("Must have at least one Avalon data master");
    }

    $ret->{num_tightly_coupled_data_masters} = 
      scalar(@{$ret->{avalon_tightly_coupled_data_master_list}});
    $ret->{num_tightly_coupled_instruction_masters} =
      scalar(@{$ret->{avalon_tightly_coupled_instruction_master_list}});




    $ret->{i_Address_Width} = 
      compute_address_width($bit_31_bypass_dcache, $max_inst_paddr_top,
      "all instruction masters");
    $ret->{d_Address_Width} = 
      compute_address_width($bit_31_bypass_dcache, $max_data_paddr_top,
        "all data masters");


    $ret->{Max_Address_Width} = 
      ($ret->{i_Address_Width} > $ret->{d_Address_Width}) ?
      $ret->{i_Address_Width} :
      $ret->{d_Address_Width};
 




    $ret->{pcb_sz} = ($mmu_present || $mpu_present) ? 32 : $ret->{i_Address_Width};





    $ret->{mem_baddr_sz} = 
      $mmu_present ? 32 :
      $mpu_present ? ($bit_31_bypass_dcache ? 31 : 32):
                     $ret->{d_Address_Width};

    return $ret;
}

sub
initialize_config_constants
{
    my $Opt = shift;

    my $dcache_present = manditory_bool($Opt, "cache_has_dcache");
    my $icache_present = manditory_bool($Opt, "cache_has_icache");

    $dmaster_bursts = manditory_bool($Opt, "cache_dcache_bursts");
    $dmaster_burstcount_max = $dmaster_bursts ? 
        (manditory_int($Opt, "cache_dcache_line_size") / 4) :
        1;
    $dmaster_burstcount_sz = num2sz($dmaster_burstcount_max);

    if ($icache_present) {
        $imaster_bursts = 
          (not_empty_scalar($Opt, "cache_icache_burst_type") ne "none");
        $imaster_burstcount_max = 
          $imaster_bursts ? 
            (manditory_int($Opt, "cache_icache_line_size") / 4) : 
            1;
        $imaster_burstcount_sz = num2sz($imaster_burstcount_max);
    } else {
        $imaster_bursts = 0;
    }


    $itcm_present = 
      (manditory_int($Opt, "num_tightly_coupled_instruction_masters") > 0);
    $dtcm_present = 
      (manditory_int($Opt, "num_tightly_coupled_data_masters") > 0);
    

    $ihp_present = 
      (defined($Opt->{instruction_master_high_performance}{name}));
    $dhp_present = 
      (defined($Opt->{data_master_high_performance}{name}));


    $pcb_sz = manditory_int($Opt, "pcb_sz");


    $pc_sz = $pcb_sz - 2;
    $pch_sz = $pcb_sz - 1;


    $pc_nibbles = int(($pc_sz + 3) / 4);


    $mem_baddr_sz = manditory_int($Opt, "mem_baddr_sz");


    $max_paddr_sz = manditory_int($Opt, "Max_Address_Width");
}






sub
validate_master_name
{
    my $master_name = shift;

    if ($master_name eq "data_master") {
        return;
    }

    if ($master_name eq "instruction_master") {
        return;
    }
    
    if ($master_name eq "flash_instruction_master") {
        return;
    }

    if ($master_name =~ /tightly_coupled_data_master_[0-9]/) {
        return;
    }

    if ($master_name =~ /tightly_coupled_instruction_master_[0-9]/) {
        return;
    }

    if ($master_name =~ "data_master_high_performance") {
        return;
    }

    if ($master_name =~ "instruction_master_high_performance") {
        return;
    }

    &$error("Master $master_name is not a recognized Avalon master name");
}


sub 
compute_address_width
{
    my $bit_31_bypass_dcache = shift;
    my $paddr_top = shift;
    my $error_name = shift;




    my $max_avalon_address_bits = $bit_31_bypass_dcache ? 31 : 32;

    my $desired_address_bits = num2sz($paddr_top);

    if ($desired_address_bits > $max_avalon_address_bits) {
        return &$error("Maximum Avalon address bits for $error_name is " .
          $max_avalon_address_bits . " for this CPU implementation" .
          " but " .  $desired_address_bits . " are required to address" .
          " all the slave modules.");
    }

    return $desired_address_bits;
}

1;

