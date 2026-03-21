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


###############################################################
# Performance-counter block
#
# A performance-counter unit is just a block of 
# big counters for keeping track of "sections" in your software.
#
# This block lets you accurately measure execution-time 
# taken by blocks C-code.  Simple, efficient, minimally-intrusive
# macros allow you to mark the start and end of blocks-of-interest
# in your program.  Each block-of-interest is called a "section."
#
# This peripheral has a measurement start/stop feature that 
# lets you measure each section as a fraction of some larger 
# program (or enclosing task).
#
# This block to keep track of as many sections as you like (the default is 3).
# You change the number of sections in the GUI.
#
# This block will contain two counters for every section:
#   * Time:        A 64-bit time (clock-tick) counter.
#   * Occurrences: A 32-bit event counter.
#
# If you had some function, and you wanted to know how much of your
# execution time it was taking, you would do this:
#
#         // Use section-counter #3 to measure this function:
#         #define INTERESTING_FUNCTION_SECTION 3
#     
#         int my_interesting_function (int a, int b, ....) 
#         {
#            int result;
#            PERF_BEGIN (PERF_UNIT_BASE, INTERESTING_FUNCTION_SECTION);
#     
#               ..body of subroutine...
#            
#            PERF_END (PERF_UNIT_BASE, INTERESTING_FUNCTION_SECTION);
#            return result;
#         }    
#
#
# Then you would need to turn measurement on & off only for the 
# "interesting" part of your program, like this:
# 
#         #include "altera_avalon_performance_counter.h"
#         #include "system.h"
#
#         int main(){
#
#            // Reset the counters before every run
#            PERF_RESET (PERF_UNIT_BASE);
#
#            // First, do things that we don't want to measure:
#            // 
#            get_user_input_that_might_take_arbitrarily_long();
#
#            // Now our program starts in earnest.  Begin measuring:
#            //
#            PERF_START_MEASURING (PERF_UNIT_BASE);
# 
#            while (things_to_do()) {
#               my_interesting_function (a, b);
#               my_boring_function (c,d);
#               my_time_consuming_function (e,f);
#            }
# 
#            PERF_STOP_MEASURING (PERF_UNIT_BASE);
#
#            clean_up_and_print_results();
#            return 0;
#        }
#      
# You can simultaneously measure as many sections as you like
# (HOW_MANY_COUNTERS, less one for the "global" counter #0).
#
# You read the results using these functions:
#
#          unsigned long long perf_get_section_time 
#              (void* hw_base_address, int which_section);
#
#          unsigned long long perf_get_num_starts
#              (void* hw_base_address, int which_section);
# 
# Using straightforward arithmetic, you can compute the total 
# "hard" runtime, in real seconds, taken by each section 
# (using ALT_CPU_FREQ).
# 
# You can also compute the actual percent-time-taken by each section
# by dividing the section-time by the overall measurement time.
# (the overall measurement time is returned by perf_get_section_time
# for section #0).
# 
#
# THE REGISTER MAP
#
# 
#             31           7     6     5     4     3     2     1     0
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_0     |            Global Time Counter [31: 0]                    |  0
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_0     |            Global Time Counter [63:32]                    |  4
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Ev_0      |            Global Measurement-Start Counter               |  8
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#   -       |                  --reserved--                             |  C 
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_1     |            Section 1 Time Counter [31: 0]                 | 10
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_1     |            Section 1 Time Counter [63:32]                 | 14
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Ev_1      |            Section 1 Start Counter                        | 18
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#   -       |                  --reserved--                             | 1C 
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_2     |            Section 2 Time Counter [31: 0]                 | 20
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_2     |            Section 2 Time Counter [63:32]                 | 24
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Ev_2      |            Section 2 Start Counter                        | 28
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#   -       |                  --reserved--                             | 2C 
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#           |                                                           |  
#           ~                      ...                                  ~
#
#           ~                      ...                                  ~
#           |                                                           |  
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_N     |            Section N Time Counter [31: 0]                 | n0
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Tlo_N     |            Section N Time Counter [63:32]                 | n4
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
# Ev_N      |            Section N Start Counter                        | n8
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#   -       |                  --reserved--                             | nC 
#           +---+-/../--+-----+-----+-----+-----+-----+-----+-----+-----+
#
#
# THE GLOBAL COUNTERS
#
# This unit uses section #0 as a special "global" section, which 
# counts the total time during which measurements are being taken.
# None of the other section-counters are allowed to run at all
# (not even the other event counters) when the global time-counter
# is stopped. 
#
# Special macros (PERF_START_MEASURING, PERF_STOP_MEASURING) are defined 
# to control the global counters.  Users should not manipulate
# the global counters directly through PERF_BEGIN and PERF_END.
#
# PERF_BEGIN and PERF_END 
#
# These macros are very efficient, typically requiring only 
# two or three machine instructions.
#
################################################################

