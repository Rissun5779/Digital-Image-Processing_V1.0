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


# +----------------------------------------------------------
# | 
# | Name: 		 altera_hwtcl_ipri.tcl
# |
# | Description: This packages contains common utilities for the
# |              ipri project.  The intent is to provide a common
# |              framework across all IP's for figuring out if
# |              the user is running an early access IPRI flow, to
# |              provide some utilities, and to ease the migration
# |              from early access to production
# |	
# | Operation:   The file reads altera_hwtcl_ipri_ip_opt_in.txt to
# |              figure out which IPs have opted into for IPRI/SDC
# |              support.
# |
# |              If anything goes wrong, we turn IPRI/SDC off to
# |              make sure that the EA feature doesn't impact
# |              general users.
# |
# | Lifespan:    This file is only here to support early access 
# |              opt in of the IPRI/ SDC feature.  Once this is
# |              Production in 17.0 (hopefully) this file should be
# |              depricated and removed.
# |
# | Version:	1.0
# |
# | Author:  	Andrew Brownbill
# |
# +----------------------------------------------------------

package provide altera_hwtcl_ipri 1.0

namespace eval ::altera_hwtcl_ipri:: {
   namespace export ipri_sdc_enabled
   namespace export ipri_extension_filter
}

variable commonScriptDir [file dirname [info script]]
variable exceptionMessageIssued false

# -----------------------------------------------------------------------------
# |  
# |  ipri_sdc_enabled
# |
# |  Return TRUE if the new IPRI SDC_ENTITY and TCL_ENTITY file
# |  types should be used for a particular ip
# | 
# -----------------------------------------------------------------------------
proc ::altera_hwtcl_ipri::ipri_sdc_enabled {ip} {

   # default to "not enabled"
   set ipri_sdc_enabled false

   # We will set this to true if one of the conditions
   # that activate IPRI/SDC are try (i.e., ini,
   # environment variable, etc).
   set ipri_sdc_enable_if_ea false

   # wrap the business logic in a big try catch loop.
   # if anything goes wrong we disable ipri/sdc

   if { [ catch {

      # if the Opt In level is EA then turn on IPRI if
      # we can spot SPECTRAQ_IPRI_EARLY_ACCESS in the 
      # quartus.in file

      if {[get_quartus_ini "SPECTRAQ_IPRI_EARLY_ACCESS"]} {
         set ipri_sdc_enable_if_ea true
      }

      # similarly, turn on IPRI if we see an environment
      # variable, which is set, called
      # SPECTRAQ_IPRI_EARLY_ACCESS.  This is primarily for
      # internal testing

      global env;

      set ea_environment_variable ""
      if { [info exists env(SPECTRAQ_IPRI_EARLY_ACCESS)]} { 
         set ea_environment_variable $env(SPECTRAQ_IPRI_EARLY_ACCESS)
      }
      if {[string match *on* $ea_environment_variable]} {
         set ipri_sdc_enable_if_ea true
      }

      set quartus_ini_override ""
      if { [info exists env(QUARTUS_INI_VARS)]} { 
         set quartus_ini_override $env(QUARTUS_INI_VARS)
      }
      if {[string match *SPECTRAQ_IPRI_EARLY_ACCESS* $quartus_ini_override]} {
         set ipri_sdc_enable_if_ea true
      }

      global commonScriptDir;
      set filename [file join $commonScriptDir "altera_hwtcl_ipri_ip_opt_in.txt" ]

      # read the optin file

      set optin [open $filename r]
      set raw_file [read $optin ]
      close $optin

      # split into lines

      set all_lines [split $raw_file "\n"]

      # and parse the lines

      foreach line $all_lines {
         if {[regexp {^([[:alpha:]]+)\s+([[:alpha:]]+)$} $line matched line_ip line_optin]} {
            if {[string equal $line_ip $ip]} {
               if {[string equal $line_optin "EA"]} {
                  set ipri_sdc_enabled $ipri_sdc_enable_if_ea 
               }
            }
         }
      }
   } err ] } { 

      # print 1 and only 1 message

      global exceptionMessageIssued
      if { $exceptionMessageIssued == false } {
         puts "Exception caught in ipri_sdc_enabled - disabling the IPRI/SDC feature"
         puts $err
         set exceptionMessageIssued true
      }
      set ipri_sdc_enabled false;
   }

   return $ipri_sdc_enabled;
}

proc ::altera_hwtcl_ipri::ipri_sdc_promotion {ip} {
   # default to not do it in Altera IP
   set ipri_sdc_promotion false

   # wrap the business logic in a big try catch loop.
   # if anything goes wrong we disable ipri/sdc

   if { [ catch {

      # Turn on sdc promotion if we can spot IPRI_SDC_PROMOTION 
      # in the quartus.ini file

      if {[get_quartus_ini "IPRI_SDC_PROMOTION"]} {
         set ipri_sdc_promotion true
      }

      # similarly, turn on SDC promotion if we see an 
      # environment variable, which is set, called
      # IPRI_SDC_PROMOTION.  This is primarily for
      # internal testing

      global env;

      set ea_environment_variable ""
      if { [info exists env(IPRI_SDC_PROMOTION)]} { 
         set ea_environment_variable $env(IPRI_SDC_PROMOTION)
      }
      if {[string match *on* $ea_environment_variable]} {
         set ipri_sdc_promotion true
      }

      set quartus_ini_override ""
      if { [info exists env(QUARTUS_INI_VARS)]} { 
         set quartus_ini_override $env(QUARTUS_INI_VARS)
      }
      if {[string match *IPRI_SDC_PROMOTION* $quartus_ini_override]} {
         set ipri_sdc_promotion true
      }

      global commonScriptDir;
      set filename [file join $commonScriptDir "altera_hwtcl_ipri_ip_opt_in.txt" ]

      # read the option file

      set optin [open $filename r]
      set raw_file [read $optin ]
      close $optin

      # split into lines

      set all_lines [split $raw_file "\n"]

      # and parse the lines

      foreach line $all_lines {
         if {[regexp {^([[:alpha:]]+)\s+([[:alpha:]]+)$} $line matched line_ip line_optin]} {
            if {[string equal $line_ip $ip]} {
               if {[string equal $line_optin "SDCPROMO"]} {
                  set ipri_sdc_promotion true
               }
            }
         }
      }
   } err ] } { 

      # print 1 and only 1 message

      global exceptionMessageIssued
      if { $exceptionMessageIssued == false } {
         puts "Exception caught in ipri_sdc_promotion - disabling the IPRI/SDC feature"
         puts $err
         set exceptionMessageIssued true
      }
      set ipri_sdc_promotion false;
   }

   return $ipri_sdc_promotion;
}

# -----------------------------------------------------------------------------
# |  
# |  ipri_extension_filter
# |
# |  Given an extension and an IP type, returns an entity extension
# |  if IPRI is on and the file type as appripriate.
# | 
# -----------------------------------------------------------------------------
proc ::altera_hwtcl_ipri::ipri_extension_filter {ext ip} {
   if {[ipri_sdc_enabled $ip]} {
      if {[ipri_sdc_promotion $ip]} {
         if {[string equal $ext "SDC"]} {return "SDC_ENTITY";}
      } else {
         #
         # "SDC_ENTITY_NOPROMO" is actually an illegal file type
         # The calling IP has to catch the filetype, convert
         # it to an SDC_ENTITY, and the add the appropriate
         # options to turn off promotion
         #

         if {[string equal $ext "SDC"]} {return "SDC_ENTITY_NOPROMO";}
      }
      if {[string equal $ext "TCL"]} {return "TCL_ENTITY";}
   }
   return $ext;
}

