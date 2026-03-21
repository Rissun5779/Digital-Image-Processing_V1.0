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


use e_lpm_scfifo;
use europa_all;        
use e_atlantic_master;
use e_atlantic_slave;
use strict;

############################################################################
#
# Main
#
############################################################################

my $proj = e_project->new(@ARGV);

my $avalonmm_write_slave_cp_name = "in";
my $avalonmm_read_slave_cp_name = "out";
my $avalonst_sink_cp_name = "in";
my $avalonst_source_cp_name = "out";
my $wrclk_control_slave_cp_name = "in_csr";
my $rdclk_control_slave_cp_name = "out_csr";
my $wrclk_reset_n;
my $rdclk_reset_n;

&make_proj($proj);
$proj->output();

sub calculate_derived_parameters
{
    my $options = shift;

    # The signal name for reset_n (SCFIFO will has only one clock, therefore only one reset_n)
    if($options->{Single_Clock_Mode}){
      $wrclk_reset_n = "reset_n";
      $rdclk_reset_n = "reset_n";
    }
    else {
      $wrclk_reset_n = "wrreset_n";
      $rdclk_reset_n = "rdreset_n";
    }

    #
    # Calculate some useful parameters for constructing the memory map
    # between AvalonMM and AvalonST
    #
    $options->{avalonMMBitsPerSymbol} = 1 << ceil (log2($options->{Bits_Per_Symbol}));
    $options->{minimumCyclesPerSymbol} = ceil( $options->{avalonMMBitsPerSymbol} / $options->{AvalonMM_AvalonST_Data_Width} );
    $options->{maximumSymbolsPerCycle} = $options->{AvalonMM_AvalonST_Data_Width} / $options->{avalonMMBitsPerSymbol};
    $options->{cyclesPerBeat} = ($options->{Symbols_Per_Beat} / $options->{maximumSymbolsPerCycle});

    #
    # Define Width of FIFO based on Interface type.
    #
    if($options->{Use_AvalonMM_Write_Slave} && 
       $options->{Use_AvalonMM_Read_Slave} &&
       !$options->{Use_AvalonST_Source} &&
       !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM-AvalonMM Interface
        $options->{FIFO_Width} = $options->{AvalonMM_AvalonMM_Data_Width};
    }
    elsif($options->{Use_AvalonMM_Write_Slave} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM/AvalonST Interface
        # Bits_Per_Symbol is used because the AvalonST data should be packed.
	$options->{FIFO_Width} = $options->{maximumSymbolsPerCycle} * $options->{Bits_Per_Symbol};
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonST_Source})
    {
        # AvalonST/AvalonMM Interface
        $options->{FIFO_Width} = $options->{maximumSymbolsPerCycle} * $options->{Bits_Per_Symbol};
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonMM_Read_Slave})
    {
        # AvalonST/AvalonST Interface
        # Calculate the width of the FIFO from the AvalonST signals.
        # When AvalonST/AvalonST interface is used, the data and other info 
        # are using only one FIFO as no special mapping is required.
        my @avalonst_signals = &get_avalonst_signals($options, "");
        $options->{FIFO_Width} = 0;
        foreach(@avalonst_signals)
        {
            $options->{FIFO_Width} = $options->{FIFO_Width} + $_->[1];
        };
    }
    else
    {
        &ribbit("Invalid Combination of Interfaces.\n");
    }
}

sub make_proj
{
    my $proj = shift;
    my $top_mod = $proj->top();
    my $marker = e_default_module_marker->new($top_mod);
    my $options = &copy_of_hash($proj->WSA());

    &calculate_derived_parameters($options);

    #
    # Define the scfifo or dcfifo based on user selection.
    #
    if($options->{Single_Clock_Mode})
    {
        # Define and make the SCFIFO logic
        &define_scfifo_with_controls($proj, $options);
        &make_scfifo($proj, $options);
    }
    else
    {
        # Define and make the DCFIFO logic
        &define_dcfifo_with_controls($proj, $options);
        &make_dcfifo($proj, $options);
    }

    #
    # Make the write control slave if enabled.
    #
    if($options->{Use_Write_Control})
    {
        &make_write_control($proj, $options);
    }

    #
    # Make the read control slave if enabled.
    #
    if($options->{Use_Read_Control})
    {
        &make_read_control($proj, $options);
    }
}

#######################################################################################
#
# Define scfifo using LPM_FIFO megafunction
#
# Parameters: 
#             project
#             device_family   : e.g. $options->{Device_Family}
#             fifo_name       : e.g. $proj->top()->name()."_single_clock_fifo"
#             fifo_depth      : e.g. $options->{FIFO_Depth}
#             fifo_width      : e.g. $options->{FIFO_Width}
#             use_register    : e.g. $options->{Use_Register}
#             use_usedw       : Want to enable usedw? If use, "1", else "0"
#             use_full        : Want to enable full? If use, "1", else "0"
#             use_empty       : Want to enable empty? If use, "1", else "0"
# 
#######################################################################################

sub define_scfifo
{
    my $proj = shift;
    my $device_family = shift;
    my $fifo_name = shift;
    my $fifo_depth = shift;
    my $fifo_width = shift;
    my $use_register = shift;
    my $use_usedw = shift;
    my $use_full = shift;
    my $use_empty = shift;

    my $use_eab = $use_register ? qq("OFF") : qq("ON");
    my $fifo_widthu = log2($fifo_depth);
    my $fifo_widthu_ceil = ceil (log2($fifo_depth));

    if ($fifo_widthu != $fifo_widthu_ceil)
    {
        &ribbit("FIFO depth need to be power of 2.");
    }
    

    my $mod = e_module->new({name => $fifo_name});
    $proj->add_module($mod);

    my %out_port_map_hash = 
    (
        q => e_signal->new([q => $fifo_width]),
    );

    if($use_full)
    {
	$out_port_map_hash{"full"} = e_signal->new([full => 1]);
    }

    if($use_empty)
    {
	$out_port_map_hash{"empty"} = e_signal->new([empty => 1]);
    }

    if($use_usedw)
    {
         $out_port_map_hash{"usedw"} = e_signal->new([usedw => $fifo_widthu]);
    }

    $mod->add_contents(
        e_blind_instance->new({
            name => 'single_clock_fifo',
            module => 'scfifo',
            use_sim_models => 1,
            in_port_map =>
            {
                aclr => 'aclr',
                clock => 'clock',
                data => e_signal->new([data => $fifo_width]),
                rdreq => 'rdreq',
                wrreq => 'wrreq',
            },
            out_port_map =>
            {
                 %out_port_map_hash,
            },

            parameter_map =>
            {
                add_ram_output_register => qq("OFF"),
                intended_device_family => qq("$device_family"),
                lpm_numwords => $fifo_depth,
                lpm_showahead => qq("OFF"),
                lpm_type => qq("scfifo"),
                lpm_width => $fifo_width,
                lpm_widthu => $fifo_widthu,
                overflow_checking => qq("ON"),
                underflow_checking => qq("ON"),
                use_eab => $use_eab,
            },
        }),
    );
}


#######################################################################################
#
# Define dcfifo using LPM_FIFO megafunction
#
# Parameters: 
#             project
#             device_family   : e.g. $options->{Device_Family}
#             fifo_name       : e.g. $proj->top()->name()."_single_clock_fifo"
#             fifo_depth      : e.g. $options->{FIFO_Depth}
#             fifo_width      : e.g. $options->{FIFO_Width}
#             use_register    : e.g. $options->{Use_Register}
#             use_rdusedw     : Want to enable rdusedw? If use, "1", else "0"
#             use_wrusedw     : Want to enable wrusedw? If use, "1", else "0"
#             use_rdfull      : Use rdfull port? If use, "1", else "0"
#             use_wrempty     : Use wrempty port? If use, "1", else "0"
#             use_wrfull      : Use wrfull port? If use, "1", else "0"
#             use_rdempty     : Use rdempty port? If use, "1", else "0"
# 
#######################################################################################

sub define_dcfifo
{
    my $proj = shift;
    my $device_family = shift;
    my $fifo_name = shift;
    my $fifo_depth = shift;
    my $fifo_width = shift;
    my $use_register = shift;
    my $use_rdusedw = shift;
    my $use_wrusedw = shift;
    my $use_rdfull = shift;
    my $use_wrempty = shift;
    my $use_wrfull = shift;
    my $use_rdempty = shift;

    my $use_eab = $use_register ? qq("OFF") : qq("ON");
    my $fifo_widthu = log2($fifo_depth);
    my $fifo_widthu_ceil = ceil (log2($fifo_depth));

    if ($fifo_widthu != $fifo_widthu_ceil)
    {
        &ribbit("FIFO depth need to be power of 2.");
    }

    my $mod = e_module->new({name => $fifo_name});
    $proj->add_module($mod);

    my %out_port_map_hash = 
    (
        q => e_signal->new([q => $fifo_width]),
    );


    if($use_wrfull)
    {
 	$out_port_map_hash{"wrusedw"} = e_signal->new([wrusedw => $fifo_widthu]);
        $out_port_map_hash{"wrfull"} = e_signal->new([int_wrfull => 1]);
	$mod->add_contents(
	    e_assign->new(
		{lhs => e_signal->new([wrfull => 1]),
		 rhs => "(wrusedw >= $fifo_depth-3) | int_wrfull"},
	    ),
	);
    }

    if($use_rdfull)
    {
        $out_port_map_hash{"rdusedw"} = e_signal->new([rdusedw => $fifo_widthu]);
        $out_port_map_hash{"rdfull"} = e_signal->new([int_rdfull => 1]);
	$mod->add_contents(
	    e_assign->new(
		{lhs => e_signal->new([rdfull => 1]),
		 rhs => "(rdusedw >= $fifo_depth-3) | int_rdfull"}
	    ),
	);
    }

    if($use_rdempty)
    {
	$out_port_map_hash{"rdempty"} = e_signal->new(["rdempty", 1, 1]);
    }

    if($use_wrempty)
    {
    	 $out_port_map_hash{"wrempty"} = e_signal->new(["wrempty", 1, 1]);
    }
 
    if($use_rdusedw)
    {
        $out_port_map_hash{"rdusedw"} = e_signal->new(["rdusedw", $fifo_widthu, 1]);
    }

    if($use_wrusedw)
    {
         $out_port_map_hash{"wrusedw"} = e_signal->new(["wrusedw", $fifo_widthu, 1]);
    }

    my %parameter_map_hash = 
    (
         intended_device_family => qq("$device_family"),
         lpm_numwords => $fifo_depth,
         lpm_showahead => qq("OFF"),
         lpm_type => qq("dcfifo"),
         lpm_width => $fifo_width,
         lpm_widthu => $fifo_widthu,
         overflow_checking => qq("ON"),
         underflow_checking => qq("ON"),
         use_eab => $use_eab,
    );

    if( ($device_family =~ m/stratix\s*iii/i) || ($device_family =~ m/cyclone\s*iii/i) )
    {
	# StratixIII or CycloneIII
	$parameter_map_hash{"rdsync_delaypipe"} = 4;
	$parameter_map_hash{"wrsync_delaypipe"} = 4;
    }
    elsif ( ($device_family =~ m/stratix\s*ii/i) || ($device_family =~ m/cyclone\s*ii/i) )
    {
	# StratixII or CycloneII
	$parameter_map_hash{"lpm_hint"} = qq("MAXIMIZE_SPEED=5,");
	$parameter_map_hash{"rdsync_delaypipe"} = 4;
	$parameter_map_hash{"wrsync_delaypipe"} = 4;
    }
    else
    {
	# Others
        $parameter_map_hash{"add_ram_output_register"} = qq("OFF");
	$parameter_map_hash{"clocks_are_synchronized"} = qq("FALSE");
    }



    $mod->add_contents(
        e_blind_instance->new({
            name => 'dual_clock_fifo',
            module => 'dcfifo',
            use_sim_models => 1,
            in_port_map =>
            {
                aclr => 'aclr',
                data => e_signal->new([data => $fifo_width]),
                wrreq => 'wrreq',
                wrclk => 'wrclk',

                rdreq => 'rdreq',
                rdclk => 'rdclk',
            },
            out_port_map =>
            {
                 %out_port_map_hash,
            },

            parameter_map =>
            {
		%parameter_map_hash,
            },
        }),
    );
}

