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


# This SDC is used to constrain a design containing logic driven by JTAG that is missing a clocking
# constraint on altera_reserved_tck. This SDC will add a default constraint if none is present, and 
# there are is at least one clock defined in the design.  We don't want to constrain altera_reserved_tck
# when there are no defined clocks since altera_reserved_tck will then become the highest priority clock.
# This will affect the place and route result of logic driven by other clocks in the design.

namespace eval intel_reserved_jtag_default_constraints {

    proc set_default_quartus_fit_timing_directive { } {
        # A10 & S10 support max 33.3Mhz clock
        set jtag_33Mhz_t_period 30
        
        create_clock -name {altera_reserved_tck} -period $jtag_33Mhz_t_period [get_ports {altera_reserved_tck}] 
        set_clock_groups -asynchronous -group {altera_reserved_tck} 
        # Force fitter to place register driving TDO pin to be as close to 
        # the JTAG controller as possible to maximize the slack outside of FPGA.
        set_max_delay -to [get_ports { altera_reserved_tdo } ] 0 
    }

    proc add_contraints_if_appropriate { } {
        # Only constrain if the design contains user-declared clocks
        set number_of_user_clocks [get_collection_size [all_clocks]]

        if {$number_of_user_clocks > 0} {
            # Only contstrain if altera_reserved_tck has not already been constrained
            set tck_defined [get_collection_size [get_clocks -nowarn altera_reserved_tck]]
            if {$tck_defined == 0} {
                post_message -type info "Adding default timing constraints to JTAG signals.  This will help to achieve basic functionality since no such constraints were provided by the user."
                set_default_quartus_fit_timing_directive
            }
        }
    }
}

# Only make this constraint 
if { [string equal quartus_fit $::TimeQuestInfo(nameofexecutable)] } {
    # Define a different set of timing spec to influence place-and-route 
    # result in the jtag clock domain. The slacks outside of FPGA are 
    # maximized.
    intel_reserved_jtag_default_constraints::add_contraints_if_appropriate
}
