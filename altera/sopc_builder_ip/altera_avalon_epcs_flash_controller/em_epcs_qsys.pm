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


#Copyright (C)2001-2010 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.

use europa_all;
use strict;



my $Address_Width = 9;     # 2KBytes = 11 bits, 32 bits --> -2.
my $Data_Width = 32;
my $file_location;

sub make_epcs
{

  my $Address_Width = 9;
  my $Data_Width = 32;

  my ($project, $Options, $module) = (@_);
  my $slave_name = &get_slave_name();
  my $register_offset = $project->{register_offset};
  my $use_asmi_atom = $project->{use_asmi_atom};
  my $SBI = $slave_name;
  $file_location= $Options->{project_info}{system_directory} ;

  # I'll base various names of things on this component's top module name,
  # even though I fully expect it to always be 'epcs' at this point.
  my $top_level_module_name = $module->name();

  # I must update, to fill in the data base.
  $module->update();

  # Get the SPI ports.
  my @inner_ports = $module->get_object_names("e_port");

  # Rename the SPI module.
  my $new_name = $top_level_module_name . "_sub";
  my $inner_mod = $project->module_hash()->{$top_level_module_name};
  $inner_mod->name($new_name);
  $project->module_hash()->{$new_name} = $inner_mod;
  delete $project->module_hash()->{$top_level_module_name};

  # Make a new module, with the original top module name.
  my $module = e_module->new({
    name => $top_level_module_name,
    project => $project,
  });

  $module->add_contents(
    e_instance->new({
      module => $new_name,
    }),
  );

  # All inner module non-export ports become new top module ports--
  #   with the following specific exceptions:
  #
  #     chipselect   -- The SPI module is only selected in the
  #                     high-half of this address range.
  #
  #     readdata     -- Needs to be multiplexed
  #
  #     writedata    -- The outer module's data is wider (32 bits).
  #
  #     address      -- The outer module's address is wider.
  #

  my @port_list = ();
  my %spi_port_names_by_type;

  foreach my $port_name (@inner_ports)
  {
    #my $port = $top_module->get_object_by_name($port_name);
    my $port = $inner_mod->get_object_by_name($port_name);

    ribbit() if not $port;
    ribbit() if not ref($port) eq "e_port";

    # Below, we might be interested in knowing the names of various
    # types.  Write them in a handy hash:
    #

    $spi_port_names_by_type{$port->type()} = $port_name;

    next if ($port->type() eq ''          ) ||
            ($port->type() eq 'address'   ) ||
            ($port->type() eq 'chipselect') ||
            ($port->type() eq 'writedata' ) ||
            ($port->type() eq 'readdata'  )  ;

    push @port_list, e_port->new({
        name => $port->name(),
        width => $port->width(),
        direction => $port->direction(),
        type => $port->type(),
      });
  }

  # Now give the outer-module the "special" ports from above:
  push (@port_list, e_port->news(
    {name      => "address",
     type      => "address",
#     width     => $SBI->{Address_Width},
     width     => $Address_Width,
     direction => "input",
    },
    {name      => "writedata",
     type      => "writedata",
     width     => 32,
     direction => "input",
    },
    {name      => "readdata",
     type      => "readdata",
     width     => 32,
     direction => "output",
    },
  ));

  $module->add_contents(@port_list);

  # Make an avalon slave port.
  my %type_map = ();
  map {$type_map{$_->name()} = $_->type()} @port_list;

  # My slave control port.
  $module->add_contents(
    e_avalon_slave->new({
      name => 'epcs_control_port',
      type_map => \%type_map,
    })
  );


  # If there is no WYSIWYG atom for the ASMI block, we just express
  # the master SPI ports at the top level: renamed for convenience, of course
   if ($project->{use_asmi_atom} eq "0") {
    $module->add_contents(
      e_port->new(["dclk", 1, "output"]),
      e_port->new(["sce", 1, "output"]),
      e_port->new(["sdo", 1, "output"]),
      e_port->new(["data0", 1, "input"]),

      e_assign->new(["dclk", "SCLK"]),
      e_assign->new(["sce", "SS_n"]),
      e_assign->new(["sdo", "MOSI"]),
      e_assign->new(["MISO", "data0"])
    );

  }
  else {

    # Create a wrapper module for the tornado_spiblock.  Why?  We need
    # to write this module into its own file, so that VHDL can cope with
    # the simulation model.
    my $tspi_name = 'tornado_' . $top_level_module_name . '_atom';
    my $tspi_module = e_module->new({
      name => $tspi_name,
      project => $project,
    });
    $tspi_module->do_black_box(1);

    # This module definition will go in its own separate simulation and
    # compilation files.  Make the file name the same as the module,
    # so Quartus can find it.
    my $device_family =   uc($project->{device_family});
    # Stratix V has regressed somewhat requiring the use of an atom to talk
    # to the EPCS/EPCQ pins; they are now dedicated pins.
    #
    # Worse yet, the atom documentation completely neglects polarity of the
    # all signals. Compounding this, the output enables are split in polarity
    # between 'oe' (for clk and sce), versus 'datanoe' for each data output....
    # All of this will land you with some quality time in front of an
    # oscilliscope. Ask me how I know.
    if( ($device_family eq "STRATIXV") ) {

     # Confusingly, the port-names on the atom have changed between families.
      # S-V atom notes in single-bit data (x1), aka SPI mode:
      # stratixv_asmiblock <name>
      # (
      # 	.dclk(<clock source from core>),
      # 	.sce(<SCE from core>),
      # 	.oe(<output enable from core>),--> This is ACTIVE LOW!
      # 	.data0out(<SPI_DATA0 from core>), --> This looks to be MOSI
      # 	.data1out(<SPI_DATA1 from core>),
      # 	.data2out(<SPI_DATA2 from core>),
      # 	.data3out(<SPI_DATA3 from core>),
      #
      # 	.data0oe (<OE of data0out from core>), --> This is ACTIVE HIGH!
      # 	.data1oe (<OE of data1out from core>), --> This is ACTIVE HIGH!
      # 	.data2oe (<OE of data2out from core>), --> This is ACTIVE HIGH!
      # 	.data3oe (<OE of data3out from core>), --> This is ACTIVE HIGH!
      #
      # 	.data0in(<SPI_DATA0 to core>),
      # 	.data1in(<SPI_DATA1 to core>), --> This looks to be MISO
      # 	.data2in(<SPI_DATA2 to core>),
      # 	.data3in(<SPI_DATA3 to core>),
      # );
      $tspi_module->add_contents(
        e_port->new(['dclkin', 1, 'input',]),
        e_port->new(['scein', 1, 'input',]),
        e_port->new(['sdoin', 1, 'input',]),
        e_port->new(['oe', 1, 'input',]),
        e_port->new(['data0out', 1, 'output',]),
        e_blind_instance->new({
          tag => 'synthesis',
          name => 'the_stratixv_asmiblock',
          module => 'stratixv_asmiblock',
          in_port_map => {
            dclk => 'dclkin',
            sce => 'scein',
            data0out => 'sdoin', # MOSI
            data1out => 0,
            data2out => 0,
            data3out => 0,
            data0oe => '~oe',
            data1oe => 0,
            data2oe => 0,
            data3oe => 0,
            oe => 'oe',
          },
          out_port_map => {
            data1in => 'data0out', # MISO
          },
        }),
        # Simple simulation contents, because (I think) e_module::to_vhdl() won't
        # output an empty simulation module.
        e_assign->new({
          tag => 'simulation',
          lhs => 'data0out',
          rhs => 'sdoin | scein | dclkin | oe',
        }),
      );
    }
    elsif( ($device_family eq "ARRIAV") ) {
      $tspi_module->add_contents(
        e_port->new(['dclkin', 1, 'input',]),
        e_port->new(['scein', 1, 'input',]),
        e_port->new(['sdoin', 1, 'input',]),
        e_port->new(['oe', 1, 'input',]),
        e_port->new(['data0out', 1, 'output',]),
        e_blind_instance->new({
          tag => 'synthesis',
          name => 'the_arriav_asmiblock',
          module => 'arriav_asmiblock',
          in_port_map => {
            dclk => 'dclkin',
            sce => 'scein',
            data0out => 'sdoin', # MOSI
            data1out => 0,
            data2out => 0,
            data3out => 0,
            data0oe => '~oe',
            data1oe => 0,
            data2oe => 0,
            data3oe => 0,
            oe => 'oe',
          },
          out_port_map => {
            data1in => 'data0out', # MISO
          },
        }),
        # Simple simulation contents, because (I think) e_module::to_vhdl() won't
        # output an empty simulation module.
        e_assign->new({
          tag => 'simulation',
          lhs => 'data0out',
          rhs => 'sdoin | scein | dclkin | oe',
        }),
      );
    }
    elsif( ($device_family eq "ARRIAVGZ") ) {
      $tspi_module->add_contents(
        e_port->new(['dclkin', 1, 'input',]),
        e_port->new(['scein', 1, 'input',]),
        e_port->new(['sdoin', 1, 'input',]),
        e_port->new(['oe', 1, 'input',]),
        e_port->new(['data0out', 1, 'output',]),
        e_blind_instance->new({
          tag => 'synthesis',
          name => 'the_arriavgz_asmiblock',
          module => 'arriavgz_asmiblock',
          in_port_map => {
            dclk => 'dclkin',
            sce => 'scein',
            data0out => 'sdoin', # MOSI
            data1out => 0,
            data2out => 0,
            data3out => 0,
            data0oe => '~oe',
            data1oe => 0,
            data2oe => 0,
            data3oe => 0,
            oe => 'oe',
          },
          out_port_map => {
            data1in => 'data0out', # MISO
          },
        }),
        # Simple simulation contents, because (I think) e_module::to_vhdl() won't
        # output an empty simulation module.
        e_assign->new({
          tag => 'simulation',
          lhs => 'data0out',
          rhs => 'sdoin | scein | dclkin | oe',
        }),
      );
    }
    elsif( ($device_family eq "CYCLONEV") ) {
      $tspi_module->add_contents(
        e_port->new(['dclkin', 1, 'input',]),
        e_port->new(['scein', 1, 'input',]),
        e_port->new(['sdoin', 1, 'input',]),
        e_port->new(['oe', 1, 'input',]),
        e_port->new(['data0out', 1, 'output',]),
        e_blind_instance->new({
          tag => 'synthesis',
          name => 'the_cyclonev_asmiblock',
          module => 'cyclonev_asmiblock',
          in_port_map => {
            dclk => 'dclkin',
            sce => 'scein',
            data0out => 'sdoin', # MOSI
            data1out => 0,
            data2out => 0,
            data3out => 0,
            data0oe => '~oe',
            data1oe => 0,
            data2oe => 0,
            data3oe => 0,
            oe => 'oe',
          },
          out_port_map => {
            data1in => 'data0out', # MISO
          },
        }),
        # Simple simulation contents, because (I think) e_module::to_vhdl() won't
        # output an empty simulation module.
        e_assign->new({
          tag => 'simulation',
          lhs => 'data0out',
          rhs => 'sdoin | scein | dclkin | oe',
        }),
      );
    }
    # Older device families (Cyclone I (!)) use the 'tornado_spiblock' atom:
   else {
    $tspi_module->add_contents(
      e_port->new(['dclkin', 1, 'input',]),
      e_port->new(['scein', 1, 'input',]),
      e_port->new(['sdoin', 1, 'input',]),
      e_port->new(['oe', 1, 'input',]),
      e_port->new(['data0out', 1, 'output',]),
      e_blind_instance->new({
        tag => 'synthesis',
        name => 'the_tornado_spiblock',
        module => 'tornado_spiblock',
        in_port_map => {
          dclkin => 'dclkin',
          scein => 'scein',
          sdoin => 'sdoin',
          oe => 'oe',
        },
        out_port_map => {
          data0out => 'data0out',
        },
      }),
        # Simple simulation contents, because (I think) e_module::to_vhdl() won't
        # output an empty simulation module.
      e_assign->new({
        tag => 'simulation',
        lhs => 'data0out',
        rhs => 'sdoin | scein | dclkin | oe',
      }),
    );
  }
    # Instantiate a Tornado SPI widget.
    $module->add_contents(
      e_instance->new({
        module => $tspi_name,
        port_map => {
          dclkin => 'SCLK',
          scein => 'SS_n',
          sdoin => 'MOSI',
          # For now, always drive oe low (active).  Someday someone
          # might want to control the oe drive level from software.
          # Note that oe must be drive low to enable driving on the device
          # output pins, contrary to what the documentation
          # (tornado_config_doc.doc) says.
          oe => "1'b0",
          data0out => 'MISO',
        },
      }),
    );
  }

  #Instantiate our boot-copier ROM.
 # if ((&Bits_To_Encode(get_code_size($project) - 1) - 2) > ($SBI->{Address_Width} - 1))
  if ((&Bits_To_Encode(get_code_size($project) - 1) - 2) > ($Address_Width - 1))
  {
     my $addr_bits = $SBI->{Address_Width};
     ribbit ("EPCS Boot copier program (@{[get_code_size($project)]}) too big for  address-range (($addr_bits)");
  }

#  my $rom_data_width = $SBI->{Data_Width};
  my $rom_data_width = $Data_Width;
  my $bytes_per_word = $rom_data_width / 8;
  my $rom_address_width = &Bits_To_Encode(get_code_size($project) / $bytes_per_word - 1);

  my $rom_parameter_map = {
    init_file                 => qq("@{[get_contents_file_name($project, 'hex')]}"),
    operation_mode            => qq("ROM"),
#    width_a                   => $SBI->{Data_Width},
    width_a                   => $Data_Width,
    widthad_a                 => $rom_address_width,
    numwords_a                => get_code_size($project) / $bytes_per_word,
    lpm_type                  => qq("altsyncram"),
    byte_size                 => 8,
    outdata_reg_a             => qq("UNREGISTERED"),
    read_during_write_mode_mixed_ports => qq("DONT_CARE"),
  };

  # nifty how ROMs only have two inputs and one output:
  my $rom_in_port_map  = { address_a => sprintf("address[%d : 0]", $rom_address_width - 1),
                           clock0    => 'clk',
                           clocken0  => 'clocken' };
  my $rom_out_port_map = { q_a       => 'rom_readdata' };

  $module->add_contents(
    e_blind_instance->new({
      tag           => 'synthesis',
      name          => 'the_boot_copier_rom',
      module        => 'altsyncram',
      in_port_map   => $rom_in_port_map,
      out_port_map  => $rom_out_port_map,
      parameter_map => $rom_parameter_map,
   })
  );

  # 1) The init_file setting for this simulated ROM is wrong: it needs to have
  #    the usual `ifdef NO_PLI song and dance.
  # 2) The contents files for this simulated ROM should be the standard elf2dat/elf2hex
  #    file that an onchip memory would have.  This will contain the appropriate
  #    jump-to-start code (assuming that the reset address is to this ROM. The simulation
  #    hex file must not conflict with the hardware-target hex file, so be sure to override
  #    e_project::do_makefile_target_ptf_assignments()'s notion of the contents filename,
  #    and set init_file appropriately.

  # 2011-01-21  shlaw: Change the init_file to be a parameter due to new Qsys simulation flow requirements.
  $module->add_contents(
    e_parameter->adds({
        name => "INIT_FILE",
        default => get_contents_file_name($project, 'hex'),
        vhdl_type => "STRING",
    })
  );

  $rom_parameter_map->{init_file} = 'INIT_FILE';

  $module->add_contents(
    e_blind_instance->new({
      tag           => 'simulation',
      name          => 'the_boot_copier_rom',
      module        => 'altsyncram',
      in_port_map   => $rom_in_port_map,
      out_port_map  => $rom_out_port_map,
      parameter_map => $rom_parameter_map,
      use_sim_models => 1,
   })
  );

  &copy_and_convert_contents_file($project);

  # Add in the reset_req for EPCS ROM
  $module->add_contents (
      e_assign->new ({
         lhs => "clocken",
         rhs => "~reset_req",
      }),
  );

  # Generate the chipselect-signal for the SPI module.
  # While we're here, assign the address & writedata going into the
  # module, too.
  my $address_msb = (&Bits_To_Encode(get_code_size($project) - 1) - 1) + 1;

  $address_msb -= 2;    # Word address --> byte address


  $module->add_contents (
      e_assign->new ({
         lhs => $spi_port_names_by_type {"chipselect"},
         rhs => "chipselect && (address \[ $address_msb \] )",
      }),
      e_assign->new ({
         lhs => $spi_port_names_by_type {"address"},
         rhs => "address",
      }),
      e_assign->new ({
         lhs => $spi_port_names_by_type {"writedata"},
         rhs => "writedata",
      }),
  );

  # Now we have to build a multiplexer for readdata
  #
  my $spi_chipselect = $spi_port_names_by_type {"chipselect"};
  my $spi_readdata   = $spi_port_names_by_type {"readdata"  };
  $module->add_contents (
      e_signal->new({name => 'rom_readdata', width => $rom_data_width,}),
      e_assign->new ({
         lhs => "readdata",
         rhs => "$spi_chipselect ? $spi_readdata : rom_readdata",
      })
  );

  $project->add_module($module);
  $project->top($module);

  # Ensure that register_offset tracks any change made
  # in the hardware.
  #
  # Note: Perform this update before
  # calling do_makefile_target_ptf_assignments below;
  # apparently it is dependant on the correctness of this
  # PTF setting.
  $project->{"MODULE $top_level_module_name"}->{register_offset} = sprintf("0x%X", get_code_size($project));

#  my @targets = ('flashfiles', 'dat', 'hex', 'programflash', 'sym');
#  $targets = ('flashfiles', 'dat', 'hex', 'programflash', 'sym');

#  $project->do_makefile_target_ptf_assignments(
#    'epcs_control_port',
#    \@targets,

   # Override the default contents file name.
#    {name => get_contents_file_name($project)},
# );



}


