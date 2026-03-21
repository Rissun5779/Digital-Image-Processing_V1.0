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


use strict;
use europa_all;
package refdes_check;

sub check
{
  my $project = shift;
  my $error;
  # Check for errors:
  # 1) Duplicate reference designators (except '--none--')
  # 2) Illegal reference designators (unless no board)

  # Make a hash of module_name => refdes for this class.
  my $sys_ptf = $project->system_ptf();
  
  die("No project!") if !$sys_ptf;

  my $class = $sys_ptf->{"MODULE @{[$project->_target_module_name()]}"}->{class};
  die("No class!") if !$class;
  
  my $module_classes = $project->get_module_hash("class");
  
  # Loop over all modules.  For each module of this component's class, save its module name 
  # and refdes in a hash.
  my %rd;
  for my $module_name (keys %$module_classes)
  {
    my $module_ptf = $sys_ptf->{"MODULE $module_name"};
    
    next if $module_ptf->{class} ne $class;
    
    # Ok, I have the module name of a module of this component's class.
    # Go find its reference designator, which unfortunately is stored 
    # in a SLAVE <s> section. I don't know what it would mean to have 
    # multiple slaves, each with a reference designator.  hash keys
    # will be module/slave_name, to handle that possibility.
    for my $module_key (keys %$module_ptf)
    {
      next if $module_key !~ /SLAVE\s*(\S+)$/;
      my $rdkey = "$module_name/$1";
      my $refdes = $module_ptf->{$module_key}->{WIZARD_SCRIPT_ARGUMENTS}->{flash_reference_designator};
      $rd{$rdkey} = $refdes;
    }
  }
  
  my %brd;
  # Make a list of refdes in the selected board
  my $board_class = $sys_ptf->{WIZARD_SCRIPT_ARGUMENTS}->{board_class};
  if ($board_class ne '')
  {
    my $board_section = $sys_ptf->{WIZARD_SCRIPT_ARGUMENTS}->{BOARD_INFO};
    if (!defined($board_section->{$class}))
    {
      # Well, this board class has no reference designators for this class.
      # This is unexpected - it may mean that the board component is out of 
      # date, or some other internal error.
      $error .= "Board component '$board_class' has no reference designators for components of class '$class'\n";
    }
    else
    {
      my $rdstring = $board_section->{$class}->{reference_designators};
      %brd = get_board_refdes_list($rdstring);

      # find illegal reference designators, if a board is defined.
      $error .= test_illegal_rd(\%rd, \%brd);
    }
  }

  # Notice duplicate reference designators.
  $error .= test_duplicates(\%rd, \%brd);

  # Return accumulated error message, or empty string for success.
  return $error;
}

sub test_illegal_rd
{
  my ($rdhash, $brd) = @_;
  
  # Examine each rd in %$rdhash; for all that are not found
  # in %$brd, complain.

  my $no_board_defined = keys %$brd == 0;

  my @no_refdes;
  my @illegal_refdes;
  for my $mod (keys %$rdhash)
  {
    my $rd = $rdhash->{$mod};
    my $module_name_without_slave = $mod;
    $module_name_without_slave =~ s|/.*$||;
    
    if (!defined($rd) || $rd eq '' || $rd eq '--none--')
    {
      push @no_refdes, $module_name_without_slave;
      next;
    }
    
    if (!$no_board_defined && !defined($brd->{$rd}))
    {
      push @illegal_refdes, "$module_name_without_slave ('$rd')";
      next;
    }
  }
  
  my $error_string;
  if (@illegal_refdes)
  {
    my $plural = @illegal_refdes > 1 ? "s" : "";
    $error_string .= "Illegal reference designator$plural in module$plural ";
    $error_string .= join(", ", @illegal_refdes);
    $error_string .= ".\n";
  }
  
  if (@no_refdes)
  {
    my $plural = @no_refdes > 1 ? "s" : "";
    $error_string .= "No reference designator$plural specified for module$plural ";
    $error_string .= join(", ", @no_refdes);
    $error_string .= ".\n";
  }
  
  return $error_string;
}

# Warning: this code duplicated from cfi_flash.pl.  cfi_flash.pl
# should use this package.
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

sub test_duplicates
{
  my ($rdhash, $brd) = @_;
  
  # %$rd is a hash of module => reference designator.
  # Make a reverse hash.  Duplicate reference designators
  # may exist, so the reverse hash is
  # reference designator => [module1, module2, ...].

  my %reverse_hash;
  for my $mod (keys %$rdhash)
  {
    my $rd = $rdhash->{$mod};
    my $module_name_without_slave = $mod;
    $module_name_without_slave =~ s|/.*$||;
    
    # Unassigned reference designators are allowed only if
    # there are no reference designators for this component class
    # in the board, or if no board is assigned.
    next if ($rd eq '' || $rd eq '--none--');
    if (!defined $reverse_hash{$rd})
    {
      $reverse_hash{$rd} = [$module_name_without_slave];
    }
    else
    {
      push @{$reverse_hash{$rd}}, $module_name_without_slave;
    }
  }
  
  my @errors;
  for my $rd (keys %reverse_hash)
  {
    my @mods = @{$reverse_hash{$rd}};
    if (@mods > 1)
    {
      push @errors, "Reference designator '$rd' shared by modules " . join(", ", @mods) . ".\n";
    }
  }
  
  return join('', @errors);
}

1;