#######################################################################################
#
# Define DCFIFO with control logic by instantiating the DCFIFO.
#
#######################################################################################
sub define_dcfifo_with_controls
{
    my $proj = shift;
    my $options = shift;
 
    my $use_rdusedw = 0;
    my $use_wrusedw = 0;
    my $use_rdfull = 0;
    my $use_wrempty = 0;
    my $use_wrfull = 1;
    my $use_rdempty = 1;

    # use wrusedw if the following condition
    my $need_wrlevel = 0;
    if($options->{Use_AvalonST_Sink} & $options->{Use_Backpressure})
    {
	$need_wrlevel = 1;
    }

    # always use wrclk_reset_n as asynchronous clear signal for the DC FIFO
    my %port_map_hash = 
    (
        aclr => "~$wrclk_reset_n",
        data => 'data',
        wrreq => 'wrreq',
        wrclk => 'wrclk',
        rdreq => 'rdreq',
        rdclk => 'rdclk',
        q => 'q',
        rdempty => 'rdempty',
        wrfull => 'wrfull',
    );
    
    # This 2 signal is output from <name> "_dcfifo_with_controls" module
    # It is only used internally in $proj->top(), never export this out of top
    # BUG: without this, it will export out of top if Use_Backpressure=false
    $proj->top()->add_contents
    (
        e_signal->new({name=>"rdempty",never_export=>1}),
        e_signal->new({name=>"wrfull",never_export=>1}),
    ###############################################
    # case:64568 - always export read reset_n signal in top level
    ###############################################
    e_signal->new({name=>"rdreset_to_be_optimized",never_export=>1}),
    e_assign->new(
            {lhs => "rdreset_to_be_optimized",
             rhs => "$rdclk_reset_n"}
		),
    );

	if($options->{Use_Backpressure})   
	{
		$port_map_hash{"wrreq"} = "wrreq_valid";
	}
	
    if($options->{Use_Write_Control} | $need_wrlevel)
    {
        $use_wrusedw = 1;
        $port_map_hash{"wrusedw"} = "wrusedw";
    }

    if($options->{Use_Write_Control})
    {   
        $use_wrempty = 1;
        $port_map_hash{"wrempty"} = "wrempty";
    }

    if($options->{Use_Read_Control})
    {
        $use_rdfull = 1;
        $use_rdusedw = 1;

        $port_map_hash{"rdfull"} = "rdfull";
        $port_map_hash{"rdusedw"} = "rdusedw";	
    }

    &define_dcfifo($proj,
                   $options->{Device_Family},
                   $proj->top()->name()."_dual_clock_fifo",
                   $options->{FIFO_Depth},
                   $options->{FIFO_Width},
                   $options->{Use_Register},
                   $use_rdusedw,
                   $use_wrusedw,
                   $use_rdfull,
                   $use_wrempty,
		   $use_wrfull,
		   $use_rdempty
		  );

    # The threshold range values are the allowable threshold values
    # for almostfull_threshold and almostempty_threshold registers.
    # When trying to write a value that is out of the range, the value
    # is ignored and maximum_threshold or minimum_threshold will be used
    # instead. The default almostempty_threshold register value is minimum_threshold
    # and the default almostfull_threshold register value is maximum_threshold.
    my $minimum_threshold = 1;
    ## my $maximum_threshold = $options->{FIFO_Depth}-1;
    ## Maximum Depth of FIFO is DEPTH-3, hence 
    ## maximum threshold is one less than that, which is DEPTH-4
    my $maximum_threshold = $options->{FIFO_Depth}-4;

    # Calculate the LEVEL register width
    # The LEVEL register is the concatenation of USEDW[] and FULL.
    my $fifo_widthu = log2($options->{FIFO_Depth});
    my $fifo_widthu_ceil = ceil (log2($options->{FIFO_Depth}));
    if ($fifo_widthu != $fifo_widthu_ceil)
    {
        &ribbit("FIFO depth need to be power of 2.");
    }
    my $level_width = $fifo_widthu + 1;

    # Define the width of iEnable, Event, and Status registers
    # The status bits are mapped as following:
    #      Bits   :    5      4      3     2     1     0
    #      Status :    U      O     AME   AMF    E     F
    # Where U   = Underflow    AME = AlmostEmpty    E   = Empty
    #       O   = Overflow     AMF = AlomostFull    F   = Full
    #
    my @status_bits_signals = &get_status_bits_signals();

    # Get the total number of status signals
    my $status_width = @status_bits_signals;

    my $mod = e_module->new({name => $proj->top()->name()."_dcfifo_with_controls"});
    $proj->add_module($mod);

    $mod->add_contents(
        # Instantiate DCFIFO
        e_instance->new
        ({
            name => "the_dcfifo",
            module => $proj->top()->name()."_dual_clock_fifo",
            port_map =>
                {
                    %port_map_hash,
                },
        }),

        # Export the full, empty signals.
        e_signal->news(
            ["rdempty", 1, 1],
            ["wrfull", 1, 1],
        ),
    );

    ###############################################
    #
    # Define the level signal when write control 
    # slave is used or $need_wrlevel is true
    #
    ###############################################
    if($options->{Use_Write_Control} | $need_wrlevel)
    {
        # Define the LEVEL output signal
        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["wrlevel", $level_width]),
##                 rhs => &concatenate("wrfull", "wrusedw")},
                 rhs => &concatenate("1'b0", "wrusedw")},
            ),
        );

	# Only export the level if needed.
	if($need_wrlevel)
	{
	    $mod->add_contents(
		e_signal->new(
		    ["wrlevel", $level_width, 1],
		),
	    );
	}
    }

	if($options->{Use_Backpressure})   
    {
        $mod->add_contents(
        e_assign->news(
            {lhs => e_signal->new(["wrreq_valid", 1]),
             rhs => "wrreq & ~wrfull"},
		)
		);
	}
	
    ###############################################
    #
    # The following signals are needed only when 
    # write control slave is used.
    #
    ###############################################
    if($options->{Use_Write_Control})
    {
        $mod->add_contents(
            # Define overflow and underflow signals. Overflow occurs when writing to a full FIFO.
            # Underflow occurs when reading from an empty FIFO.
            e_assign->news(
                {lhs => "wroverflow",
                 rhs => "wrreq & wrfull"},
                {lhs => "wrunderflow",
                 rhs => "rdreq & wrempty"},
            ),
        );
    }

    if($options->{Use_Write_Control})
    {
        $mod->add_contents(
           e_assign->news(
                #
                # The almost*_threshold registers values must within
                # the range defined by minimum_threshold and maximum_threshold
                # values. If user setting exceeds the range, the minimum and
                # maximum will be used for almostempty_threshold and
                # almostfull_threshold respectively.
                #
                {lhs => e_signal->new(["wrclk_control_slave_threshold_writedata", $level_width]),
                 rhs => "(wrclk_control_slave_writedata < $minimum_threshold) ? $minimum_threshold :
                         (wrclk_control_slave_writedata > $maximum_threshold) ? $maximum_threshold :
                          wrclk_control_slave_writedata[$level_width-1:0]"},

                #
                # Define the Status signals. There are $status_width bits of status bits.
                #
                # almostfull and almostempty flags assignments
                {lhs => "wrclk_control_slave_event_almostfull_signal",
                 rhs => "wrclk_control_slave_almostfull_pulse"},
                {lhs => "wrclk_control_slave_event_almostempty_signal",
                 rhs => "wrclk_control_slave_almostempty_pulse"},

		{lhs => "wrclk_control_slave_status_almostfull_signal",
		 rhs => "wrclk_control_slave_almostfull_signal"},
		{lhs => "wrclk_control_slave_status_almostempty_signal",
		 rhs => "wrclk_control_slave_almostempty_signal"},

                # full and empty flags assignments
                {lhs => "wrclk_control_slave_event_full_signal",
                 rhs => "wrclk_control_slave_full_pulse"},
                {lhs => "wrclk_control_slave_event_empty_signal",
                 rhs => "wrclk_control_slave_empty_pulse"},

		{lhs => "wrclk_control_slave_status_full_signal",
		 rhs => "wrclk_control_slave_full_signal"},
		{lhs => "wrclk_control_slave_status_empty_signal",
		 rhs => "wrclk_control_slave_empty_signal"},

                # overflow and underflow flags assignments
                {lhs => "wrclk_control_slave_event_overflow_signal",
                 rhs => "wroverflow"},
                {lhs => "wrclk_control_slave_event_underflow_signal",
                 rhs => "wrunderflow"},

		{lhs => "wrclk_control_slave_status_overflow_signal",
		 rhs => "wroverflow"},
		{lhs => "wrclk_control_slave_status_underflow_signal",
		 rhs => "wrunderflow"},
                ),


            # Detection of empty condition. The level of the fifo must exceed the 
            # zero first, then decrease until empty. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of empty happen.
            # This is to prevent the empty being falsely triggered when enabled after power-up/reset.
            #
            e_assign->news(
                {lhs => "wrclk_control_slave_empty_signal",
                 rhs => "wrempty"},
                {lhs => "wrclk_control_slave_empty_pulse",
                 rhs => "wrclk_control_slave_empty_signal & wrclk_control_slave_empty_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_empty_n_reg",
                in  => "!wrclk_control_slave_empty_signal",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of full condition. The level of the fifo must equal the 
            # maximum fifo depth first. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of full happen.
            #
            e_assign->news(
                {lhs => "wrclk_control_slave_full_signal",
                 rhs => "wrfull"},
                {lhs => "wrclk_control_slave_full_pulse",
                 rhs => "wrclk_control_slave_full_signal & wrclk_control_slave_full_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_full_n_reg",
                in  => "!wrclk_control_slave_full_signal",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of almostempty condition. The level of the fifo must exceed the 
            # almostempty_threshold value first, then decrease until almostempty_threshold or less
            # value. Once that occur, a pulse of one clock cycle is generated to indicate the condition
            # of almostempty happen. This is to prevent the almostempty being falsely triggered
            # when enabled after power-up/reset.
            e_assign->news(
                {lhs => "wrclk_control_slave_almostempty_signal",
                 rhs => "wrlevel <= wrclk_control_slave_almostempty_threshold_register"},
                {lhs => "wrclk_control_slave_almostempty_pulse",
                 rhs => "wrclk_control_slave_almostempty_signal & wrclk_control_slave_almostempty_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_almostempty_n_reg",
                in  => "!wrclk_control_slave_almostempty_signal",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of almostfull condition. Everytime the level of the fifo is equal or more than
            # almostfull_threshold value, a pulse of one clock cycle is generated to indicate the condition  
            # of almostfull happen.
            e_assign->news(
                {lhs => "wrclk_control_slave_almostfull_signal",
                 rhs => "wrlevel >= wrclk_control_slave_almostfull_threshold_register"},
                {lhs => "wrclk_control_slave_almostfull_pulse",
                 rhs => "wrclk_control_slave_almostfull_signal & wrclk_control_slave_almostfull_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_almostfull_n_reg",
                in  => "!wrclk_control_slave_almostfull_signal",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Define almostempty_threshold register. Default value
            # is $minimum_threshold. Address Offset == 5
            e_register->new({
                out => "wrclk_control_slave_almostempty_threshold_register",
                in  => "wrclk_control_slave_threshold_writedata",
                clock => "wrclk",
                async_value => $minimum_threshold,
                enable => "(wrclk_control_slave_address == 5) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n"}),

            # Define almostfull_threshold register. Default value
            # is $maximum_threshold. Address Offset == 4
            e_register->new({
                out => "wrclk_control_slave_almostfull_threshold_register",
                in  => "wrclk_control_slave_threshold_writedata",
                clock => "wrclk",
                async_value => $maximum_threshold,
                enable => "(wrclk_control_slave_address == 4) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n"}),

            # Define IEnable register. There are $status_width bits of interrupt bits.
            # Default value is 0, i.e. All interrupts are diabled.
            # Address offset == 3
            e_register->new({
                out => e_signal->new(["wrclk_control_slave_ienable_register", $status_width]),
                in => "wrclk_control_slave_writedata[$status_width-1:0]",
                clock => "wrclk",
                enable => "(wrclk_control_slave_address == 3) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n",}),

            # Define LEVEL register.
            # Address offset == 0
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_level_register", $level_width]),
                 rhs => "wrlevel"},
            ),
        );

        # Define Event register. There are $status_width bits of events. Each bit is corresponding
        # to the status bits of the status signals. When a status signal is changing from
        # 0 to 1, the event register will become 1. Each bit of the event register can be cleared
        # independently by writing a 1 to the respective bit.
        # Address offset == 2
        my @event_reg_bits = ();
        foreach (@status_bits_signals)
        {
            my $event_regout = "wrclk_control_slave_event_".$_->[0]."_q";
            my $event_set  = "wrclk_control_slave_event_".$_->[0]."_signal";
            my $event_reset = "wrclk_control_slave_write & 
                               (wrclk_control_slave_address == 2) &
                               wrclk_control_slave_writedata[".$_->[1]."]";
            push(@event_reg_bits, $event_regout);
            
            $mod->add_contents(
                e_register->new({
                    out => $event_regout,
                    clock => "wrclk",
                    enable => 1,
                    reset => "$wrclk_reset_n",
                    sync_set => $event_set,
                    sync_reset => "$event_reset",
                }),
            );
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_event_register", $status_width]),
                 rhs => &concatenate(@event_reg_bits)},
            ),
        );

        if($options->{Use_IRQ})
        {
            $mod->add_contents(
                e_assign->new(
                    {lhs => "wrclk_control_slave_irq",
                     rhs => "| (wrclk_control_slave_event_register & wrclk_control_slave_ienable_register)"},
                ),  
            );
        }


        # Define Status register. There are $status_width bits of status.
        # Address offset == 1. Read-Only.
        my @status_reg_bits = ();
        foreach(@status_bits_signals)
        {
            my $status_regin = "wrclk_control_slave_status_".$_->[0]."_signal";
            my $status_regout = "wrclk_control_slave_status_".$_->[0]."_q";

            $mod->add_contents(
                e_register->new({
                    out => $status_regout,
                    in  => $status_regin,
                    clock => "wrclk",
                    enable => 1,
                    reset => "$wrclk_reset_n",
                }),
            );
            push(@status_reg_bits, $status_regout);
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_status_register", $status_width]),
                 rhs => &concatenate(@status_reg_bits)},
            ),
        );

        #
        # Read from wrclk_control_slave 
        # User can read the registers from the component through the wrclk control slave.
        # 
        my @wrclk_control_slave_read_mux_table = (
        "wrclk_control_slave_address == 0" => "wrclk_control_slave_level_register",
        "wrclk_control_slave_address == 1" => "wrclk_control_slave_status_register",
        "wrclk_control_slave_address == 2" => "wrclk_control_slave_event_register",
        "wrclk_control_slave_address == 3" => "wrclk_control_slave_ienable_register",
        "wrclk_control_slave_address == 4" => "wrclk_control_slave_almostfull_threshold_register",
        "wrclk_control_slave_address == 5" => "wrclk_control_slave_almostempty_threshold_register",
        );

        $mod->add_contents(
            e_mux->new({
                lhs => "wrclk_control_slave_read_mux",
                table => \@wrclk_control_slave_read_mux_table,
                type => "and-or",
                default => "wrclk_control_slave_level_register",}),

            e_register->new({
                out => "wrclk_control_slave_readdata",
                in  => "wrclk_control_slave_read_mux",
                clock => "wrclk",
                enable => "wrclk_control_slave_read",
                reset => "$wrclk_reset_n",
            }),
        );
    }
    
    ###############################################
    #
    # The following signals are needed only when 
    # read control slave is used.
    #
    ###############################################
    if($options->{Use_Read_Control})
    {
        # Define the LEVEL output signal
        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["rdlevel", $level_width]),
	##   rhs => &concatenate("rdfull", "rdusedw")},
		 rhs => &concatenate("1'b0", "rdusedw")},
            ),
        );

        $mod->add_contents(
            # Define overflow and underflow signals. Overflow occurs when writing to a full FIFO.
            # Underflow occurs when reading from an empty FIFO.
            e_assign->news(
                {lhs => "rdoverflow",
                 rhs => "wrreq & rdfull"},
                {lhs => "rdunderflow",
                 rhs => "rdreq & rdempty"},
            ),
        );
    }

    if($options->{Use_Read_Control})
    {
        $mod->add_contents(
           e_assign->news(
                #
                # The almost*_threshold registers values must within
                # the range defined by minimum_threshold and maximum_threshold
                # values. If user setting exceeds the range, the minimum and
                # maximum will be used for almostempty_threshold and
                # almostfull_threshold respectively.
                #
                {lhs => e_signal->new(["rdclk_control_slave_threshold_writedata", $level_width]),
                 rhs => "(rdclk_control_slave_writedata < $minimum_threshold) ? $minimum_threshold :
                         (rdclk_control_slave_writedata > $maximum_threshold) ? $maximum_threshold :
                          rdclk_control_slave_writedata[$level_width-1:0]"},

                #
                # Define the Status signals. There are $status_width bits of status bits.
                #
                # almostfull and almostempty flags assignments
                {lhs => "rdclk_control_slave_event_almostfull_signal",
                 rhs => "rdclk_control_slave_almostfull_pulse"},
                {lhs => "rdclk_control_slave_event_almostempty_signal",
                 rhs => "rdclk_control_slave_almostempty_pulse"},

		{lhs => "rdclk_control_slave_status_almostfull_signal",
		 rhs => "rdclk_control_slave_almostfull_signal"},
		{lhs => "rdclk_control_slave_status_almostempty_signal",
		 rhs => "rdclk_control_slave_almostempty_signal"},

                # full and empty flags assignments
                {lhs => "rdclk_control_slave_event_full_signal",
                 rhs => "rdclk_control_slave_full_pulse"},
                {lhs => "rdclk_control_slave_event_empty_signal",
                 rhs => "rdclk_control_slave_empty_pulse"},

		{lhs => "rdclk_control_slave_status_full_signal",
		 rhs => "rdclk_control_slave_full_signal"},
		{lhs => "rdclk_control_slave_status_empty_signal",
		 rhs => "rdclk_control_slave_empty_signal"},

                # overflow and underflow flags assignments
                {lhs => "rdclk_control_slave_event_overflow_signal",
                 rhs => "rdoverflow"},
                {lhs => "rdclk_control_slave_event_underflow_signal",
                 rhs => "rdunderflow"},

		{lhs=> "rdclk_control_slave_status_overflow_signal",
		 rhs => "rdoverflow"},
		{lhs=> "rdclk_control_slave_status_underflow_signal",
		 rhs => "rdunderflow"},
                ),


            # Detection of empty condition. The level of the fifo must exceed the 
            # zero first, then decrease until empty. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of empty happen.
            # This is to prevent the empty being falsely triggered when enabled after power-up/reset.
            #
            e_assign->news(
                {lhs => "rdclk_control_slave_empty_signal",
                 rhs => "rdempty"},
                {lhs => "rdclk_control_slave_empty_pulse",
                 rhs => "rdclk_control_slave_empty_signal & rdclk_control_slave_empty_n_reg"},
            ),

            e_register->new({
                out => "rdclk_control_slave_empty_n_reg",
                in  => "!rdclk_control_slave_empty_signal",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n"}),

            # Detection of full condition. The level of the fifo must equal the 
            # maximum fifo depth first. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of full happen.
            #
            e_assign->news(
                {lhs => "rdclk_control_slave_full_signal",
                 rhs => "rdfull"},
                {lhs => "rdclk_control_slave_full_pulse",
                 rhs => "rdclk_control_slave_full_signal & rdclk_control_slave_full_n_reg"},
            ),

            e_register->new({
                out => "rdclk_control_slave_full_n_reg",
                in  => "!rdclk_control_slave_full_signal",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n"}),

            # Detection of almostempty condition. The level of the fifo must exceed the 
            # almostempty_threshold value first, then decrease until almostempty_threshold or less
            # value. Once that occur, a pulse of one clock cycle is generated to indicate the condition
            # of almostempty happen. This is to prevent the almostempty being falsely triggered
            # when enabled after power-up/reset.
            e_assign->news(
                {lhs => "rdclk_control_slave_almostempty_signal",
                 rhs => "rdlevel <= rdclk_control_slave_almostempty_threshold_register"},
                {lhs => "rdclk_control_slave_almostempty_pulse",
                 rhs => "rdclk_control_slave_almostempty_signal & rdclk_control_slave_almostempty_n_reg"},
            ),

            e_register->new({
                out => "rdclk_control_slave_almostempty_n_reg",
                in  => "!rdclk_control_slave_almostempty_signal",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n"}),

            # Detection of almostfull condition. Everytime the level of the fifo is equal or more than
            # almostfull_threshold value, a pulse of one clock cycle is generated to indicate the condition  
            # of almostfull happen.
            e_assign->news(
                {lhs => "rdclk_control_slave_almostfull_signal",
                 rhs => "rdlevel >= rdclk_control_slave_almostfull_threshold_register"},
                {lhs => "rdclk_control_slave_almostfull_pulse",
                 rhs => "rdclk_control_slave_almostfull_signal & rdclk_control_slave_almostfull_n_reg"},
            ),

            e_register->new({
                out => "rdclk_control_slave_almostfull_n_reg",
                in  => "!rdclk_control_slave_almostfull_signal",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n"}),

            # Define almostempty_threshold register. Default value
            # is $minimum_threshold. Address Offset == 5
            e_register->new({
                out => "rdclk_control_slave_almostempty_threshold_register",
                in  => "rdclk_control_slave_threshold_writedata",
                clock => "rdclk",
                async_value => $minimum_threshold,
                enable => "(rdclk_control_slave_address == 5) & rdclk_control_slave_write",
                reset => "$rdclk_reset_n"}),

            # Define almostfull_threshold register. Default value
            # is $maximum_threshold. Address Offset == 4
            e_register->new({
                out => "rdclk_control_slave_almostfull_threshold_register",
                in  => "rdclk_control_slave_threshold_writedata",
                clock => "rdclk",
                async_value => $maximum_threshold,
                enable => "(rdclk_control_slave_address == 4) & rdclk_control_slave_write",
                reset => "$rdclk_reset_n"}),

            # Define IEnable register. There are $status_width bits of interrupt bits.
            # Default value is 0, i.e. All interrupts are diabled.
            # Address offset == 3
            e_register->new({
                out => e_signal->new(["rdclk_control_slave_ienable_register", $status_width]),
                in => "rdclk_control_slave_writedata[$status_width-1:0]",
                clock => "rdclk",
                enable => "(rdclk_control_slave_address == 3) & rdclk_control_slave_write",
                reset => "$rdclk_reset_n",}),

            # Define LEVEL register.
            # Address offset == 0
            e_assign->new(
                {lhs => e_signal->new(["rdclk_control_slave_level_register", $level_width]),
                 rhs => "rdlevel"},
            ),
        );

        # Define Event register. There are $status_width bits of events. Each bit is corresponding
        # to the status bits of the status signals. When a status signal is changing from
        # 0 to 1, the event register will become 1. Each bit of the event register can be cleared
        # independently by writing a 1 to the respective bit.
        # Address offset == 2
        my @event_reg_bits = ();
        foreach (@status_bits_signals)
        {
            my $event_regout = "rdclk_control_slave_event_".$_->[0]."_q";
            my $event_set  = "rdclk_control_slave_event_".$_->[0]."_signal";
            my $event_reset = "rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[".$_->[1]."]";
            push(@event_reg_bits, $event_regout);
            
            $mod->add_contents(
                e_register->new({
                    out => $event_regout,
                    clock => "rdclk",
                    enable => 1,
                    reset => "$rdclk_reset_n",
                    sync_set => $event_set,
                    sync_reset => "$event_reset",
                }),
            );
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["rdclk_control_slave_event_register", $status_width]),
                 rhs => &concatenate(@event_reg_bits)},
            ),
        );

        if($options->{Use_IRQ})
        {
            $mod->add_contents(
                e_assign->new(
                    {lhs => "rdclk_control_slave_irq",
                     rhs => "| (rdclk_control_slave_event_register & rdclk_control_slave_ienable_register)"},
                ),  
            );
        }


        # Define Status register. There are $status_width bits of status.
        # Address offset == 1. Read-Only.
        my @status_reg_bits = ();
        foreach(@status_bits_signals)
        {
            my $status_regin = "rdclk_control_slave_status_".$_->[0]."_signal";
            my $status_regout = "rdclk_control_slave_status_".$_->[0]."_q";

            $mod->add_contents(
                e_register->new({
                    out => $status_regout,
                    in  => $status_regin,
                    clock => "rdclk",
                    enable => 1,
                    reset => "$rdclk_reset_n",
                }),
            );
            push(@status_reg_bits, $status_regout);
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["rdclk_control_slave_status_register", $status_width]),
                 rhs => &concatenate(@status_reg_bits)},
            ),
        );

        #
        # Read from rdclk_control_slave 
        # User can read the registers from the component through the wrclk control slave.
        # 
        my @rdclk_control_slave_read_mux_table = (
        "rdclk_control_slave_address == 0" => "rdclk_control_slave_level_register",
        "rdclk_control_slave_address == 1" => "rdclk_control_slave_status_register",
        "rdclk_control_slave_address == 2" => "rdclk_control_slave_event_register",
        "rdclk_control_slave_address == 3" => "rdclk_control_slave_ienable_register",
        "rdclk_control_slave_address == 4" => "rdclk_control_slave_almostfull_threshold_register",
        "rdclk_control_slave_address == 5" => "rdclk_control_slave_almostempty_threshold_register",
        );

        $mod->add_contents(
            e_mux->new({
                lhs => "rdclk_control_slave_read_mux",
                table => \@rdclk_control_slave_read_mux_table,
                type => "and-or",
                default => "rdclk_control_slave_level_register",}),

            e_register->new({
                out => "rdclk_control_slave_readdata",
                in  => "rdclk_control_slave_read_mux",
                clock => "rdclk",
                enable => "rdclk_control_slave_read",
                reset => "$rdclk_reset_n",
            }),
        );
    }
}
#######################################################################################
#
# Define SCFIFO with control logic by instantiating the SCFIFO.
#
#######################################################################################
sub define_scfifo_with_controls
{
    my $proj = shift;
    my $options = shift;

    my $use_usedw = 0;
    my $use_full = 1;
    my $use_empty = 1;

    # use usedw if the following condition
    my $need_level = 0;
    if($options->{Use_AvalonST_Sink} & $options->{Use_Backpressure})
    {
	$need_level = 1; # need to export level register
    }

    my %port_map_hash = 
    (
        data => 'data',
        wrreq => 'wrreq',
        rdreq => 'rdreq',
        clock => 'clock',
        aclr => "~$wrclk_reset_n",

        q => 'q',
        full => 'full',
        empty => 'empty',
    );
    
    # This 2 signal is output from <name> "_scfifo_with_controls" module
    # It is only used internally in $proj->top(), never export this out of top
    # BUG: without this, it will export out of top if Use_Backpressure=false
    $proj->top()->add_contents
    (
        e_signal->new({name=>"empty",never_export=>1}),
        e_signal->new({name=>"full",never_export=>1}),
    );

    if($options->{Use_Write_Control} | $need_level)
    {
        $use_usedw = 1;
        $port_map_hash{"usedw"} = "usedw";
    }

	if($options->{Use_Backpressure})  
    {
        $port_map_hash{"wrreq"} = "wrreq_valid";
    }
	
    &define_scfifo($proj,
                   $options->{Device_Family},
                   $proj->top()->name()."_single_clock_fifo",
                   $options->{FIFO_Depth},
                   $options->{FIFO_Width},
                   $options->{Use_Register},
                   $use_usedw,
		   $use_full,
		   $use_empty);

    # The threshold range values are the allowable threshold values
    # for almostfull_threshold and almostempty_threshold registers.
    # When trying to write a value that is out of the range, the value
    # is ignored and maximum_threshold or minimum_threshold will be used
    # instead. The default almostempty_threshold register value is minimum_threshold
    # and the default almostfull_threshold register value is maximum_threshold.
    my $minimum_threshold = 1;
    my $maximum_threshold = $options->{FIFO_Depth}-1;

    # Calculate the LEVEL register width
    # The LEVEL register is the concatenation of USEDW[] and FULL.
    my $fifo_widthu = log2($options->{FIFO_Depth});
    my $fifo_widthu_ceil = ceil (log2($options->{FIFO_Depth}));
    if ($fifo_widthu != $fifo_widthu_ceil)
    {
        &ribbit("FIFO depth need to be power of 2.");
    }
    my $level_width = $fifo_widthu + 1;

    # Define the width of iEnable, Event, and Status registers
    # The status bits are mapped as following:
    #      Bits   :    5      4      3     2     1     0
    #      Status :    U      O     AME   AMF    E     F
    # Where U   = Underflow    AME = AlmostEmpty    E   = Empty
    #       O   = Overflow     AMF = AlomostFull    F   = Full
    #
    my @status_bits_signals = &get_status_bits_signals();

    # Get the total number of status signals
    my $status_width = @status_bits_signals; 

    my $mod = e_module->new({name => $proj->top()->name()."_scfifo_with_controls"});
    $proj->add_module($mod);

    $mod->add_contents(
        # Instantiate SCFIFO
        e_instance->new
        ({
            name => "the_scfifo",
            module => $proj->top()->name()."_single_clock_fifo",
            port_map =>
                {
                    %port_map_hash,
                },
        }),

        # Export the full, empty signals.
        e_signal->news(
            ["full", 1, 1],
            ["empty", 1, 1],
        ),
    );

    ###############################################
    #
    # Define the level signal when write control
    # is used or $need_level is true.
    #
    ###############################################
    if($options->{Use_Write_Control} | $need_level)
    {
        # Define the LEVEL output signal
        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["level", $level_width]),
                 rhs => &concatenate("full", "usedw")},
            ),
        );

	# Only export the level if needed.
	if($need_level)
	{
	    $mod->add_contents(
		e_signal->new(
		    ["level", $level_width, 1],
		),
	    );
	}
    }
	
	
	if($options->{Use_Backpressure})   
    {
        $mod->add_contents(
        e_assign->news(
            {lhs => e_signal->new(["wrreq_valid", 1]),
             rhs => "wrreq & ~full"},
		)
		);
	}
						  
    ###############################################
    #
    # The following signals are needed only when 
    # control slave is used.
    #
    ###############################################
    if($options->{Use_Write_Control})
    {
        $mod->add_contents(
            # Define overflow and underflow signals. Overflow occurs when writing to a full FIFO.
            # Underflow occurs when reading from an empty FIFO.
            e_assign->news(
                {lhs => "overflow",
                 rhs => "wrreq & full"},
                {lhs => "underflow",
                 rhs => "rdreq & empty"},
            ),
        );
    }


    if($options->{Use_Write_Control})
    {
        $mod->add_contents(
           e_assign->news(
                #
                # The almost*_threshold registers values must within
                # the range defined by minimum_threshold and maximum_threshold
                # values. If user setting exceeds the range, the minimum and
                # maximum will be used for almostempty_threshold and
                # almostfull_threshold respectively.
                #
                {lhs => e_signal->new(["wrclk_control_slave_threshold_writedata", $level_width]),
                 rhs => "(wrclk_control_slave_writedata < $minimum_threshold) ? $minimum_threshold :
                         (wrclk_control_slave_writedata > $maximum_threshold) ? $maximum_threshold :
                          wrclk_control_slave_writedata[$level_width-1:0]"},

                #
                # Define the Status signals. There are $status_width bits of status bits.
                #
                # almostfull and almostempty flags assignments
                {lhs => "wrclk_control_slave_event_almostfull_signal",
                 rhs => "wrclk_control_slave_almostfull_pulse"},
                {lhs => "wrclk_control_slave_event_almostempty_signal",
                 rhs => "wrclk_control_slave_almostempty_pulse"},

		{lhs => "wrclk_control_slave_status_almostfull_signal",
		 rhs => "wrclk_control_slave_almostfull_signal"},
		{lhs => "wrclk_control_slave_status_almostempty_signal",
		 rhs => "wrclk_control_slave_almostempty_signal"},

                # full and empty flags assignments
                {lhs => "wrclk_control_slave_event_full_signal",
                 rhs => "wrclk_control_slave_full_pulse"},
                {lhs => "wrclk_control_slave_event_empty_signal",
                 rhs => "wrclk_control_slave_empty_pulse"},

		{lhs => "wrclk_control_slave_status_full_signal",
		 rhs => "wrclk_control_slave_full_signal"},
		{lhs => "wrclk_control_slave_status_empty_signal",
		 rhs => "wrclk_control_slave_empty_signal"},

                # overflow and underflow flags assignments
                {lhs => "wrclk_control_slave_event_overflow_signal",
                 rhs => "overflow"},
                 {lhs => "wrclk_control_slave_event_underflow_signal",
                 rhs => "underflow"},

		{lhs => "wrclk_control_slave_status_overflow_signal",
		 rhs => "overflow"},
		{lhs => "wrclk_control_slave_status_underflow_signal",
		 rhs => "underflow"},
                ),


            # Detection of empty condition. The level of the fifo must exceed the 
            # zero first, then decrease until empty. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of empty happen.
            # This is to prevent the empty being falsely triggered when enabled after power-up/reset.
            #
            e_assign->news(
                {lhs => "wrclk_control_slave_empty_signal",
                 rhs => "empty"},
                {lhs => "wrclk_control_slave_empty_pulse",
                 rhs => "wrclk_control_slave_empty_signal & wrclk_control_slave_empty_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_empty_n_reg",
                in  => "!wrclk_control_slave_empty_signal",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of full condition. The level of the fifo must equal the 
            # maximum fifo depth first. Once that occur, a pulse of one clock
            # cycle is generated to indicate the condition of full happen.
            #
            e_assign->news(
                {lhs => "wrclk_control_slave_full_signal",
                 rhs => "full"},
                {lhs => "wrclk_control_slave_full_pulse",
                 rhs => "wrclk_control_slave_full_signal & wrclk_control_slave_full_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_full_n_reg",
                in  => "!wrclk_control_slave_full_signal",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of almostempty condition. The level of the fifo must exceed the 
            # almostempty_threshold value first, then decrease until almostempty_threshold or less
            # value. Once that occur, a pulse of one clock cycle is generated to indicate the condition
            # of almostempty happen. This is to prevent the almostempty being falsely triggered
            # when enabled after power-up/reset.
            e_assign->news(
                {lhs => "wrclk_control_slave_almostempty_signal",
                 rhs => "level <= wrclk_control_slave_almostempty_threshold_register"},
                {lhs => "wrclk_control_slave_almostempty_pulse",
                 rhs => "wrclk_control_slave_almostempty_signal & wrclk_control_slave_almostempty_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_almostempty_n_reg",
                in  => "!wrclk_control_slave_almostempty_signal",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Detection of almostfull condition. Everytime the level of the fifo is equal or more than
            # almostfull_threshold value, a pulse of one clock cycle is generated to indicate the condition  
            # of almostfull happen.
            e_assign->news(
                {lhs => "wrclk_control_slave_almostfull_signal",
                 rhs => "level >= wrclk_control_slave_almostfull_threshold_register"},
                {lhs => "wrclk_control_slave_almostfull_pulse",
                 rhs => "wrclk_control_slave_almostfull_signal & wrclk_control_slave_almostfull_n_reg"},
            ),

            e_register->new({
                out => "wrclk_control_slave_almostfull_n_reg",
                in  => "!wrclk_control_slave_almostfull_signal",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n"}),

            # Define almostempty_threshold register. Default value
            # is $minimum_threshold. Address Offset == 5
            e_register->new({
                out => "wrclk_control_slave_almostempty_threshold_register",
                in  => "wrclk_control_slave_threshold_writedata",
                clock => "clock",
                async_value => $minimum_threshold,
                enable => "(wrclk_control_slave_address == 5) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n"}),

            # Define almostfull_threshold register. Default value
            # is $maximum_threshold. Address Offset == 4
            e_register->new({
                out => "wrclk_control_slave_almostfull_threshold_register",
                in  => "wrclk_control_slave_threshold_writedata",
                clock => "clock",
                async_value => $maximum_threshold,
                enable => "(wrclk_control_slave_address == 4) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n"}),

            # Define IEnable register. There are $status_width bits of interrupt bits.
            # Default value is 0, i.e. All interrupts are diabled.
            # Address offset == 3
            e_register->new({
                out => e_signal->new(["wrclk_control_slave_ienable_register", $status_width]),
                in => "wrclk_control_slave_writedata[$status_width-1:0]",
                clock => "clock",
                enable => "(wrclk_control_slave_address == 3) & wrclk_control_slave_write",
                reset => "$wrclk_reset_n",}),

            # Define LEVEL register.
            # Address offset == 0
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_level_register", $level_width]),
                 rhs => "level"},
            ),
        );

        # Define Event register. There are $status_width bits of events. Each bit is corresponding
        # to the status bits of the status signals. When a status signal is changing from
        # 0 to 1, the event register will become 1. Each bit of the event register can be cleared
        # independently by writing a 1 to the respective bit.
        # Address offset == 2
        my @event_reg_bits = ();
        foreach (@status_bits_signals)
        {
            my $event_regout = "wrclk_control_slave_event_".$_->[0]."_q";
            my $event_set  = "wrclk_control_slave_event_".$_->[0]."_signal";
            my $event_reset = "wrclk_control_slave_write & 
                               (wrclk_control_slave_address == 2) &
                               wrclk_control_slave_writedata[".$_->[1]."]";
            push(@event_reg_bits, $event_regout);
            
            $mod->add_contents(
                e_register->new({
                    out => $event_regout,
                    clock => "clock",
                    enable => 1,
                    reset => "$wrclk_reset_n",
                    sync_set => $event_set,
                    sync_reset => "$event_reset",
                }),
            );
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_event_register", $status_width]),
                 rhs => &concatenate(@event_reg_bits)},
            ),
        );

        if($options->{Use_IRQ})
        {
            $mod->add_contents(
                e_assign->new(
                    {lhs => "wrclk_control_slave_irq",
                     rhs => "| (wrclk_control_slave_event_register & wrclk_control_slave_ienable_register)"},
                ),  
            );
        }


        # Define Status register. There are $status_width bits of status.
        # Address offset == 1. Read-Only.
        my @status_reg_bits = ();
        foreach(@status_bits_signals)
        {
            my $status_regin = "wrclk_control_slave_status_".$_->[0]."_signal";
            my $status_regout = "wrclk_control_slave_status_".$_->[0]."_q";

            $mod->add_contents(
                e_register->new({
                    out => $status_regout,
                    in  => $status_regin,
                    clock => "clock",
                    enable => 1,
                    reset => "$wrclk_reset_n",
                }),
            );
            push(@status_reg_bits, $status_regout);
        }

        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["wrclk_control_slave_status_register", $status_width]),
                 rhs => &concatenate(@status_reg_bits)},
            ),
        );

        #
        # Read from wrclk_control_slave 
        # User can read the registers from the component through the wrclk control slave.
        # 
        my @wrclk_control_slave_read_mux_table = (
        "wrclk_control_slave_address == 0" => "wrclk_control_slave_level_register",
        "wrclk_control_slave_address == 1" => "wrclk_control_slave_status_register",
        "wrclk_control_slave_address == 2" => "wrclk_control_slave_event_register",
        "wrclk_control_slave_address == 3" => "wrclk_control_slave_ienable_register",
        "wrclk_control_slave_address == 4" => "wrclk_control_slave_almostfull_threshold_register",
        "wrclk_control_slave_address == 5" => "wrclk_control_slave_almostempty_threshold_register",
        );

        $mod->add_contents(
            e_mux->new({
                lhs => "wrclk_control_slave_read_mux",
                table => \@wrclk_control_slave_read_mux_table,
                type => "and-or",
                default => "wrclk_control_slave_level_register",}),

            e_register->new({
                out => "wrclk_control_slave_readdata",
                in  => "wrclk_control_slave_read_mux",
                clock => "clock",
                enable => "wrclk_control_slave_read",
                reset => "$wrclk_reset_n",
            }),
        );
    }
}