my $g_slave_name = 'epcs_control_port';
sub get_slave_name
{
  return $g_slave_name;
}


sub get_contents_file_name
{
  my $project = shift;
  my $extension = shift;
  my $suffix = shift;
  my $module = $project->top();
#  my $top_level_module_name = $top_module->name();

  my $top_level_module_name = $module->name();

  # If an extension was requested, make sure it starts
  # with '.'.
  if ($extension && $extension !~ /^\./)
  {
    $extension = '.' . $extension;
  }

  # add suffix if given
  if ($suffix)
  {
    $extension = "$suffix" . $extension;
  }
  return "$top_level_module_name\_boot_rom$extension";
}


sub copy_and_convert_contents_file
{
  my ($project, $Options, $module) = (@_);
  my $device_family = shift;
  my $top_level_module_name = $module;
  my $slave_name = &get_slave_name();
  my $SBI = $slave_name;

  # The actual data for the ROM in this component belongs to the mastering
  # CPU.
  # Find all CPU masters of this component
#  my @master_list = $project->get_my_cpu_masters_through_bridges(
#      $top_level_module_name,
#      $slave_name
#    );

  # Verify that all such masters are the same class - otherwise, it's an error.
#  my %master_classes =
#    map {
#      ($project->{"MODULE $_"}->{class}, 1)
#    } @master_list;

  # SPR:348622 alaways choose bootloader for epcs ROM
  # unless the expected bootloader not found
  require "format_conversion_utils.pm";


  # args contains all parameters common to all output file types.
  my $args =
  {
    comments     => "0",
    width        => "32",
    address_low  => 0,
    address_high => get_code_size($project) - 1,
  };

   my $boot_copier_srec;

   my $device_family = uc($project->{device_family});

    # Stratix II / Stratix III / Cyclone III has their own boot copier with their own file name
#  if( ($device_family eq "STRATIXII")   ||
#      ($device_family eq "STRATIXIIGX") ||
#      ($device_family eq "STRATIXIIGXLITE") ||
#      ($device_family eq "STRATIXIII") ||
#      ($device_family eq "STRATIXIV") ||
#      ($device_family eq "STRATIXV") ||
#      ($device_family eq "ARRIAII") ||
#      ($device_family eq "ARRIAIIGZ") ||
#      ($device_family eq "ARRIAV") ||
#      ($device_family eq "CYCLONEIII") ||
#      ($device_family eq "TARPON") ||
#      ($device_family eq "STINGRAY") ||
#      ($device_family eq "CYCLONEIVE") ||
#      ($device_family eq "ARRIAIIGX") ||
#      ($device_family eq "ARRIAGX") ||
#      ($device_family eq "CYCLONEIIILS") ||
#      ($device_family eq "CYCLONEIVGX") ||
#      ($device_family eq "HARDCOPYII") ||
#      ($device_family eq "HARDCOPYIII") ||
#      ($device_family eq "HARDCOPYIV") ||
#      ($device_family eq "CYCLONEV"))
#    {
#      $boot_copier_srec = "$ENV{QUARTUS_ROOTDIR}/../ip/altera/nios2_ip/altera_nios2/boot_loader_epcs_sii_siii_ciii.srec";
#    }
#    else
#    {
#      $boot_copier_srec = "$ENV{QUARTUS_ROOTDIR}/../ip/altera/nios2_ip/altera_nios2/boot_loader_epcs.srec";
#    }

  if(   ($device_family eq "CYCLONE")   ||
        ($device_family eq "CYCLONEII"))
    {
        $boot_copier_srec = "$ENV{QUARTUS_ROOTDIR}/../ip/altera/nios2_ip/altera_nios2/boot_loader_epcs.srec";
    }
    elsif(  ($device_family eq "STRATIXII")   ||
            ($device_family eq "STRATIXIIGX") ||
            ($device_family eq "STRATIXIIGXLITE") ||
            ($device_family eq "STRATIXIII") ||
            ($device_family eq "STRATIXIV") ||
            ($device_family eq "ARRIAII") ||
            ($device_family eq "ARRIAIIGZ") ||
			($device_family eq "ARRIAIIGX") ||
            ($device_family eq "CYCLONEIII") ||
            ($device_family eq "TARPON") ||
            ($device_family eq "STINGRAY") ||
            ($device_family eq "CYCLONEIVE") ||
            ($device_family eq "CYCLONEIVGX"))
    {
        $boot_copier_srec = "$ENV{QUARTUS_ROOTDIR}/../ip/altera/nios2_ip/altera_nios2/boot_loader_epcs_sii_siii_ciii.srec";
    }
   else
    {
        $boot_copier_srec = "$ENV{QUARTUS_ROOTDIR}/../ip/altera/nios2_ip/altera_nios2/boot_loader_universal.srec";
    }

    if (-e $boot_copier_srec) {
        $$args{infile} = $boot_copier_srec;
    } else {
        print STDERR ("Warning: $boot_copier_srec not found.\n");
    }

  # Convert to output files, copy to destinations.

  # The hash references within contents_file_spec list the
  # parameters that differ among the output file types.
  # Warning: the assumption is made below that "oformat"
  # is the same as the desired file extension.

 my @contents_file_spec = (
    {
      oformat => 'hex',
   #   outfile => "./",
      outfile => "$file_location",
    },
  );

  # Add the filename, with appropropriate extension, to hash element
  # 'outfile' (output_file).
  # prefix the output filename to differentiate the boot rom from simulated file
#  map {
#    $_->{outfile} .= get_contents_file_name($project, $_->{oformat}, "_synth")
#  } @contents_file_spec;

   map {
    $_->{outfile} .= get_contents_file_name($project, $_->{oformat})
  } @contents_file_spec;

  for my $file_spec (@contents_file_spec)
  {
    my %specific_args = %$args;
    for (keys %$file_spec)
    {
      $specific_args{$_} = $file_spec->{$_};
    }

    format_conversion_utils::fcu_convert(\%specific_args);
  }
}

