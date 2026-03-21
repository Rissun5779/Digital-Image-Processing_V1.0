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


package provide hps_csr 0.1 


namespace eval ::hps_csr:: {

    source [file join $env(QUARTUS_ROOTDIR) .. ip altera altera_hps s10 util xml.tcl]

    namespace export get_address_blocks create_address_block
    namespace export get_address_block_properties get_address_block_property

    namespace export get_registers create_register
    namespace export get_register_properties get_register_property

    namespace export get_fields create_field
    namespace export get_field_properties get_field_property
    namespace export set_field_property set_field_value

    namespace export dump init

    variable addressBlocks {}
}


proc ::hps_csr::dump {} {
    variable addressBlocks
    return $addressBlocks
}


proc ::hps_csr::init {{state {}}} {
    variable addressBlocks
    set addressBlocks $state
}


proc ::hps_csr::get_names {theListRef} {
    upvar $theListRef theList

    set names {}
    foreach e $theList {
        set propertyList [lindex $e 0]
        array set properties $propertyList
        if {[info exists properties(name)]} {
            lappend names $properties(name)
        }
    }
    return $names
}


proc ::hps_csr::get_index {theListRef name} {
    upvar $theListRef theList

    set index -1
    foreach e $theList {
        incr index        
        set propertyList [lindex $e 0]
        array set properties $propertyList
        if {[info exists properties(name)] && $properties(name) == $name} {
            return $index
        }
    }
}


proc ::hps_csr::insert {theListRef indices value} {
    upvar $theListRef theList

    set sublist [::hps_csr::lindex2 $theList $indices]
    set sublistCount [llength $sublist]
    if {$sublistCount == 0} {
        ::hps_csr::lset2 theList $indices $value
    } else {
        ::hps_csr::lset2 theList [concat $indices $sublistCount] $value
    }
}

proc ::hps_csr::get_property_names {theListRef name} {
    upvar $theListRef theList

    set propertyNames {}
    foreach e $theList {
        set propertyList [lindex $e 0]
        array set properties $propertyList
        if {[info exists properties(name)] && $properties(name) == $name} {
            foreach {propertyName propertyValue} $propertyList {
                lappend propertyNames $propertyName
            }
        }
    }

    return $propertyNames
}


proc ::hps_csr::get_property_index {theListRef name} {
    upvar $theListRef theList

    set index -1
    foreach {propertyName propertyValue} $theList {
        incr index
        if {$propertyName == $name} {
            return [expr $index * 2 + 1]
        }
    }
}


proc ::hps_csr::get_property_value {theListRef name} {
    upvar $theListRef theList
    set propertyList $theList
    array set properties $propertyList
    if {[info exists properties($name)]} {
        return $properties($name)
    }
}


proc ::hps_csr::get_address_blocks {} {
    variable addressBlocks
    return [::hps_csr::get_names addressBlocks]
}


proc ::hps_csr::create_address_block {addressBlockName} {
    variable addressBlocks
    set addressBlockCount [llength $addressBlocks]
    ::hps_csr::insert addressBlocks $addressBlockCount [list [list name $addressBlockName] [list]]
}


proc ::hps_csr::get_address_block_properties {addressBlockName} {
    variable addressBlocks
    return [::hps_csr::get_property_names addressBlocks $addressBlockName]
}


proc ::hps_csr::get_address_block_property {addressBlockName addressBlockPropertyName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockProperties [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 0]]

    return [::hps_csr::get_property_value addressBlockProperties $addressBlockPropertyName]
}

proc ::hps_csr::get_registers {addressBlockName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]

    return [::hps_csr::get_names addressBlockRegisters]
}


proc ::hps_csr::create_register {addressBlockName registerName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerCount [llength $addressBlockRegisters]

    ::hps_csr::insert addressBlocks [list $addressBlockIndex 1 $registerCount] [list [list name $registerName] [list]]
}