#######################################################################################
#
# Connects the scfifo with controls and respective interfaces. Separate IEnable and
# Event registers are created for each control slave. Thus, if both control slaves
# are enabled, almostfull and almostempty IRQ may happen for both slaves independently
# depending on the settings of the respective threshold registers.
# 
# However, the empty and full interrupt, if enabled at both slaves, will happen  
# concurrently.
#
#######################################################################################

sub make_scfifo
{
    my $proj = shift;
    my $options = shift;

    e_instance->add({
        name => "the_scfifo_with_controls",
        module => $proj->top()->name()."_scfifo_with_controls",
    });
    
    if($options->{Use_AvalonMM_Write_Slave} && 
       $options->{Use_AvalonMM_Read_Slave} &&
       !$options->{Use_AvalonST_Source} &&
       !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM-AvalonMM Interface
        &make_avalonmm_avalonmm_interface($proj, $options);
    }
    elsif($options->{Use_AvalonMM_Write_Slave} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM/AvalonST Interface
        &make_avalonmm_avalonst_interface($proj, $options);
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonST_Source})
    {
        # AvalonST/AvalonMM Interface
        &make_avalonst_avalonmm_interface($proj, $options);
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonMM_Read_Slave})
    {
        # AvalonST/AvalonST Interface
        &make_avalonst_avalonst_interface($proj, $options);
    }
    else
    {
        &ribbit("Invalid Combination of Interfaces.\n");
    }
}