sub get_code_size
{
  my $project = shift;
  my $device_family = uc($project->{device_family});

#  if( ($device_family eq "STRATIXII")   ||
#      ($device_family eq "STRATIXIIGX") ||
#      ($device_family eq "STRATIXIIGXLITE") ||
#      ($device_family eq "STRATIXIII") ||
#      ($device_family eq "STRATIXIV") ||
#      ($device_family eq "STRATIXV") ||
#      ($device_family eq "ARRIAII") ||
#      ($device_family eq "ARRIAIIGZ") ||
#      ($device_family eq "ARRIAV") ||
#      ($device_family eq "STRATIXIIGXLITE") ||
#      ($device_family eq "CYCLONEIII")||
#      ($device_family eq "TARPON") ||
#      ($device_family eq "CYCLONEIVE") ||
#      ($device_family eq "STINGRAY") ||
#      ($device_family eq "ARRIAIIGX") ||
#      ($device_family eq "ARRIAGX") ||
#      ($device_family eq "CYCLONEIIILS") ||
#      ($device_family eq "CYCLONEIVGX") ||
#      ($device_family eq "HARDCOPYII") ||
#      ($device_family eq "HARDCOPYIII") ||
#      ($device_family eq "HARDCOPYIV") ||
#      ($device_family eq "CYCLONEV"))

#  {


#    return 0x400;
#  }
#  else
#  {
#    return 0x200;

#  }
  if( ($device_family eq "CYCLONE")   ||
      ($device_family eq "CYCLONEII"))
    {
	return 0x200;
    }
    else
    {
	return 0x400;
    }


}



return 1;


