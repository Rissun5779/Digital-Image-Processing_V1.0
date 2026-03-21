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


#!perl
use strict;

my $cfi_slave_name = 's1';
# Transform a string like
# cfi_flash_0/s1,cfi_flash_1/s1
# into a list like
# qw(cfi_flash_0 cfi_flash_1)
#
sub get_instances
{
  my ($instance_string, $slave_name) = @_;
  
  my @instances = split(/,/, $instance_string);
  
  map {s|/$slave_name$||} @instances;

  printlog("instance string: '$instance_string'; get_instances: qw(" . join(' ', @instances) . ")\n");
  return @instances;
}

sub get_info
{
  my ($code, $ptf, $module_name, $cfi_instances, $slave_name, $new_refdes, $add, $edit, $board_class, $board_refdes_list) = @_;
  my $board_info;
  my $extra_info;

  # $add and $edit come in as floating point numbers, but I'd rather think of
  # them as flags.
  $add = $add == 1.0;
  $edit = $edit == 1.0;
  
  # Return one of the following codes:
  #  no_board
  #  error
  #  warning
  #  1_ref_des
  #  some_ref_des
  
  # If it's edit time, just double-check that the assignments are sane.
  # Issue an error on any problem.

  my @cfi_instances = get_instances($cfi_instances, $slave_name);
  # Collect some info about the selected board, and the available reference designators.
  my %rd = get_used_ref_deses($ptf, @cfi_instances);
  my %brd = get_board_refdes_list($board_refdes_list);

  # Add or edit, the "no board" case is the same.
  if (!defined $board_class || $board_class eq '')
  {
    $board_info = 'no_board';
    $extra_info = $new_refdes;
  }
  else
  {
    # add or edit
    if ($edit)
    {
      my $this_module_rd = $new_refdes; # $rd{$module_name};
      if (!defined($brd{$this_module_rd}))
      {
        $board_info = 'error';
        $extra_info = "Reference designator <B>$this_module_rd</B> is not defined in board <B>$board_class</B>.";
      }
      else
      {
        $extra_info = $new_refdes;

        if ((keys %brd == 1) && (keys %rd == 1))
        {
          $board_info = '1_ref_des';
        }
        else
        {
          $board_info = 'some_ref_des';
        }
      }
    }
    else
    {
      # add
      
      # If there are no free reference designators, issue an error.
      my %available_rds = %brd;
      for (values %rd)
      {
        delete $available_rds{$_};
      }
      
      my @available_rds = keys %available_rds;
      
      if (0 == @available_rds)
      {
        $board_info = "error";
        $extra_info = "The target board has no remaining reference designators for this flash component.  ";
      }
      elsif ((keys %brd == 1) && (keys %rd == 0))
      {
        $board_info = '1_ref_des';
        $extra_info = $new_refdes;
        if ($new_refdes eq '--none--')
        {
          $extra_info = (each %brd)[0];
        }
      }
      else
      {
        $board_info = 'some_ref_des';

        for (values %rd)
        {
          delete $brd{$_};
        }

        $extra_info = $new_refdes;
        if ($new_refdes eq '--none--')
        {
          $extra_info = (sort keys %brd)[0];
        }
      }
    }
  }
  
  if ($board_info =~ /_ref_des$/ || $board_info eq 'no_board')
  {
    # A reference designator is being returned.
    # Check for duplicate rd's here.  Issue an error if any are found.
    my @dup_mods;
    for my $mod (keys %rd)
    {
      next if $mod eq $module_name;
      
      my $this_module_rd = $rd{$mod};
      next if $this_module_rd eq '--none--';
      
      push (@dup_mods, $mod) if $this_module_rd eq $extra_info;
    }

    if (@dup_mods)
    {
      my $list = join(', ', @dup_mods);
      $board_info = 'warning';
      $extra_info = "Reference designator <B>$extra_info</B> also used by <B>$list</B>";
    }
  }
  
  printlog("board: '$board_info'; extra: '$extra_info'\n");

  if ($code eq 'board')
  {
    print $board_info;
  }
  elsif ($code eq 'extra')
  {
    print $extra_info;
  }
  else
  {
    print "internal error\n";
  }
}