proc ::hps_csr::get_register_properties {addressBlockName registerName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]

    return [::hps_csr::get_property_names addressBlockRegisters $registerName]
}


proc ::hps_csr::get_register_property {addressBlockName registerName registerPropertyName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerProperties [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 0]]

    return [::hps_csr::get_property_value registerProperties $registerPropertyName]
}


proc ::hps_csr::get_fields {addressBlockName registerName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerFields [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1]]

    return [::hps_csr::get_names registerFields]
}


proc ::hps_csr::create_field {addressBlockName registerName fieldName {fieldProperties {}}} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerFields [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1]]
    set fieldCount [llength $registerFields]
    set fieldProperties [concat [list name $fieldName] $fieldProperties]

    ::hps_csr::insert addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldCount] [list $fieldProperties [list]]
}


proc ::hps_csr::get_field_properties {addressBlockName registerName fieldName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerFields [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1]]

    return [::hps_csr::get_property_names registerFields $fieldName]
}

proc ::hps_csr::get_field_property {addressBlockName registerName fieldName fieldPropertyName} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerFields [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1]]
    set fieldIndex [::hps_csr::get_index registerFields $fieldName]
    set fieldProperties [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldIndex 0]]

    return [::hps_csr::get_property_value fieldProperties $fieldPropertyName]
}


# INTERNAL USE ONLY: set any field property, although renaming a field or
#            creating new field properties should not allowed.
proc ::hps_csr::set_field_property {addressBlockName registerName fieldName fieldPropertyName fieldPropertyValue} {
    variable addressBlocks

    set addressBlockIndex [::hps_csr::get_index addressBlocks $addressBlockName]
    set addressBlockRegisters [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1]]
    set registerIndex [::hps_csr::get_index addressBlockRegisters $registerName]
    set registerFields [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1]]
    set fieldIndex [::hps_csr::get_index registerFields $fieldName]
    set fieldProperties [::hps_csr::lindex2 $addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldIndex 0]]
    set fieldPropertyIndex [::hps_csr::get_property_index fieldProperties $fieldPropertyName]
    set fieldPropertyCount [llength $fieldProperties]

    if {$fieldPropertyIndex > -1} {
        # If field property exists, update it
        ::hps_csr::lset2 addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldIndex 0 $fieldPropertyIndex] $fieldPropertyValue
    } else {
        # Otherwise create the property with the given name and value
        set fieldPropertyNameIndex $fieldPropertyCount
        set fieldPropertyValueIndex [expr $fieldPropertyNameIndex + 1] 
        ::hps_csr::insert addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldIndex 0 $fieldPropertyNameIndex] $fieldPropertyName
        ::hps_csr::insert addressBlocks [list $addressBlockIndex 1 $registerIndex 1 $fieldIndex 0 $fieldPropertyValueIndex] $fieldPropertyValue
    }
}


# Set field property with name $fieldProperty to value $fieldValue
proc ::hps_csr::set_field_value {addressBlockName registerName fieldName fieldValue} {
    return [::hps_csr::set_field_property $addressBlockName $registerName $fieldName value $fieldValue]
}