#######################################################################################
#
# This is to construct the AvalonST-AvalonST interface for the FIFO. The AvalonST
# Sink interface is used to read data from upstream AvalonST Source, and the AvalonST
# Source interface is feeding the data to the downstream AvalonST Sink.
#
#######################################################################################
sub make_avalonst_avalonst_interface
{
    my $proj = shift;
    my $options = shift;

    my @avalonst_sink_signals = &get_avalonst_signals($options, "");
    my @avalonst_source_signals = &get_avalonst_signals($options, "");

    my @avalonst_special_signals = ([valid => 1]);

    if($options->{Use_Backpressure})
    {
        push(@avalonst_special_signals, [ready => 1]);
    }

    e_signal->adds(map {["avalonst_sink_".$_->[0] => $_->[1]]} @avalonst_sink_signals, @avalonst_special_signals);
    e_signal->adds(map {["avalonst_source_".$_->[0] => $_->[1]]} @avalonst_source_signals, @avalonst_special_signals);

    # Define AvalonST sink slave signals
    my $avalonst_sink_type_map = { map {"avalonst_sink_".$_->[0] => $_->[0]}
                                         (@avalonst_sink_signals, @avalonst_special_signals) };
    # Define AvalonST sink slave signals
    my $avalonst_source_type_map = { map {"avalonst_source_".$_->[0] => $_->[0]}
                                         (@avalonst_source_signals, @avalonst_special_signals) };
    
    $avalonst_sink_type_map->{"$wrclk_reset_n"} = "reset_n";
    $avalonst_source_type_map->{"$rdclk_reset_n"} = "reset_n";

    if($options->{Single_Clock_Mode})
    {
        $avalonst_sink_type_map->{"wrclock"} = "clk";
        $avalonst_source_type_map->{"wrclock"} = "clk";
    }
    else
    {
        $avalonst_sink_type_map->{"wrclock"} = "clk";
        $avalonst_source_type_map->{"rdclock"} = "clk";
    }

    e_atlantic_slave->add({
        name => $avalonst_sink_cp_name,
        type_map => $avalonst_sink_type_map,
    });


    e_atlantic_master->add({
        name => $avalonst_source_cp_name,
        type_map => $avalonst_source_type_map,
    });

    my $total_width = 0;
    foreach(@avalonst_sink_signals)
    {
        $total_width = $total_width + $_->[1];
    };

    e_assign->adds(
        {lhs => e_signal->add([avalonst_sink_signals => $total_width]),
         rhs => &concatenate(map{"avalonst_sink_".$_->[0]}@avalonst_sink_signals)},
        {lhs => &concatenate(map{"avalonst_source_".$_->[0]}@avalonst_source_signals),
         rhs => e_signal->add([avalonst_source_signals => $total_width])},
    );

	if($options->{Use_Backpressure})   
	{
	# used to stop fifo from continue accepting data while external interface is being back pressured 
	e_assign->adds(
		{lhs => e_signal->add(["no_stop_write" =>1]),
		 rhs => "(ready_selector & ready_1) | (!ready_selector & ready_0)"},
    );
			
	e_assign->add(
        {lhs => "wrreq",
         rhs => "avalonst_sink_valid & no_stop_write_d1"}, 
	);

			
	
	if($options->{Single_Clock_Mode})
    {
	    # AvalonST sink ready signal need special handling
	    # to avoid data overflow at the FIFO when the FIFO
	    # can only take one last data. Originally, ready signal
	    # was !full.
	    # However, the ready signal was taking two clock
	    # cycles before it get deasserted although the FIFO
	    # can only take one last data. This is because the source
	    # will take one cycle to produce data. The valid data will
	    # only be consumed by the sink at the second clock edge,
	    # where the FIFO becomes full. If the ready is asserted for
	    # two clock cycles, the source will potentially produce two
	    # data and the second data will be lost! 
	    # When there is only one last space available at the 
            # sink FIFO, the ready signal should be deasserted as soon
	    # as datavalid is asserted. If the sink FIFO have more than
	    # depth-1 space available(not last space), then ready signal
	    # will still remain !full.
		e_assign->adds(
		{lhs => "ready_1",
		 rhs => "!full"},
		{lhs => "ready_0",
		 rhs => "!full & !avalonst_sink_valid"},
	    );
		
		##  my $last_word = $options->{FIFO_Depth}-1;
		my $last_word = $options->{FIFO_Depth}-1; 
	    e_assign->adds(
		{lhs => "ready_selector",
		 rhs => "(level < $last_word)"},
	    );
		
		
		e_register->add({
                out => "no_stop_write_d1",
                in  => "no_stop_write",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n",}
		);
	}
	else
	{
	    # AvalonST sink ready signal need special handling
	    # to avoid data overflow at the FIFO when the FIFO
	    # can only take one last data. Originally, ready signal
	    # was !full.
	    # However, the ready signal was taking two clock
	    # cycles before it get deasserted although the FIFO
	    # can only take one last data. This is because the source
	    # will take one cycle to produce data. The valid data will
	    # only be consumed by the sink at the second clock edge,
	    # where the FIFO becomes full. If the ready is asserted for
	    # two clock cycles, the source will potentially produce two
	    # data and the second data will be lost! 
	    # When there is only one last space available at the 
            # sink FIFO, the ready signal should be deasserted as soon
	    # as datavalid is asserted. If the sink FIFO have more than
	    # depth-1 space available(not last space), then ready signal
	    # will still remain !full.
		e_assign->adds(
		{lhs => "ready_1",
		 rhs => "!wrfull"},
		{lhs => "ready_0",
		 rhs => "!wrfull & !avalonst_sink_valid"},
	    );

	    ##  my $last_word = $options->{FIFO_Depth}-1;
	    my $last_word = $options->{FIFO_Depth}-4;  ## DCFIFO maximum depth is DEPTH-3, hence last word is DEPTH-4
	    e_assign->adds(
		{lhs => "ready_selector",
		 rhs => "(wrlevel < $last_word)"},
	    );
		
	
		e_register->add({
                out => "no_stop_write_d1",
                in  => "no_stop_write",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n",}
		);

	}
	}
	else
	{
		e_assign->add(
        {lhs => "wrreq",
         rhs => "avalonst_sink_valid"}, 
	);
	}
	
	
    if($options->{Single_Clock_Mode})
    {
        # Connect to the FIFO
        e_assign->adds(
            {lhs => "data",
             rhs => "avalonst_sink_signals"},
            {lhs => "avalonst_source_signals",
             rhs => "q"},
            {lhs => "clock",
             rhs => "wrclock"},
        );

        if($options->{Use_Backpressure})
        {
        # AvalonST Sink data to FIFO
        e_assign->adds(
			{lhs => "avalonst_sink_ready",
			rhs => "no_stop_write"},   
        );
		}

        # Connect control signals for the AvalonST Source interface
        if($options->{Use_Backpressure})
        {
            e_register->adds({
                out => "avalonst_source_valid",
                in  => "avalonst_source_ready & !empty",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });

            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "avalonst_source_ready & !empty"},
            );
        }
        else
        {
            e_register->adds({
                out => "avalonst_source_valid",
                in  => "!empty",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });


            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!empty"},
            );
        }
    }
    else
    {   # Dual Clock Mode

        # Connect to the FIFO
        e_assign->adds(
            {lhs => "data",
             rhs => "avalonst_sink_signals"},
            {lhs => "avalonst_source_signals",
             rhs => "q"},
            {lhs => "wrclk",
             rhs => "wrclock"},
            {lhs => "rdclk",
             rhs => "rdclock"},
        );

        if($options->{Use_Backpressure})
        {
        # AvalonST Sink data to FIFO
        e_assign->adds(
			{lhs => "avalonst_sink_ready",
			rhs => "no_stop_write & no_stop_write_d1"},   
        );
        }

        # Connect control signals for the AvalonST Source interface

        if($options->{Use_Backpressure})
        {
            e_register->adds({
                out => "avalonst_source_valid",
                in  => "avalonst_source_ready & !rdempty",
                clock => "rdclock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });

            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "avalonst_source_ready & !rdempty"},
            );
        }
        else
        {
            e_register->adds({
                out => "avalonst_source_valid",
                in  => "!rdempty",
                clock => "rdclock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });


            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!rdempty"},
            );
        }
    }
}

