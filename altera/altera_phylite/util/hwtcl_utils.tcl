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


# package: altera_phylite::util:hwtcl_utils
#
# Provides utility functions for interacting with _hw.tcl API
#
# Wrapper around the emif hwtcl_utils package, with added PHYLite group
# functionaliy
#
package provide altera_phylite::util::hwtcl_utils 0.1

################################################################################
###                          TCL INCLUDES                                   ###
################################################################################
package require altera_emif::util::hwtcl_utils

################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################
namespace eval ::altera_phylite::util::hwtcl_utils:: {
   # Package Exports
   #namespace export ::altera_emif::util::hwtcl_utils::*
   namespace export add_group_gui_param_useable
   namespace export add_group_gui_param_unuseable
   namespace export get_group_param_list
   namespace export add_group_derived_param
   namespace export add_param_to_gui_with_shadow

   # Namespace variables

   # Import functions into namespace
   namespace import ::altera_emif::util::hwtcl_utils::add_user_param
   namespace import ::altera_emif::util::hwtcl_utils::add_derived_param

   # Package variables
   #
   # WARNING: When a Qsys system contains multiple instances of the IP, they
   #          all share the same _copy_ of package variables in memory. Therefore,
   #          if the variable is meant to store data that are specific to an IP
   #          instance, the data must be indexed using a key that is unique to that IP.

   # Arrays of lists. The arrays (map) are indexed by an integer (group index),
   # and gives a list of all the group's parameter names of a certain type.
   variable group_derived_params
   variable group_gui_params
   variable group_shadow_params
}

################################################################################
###                       PUBLIC FUNCTIONS                                   ###
################################################################################

# proc: add_group_gui_param_useable
#
# A wrapper around add_derived_param and add_user_param, which creates 3 parameters when called. A non-derived, visible user parameter
# that can be changed by the user, an invisible derived parameter that is used to store the values of the GUI parameter, and a sometimes
# visible derived "shadow" parameter that can be used to mimic other GUI parameters. Shadow parameters are used in the group copy
# feature in PHYLite, which can show the user that the group parameters are the same while copying the underlying derived parameters
#
#
# parameters:
#
#  name                : The name of the parameter.
#  type                : The parameter's data type. This is important in how the parameter will look in the GUI.
#  default_val         : The default value of the parameter
#  allowed_ranges      : The range of values the parameter can have. This is important in how the parameter will look in the GUI.
#  grp_idx             : The group ID of the parameter. This is useful for updating the array of group parameter names.
#  {units ""}          : Units of parameter (optional).
#  {display_units ""}  : The units shown after the parameter field in the GUI (optional).
#  {display_hint ""}   : A value to help control the parameter's behaviour in the GUI (optional).
#  {resource_name ""}  : A string that is tied to a name and description, to fill in these fields in the GUI (optional).
#
#  returns:
#

proc ::altera_phylite::util::hwtcl_utils::add_group_gui_param_useable {\
   name \
   type \
   default_val \
   allowed_ranges \
   grp_idx \
   {units ""} \
   {display_units ""} \
   {display_hint ""} \
   {resource_name ""}
} {
   variable group_gui_params
   set gui_name "GUI_${name}"
   set gui_resource_name ""
   if {!([string compare -nocase $resource_name ""] == 0)} {
      set gui_resource_name "GUI_${resource_name}"
   }
   _add_group_gui_param $name $type $default_val $allowed_ranges $grp_idx $units $display_units $display_hint $resource_name
   add_user_param $gui_name $type $default_val $allowed_ranges $units $display_units $display_hint $gui_resource_name
   lappend group_gui_params($grp_idx) $gui_name
}

# proc: add_group_gui_param_unuseable
#
# The same as add_group_gui_param_useable, except that the GUI parameter is only there to inform the user. This parameter
# is not changeable by the user, and it is set to derived. Since the GUI parameter is derived, it is added to the
# list of derived parameters as well as GUI parameters.
#
# parameters:
#
#  Same as add_group_gui_param_unuseable.
#
# returns:
#

proc ::altera_phylite::util::hwtcl_utils::add_group_gui_param_unuseable {\
   name \
   type \
   default_val \
   allowed_ranges \
   grp_idx \
   {units ""} \
   {display_units ""} \
   {display_hint ""} \
   {resource_name ""}
} {
   variable group_derived_params
   variable group_gui_params
   set visible true
   set gui_name "GUI_${name}"
   set gui_resource_name ""
   if {!([string compare -nocase $resource_name ""] == 0)} {
      set gui_resource_name "GUI_${resource_name}"
   }
   _add_group_gui_param $name $type $default_val $allowed_ranges $grp_idx $units $display_units $display_hint $resource_name
   add_derived_param $gui_name $type $default_val $visible $units $display_units $display_hint $gui_resource_name
   set_parameter_property $gui_name ALLOWED_RANGES $allowed_ranges
   lappend group_derived_params($grp_idx) $gui_name
   lappend group_gui_params($grp_idx) $gui_name
}