use europa_all;
use europa_utils;
use strict;

###############################################################################
# Component parameter check, internal variables will be used for RTL generation
###############################################################################

# internal variables with default value, will considered as verilog parameter
my $how_many_sections = 3;
my $how_many_counters = 4;
my $highest_addressable_byte = 15;
my $address_width = 4;

################################################################
# Validate_Performance_counter_Options
#
# Checks all my PTF-parameters to be sure they're good.
#
################################################################

sub Validate_Options 
{
  my ($Options) = (@_);

   &validate_parameter ({hash    => $Options,
                         name    => "how_many_sections",
                         type    => "integer",
                         default => 3,
                      });

   $how_many_sections = $Options->{how_many_sections};
   $how_many_counters = $how_many_sections + 1;
   $highest_addressable_byte = ($how_many_counters * 4) - 1; 
   $address_width = &Bits_To_Encode($highest_addressable_byte);
}

################################################################
# make_performance_counter
#
# Arguments:
#     $module (e_module object):  A new, empty module to populate.
#     $Opt    (hash-ref)       :  Options for building this master.
#
# Recognized options are:
#
################################################################
sub make_performance_counter
{
   my ($module, $Opt) = (@_);
   
   &Validate_Options ($Opt);

   # mark the new, empty module as the one into which
   # all new "things" should go.  It gets unmarked when this subroutine
   # exits and "$marker" is destroyed.
   #
   my $marker = e_default_module_marker->new($module);

   e_port->adds(["address",       $address_width,        "in" ],
                ["writedata",     32,                    "in"],
                ["readdata",      32,                    "out"],
                ["write",         1,                     "in" ],
                ["begintransfer", 1,                     "in" ],
                );
   
   e_avalon_slave->add ({name => "control_slave",});  
   e_assign->add (["clk_en", "-1"]);
   e_assign->add (["write_strobe", "write & begintransfer"]);

   # Build the actual 64-bit counters:
   # (I hope quartus is clever enough to bulid something nice for me).
   # Build the read-mux and the go/stop bits at the same time
   #
   my @read_mux_table = ();

   for (my $i = 0; $i < $how_many_counters; $i++) {
      my $time_counter_signal = "time_counter_$i";
      my $event_counter_signal = "event_counter_$i";
      my $enable_signal  = "time_counter_enable_$i";
      my $stop_strobe = "stop_strobe_$i";
      my $go_strobe   = "go_strobe_$i";

      # Add the 64-bit time counter (lasts 2000 years at 200MHz).
      # 
      e_register->add 
          ({out        => e_signal->add([$time_counter_signal, 64]),
            in         => "$time_counter_signal + 1",
            sync_reset => "global_reset",
            enable     => "($enable_signal & global_enable) | global_reset",
         });

      # Add the event-counter
      # 
      e_register->add 
          ({out        => e_signal->add([$event_counter_signal, 64]),
            in         => "$event_counter_signal + 1",
            sync_reset => "global_reset",
            enable     => "($go_strobe & global_enable) | global_reset",
         });

      # Break the register-halves apart into read-signals:
      my $lo_A    = $i * 4;
      my $hi_A    = $lo_A + 1;
      my $event_A = $hi_A + 1;
      push (@read_mux_table, 
            "(address == $lo_A)",     "$time_counter_signal \[31: 0]",
            "(address == $hi_A)",     "$time_counter_signal \[63:32]",
            "(address == $event_A)",  "$event_counter_signal"         );

      # Build the write-strobe decoding:
      e_assign->adds 
          ([$stop_strobe, "(address == $lo_A) && write_strobe"],
           [$go_strobe,   "(address == $hi_A) && write_strobe"] );


      # Build the counter-specific enable signal:
      e_register->add 
          ({out        => $enable_signal,
            sync_reset => "$stop_strobe | global_reset",
            sync_set   => $go_strobe,
            priority   => "reset",
         });

      # Counter #0 is the MASTER COUNTER.
      # it's enable-signal is the global-enable.
      # writing a "1" to it's stop-strobe resets the whole unit.
      #
      if ($i == 0) {
         e_assign->adds
             (["global_enable", "$enable_signal | $go_strobe" ],
              ["global_reset",  "$stop_strobe && writedata[0]"] );
      }
   }

   ################
   # The read-mux
   # 
   #  All the important bits were added to the @read_mux list, above.
   #
   e_mux->add ({out   => e_signal->add(["read_mux_out", 32]),
                table => \@read_mux_table,
                type  => "and-or"
               });

  e_register->add ({out => "readdata",
                    in  => "read_mux_out"});
}

1;