#######################################################################################
#
# Return the AvalonST signals that are used for AvalonST-AvalonST interface. The
# availability of signals are based on the AvalonST parameter settings such as widths
# of error and channel, bits_per_symbol and symbols_per_beat, use_packet.
#
#######################################################################################
sub get_avalonst_signals
{
    my $options = shift;
    my $prefix_name = shift;

    my @avalonst_signals = ();

    # Some useful widths
    my $error_width = $options->{Error_Width};
    my $channel_width = $options->{Channel_Width};
    my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
    my $data_width = $options->{Symbols_Per_Beat} * $options->{Bits_Per_Symbol};

    if($options->{Use_Packet})
    {
        push(@avalonst_signals,
             [$prefix_name."startofpacket" => 1],
             [$prefix_name."endofpacket" => 1]);

        if($empty_width > 0)
        {
            push(@avalonst_signals, [$prefix_name."empty" => $empty_width]);
        }
    }

    if($channel_width > 0)
    {
        push(@avalonst_signals, [$prefix_name."channel" => $channel_width]);
    }

    if($error_width > 0)
    {
        push(@avalonst_signals, [$prefix_name."error" => $error_width]);
    }

    push(@avalonst_signals, [$prefix_name."data" => $data_width]);

    return @avalonst_signals;
}

#######################################################################################
#
# This is to construct the AvalonST-AvalonMM interface for the FIFO. The AvalonMM Read
# Slave is used to read the data from the memory map of the AvalonMM slave, and the 
# AvalonST Sink is the interface that getting the data from the AvalonST world.
#
#######################################################################################
sub make_avalonst_avalonmm_interface
{
    my $proj = shift;
    my $options = shift;

    if($options->{cyclesPerBeat} == 1)
    {
        #
        # Each clock cycle will pop one beat from the FIFO.
        #
        &create_avalonst_to_avalonmm_with_one_read_per_beat($proj, $options);
    }
    else
    {
        &ribbit("Configuration not supported: Bits Per Symbol = $options->{Bits_Per_Symbol}; Symbols Per Beat = $options->{Symbols_Per_Beat}\n");
    }
}