sub get_used_ref_deses
{
  my $ptf = shift;
  
  # I have a list of cfi instances which currently exist. 
  # That's useful because the ptf file may not be up to date.
  my @instances = @_;

  # Scan through the ptf file for existing cfi flash components.
  # Make a list of all cfi flash components' reference designators.
  # Rather than using ptf_parse.pm, I'll use an ad-hoc method, for now.
  my %rd;
  my $module;
  open(PTFFILE, $ptf) || die "Error '$ptf'";
  my $valid_module = 0;
  while (<PTFFILE>)
  {
    if (/^\s+MODULE\s+(\S+)/)
    {
      $module = $1;
      $valid_module = grep {/$module/} @instances;
      next;
    }
    
    # Backward compatibility:
    if (/^\s*cfi_flash_refdes\s*=\s*"(.*)"/)
    {
      next if !$valid_module;
      $rd{$module} = $1;
      $rd{$module} = '--none--' if $rd{$module} eq '';
    }

    if (/^\s*flash_reference_designator\s*=\s*"(.*)"/)
    {
      next if !$valid_module;
      $rd{$module} = $1;
      $rd{$module} = '--none--' if $rd{$module} eq '';
    }
  }
  close PTFFILE;

  return %rd;
}

sub get_board_refdes_list
{
  my $board_refdes_list = shift;
  
  return () if !$board_refdes_list;
  
  # Get the list of this boards ref designators.
  my $sep = ',';
  if ($board_refdes_list !~ /[a-zA-Z0-9]/)
  {
    $sep = substr($board_refdes_list, 0, 1);
  }
  my %board_rd;
  %board_rd = map {($_, 1)} split(/$sep/, $board_refdes_list);

  return wantarray ? %board_rd : (0 + keys %board_rd);
}

sub generator_program
{
  require 'europa_all.pm';
  require 'wiz_utils.pm';
  require 'format_conversion_utils.pm';
  require 'refdes_check.pm';

  my $project = e_project->new(@_);
  
  # Check the reference designators.
  my $error = refdes_check::check($project);
  if ($error)
  {
    print STDERR "\nERROR:\n$error\n";
    ribbit();
  }

  # 2005.03.14 -- SPR 172900 -- Create individual byte-lanes for simulation
  # .dat files if the data bus is wider than a single byte. 
  my $data_width = $project->SBI($cfi_slave_name)->{Data_Width};
  
  my $target_ptf_assignments = 
  {
    make_individual_byte_lanes  => ($data_width > 8) ? 1 : 0,
    num_lanes                   => ($data_width / 8),
  };

  $project->do_makefile_target_ptf_assignments(
    $cfi_slave_name,
    ['flashfiles', 'dat', 'programflash', 'sym',],
    $target_ptf_assignments,
  );
  
  # Write the changes back to the ptf file.
  $project->ptf_to_file();

  # Do I need to call output?  Actually, it's harmful to do so: it creates
  # a blank HDL file, which is `included at the top level.
  # $project->output();
}

sub printlog
{
  my $string_to_figure_out_build = '
  #The builder strips out comments like this /^\s+\#/m
  ';
  return if ($string_to_figure_out_build =~ /^\s+$/s);

  my $printable = join('', @_);
  my $log = 'cfi_flash.log';
  open (LOGFILE, ">>$log") || die "error: Can't open log file '$log' for append.";

  print LOGFILE $printable;
  close LOGFILE;
}

# The makefile for this component calls this script with no arguments,
# which tells this script, "do nothing".  The value of doing nothing
# is that I learn about syntax errors without having to wait for SOPC
# Builder to get around to calling this script.
exit if (0 == @ARGV);

my ($sec, $min, $hour, $mday, $mon, $year) = localtime;

printlog sprintf("%02d:%02d:%02d %d/%d/%04d\n", $hour, $min, $sec, $mon + 1, $mday, $year + 1900);
printlog(join("; ", @ARGV), "\n");

my $cmd = shift;
{
  $cmd eq 'get_board_info' && do {get_info('board', @ARGV); last};
  $cmd eq 'get_extra_info' && do {get_info('extra', @ARGV); last};

  # Default case: none of the above special commands was passed,
  # so act like a generator program (pass $cmd, whatever it may
  # have been, along with the remaining components in @ARGV).
  do {generator_program($cmd, @ARGV); last};
}

printlog("\n");

