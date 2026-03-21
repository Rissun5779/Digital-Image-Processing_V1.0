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


# +--------------------------------------------------------------------------------------------------------------------
# |
# | Name:        alt_vip_av_st_video_format.tcl
# |
# | Description: This package provides construction and validation procedures which should be used when constructing
# |              interfaces conforming to the Avalon-ST Video specification.
# |
# | Notes:       Interface assignments are used to transfer information between each of the proceedures in this
# |              package. They are also used to save information to the sopcinfo file for use by downstream tools.
# |
# +--------------------------------------------------------------------------------------------------------------------
package provide alt_vip_av_st_video_format 1.0

set package_version ""
catch {set package_version [package present sopc]}


# +--------------------------------------------------------------------------------------------------------------------
# | Define a namespace for this package, including a list of procedures to export.
# |
# | Define any constant values used in the package.
# +--------------------------------------------------------------------------------------------------------------------
namespace eval ::alt_vip_av_st_video_format {
    namespace export set_packet_property get_packet_property validate

    # Packet property values and defaults
    variable valid_packet_properties {NUMBER_OF_COLOR_PLANES COLOR_PLANES_ARE_IN_PARALLEL PIXELS_IN_PARALLEL}
    variable packet_property_defaults
    array set packet_property_defaults {
        NUMBER_OF_COLOR_PLANES         1
        COLOR_PLANES_ARE_IN_PARALLEL   0
        PIXELS_IN_PARALLEL             1
    }
}



# +--------------------------------------------------------------------------------------------------------------------
# | set_packet_property - this procedure allows you to configure the top level properties of an Avalon-ST Video
# | interface.
# |
# | interfaceName   The name of the interface to configure
# | propertyName    The name of the property to set
# | value           The value of the property
# +--------------------------------------------------------------------------------------------------------------------
proc ::alt_vip_av_st_video_format::set_packet_property {interfaceName propertyName value} {
    variable valid_packet_properties

    # Check that the property name is valid
    if {[lsearch -exact $valid_packet_properties $propertyName] == -1} {
        error "set_packet_property: The property $propertyName is not allowed. Permitted values are $valid_packet_properties"
    }

    # Store the property
    set_interface_assignment $interfaceName "alt_vip_av_st_video_format.$propertyName" $value
}



# +--------------------------------------------------------------------------------------------------------------------
# | get_packet_property - this procedure allows you to retrieve the top level properties of an Avalon-ST Video
# | interface.
# |
# | interfaceName     The name of the interface to interogate
# | propertyName      The name of the property to retrieve
# |
# | Returns the value of the property
# +--------------------------------------------------------------------------------------------------------------------
proc ::alt_vip_av_st_video_format::get_packet_property {interfaceName propertyName} {
    variable valid_packet_properties
    variable packet_property_defaults

    # Check that the property name is valid
    if {[lsearch -exact $valid_packet_properties $propertyName] == -1} {
        error "get_packet_property: The property $propertyName is not allowed. Permitted values are $valid_packet_properties"
    }

    # Default value of dataBitsPerSymbol provided by SOPC Builder. Used to verify that the user has not tried to set this themselves.
    variable defaultBitsPerSymbol 8
    # Default value of empty provided by SOPC Builder. Used to verify that the user has not tried to set this themselves.
    variable defaultEmptyBits 0
    
    set value [get_interface_assignment $interfaceName "alt_vip_av_st_video_format.$propertyName"]
    if {$value == ""} {
        return packet_property_defaults($propertyName)
    } else {
        return $value
    }
}

# +--------------------------------------------------------------------------------------------------------------------
# | Check that the specified interface has the correct ports, carries one symbol per beat and has ready latency zero
# +--------------------------------------------------------------------------------------------------------------------
proc ::alt_vip_av_st_video_format::_validate_interface_ports {interfaceName} {
    variable defaultBitsPerSymbol

    # Note that SOPC Builder does not provide the ability to check the type of an interface
    # (e.g Avalon ST source/sink). Instead we have to rely on the port roles

    # Check that the interface has the correct ports
    foreach port [get_interface_ports $interfaceName] {
        set role [get_port_property $port ROLE]
        set roles($role) true

        if {$role == "data"} {
            set dataPort $port
        }
        if {$role == "empty"} {
            set emptyPort $port
        }
    }

    set requiredRoles {data endofpacket ready startofpacket valid}
    if {[get_packet_property $interfaceName PIXELS_IN_PARALLEL] > 1} {
        lappend requiredRoles empty
    } else {
        if { [info exists roles("empty")] } {
            error "Interface $interfaceName should not have a port with the role empty"
        }
    }
    foreach requiredRole $requiredRoles {
        if { ![info exists roles($requiredRole)] } {
            error "Interface $interfaceName does not have a port with the role $requiredRole"
        }
    }

}


# +--------------------------------------------------------------------------------------------------------------------
# | This proceedure is used to actually validate the construction of the specified interface. This proceedure
# | should be called after all calls to set_packet_property for the specified interface.
# +--------------------------------------------------------------------------------------------------------------------
proc ::alt_vip_av_st_video_format::validate {interfaceName} {
    _validate_interface_ports $interfaceName
    
    # tag the version once validated
    set_interface_assignment $interfaceName alt_vip_av_st_video_format.version 1.0
}