######################################################################################
#
# Creat logics for mapping one AvalonST beat per AvalonMM read.
#
######################################################################################
sub create_avalonst_to_avalonmm_with_one_read_per_beat
{
    my $proj = shift;
    my $options = shift;

    if($options->{cyclesPerBeat} != 1)
    {
         &ribbit("Mapping one AvalonMM read from one AvalonST beat is
                 incorrect because the interface pair need $options->{cyclesPerBeat} 
                 AvalonMM read per AvalonST beat\n");
    }

    my @read_slave_signals = &get_avalonmm_slave_signals($proj, $options, "avalonmm_read_slave", $avalonmm_read_slave_cp_name);

    # Define AvalonMM read slave signals
    my $read_slave_type_map = {map {"avalonmm_read_slave_".$_->[0] => $_->[0]}
                                    @read_slave_signals};

    $read_slave_type_map->{"$rdclk_reset_n"} = "reset_n";
    if($options->{Single_Clock_Mode})
    {
	$read_slave_type_map->{"wrclock"} = "clk";
    }
    else
    {
	$read_slave_type_map->{"rdclock"} = "clk";
    }

    e_avalon_slave->add({
        name => $avalonmm_read_slave_cp_name,
        type_map => $read_slave_type_map,
    });

    e_signal->adds(map{["avalonmm_read_slave_".$_->[0],
                        $_->[1]]} @read_slave_signals);

    # Connect the optional waitrequest signals
    if($options->{Use_Backpressure})
    {
	# De-assert waitrequest if reading from the base+1, so that
	# the avalonmm master can still read the status of last 
	# data item in the FIFO.
	e_assign->adds(
	    {lhs => e_signal->add(["deassert_waitrequest" => 1]),
	     rhs => "avalonmm_read_slave_address & avalonmm_read_slave_read"},
	);

        if($options->{Single_Clock_Mode})
        {
            e_assign->adds(
                {lhs => "avalonmm_read_slave_waitrequest",
                 rhs => "!deassert_waitrequest & empty"},
            );
        }
        else
        {
            e_assign->adds(
                {lhs => "avalonmm_read_slave_waitrequest",
                 rhs => "!deassert_waitrequest & rdempty"},
            );
        }
    }

    #
    # Connect the signals for FIFO to the AvalonMM read slave
    #
    &define_map_avalonst_to_avalonmm($proj, $options);
    e_instance->add
    ({
        name => "the_map_avalonst_to_avalonmm",
        module => $proj->top()->name()."_map_avalonst_to_avalonmm",
        port_map =>
            {
                avalonmm_data => 'avalonmm_map_data_out',
                avalonst_data => 'avalonst_map_data_in',
            },
    });

    # Read data from FIFO when (address == 0 & read). FIFO handle underflow checking.
    my $rdreq_driver = "(avalonmm_read_slave_address == 0) & avalonmm_read_slave_read";

    if($options->{Single_Clock_Mode})
    {
        e_assign->adds(
            {lhs => "clock",
             rhs => "wrclock"}, 
        );
    }
    else
    {
        e_assign->adds(
            {lhs => "wrclk",
             rhs => "wrclock"},
            {lhs => "rdclk",
             rhs => "rdclock"},
        );
    }

    e_assign->adds(
        {lhs => "rdreq_driver",
         rhs => $rdreq_driver},
        {lhs => "avalonst_map_data_in",
         rhs => "q"},
        {lhs => "rdreq",
         rhs => "rdreq_driver"},
    );

    # AvalonST Sink data to FIFO
    e_assign->adds(
        {lhs => "data",
         rhs => e_signal->add(["avalonst_sink_data" => $options->{FIFO_Width}])},
    );

	if($options->{Use_Backpressure})
	{
	e_assign->adds(
		{lhs => "wrreq",
         rhs => "avalonst_sink_valid & no_stop_write_d1"}, # FIFO checks for overflow 
	);
	
	# used to stop fifo from continue accepting data while external interface is being back pressured
	e_assign->adds(
		{lhs => e_signal->add(["no_stop_write" =>1]),
		 rhs => "(ready_selector & ready_1) | (!ready_selector & ready_0)"},
            );
			
	if($options->{Single_Clock_Mode})
    {
	    # AvalonST sink ready signal need special handling
	    # to avoid data overflow at the FIFO when the FIFO
	    # can only take one last data. Originally, ready signal
	    # was !full.
	    # However, the ready signal was taking two clock
	    # cycles before it get deasserted although the FIFO
	    # can only take one last data. This is because the source
	    # will take one cycle to produce data. The valid data will
	    # only be consumed by the sink at the second clock edge,
	    # where the FIFO becomes full. If the ready is asserted for
	    # two clock cycles, the source will potentially produce two
	    # data and the second data will be lost! 
	    # When there is only one last space available at the 
            # sink FIFO, the ready signal should be deasserted as soon
	    # as datavalid is asserted. If the sink FIFO have more than
	    # depth-1 space available(not last space), then ready signal
	    # will still remain !full.
		e_assign->adds(
		{lhs => "ready_1",
		 rhs => "!full"},
		{lhs => "ready_0",
		 rhs => "!full & !avalonst_sink_valid"},
	    );
		
		##  my $last_word = $options->{FIFO_Depth}-1;
		my $last_word = $options->{FIFO_Depth}-1; 
	    e_assign->adds(
		{lhs => "ready_selector",
		 rhs => "(level < $last_word)"},
	    );
		

		e_register->add({
                out => "no_stop_write_d1",
                in  => "no_stop_write",
                clock => "clock",
                enable => 1,
                reset => "$wrclk_reset_n",}
		);
	}
	else
	{
	    # AvalonST sink ready signal need special handling
	    # to avoid data overflow at the FIFO when the FIFO
	    # can only take one last data. Originally, ready signal
	    # was !full.
	    # However, the ready signal was taking two clock
	    # cycles before it get deasserted although the FIFO
	    # can only take one last data. This is because the source
	    # will take one cycle to produce data. The valid data will
	    # only be consumed by the sink at the second clock edge,
	    # where the FIFO becomes full. If the ready is asserted for
	    # two clock cycles, the source will potentially produce two
	    # data and the second data will be lost! 
	    # When there is only one last space available at the 
            # sink FIFO, the ready signal should be deasserted as soon
	    # as datavalid is asserted. If the sink FIFO have more than
	    # depth-1 space available(not last space), then ready signal
	    # will still remain !full.
		e_assign->adds(
		{lhs => "ready_1",
		 rhs => "!wrfull"},
		{lhs => "ready_0",
		 rhs => "!wrfull & !avalonst_sink_valid"},
	    );

	    ##  my $last_word = $options->{FIFO_Depth}-1;
	    my $last_word = $options->{FIFO_Depth}-4;  ## DCFIFO maximum depth is DEPTH-3, hence last word is DEPTH-4
	    e_assign->adds(
		{lhs => "ready_selector",
		 rhs => "(wrlevel < $last_word)"},
	    );
		

		e_register->add({
                out => "no_stop_write_d1",
                in  => "no_stop_write",
                clock => "wrclk",
                enable => 1,
                reset => "$wrclk_reset_n",}
		);
	}
	}
	else
	{
	e_assign->add(
        {lhs => "wrreq",
         rhs => "avalonst_sink_valid"}, 
	);
	}
	
    if($options->{Use_Backpressure})
    {
        # AvalonST Sink data to FIFO
            e_assign->adds(
		{lhs => "avalonst_sink_ready",
		 rhs => "no_stop_write & no_stop_write_d1"}, 
            );
    }

    #
    # AvalonST Sink other info to FIFO
    #

    #
    # Construct mapping and fifo for other info. 
    #
    
    # Decide if we need to construct fifo other info.
    my $need_fifo_other_info = 0;
    
    if (($options->{Error_Width} > 0) || ($options->{Channel_Width} > 0) || ($options->{Use_Packet}))
    {
        $need_fifo_other_info = 1;
    }
    
    if ($need_fifo_other_info)
    {
        my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
        my $packet_info_width = 0;
        my @avalonst_other_info_signals = ();
    
        if($options->{Error_Width} > 0)
        {
            e_signal->add(
                [avalonst_sink_error => $options->{Error_Width}],
            );
            push(@avalonst_other_info_signals, "avalonst_sink_error");
        }
    
    
        if($options->{Channel_Width} > 0)
        {
            e_signal->add(
                [avalonst_sink_channel => $options->{Channel_Width}],
            );
            push(@avalonst_other_info_signals, "avalonst_sink_channel");
        }
    
        if($options->{Use_Packet})
        {
            $packet_info_width = $empty_width + 2;
            if($empty_width!=0)
            {
                e_signal->add(
                    [avalonst_sink_empty => $empty_width],
                );
                push(@avalonst_other_info_signals, "avalonst_sink_empty");
            }
    
            e_signal->adds(
                [avalonst_sink_startofpacket => 1],
                [avalonst_sink_endofpacket => 1],
            );
            push(@avalonst_other_info_signals, "avalonst_sink_endofpacket", "avalonst_sink_startofpacket");
        }
    
        my $other_info_fifo_width = $packet_info_width + $options->{Error_Width} + $options->{Channel_Width};
    
        # Define and instantiate FIFO for other info signals
        if($options->{Single_Clock_Mode})
        {
            &define_scfifo($proj,
                           $options->{Device_Family},
                           $proj->top()->name()."_single_clock_fifo_for_other_info",
                           $options->{FIFO_Depth},
                           $other_info_fifo_width,
                           $options->{Use_Register},
                           0,
    		       0,
    		       0);
    
			if($options->{Use_Backpressure})
			{
            # Pop out other info from FIFO when (address == 1 & read), i.e. when the data is read
            e_instance->add
            ({
                name => "the_scfifo_other_info",
                module => $proj->top()->name()."_single_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => &concatenate(@avalonst_other_info_signals),
                        wrreq => 'avalonst_sink_valid & no_stop_write_d1', # FIFO take care of overflow checking 
                        rdreq => $rdreq_driver,    
                        clock => 'clock',    # Use common clock
                        aclr => "~$wrclk_reset_n",
    
                        q => 'avalonst_other_info_map_in',
                    },
            });
			}
			else
			{
			e_instance->add
            ({
                name => "the_scfifo_other_info",
                module => $proj->top()->name()."_single_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => &concatenate(@avalonst_other_info_signals),
                        wrreq => 'avalonst_sink_valid', # FIFO take care of overflow checking 
                        rdreq => $rdreq_driver,    
                        clock => 'clock',    # Use common clock
                        aclr => "~$wrclk_reset_n",
                        q => 'avalonst_other_info_map_in',
                    },
            });
			}
        }
        else
        {
            &define_dcfifo($proj,
                           $options->{Device_Family},
                           $proj->top()->name()."_dual_clock_fifo_for_other_info",
                           $options->{FIFO_Depth},
                           $other_info_fifo_width,
                           $options->{Use_Register},
                           0, #no rdusedw
                           0, #no wrusedw
                           0, #no rdfull
                           0, #no wrempty
                           0, #no wrfull
                           0);#no rdempty
    
			if($options->{Use_Backpressure})
			{
            # Pop out other info from FIFO when (address == 0 & read), i.e. when the data is read
            e_instance->add
            ({
                name => "the_dcfifo_other_info",
                module => $proj->top()->name()."_dual_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => &concatenate(@avalonst_other_info_signals),
                        wrreq => 'avalonst_sink_valid & no_stop_write_d1', # FIFO take care of overflow checking  
                        rdreq => $rdreq_driver,    
                        wrclk => 'wrclk',
                        rdclk => 'rdclk',
                        aclr => "~$wrclk_reset_n",
    
                        q => 'avalonst_other_info_map_in',
                    },
            });
			}
			else  
			{
			e_instance->add
            ({
                name => "the_dcfifo_other_info",
                module => $proj->top()->name()."_dual_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => &concatenate(@avalonst_other_info_signals),
                        wrreq => 'avalonst_sink_valid', # FIFO take care of overflow checking  
                        rdreq => $rdreq_driver,    
                        wrclk => 'wrclk',
                        rdclk => 'rdclk',
                        aclr => "~$wrclk_reset_n",
                        q => 'avalonst_other_info_map_in',
                    },
            });
			}
        }
    
        &define_map_avalonst_to_avalonmm_other_info($proj, $options);
        e_instance->add
        ({
            name => "the_map_avalonst_to_avalonmm_other_info",
            module => $proj->top()->name()."_map_avalonst_to_avalonmm_other_info",
            port_map =>
                {
                    avalonmm_other_info => "avalonmm_other_info_map_out",
                    avalonst_other_info => "avalonst_other_info_map_in",
                },
        });
    }

    if ($need_fifo_other_info)
    {
        # Read from AvalonMM Read Slave 
        # User can read the output from the FIFO through the AvalonMM read slave.
        # Read from error/channel/packetinfo fifo when (address == 0 & read)
        # Read from data fifo when (address == 1 & read)
        if($options->{Single_Clock_Mode})
        {
            e_register->add({
                out => "avalonmm_read_slave_address_delayed",
                in  => "avalonmm_read_slave_address",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });

            e_register->add({
                out => "avalonmm_read_slave_read_delayed",
                in  => "avalonmm_read_slave_read",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
        else
        {
            e_register->add({
                out => "avalonmm_read_slave_address_delayed",
                in  => "avalonmm_read_slave_address",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n",
            });

            e_register->add({
                out => "avalonmm_read_slave_read_delayed",
                in  => "avalonmm_read_slave_read",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
	    
        my @avalonmm_read_slave_read_mux_table = (
	        "(avalonmm_read_slave_address_delayed == 1) & avalonmm_read_slave_read_delayed" => "avalonmm_other_info_map_out",
	        "(avalonmm_read_slave_address_delayed == 0) & avalonmm_read_slave_read_delayed" => "avalonmm_map_data_out",
	    );
	
	    e_mux->add({
	        lhs => "avalonmm_read_slave_readdata",
	        table => \@avalonmm_read_slave_read_mux_table,
	        type => "and-or",
	        });
    }
    else
    {
        e_assign->adds(
	        {lhs => "avalonmm_read_slave_readdata",
	         rhs => "avalonmm_map_data_out"},
	    );
    }
    
    # Map Avalon-ST signals
    my @avalonst_sink_signals = &get_avalonst_signals($options, "");
    my @avalonst_special_signals = ([valid => 1]);

    if($options->{Use_Backpressure})
    {
        push(@avalonst_special_signals, [ready => 1]);
    }
    my $avalonst_sink_type_map = {map {"avalonst_sink_".$_->[0] => $_->[0]}
					(@avalonst_sink_signals, @avalonst_special_signals)};

    $avalonst_sink_type_map->{"$wrclk_reset_n"} = "reset_n";

    # Always use wrclock regardless of single or dual clock mode.
    $avalonst_sink_type_map->{"wrclock"} = "clk";

    e_atlantic_slave->add({
	name => $avalonst_sink_cp_name,
	type_map => $avalonst_sink_type_map,
    });
}

######################################################################################
#
# Define the mapping of other info signals from AvalonST to AvalonMM interface.
#
######################################################################################
sub define_map_avalonst_to_avalonmm_other_info
{
    my $proj = shift;
    my $options = shift;

    my $mod = e_module->new({name => $proj->top()->name()."_map_avalonst_to_avalonmm_other_info"});
    $proj->add_module($mod);

    # Calculate some useful widths
    my $error_width = $options->{Error_Width};
    my $channel_width = $options->{Channel_Width};
    my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
    my $packet_info_width = 0;

    if($options->{Use_Packet})
    {
        $packet_info_width = $empty_width + 2;
    }

    my $avalonst_other_info_width = $error_width + $channel_width + $packet_info_width;
    my $avalonmm_other_info_width = $options->{AvalonMM_AvalonST_Data_Width};

    # Define the input and output signals
    $mod->add_contents(
        e_signal->news(
            [avalonmm_other_info => $avalonmm_other_info_width],
            [avalonst_other_info => $avalonst_other_info_width],
        ),
    );

    # Calculate boundaries for error, channel, sop, and eop signals in AvalonST
    my $sop_index = -1;
    my $eop_index = -1;
    my $empty_low_index = -1;
    my $empty_high_index = -1;
    my $channel_low_index = -1;
    my $channel_high_index = -1;
    my $error_low_index = -1;
    my $error_high_index = -1;

    my $next_index = 0;

    if($options->{Use_Packet})
    {
        $sop_index = $next_index;
        $eop_index = $sop_index + 1;
        $next_index = $eop_index + 1;

        if($empty_width > 0)
        {
            $empty_low_index = $next_index;
            $empty_high_index = $empty_low_index + $empty_width - 1;
            $next_index = $empty_high_index + 1;
        }
    }

    if($channel_width > 0)
    {
        $channel_low_index = $next_index;
        $channel_high_index = $channel_low_index + $channel_width - 1;
        $next_index = $channel_high_index + 1;
    }

    if($error_width > 0)
    {
        $error_low_index = $next_index;
        $error_high_index = $error_low_index + $error_width - 1;
        $next_index = $error_high_index + 1;
    }

    # Make sure the indexes are correct.
    if($avalonst_other_info_width != $next_index)
    {
        &ribbit("Incorrect index for other info mapping from AvalonST to AvalonMM\n");
    }

    my @other_info = ();
    if($options->{Use_Packet})
    {
        push(@other_info,
             ["sop" => 1],
             ["eop" => 1],
             ["empty" => $empty_width]);
    }
    else
    {
        push(@other_info,
             ["sop" => 0],
             ["eop" => 0],
             ["empty" => 0]);
    }

    push(@other_info,
         ["channel" => $channel_width],
         ["error" => $error_width]);

    foreach(@other_info)
    {
        if($_->[0] eq "sop")
        {
            my $sop_rhs;
            if($_->[1] == 0)
            {
                $sop_rhs = "1'b0";
            }
            else
            {
                $sop_rhs = "avalonst_other_info[$sop_index]";
            }
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new([avalonmm_sop => 1]),
                     rhs => $sop_rhs},
                ),
            );
        }
        if($_->[0] eq "eop")
        {
            my $eop_rhs;
            if($_->[1] == 0)
            {
                $eop_rhs = "1'b0";
            }
            else
            {
                $eop_rhs = "avalonst_other_info[$eop_index]";
            }
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new([avalonmm_eop => 1]),
                     rhs => $eop_rhs},
                ),
            );

        }

        ## Empty field occupies only 5 bits, i.e. maximum symbols per beat is 32.
        ## The lowest 8 bits of the Avalon Map should consist of 1 unused bit, 5 empty bits, 1 eop bit and 1 sop bit.
        ## The empty field is zero padded accordingly to make it 6 bits wide if the empty width is less than 6 bits.
        if($_->[0] eq "empty")
        {
            my $empty_rhs;
            if($_->[1] == 0)
            {
                $empty_rhs = "6'b0";
            }
            elsif($_->[1] < 6)
            {
                $empty_rhs = &concatenate(6-$empty_width."'b0", "avalonst_other_info[$empty_high_index:$empty_low_index]");
            }
            else
            {
                $empty_rhs = "avalonst_other_info[$empty_high_index:$empty_low_index]";
            }
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new([avalonmm_empty => 6]),
                     rhs => $empty_rhs},
                ),
            );
        }
        if($_->[0] eq "channel")
        {
            my $channel_rhs;
            if($_->[1] == 0)
            {
                $channel_rhs = "8'b0";
            }
            elsif($_->[1] < 8)
            {
                $channel_rhs = &concatenate(8-$channel_width."'b0", "avalonst_other_info[$channel_high_index:$channel_low_index]");
            }
            else
            {
                $channel_rhs = "avalonst_other_info[$channel_high_index:$channel_low_index]";
            }
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new([avalonmm_channel => 8]),
                     rhs => $channel_rhs},
                ),
            );
        }
        if($_->[0] eq "error")
        {
            my $error_rhs;
            if($_->[1] == 0)
            {
                $error_rhs = "8'b0";
            }
            elsif($_->[1] < 8)
            {
                $error_rhs = &concatenate(8-$error_width."'b0", "avalonst_other_info[$error_high_index:$error_low_index]");
            }
            else
            {
                $error_rhs = "avalonst_other_info[$error_high_index:$error_low_index]";
            }
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new([avalonmm_error => 8]),
                     rhs => $error_rhs},
                ),
            );
        }
    }

    my @avalonmm_signals = ();
    push(@avalonmm_signals,
         "8'b0",
         "avalonmm_error",
         "avalonmm_channel",
         "avalonmm_empty",
         "avalonmm_eop",
         "avalonmm_sop");

    $mod->add_contents(
        e_assign->new(
            {lhs => "avalonmm_other_info",
             rhs => &concatenate(@avalonmm_signals)},
        ),
    );
}




######################################################################################
#
# Define the mapping of data signal from AvalonST to AvalonMM interface.
#
######################################################################################
sub define_map_avalonst_to_avalonmm
{
    my $proj = shift;
    my $options = shift;

    my $mod = e_module->new({name => $proj->top()->name()."_map_avalonst_to_avalonmm"});
    $proj->add_module($mod);

    # Define the AvalonMM and AvalonST data signals
    $mod->add_contents(
        e_signal->news(
            [avalonmm_data => $options->{maximumSymbolsPerCycle} * $options->{avalonMMBitsPerSymbol}],
            [avalonst_data => $options->{maximumSymbolsPerCycle} * $options->{Bits_Per_Symbol}],
        ),
    );

    my $index;
    my $avalonmm_high_index;
    my $avalonmm_low_index;
    my $avalonst_high_index;
    my $avalonst_low_index;
    my $avalonmm_max_high_index;

    for($index = 0; $index < $options->{maximumSymbolsPerCycle}; $index++)
    {
        # Define ranges for AvalonMM data
        # Use Bits_Per_Symbol instead of avalonMMBitsPerSymbol when calculating
        # high index.
        $avalonmm_low_index = $index * $options->{avalonMMBitsPerSymbol};
        $avalonmm_high_index = $avalonmm_low_index + $options->{Bits_Per_Symbol} - 1;

        # Possible maximum highest index
        $avalonmm_max_high_index = $avalonmm_low_index + $options->{avalonMMBitsPerSymbol} - 1;

        # Define ranges for AvalonST data
        $avalonst_low_index = ($options->{maximumSymbolsPerCycle} - $index - 1) * $options->{Bits_Per_Symbol};
        $avalonst_high_index = $avalonst_low_index + $options->{Bits_Per_Symbol} - 1;
 
        $mod->add_contents(
            e_assign->new(
                {lhs => "avalonmm_data[$avalonmm_high_index : $avalonmm_low_index]",
                 rhs => "avalonst_data[$avalonst_high_index : $avalonst_low_index]"},
            ),
        );

        if($avalonmm_max_high_index > $avalonmm_high_index)
        {
            # Fill up the gap with 0
            $mod->add_contents(
                e_assign->new(
                    {lhs => "avalonmm_data[$avalonmm_max_high_index:$avalonmm_high_index+1]",
                     rhs => $avalonmm_max_high_index-$avalonmm_high_index."'b0"},
                ),
            );
        }
    }
}