# proc: add_group_derived_param
#
# A wrapper around add_derived_param which does the same thing but adds the parameter to the list of group derived parameters at
# the same time.
#
# parameters:
#
#  Same as add_derived_param, but includes the group index in order to add it to the list of group names.
#
# returns:
#

proc ::altera_phylite::util::hwtcl_utils::add_group_derived_param {\
   name \
   type \
   default_val \
   visible \
   grp_idx \
   {units ""} \
   {display_units ""} \
   {display_hint ""} \
   {resource_name ""}
} {
   variable group_derived_params
   add_derived_param $name $type $default_val $visible $units $display_units $display_hint $resource_name
   lappend group_derived_params($grp_idx) $name
}

# proc: get_group_param_list
#
# Returns the list of parameter names, of a certain group and a certain type.
#
# parameters:
#
#  grp_idx     : The index of the group to get the parameter names from.
#  param_type  : The type of parameter names to get.
#                       GUI      : All GUI parameters.
#                       SHADOW   : All shadow parameters.
#                       DERIVED  : All hidden derived parameters in that group including derived, unuseable GUI parameters (but not shadow).
#
# returns:
#
#  Returns a list of parameter names as strings.
#

proc ::altera_phylite::util::hwtcl_utils::get_group_param_list {\
   grp_idx \
   param_type
} {
   variable group_derived_params
   variable group_gui_params
   variable group_shadow_params
   set retval [list]
   switch -nocase -- $param_type {
      derived {
         set retval $group_derived_params($grp_idx)
      }
      gui {
         set retval $group_gui_params($grp_idx)
      }
      shadow {
         set retval $group_shadow_params($grp_idx)
      }
   }

   return $retval
}

# proc: add_param_to_gui_with_shadow
#
# A wrapper around add_param_to_gui which adds the shadow parameter in addition to the GUI parameter that is being put on the GUI.
# This should be used if shadow parameters will be needed (it will be necessary to maintain the functionality of the copy feature).
#
# parameters:
#
#  parent        : The parent container of the text field.
#  param_name    : The name of the parameter to add.
#
# returns:
#

proc ::altera_phylite::util::hwtcl_utils::add_param_to_gui_with_shadow {\
   parent \
   param_name \
} {
   set shadow_param_name "${param_name}_SHADOW"
   add_display_item $parent $param_name PARAMETER
   add_display_item $parent $shadow_param_name PARAMETER
}

################################################################################
###                       PRIVATE FUNCTIONS                                  ###
################################################################################

# proc: _add_group_gui_param
#
# Private function to instantiate the common elements of a GUI parameter, which are the derived
# and shadow parameters. This is used as a helper function for add_group_gui_param_useable and
# add_group_gui_param_unuseable.
#
# parameters:
#
#  Same as add_group_gui_param_useable and add_group_gui_param_unuseable.
#
# returns:
#
proc ::altera_phylite::util::hwtcl_utils::_add_group_gui_param {\
   name \
   type \
   default_val \
   allowed_ranges \
   grp_idx \
   {units ""} \
   {display_units ""} \
   {display_hint ""} \
   {resource_name ""}
} {
   variable group_derived_params
   variable group_shadow_params
   set visible false
   set shadow_name "GUI_${name}_SHADOW"
   set shadow_resource_name ""
   if {!([string compare -nocase $resource_name ""] == 0)} {
      # make it the same as the GUI resource name in order to prevent duplicating definitions of these descriptions
      set shadow_resource_name "GUI_${resource_name}"
   }
   add_derived_param $name $type $default_val $visible $units $display_units $display_hint $resource_name
   add_derived_param $shadow_name $type $default_val $visible $units $display_units $display_hint $shadow_resource_name
   set_parameter_property $shadow_name ALLOWED_RANGES $allowed_ranges
   lappend group_derived_params($grp_idx) $name
   lappend group_shadow_params($grp_idx) $shadow_name
}

# proc: _init
#
# Private function to initialize the package
# file
#
# parameters:
#
# returns:
#
proc ::altera_phylite::util::hwtcl_utils::_init {} {
   return 1
}

################################################################################
###                   AUTO RUN CODE AT STARTUP                               ###
################################################################################
# Run the initialization
::altera_phylite::util::hwtcl_utils::_init
