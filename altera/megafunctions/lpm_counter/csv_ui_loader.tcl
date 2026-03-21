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


# Import all required packages
package require -exact qsys 13.1
package require csv
package require struct::matrix
package require struct::stack


# Global variable to keep track of text IDs
set text_index 0


#+------------------------------------------------------------------------------
#|
#| Name:    load_layout
#|
#| Purpose: Takes a csv file and lays out the UI based on declarations made in the file
#|
#| Params:  csv_file -- the csv file with the patameter declarations
#|
#| Returns: none
#|
#+------------------------------------------------------------------------------
proc load_layout {csv_file} {


    set fid [open "$csv_file" r]            ;# Open the CSV file with parameter definitions

    struct::stack stk                       ;# Create a stack to hold group names
    stk push ""                             ;# Use "" as the root group name

    struct::matrix mat                      ;# Create a 2d matrix to hold the data
    csv::read2matrix $fid mat "," auto      ;# Fill the matrix with the csv file data

    set parameter [list]                    ;# List that holds the latest #parameter data

    # Traverse each row in the csv file
    for {set r 0} {$r < [mat rows]} {incr r} {

        # Add to the layout if the row is not blank
        set row [mat get row $r]
        if { [string match -nocase "" [join $row {}]] == 0 } {
            add_layout_from_csv_line stk $row
        }
    }

    close $fid      ;# Close the csv file
    mat destroy     ;# Destroy the matrix
    stk destroy     ;# Destroy the stack

}


#+------------------------------------------------------------------------------
#|
#| Name:    add_layout_from_csv_line
#|
#| Purpose: Takes a line from the csv file and sets up the layout based on the data
#|
#| Params:  stk_ref -- a reference to a struct::stack holding various group names
#|          row -- the csv row data that should be added as a parameter
#|
#| Returns: none
#|
#+------------------------------------------------------------------------------
proc add_layout_from_csv_line {stk_ref row} {

    upvar $stk_ref stk      ;# Get the stack from call proc
    global text_index       ;# Grab the text_index from the global scope
    set level 1             ;# Group level for nested groups

    # Traverse the row from the csv file
    foreach item $row {
    
        # If the cell is empty increase the level
        if { [string match -nocase "" $item] == 1 } {
            incr level
        
        # If the cell is in the correct format handle it
        } elseif { [string match -nocase "*:*" $item] == 1 } {

            set index [string first ":" $item]
            set lhs [string trim [string range $item 0          $index-1]]  ;# Get the value left of the first colon
            set rhs [string trim [string range $item $index+1   end]]       ;# Get the value right of the first colon

            # Check which group / item to layout
            switch -nocase $lhs {
    
                "TAB" {
                    # Get to the proper level in the stack
                    while { [stk size] > $level } { stk pop }
                    
                    # Add the display item
                    add_display_item [stk peek] $rhs GROUP TAB
                    
                    # Update the stack with the current level
                    stk push $rhs
                }

                "GROUP" {
                    # Get to the proper level in the stack
                    while { [stk size] > $level } { stk pop }
                    
                    # Add the display item
                    add_display_item [stk peek] $rhs GROUP
                    
                    # Update the stack with the current level
                    stk push $rhs
                }

                "PARAM" {
                    # Get to the proper level in the stack
                    while { [stk size] > $level } { stk pop }

                    # Add the display item
                    add_display_item [stk peek] $rhs PARAMETER
                }

                "TEXT" {
                    # Get to the proper level in the stack
                    while { [stk size] > $level } { stk pop }

                    # Add the text item
                    add_display_item [stk peek] "TEXT${text_index}" TEXT $rhs
                    incr text_index
                }
            }
        }
    }
}


#+------------------------------------------------------------------------------
#|
#| Name:    load_parameters
#|
#| Purpose: Takes a csv file and defines hw.tcl parameters based on the
#|          declarations made in the file.
#|
#| Params:  csv_file -- the csv file with the patameter declarations
#|
#| Returns: none
#|
#+------------------------------------------------------------------------------
proc load_parameters {csv_file} {

    set fid [open "$csv_file" r]            ;# Open the CSV file with parameter definitions

    struct::matrix mat                      ;# Create a 2d matrix to hold the data
    csv::read2matrix $fid mat "," auto      ;# Fill the matrix with the csv file data

    set parameter [list]                    ;# List that holds the latest #parameter data

    # Traverse each row in the csv file
    for {set r 0} {$r < [mat rows]} {incr r} {
    
        # Grab the first cell in the row and see if it defines a new #parameter
        set first_cell [string trim [mat get cell 0 $r]]
        if { [string match -nocase "#PARAMETER" $first_cell] == 1 } {
            set parameter [mat get row $r]
            continue
        }

        # Add the parameter if a #parameter has been defined and the row has some info (not a blank line)
        set row [mat get row $r]
        if { [string match -nocase "" $parameter] == 0 && [string match -nocase "" [join $row {}]] == 0 } {
            add_parameter_from_csv_line $parameter $row
        }
    }

    close $fid      ;# Close the csv file
    mat destroy     ;# Destroy the matrix
}


#+------------------------------------------------------------------------------
#|
#| Name:    add_parameter_from_csv_line
#|
#| Purpose: Takes a line from the csv file and adds a parameter to the IP
#|          based on its description
#|
#| Params:  parameter -- list containing the #PARAMETER infromation
#|          row -- the csv row data that should be added as a parameter
#|
#| Returns: none
#|
#+------------------------------------------------------------------------------
proc add_parameter_from_csv_line {parameter row} {
    # Add Parameter by grabing the name and type 
    set name_index [lsearch -nocase $parameter "#PARAMETER"]
    set type_index [lsearch -nocase $parameter "TYPE"]
    if { $name_index != -1 && $type_index != -1 } {
        set name [lindex $row $name_index]
        set type [lindex $row $type_index]
        add_parameter $name $type
    } else {
        return
    }

    # Add any of the parameter properties that are defined
    for {set i 0} {$i < [llength $parameter]} {incr i} {
        # Grab the item on the parameter line and the row line
        set pval [string trim [lindex $parameter $i]]
        set rval [string trim [lindex $row $i]]

        # Set the parameter property if the property is not the name or type (handled above) or empty
        if {
            [string match -nocase "#PARAMETER" $pval] == 0 &&
            [string match -nocase "TYPE" $pval] == 0 &&
            [string match -nocase "" $pval] == 0
        } then {
            set_parameter_property $name $pval $rval
        }
    }
}