#######################################################################################
#
# This is to construct the AvalonMM-AvalonST interface for the FIFO. The AvalonMM Write
# Slave is used to write the data into the memory map of the AvalonMM slave, and the 
# AvalonST Source is the interface that spitting out the data to the AvalonST world.
#
#######################################################################################
sub make_avalonmm_avalonst_interface
{
    my $proj = shift;
    my $options = shift;

    if($options->{cyclesPerBeat} == 1)
    {
        #
        # Each clock cycle will push one beat into the FIFO.
        #
        &create_avalonmm_to_avalonst_with_one_write_per_beat($proj, $options);
    }
    else
    {
        &ribbit("Configuration not supported: Bits Per Symbol = $options->{Bits_Per_Symbol}; Symbols Per Beat = $options->{Symbols_Per_Beat}\n");
    }
}

######################################################################################
#
# Create logics for mapping one AvalonMM write per AvalonST beat.
#
######################################################################################
sub create_avalonmm_to_avalonst_with_one_write_per_beat
{
    my $proj = shift;
    my $options = shift;

    if($options->{cyclesPerBeat} != 1)
    {
        &ribbit("Mapping one AvalonMM write to one AvalonST beat is
                 incorrect because the interface pair need $options->{cyclesPerBeat} 
                 AvalonMM write per AvalonST beat\n");
    }

    my @write_slave_signals = &get_avalonmm_slave_signals($proj, $options, "avalonmm_write_slave", $avalonmm_write_slave_cp_name);

    # Define AvalonMM write slave signals
    my $write_slave_type_map = { map {"avalonmm_write_slave_".$_->[0] => $_->[0]}
                                         @write_slave_signals };

    # Always use wrclock regardless of single or dual clock mode.
    $write_slave_type_map->{"wrclock"} = "clk";
    $write_slave_type_map->{"$wrclk_reset_n"} = "reset_n";
    e_avalon_slave->add({
        name => $avalonmm_write_slave_cp_name,
        type_map => $write_slave_type_map,
    });

    e_signal->adds( map {["avalonmm_write_slave_".$_->[0],
                          $_->[1]]} @write_slave_signals);

    # Connect the optional waitrequest signals
    if($options->{Use_Backpressure})
    {
        if($options->{Single_Clock_Mode})
        {
            e_assign->adds(
                {lhs => "avalonmm_write_slave_waitrequest",
                 rhs => "full"},
            );
        }
        else
        {
            e_assign->adds(
                {lhs => "avalonmm_write_slave_waitrequest",
                 rhs => "wrfull"},
            );
        }
    }

    #
    # Connect the signals for the AvalonMM write slave to FIFO
    #

    # Add an AvalonMM to AvalonST mapping module
    &define_map_avalonmm_to_avalonst($proj, $options);
    e_instance->add
    ({
        name => "the_map_avalonmm_to_avalonst",
        module => $proj->top()->name()."_map_avalonmm_to_avalonst",
        port_map =>
            {
                avalonmm_data => 'avalonmm_map_data_in',
                avalonst_data => 'avalonst_map_data_out',
            },
    });

        # Write to FIFO when (address == 0 & write). FIFO handle overflow checking.
    my $wrreq_driver = "(avalonmm_write_slave_address == 0) & avalonmm_write_slave_write";

    e_assign->adds(
        {lhs => "wrreq_driver",
         rhs => $wrreq_driver},
        {lhs => "avalonmm_map_data_in",
         rhs => "avalonmm_write_slave_writedata"},
        {lhs => "wrreq",
         rhs => "wrreq_driver"},
	{lhs => "data",
	 rhs => "avalonst_map_data_out"},
    );

    if($options->{Single_Clock_Mode})
    {
        e_assign->adds(
            {lhs => "clock",
             rhs => "wrclock"},
        );
    }
    else
    {
        e_assign->adds(
            {lhs => "wrclk",
             rhs => "wrclock"},
            {lhs => "rdclk",
             rhs => "rdclock"},
        );
    }

	# Decide if we need a info fifo
	my $need_other_info_fifo = 0;
	if ($options->{Use_Packet} || ($options->{Error_Width} > 0) || ($options->{Channel_Width} > 0))
	{
        $need_other_info_fifo = 1;
	}
	
    if ($need_other_info_fifo)
    {
        # Write to error/channel/packetinfo registers when (address == 1 & write).
        my $enable_other_info_register = "(avalonmm_write_slave_address == 1) & avalonmm_write_slave_write";
    
        #
        # Construct mapping and fifo for other info. 
        #
        my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
        my $packet_info_width = 0;
        if($options->{Use_Packet})
        {
            $packet_info_width = $empty_width + 2;
        }
        my $other_info_fifo_width = $packet_info_width + $options->{Error_Width} + $options->{Channel_Width};
    
        # Define and instantiate FIFO for other info signals
        if($options->{Single_Clock_Mode})
        {
            &define_scfifo($proj,
                           $options->{Device_Family},
                           $proj->top()->name()."_single_clock_fifo_for_other_info",
                           $options->{FIFO_Depth},
                           $other_info_fifo_width,
                           $options->{Use_Register},
                           0,
                           0,
                  	       0);
            e_instance->add
            ({
                name => "the_scfifo_other_info",
                module => $proj->top()->name()."_single_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => 'avalonst_other_info',
                        wrreq => 'wrreq_driver & ~full',   
                        rdreq => 'rdreq_i',
                        clock => 'clock',
                        aclr => "~$wrclk_reset_n",
    
                        q => 'q_i',
                    },
            });
        }
        else
        {
            &define_dcfifo($proj,
                           $options->{Device_Family},
                           $proj->top()->name()."_dual_clock_fifo_for_other_info",
                           $options->{FIFO_Depth},
                           $other_info_fifo_width,
                           $options->{Use_Register},
                           0, #no rdusedw
                           0, #no wrusedw
                           0, #no rdfull
                           0, #no wrempty
                	       0, #no wrfull
                           0);#no rdempty
            e_instance->add
            ({
                name => "the_dcfifo_other_info",
                module => $proj->top()->name()."_dual_clock_fifo_for_other_info",
                port_map =>
                    {
                        data => 'avalonst_other_info',
                        wrreq => 'wrreq_driver & ~wrfull',  
                        rdreq => 'rdreq_i',
                        wrclk => 'wrclk',
                        rdclk => 'rdclk',
                        aclr => "~$wrclk_reset_n",
    
                        q => 'q_i',
                    },
            });
        }
    
    
        # Define and instantiate the mapping of AvalonMM-to-AvalonST for other info signals
        &define_map_avalonmm_to_avalonst_other_info($proj, $options);
        if($options->{Single_Clock_Mode})
        {
            e_instance->add
            ({
                name => "the_map_avalonmm_to_avalonst_other_info",
                module => $proj->top()->name()."_map_avalonmm_to_avalonst_other_info",
                port_map =>
                    {
                        avalonmm_other_info => "avalonmm_write_slave_writedata",
                        auto_clr => "wrreq_driver & !full", # Only clear sop and eop when a valid write occurs
                        enable => $enable_other_info_register,
                        clock => "clock",
                        reset_n => "$wrclk_reset_n",
    
                        avalonst_other_info => "avalonst_other_info",
                    },
            });
        }
        else
        {
            e_instance->add
            ({
                name => "the_map_avalonmm_to_avalonst_other_info",
                module => $proj->top()->name()."_map_avalonmm_to_avalonst_other_info",
                port_map =>
                    {
                        avalonmm_other_info => "avalonmm_write_slave_writedata",
                        auto_clr => "wrreq_driver & !wrfull", # Only clear sop and eop when a valid write occurs
                        enable => $enable_other_info_register,
                        clock => "wrclk",
                        reset_n => "$wrclk_reset_n",
    
                        avalonst_other_info => "avalonst_other_info",
                    },
            });
        }
    
    
        #
        # Construct the AvalonST Interface
        #
        &define_map_fifo_other_info_to_avalonst($proj, $options);
        e_instance->add
        ({
            name => "the_map_fifo_other_info_to_avalonst",
            module => $proj->top()->name()."_map_fifo_other_info_to_avalonst",
            port_map =>
                {
                    data_in => "q_i",
                },
        });
    }
    
    e_assign->adds(
            {lhs => e_signal->add([avalonst_source_data => $options->{maximumSymbolsPerCycle} * $options->{Bits_Per_Symbol}]),
             rhs => "q"},
    );

    if($options->{Use_Backpressure})
    {
        if($options->{Single_Clock_Mode})
        {
            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!empty & avalonst_source_ready"},
            );
            
            if ($need_other_info_fifo){
                e_assign->adds(
                    {lhs => "rdreq_i",
                     rhs => "rdreq"},
                );
            }
            
            e_register->add({
                out => "avalonst_source_valid",
                in  => "!empty & avalonst_source_ready",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
        else
        {
            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!rdempty & avalonst_source_ready"},
            );
            
            if ($need_other_info_fifo){
                e_assign->adds(
                    {lhs => "rdreq_i",
                     rhs => "rdreq"},
                );
            }

            e_register->add({
                out => "avalonst_source_valid",
                in  => "!rdempty & avalonst_source_ready",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
    }
    else
    {
        if($options->{Single_Clock_Mode})
        {
            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!empty"},
            );

            if ($need_other_info_fifo){
                e_assign->adds(
                    {lhs => "rdreq_i",
                     rhs => "rdreq"},
                );
            }

            e_register->add({
                out => "avalonst_source_valid",
                in  => "!empty",
                clock => "clock",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
        else
        {
            e_assign->adds(
                {lhs => "rdreq",
                 rhs => "!rdempty"},
            );

            if ($need_other_info_fifo){
                e_assign->adds(
                    {lhs => "rdreq_i",
                     rhs => "rdreq"},
                );
            }

            e_register->add({
                out => "avalonst_source_valid",
                in  => "!rdempty",
                clock => "rdclk",
                enable => 1,
                reset => "$rdclk_reset_n",
            });
        }
    }

    # Map Avalon-ST signals to port wiring
    my @avalonst_source_signals = &get_avalonst_signals($options, "");
    my @avalonst_special_signals = ([valid => 1]);
    if($options->{Use_Backpressure})
    {
	push(@avalonst_special_signals, [ready => 1]);
    }

    my $avalonst_source_type_map = {map {"avalonst_source_".$_->[0] => $_->[0]}
					(@avalonst_source_signals, @avalonst_special_signals)};

    $avalonst_source_type_map->{"$rdclk_reset_n"} = "reset_n";
    if($options->{Single_Clock_Mode})
    {
	$avalonst_source_type_map->{"wrclock"} = "clk";
    }
    else
    {
	$avalonst_source_type_map->{"rdclock"} = "clk";
    }

    e_atlantic_master->add({
	name => $avalonst_source_cp_name,
	type_map => $avalonst_source_type_map,
    });
}

######################################################################################
#
# Define the mapping of other signals from FIFO to AvalonST interface.
#
######################################################################################
sub define_map_fifo_other_info_to_avalonst
{
    my $proj = shift;
    my $options = shift;

    my $mod = e_module->new({name => $proj->top()->name()."_map_fifo_other_info_to_avalonst"});
    $proj->add_module($mod);

    # Calculate some useful widths
    my $error_width = $options->{Error_Width};
    my $channel_width = $options->{Channel_Width};
    my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
    my $packet_info_width = 0;

    if($options->{Use_Packet})
    {
        $packet_info_width = $empty_width + 2;
    }

    my $total_other_info_width = $error_width + $channel_width + $packet_info_width;
    my @avalonst_signals = ();

    $mod->add_contents(
        e_signal->new(
            ["data_in" => $total_other_info_width],
        ),
    );

    if($error_width > 0)
    {
        $mod->add_contents(
            e_signal->new(
                ["avalonst_source_error" => $error_width],
            ),
        );
        push(@avalonst_signals, "avalonst_source_error");
    }

    if($channel_width > 0)
    {
        $mod->add_contents(
            e_signal->new(
                ["avalonst_source_channel" => $channel_width],
            ),
        );
        push(@avalonst_signals, "avalonst_source_channel");
    }

    if($options->{Use_Packet})
    {
       if($empty_width > 0)
        {
            $mod->add_contents(
                e_signal->new(
                    ["avalonst_source_empty" => $empty_width],
                ),
            );
            push(@avalonst_signals, "avalonst_source_empty");
        }

       $mod->add_contents(
           e_signal->news(
               ["avalonst_source_endofpacket" => 1],
               ["avalonst_source_startofpacket" => 1],
           ),
       );
       push(@avalonst_signals, "avalonst_source_endofpacket", "avalonst_source_startofpacket");
    }

    $mod->add_contents(
        e_assign->new(
            {lhs => &concatenate(@avalonst_signals),
             rhs => "data_in"},
        ),
    );
}
######################################################################################
#
# Define the mapping of other signals from AvalonMM to AvalonST interface.
#
######################################################################################
sub define_map_avalonmm_to_avalonst_other_info
{
    my $proj = shift;
    my $options = shift;

    my $mod = e_module->new({name => $proj->top()->name()."_map_avalonmm_to_avalonst_other_info"});
    $proj->add_module($mod);

    # Calculate some useful widths
    my $error_width = $options->{Error_Width};
    my $channel_width = $options->{Channel_Width};
    my $empty_width = ceil(log2($options->{Symbols_Per_Beat}));
    my $packet_info_width = 0;

    if($options->{Use_Packet})
    {
        $packet_info_width = $empty_width + 2;
    }

    my $avalonst_other_info_width = $error_width + $channel_width + $packet_info_width;
    my $avalonmm_other_info_width = $options->{AvalonMM_AvalonST_Data_Width};

    # Define the input and output signals
    $mod->add_contents(
        e_signal->news(
            [avalonmm_other_info => $avalonmm_other_info_width],
            [avalonst_other_info => $avalonst_other_info_width],
        ),
    );


    # Hard coded boundaries for error, channel, sop, and eop signals
    my $sop_index = 0;
    my $eop_index = 1;
    my $empty_low_index = 2;
    my $empty_high_index = $empty_low_index + $empty_width - 1;
    my $channel_low_index = 8;
    my $channel_high_index = $channel_low_index + $channel_width - 1;
    my $error_low_index = 16;
    my $error_high_index = $error_low_index + $error_width - 1;

    my @avalonst_signals_register = ();

    if($error_width > 0)
    {
        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["error" => $error_width]),
                 rhs => "avalonmm_other_info[$error_high_index:$error_low_index]"},
            ),
        );
        push(@avalonst_signals_register, "error_q");
    }

    if($channel_width > 0)
    {
        $mod->add_contents(
            e_assign->new(
                {lhs => e_signal->new(["channel" => $channel_width]),
                 rhs => "avalonmm_other_info[$channel_high_index:$channel_low_index]"},
            ),
        );
        push(@avalonst_signals_register, "channel_q");
    }

    if($options->{Use_Packet})
    {
        if($empty_width != 0)
        {
            $mod->add_contents(
                e_assign->new(
                    {lhs => e_signal->new(["empty" => $empty_width]),
                     rhs => "avalonmm_other_info[$empty_high_index:$empty_low_index]"},
                ),
            );
            push(@avalonst_signals_register, "empty_q");
        }

        $mod->add_contents(
            e_assign->news(
                {lhs => e_signal->new(["sop" => 1]),
                 rhs => "avalonmm_other_info[$sop_index]"},
                {lhs => e_signal->new(["eop" => 1]),
                 rhs => "avalonmm_other_info[$eop_index]"},
            ),
        );

        push(@avalonst_signals_register, "eop_q", "sop_q");
    }

    # Concatenate the signals
    $mod->add_contents(
        e_assign->new(
            {lhs => "avalonst_other_info",
             rhs => &concatenate(@avalonst_signals_register)},
        ),
    );

    if($options->{Use_Packet})
    {
        $mod->add_contents(
            e_register->new({
                out => "sop_q",
                in  => "sop",
                clock => "clock",
                enable => "enable | auto_clr",
                sync_reset => "auto_clr",
                reset => "reset_n",
            }),
            e_register->new({
                out => "eop_q",
                in  => "eop",
                clock => "clock",
                enable => "enable | auto_clr",
                sync_reset => "auto_clr",
                reset => "reset_n",
           }),
        );

        if($empty_width != 0)
        {
            $mod->add_contents(
                e_register->new({
                    out => "empty_q",
                    in  => "empty",
                    clock => "clock",
                    enable => "enable",
                    reset => "reset_n",
                }),
            );
        }
    }

    if($error_width > 0)
    {
        $mod->add_contents(
            e_register->new({
               out => "error_q",
               in  => "error",
               clock => "clock",
               enable => "enable",
               reset => "reset_n",
            }),
        );
    }

    if($channel_width > 0)
    {
        $mod->add_contents(
            e_register->new({
               out => "channel_q",
               in  => "channel",
               clock => "clock",
               enable => "enable",
               reset => "reset_n",
            }),
        );
    }
}


######################################################################################
#
# Define the mapping of data signal from AvalonMM to AvalonST interface.
#
######################################################################################
sub define_map_avalonmm_to_avalonst
{
    my $proj = shift;
    my $options = shift;

    my $mod = e_module->new({name => $proj->top()->name()."_map_avalonmm_to_avalonst"});
    $proj->add_module($mod);

    # Define the AvalonMM and AvalonST data signals
    $mod->add_contents(
        e_signal->news(
            [avalonmm_data => $options->{maximumSymbolsPerCycle} * $options->{avalonMMBitsPerSymbol}],
            [avalonst_data => $options->{maximumSymbolsPerCycle} * $options->{Bits_Per_Symbol} ],
        ),
    );

    my $index;
    my $avalonmm_high_index;
    my $avalonmm_low_index;
    my $avalonst_high_index;
    my $avalonst_low_index;

    for($index = 0; $index < $options->{maximumSymbolsPerCycle}; $index++)
    {
        # Define ranges for AvalonMM data
        # Use Bits_Per_Symbol instead of avalonMMBitsPerSymbol when calculating
        # high index.
        $avalonmm_low_index = $index * $options->{avalonMMBitsPerSymbol};
        $avalonmm_high_index = $avalonmm_low_index + $options->{Bits_Per_Symbol} - 1;

        # Define ranges for AvalonST data
        $avalonst_low_index = ($options->{maximumSymbolsPerCycle} - $index - 1) * $options->{Bits_Per_Symbol};
        $avalonst_high_index = $avalonst_low_index + $options->{Bits_Per_Symbol} - 1;
 
        $mod->add_contents(
            e_assign->new(
                {lhs => "avalonst_data[$avalonst_high_index : $avalonst_low_index]",
                 rhs => "avalonmm_data[$avalonmm_high_index : $avalonmm_low_index]"},
            ),
        );
    }
}



######################################################################################
#
# This is to construct the AvalonMM-AvalonMM interfaces for read and write side of the FIFO
#
#######################################################################################
sub make_avalonmm_avalonmm_interface
{
    my $proj = shift;
    my $options = shift;

    my @read_slave_signals = &get_avalonmm_slave_signals($proj, $options, "avalonmm_read_slave", $avalonmm_read_slave_cp_name);
    my @write_slave_signals = &get_avalonmm_slave_signals($proj, $options, "avalonmm_write_slave", $avalonmm_write_slave_cp_name);

    # Define AvalonMM write slave signals
    my $write_slave_type_map = { map {"avalonmm_write_slave_".$_->[0] => $_->[0]}
                                         @write_slave_signals };

    $write_slave_type_map->{"wrclock"} = "clk";
    $write_slave_type_map->{"$wrclk_reset_n"} = "reset_n";

    e_avalon_slave->add({
        name => $avalonmm_write_slave_cp_name,
        type_map => $write_slave_type_map,
    });

    e_signal->adds( map {["avalonmm_write_slave_".$_->[0],
                          $_->[1]]} @write_slave_signals);

    # Define AvalonMM read slave signlas
    my $read_slave_type_map = { map {"avalonmm_read_slave_".$_->[0] => $_->[0]}
                                         @read_slave_signals };

    $read_slave_type_map->{"$rdclk_reset_n"} = "reset_n";
    if($options->{"Single_Clock_Mode"})
    {
        $read_slave_type_map->{"wrclock"} = "clk";
    }
    else
    {
        $read_slave_type_map->{"rdclock"} = "clk";
    }

    e_avalon_slave->add({
        name => $avalonmm_read_slave_cp_name,
        type_map => $read_slave_type_map,
    });

    e_signal->adds( map {["avalonmm_read_slave_".$_->[0],
                          $_->[1]]} @read_slave_signals);

    # Connecting the signals for the slaves
    e_assign->adds(
        {lhs => "data",
         rhs => "avalonmm_write_slave_writedata"},
        {lhs => "wrreq",
         rhs => "avalonmm_write_slave_write"},

        {lhs => "avalonmm_read_slave_readdata",
         rhs => "q"},
        {lhs => "rdreq",
         rhs => "avalonmm_read_slave_read"},
    );

    if($options->{"Single_Clock_Mode"})
    {
        e_assign->adds(
            {lhs => "clock",
             rhs => "wrclock"},
        );

        # Connect the optional waitrequest signals
        if($options->{Use_Backpressure})
        {
            e_assign->adds(
                {lhs => "avalonmm_write_slave_waitrequest",
                 rhs => "full"},
                {lhs => "avalonmm_read_slave_waitrequest",
                 rhs => "empty"},
            );
        }
    }
    else
    {
        e_assign->adds(
            {lhs => "rdclk",
             rhs => "rdclock"},
            {lhs => "wrclk",
             rhs => "wrclock"},
	);

        # Connect the optional waitrequest signals
        if($options->{Use_Backpressure})
        {
            e_assign->adds(
                {lhs => "avalonmm_write_slave_waitrequest",
                 rhs => "wrfull"},
                {lhs => "avalonmm_read_slave_waitrequest",
                 rhs => "rdempty"},
            );
        }	
    }
}

#######################################################################################
#
# The subroutine returns the set of required signals based on the name of the slave.
# Backpressure is optional, and it is determine from Use_Backpressure parameter.
#
#######################################################################################
sub get_avalonmm_slave_signals
{
    my $proj = shift;
    my $options = shift;
    my $slave_name = shift;
    my $slave_connection_point_name = shift;

    # Make sure slave name is defined.
    if(!$proj->SBI($slave_connection_point_name))
    {
        &ribbit("Unknown slave name $slave_connection_point_name\n");
    }

    my $data_width = $proj->SBI($slave_connection_point_name)->{Data_Width};
    my $address_width = $proj->SBI($slave_connection_point_name)->{Address_Width};

    my @slave_signals = ();

## No clock is included.    push(@slave_signals, [clk => 1]);

    if($options->{Use_AvalonMM_Write_Slave} &&
       $options->{Use_AvalonMM_Read_Slave} &&
       $slave_name eq "avalonmm_write_slave")
    {
        push(@slave_signals,
            [writedata => $data_width],
            [write => 1],
        );
    }
    elsif($options->{Use_AvalonMM_Write_Slave} &&
       $options->{Use_AvalonMM_Read_Slave} &&
       $slave_name eq "avalonmm_read_slave")
    {
        push(@slave_signals,
            [readdata => $data_width],
            [read => 1],
        );
    }
    elsif($options->{Use_AvalonMM_Write_Slave} &&
       $options->{Use_AvalonST_Source} &&
       $slave_name eq "avalonmm_write_slave")
    {
        push(@slave_signals,
            [writedata => $data_width],
            [write => 1],
            [address => $address_width],
        );
    }
    elsif($options->{Use_AvalonMM_Read_Slave} &&
       $options->{Use_AvalonST_Sink} &&
       $slave_name eq "avalonmm_read_slave")
    {
        push(@slave_signals,
            [readdata => $data_width],
            [read => 1],
            [address => $address_width],
        );
    }
    else
    {
        &ribbit("Unknown slave name $slave_name\n");
    }

    if($options->{Use_Backpressure})
    {
        push(@slave_signals, [waitrequest => 1]);
    }

    return @slave_signals;
}


#######################################################################################
#
#
#
#######################################################################################
sub make_dcfifo
{
    my $proj = shift;
    my $options = shift;

    e_instance->add({
        name => "the_dcfifo_with_controls",
        module => $proj->top()->name()."_dcfifo_with_controls",
    });
    
    if($options->{Use_AvalonMM_Write_Slave} && 
       $options->{Use_AvalonMM_Read_Slave} &&
       !$options->{Use_AvalonST_Source} &&
       !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM-AvalonMM Interface
        &make_avalonmm_avalonmm_interface($proj, $options);
    }
    elsif($options->{Use_AvalonMM_Write_Slave} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonST_Sink})
    {
        # AvalonMM/AvalonST Interface
        &make_avalonmm_avalonst_interface($proj, $options);
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonMM_Read_Slave} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonST_Source})
    {
        # AvalonST/AvalonMM Interface
        &make_avalonst_avalonmm_interface($proj, $options);
    }
    elsif($options->{Use_AvalonST_Sink} &&
          $options->{Use_AvalonST_Source} &&
          !$options->{Use_AvalonMM_Write_Slave} &&
          !$options->{Use_AvalonMM_Read_Slave})
    {
        # AvalonST/AvalonST Interface
        &make_avalonst_avalonst_interface($proj, $options);
    }
    else
    {
        &ribbit("Invalid Combination of Interfaces.\n");
    }
}

