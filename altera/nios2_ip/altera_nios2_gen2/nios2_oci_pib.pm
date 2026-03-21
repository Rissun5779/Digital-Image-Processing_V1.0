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











sub make_nios2_oci_pib
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_pib",
  });



  $module->add_contents (

    e_signal->news (
      ["tr_data",         $Opt->{oci_tr_width}, 1],
    ),

    e_signal->news (
      ["tw",              $Opt->{oci_tm_width}, 0],
    ),

  );













  $module->add_contents (
    e_assign->news (
      ["tr_data" => $Opt->{oci_offchip_trace} ? "tw" : "0"],
    ),

  );

  return $module;
}



1;