# emulate lset, which is not supported by Tcl/Java
proc ::hps_csr::lset2 {elementsRef indices value} {

    upvar $elementsRef elements

    set index [lindex $indices 0]

    set indicesCount [llength $indices]
    set indicesMaxIndex [expr $indicesCount - 1]
    set sublistIndices [lrange $indices 1 $indicesMaxIndex]

    set elementsCount [llength $elements]
    set elementsMaxIndex [expr $elementsCount - 1]

    if {$index > 0} {    
        set elementsBeforeFirstIndex 0
        set elementsBeforeLastIndex [expr $index - 1]
        set elementsBefore [lrange $elements $elementsBeforeFirstIndex $elementsBeforeLastIndex]
    }

    if {$index < $elementsMaxIndex} {
        set elementsAfterFirstIndex [expr $index + 1]
        set elementsAfterLastIndex $elementsMaxIndex
        set elementsAfter [lrange $elements $elementsAfterFirstIndex $elementsAfterLastIndex]
    }

    if {$index >= 0 && $index <= $elementsMaxIndex} {
        # Perform replace operation when index is points to existing element
        if {[llength $sublistIndices] == 0} {
            # Replace current element if no more sublist indices provided
            set element $value
        } else {
            # Replace sublist element if more sublist indices provided
            set sublistElements [lindex $elements $index]
            set element [::hps_csr::lset2 sublistElements $sublistIndices $value]
        }
    } elseif {$index == $elementsCount} {
        # Perform append operation when index is at [llength $list] i.e. 
        # immediately after the last element.
        if {[llength $sublistIndices] == 0} {
            # append to current list if no more sublist indices provided
            set element $value
        } else {
            # Can't append to sublist as element at index is suppose to
            # be appended and hence sublist does not exist yet thereby
            # sublist indices makes no sense here
        }
    } else {
        # Anything else is an error
    }

    if {$index == 0} {
        if {$index == $elementsCount} {
            set elements [list $element]
        } elseif {$index == $elementsMaxIndex} {
            set elements [list $element]
        } else {
            set elements [concat [list $element] $elementsAfter]
        }
    } else {
        if {$index == $elementsMaxIndex || $index == $elementsCount} {
            set elements [concat $elementsBefore [list $element]]
        } else {
            set elements [concat $elementsBefore [list $element] $elementsAfter]
        }
    }
}


# Emulate lindex with list of indices, which is not supported by Tcl/Java
proc ::hps_csr::lindex2 {elements indices} {
    foreach index $indices {
        set elements [lindex $elements $index]
    }
    return $elements
}


proc ::hps_csr::to_xml {file {indent "\t"} {initial_indent ""}} {

    variable addressBlocks

    set t $indent 
    set t0 $initial_indent 
    set t1 "$t0$t"
    set t2 "$t0$t$t"
    set t3 "$t0$t$t$t"
    set t4 "$t0$t$t$t$t"


    puts $file "$t0<addressMap>"

    foreach addressBlock $addressBlocks {
        puts $file "$t1<addressBlock>"
        set properties [lindex $addressBlock 0]
        set registers [lindex $addressBlock 1]
        foreach {name value} $properties {
            puts $file "$t2<$name>$value</$name>"
        }
        foreach register $registers {
            puts $file "$t2<register>"
            set properties [lindex $register 0]
            set fields [lindex $register 1]
            foreach {name value} $properties {
                puts $file "$t3<$name>$value</$name>"
            }
            foreach field $fields {
                puts $file "$t3<field>"
                set properties [lindex $field 0]
                foreach {name value} $properties {
                    puts $file "$t4<$name>$value</$name>"
                }
                puts $file "$t3</field>"
            }
            puts $file "$t2</register>"
        }
        puts $file "$t1</addressBlock>"
    }
    puts $file "$t0</addressMap>"

}

proc ::hps_csr::to_list {} {

    variable addressBlocks

    set csrList {}

    foreach addressBlock $addressBlocks {
        array set addressBlockProperties [lindex $addressBlock 0]
        set registers [lindex $addressBlock 1]
        set addressBlockName $addressBlockProperties(name)
        foreach register $registers {
            array set registerProperties [lindex $register 0]
            set fields [lindex $register 1]
            set registerName $registerProperties(name)
            foreach field $fields {
                array unset fieldProperties
                array set fieldProperties [lindex $field 0]
                set fieldName $fieldProperties(name)
                set csrNamespace "$addressBlockName.$registerName.$fieldName"
                if {[info exists fieldProperties(value)]} {
                    set fieldValue $fieldProperties(value)
                    lappend csrList [list $csrNamespace $fieldValue]
                       }    
            }
        }
    }

    return $csrList
}