#######################################################################################
#
# Make the write control slave. The write control slave is optional. It is used to read
# and write the status/control registers at the write clock domain. When single clock
# fifo is used, the read_control_slave and the write_control_slave is using the same
# clock. Thus both will use the exact same LEVEL register value. If two control slaves
# are enabled at the same time, there will be two separate sets of registers for 
# almostfull_threshold, almostempty_threshold, event, enable registers.
#
# Each set can be set individually by the respective control slave and thus the IRQ 
# can be generated separately. However, it is not advisable to enable both control slaves 
# when the fifo is single clock FIFO because doing that will increase the resource usage. 
#
#######################################################################################
sub make_write_control
{
    my $proj = shift;
    my $options = shift;

    my @write_control_signals = &get_control_slave_signals($proj, $wrclk_control_slave_cp_name);
    my $write_control_slave_type_map = { map {"wrclk_control_slave_".$_->[0] => $_->[0]}
                                         @write_control_signals };

    e_avalon_slave->add({
        name => $wrclk_control_slave_cp_name,
        type_map => $write_control_slave_type_map,
    });

    e_signal->adds( map {["wrclk_control_slave_".$_->[0],
                          $_->[1],0,0,0]} @write_control_signals);
}

#######################################################################################
#
# Make the read control slave. The read control slave is optional. It is used to read
# and write the status/control registers at the read clock domain. When single clock
# fifo is used, the read_control_slave and the write_control_slave is using the same
# clock. Thus both will use the exact same LEVEL register value. If two control slaves
# are enabled at the same time, there will be two separate sets of registers for 
# almostfull_threshold, almostempty_threshold, event, enable registers.
#
# Each set can be set individually by the respective control slave and thus the IRQ 
# can be generated separately. However, it is not advisable to enable both control slaves 
# when the fifo is single clock FIFO because doing that will increase the resource usage. 
#
#######################################################################################
sub make_read_control
{
    my $proj = shift;
    my $options = shift;

    my @read_control_signals = &get_control_slave_signals($proj, $rdclk_control_slave_cp_name);
    my $read_control_slave_type_map = { map {"rdclk_control_slave_".$_->[0] => $_->[0]}
                                        @read_control_signals };
    e_avalon_slave->add({
        name => $rdclk_control_slave_cp_name,
        type_map => $read_control_slave_type_map,
    });

    e_signal->adds( map {["rdclk_control_slave_".$_->[0],
                          $_->[1],0,0,0]} @read_control_signals);
}

#######################################################################################
#
# Given the control slave's name, construct the control signals' names.
#
#######################################################################################
sub get_control_slave_signals
{
    my $proj = shift;
    my $control_slave_cp_name = shift;

    # Make sure slave name is defined.
    if(!$proj->SBI($control_slave_cp_name))
    {
        &ribbit("Unknown control slave name $control_slave_cp_name");
    }


    my $address_width = $proj->SBI($control_slave_cp_name)->{Address_Width};
    my $data_width = $proj->SBI($control_slave_cp_name)->{Data_Width};
    my $has_irq = $proj->SBI($control_slave_cp_name)->{Has_IRQ};

    my @control_slave_signals = ();
    push(@control_slave_signals,
        [clk => 1],
        [reset_n => 1],
        [address => $address_width],
        [writedata => $data_width],
        [readdata => $data_width],
        [write => 1],
        [read => 1],
    );

    if($has_irq)
    {
        push(@control_slave_signals,
            [irq => 1]);
    }

    return @control_slave_signals;
}

#######################################################################################
#
# Return the status signals names.
#
#######################################################################################
sub get_status_bits_signals
{
    my @status_bits_names = ();
    #
    # The list and the corresponding bit position must be in order.
    # MSB is coming first, with LSB at the bottom. 
    push(@status_bits_names,
        [underflow => 5],
        [overflow => 4],
        [almostempty => 3],
        [almostfull => 2],
        [empty => 1],
        [full => 0],
   );
    return @status_bits_names;
}
