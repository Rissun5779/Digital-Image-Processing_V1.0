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


#Copyright (C)1991-2002 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.

use strict;
use europa_all;
use e_jtag_project;

#----------------------------------------------------------------------------
#
# Module =>
#   <name from SOPC Builder Altera Avalon JTAG UART Component>.v(hd)
#
# Origin =>
# adraper and mroberts in the UK developed a verilog version of this part.
#jtag_avalon_link_v1.v and subcomponents are represented as Europa in this
#module.
#
# Description =>
# This device is intended to provide a communication chanel between the SLD
#JTAG Hub and an Avalon based SOPC System.  UART-like communication will be
#possible, and in fact UART's may be dropped from an SOPC system if this
#device is included...
#
# Structure =>
# Avalon Writes and Reads Data to or from simple fifo's; the fifo's use an
#Atlantic Bus style interface to talk to a JTAG core module.  The jtag_link
#core is conveniently abstracted into its own hierarchical submodule so that
#it may be replaced by a blind instance to an LPM later, when one is
#officially produced.
#
# Parameters =>
# There are 5 parameters that come from the GUI.  The first subroutine in this
#file should be '&validate_my_parameters', which shows what they are...
#
#----------------------------------------------------------------------------

  my $allow_legacy_signals;		
  my $write_depth;			
  my $read_depth;			
  my $write_threshold;		
  my $read_threshold;		
  my $read_char_stream;		
  my $showascii;			
  my $relativepath;			    
  my $read_le;			
  my $write_le;
  
  my $language;

## validate WSA parameters:
#
#   WIZARD_SCRIPT_ARGUMENTS
#   {
#      write_depth     = "64"; # max entries in write fifo
#      read_depth      = "64"; # max entries in read fifo
#      write_threshold = "8";  # Char's remaining in write fifo to trigger irq
#      read_threshold  = "8";  # Spaces in read fifo to trigger irq
#   }
#
sub validate_my_parameters 
{
  my ($Opt, $project) = (@_);

  &validate_parameter ({  # depth of write_fifo
    hash    => $Opt,
    name    => "write_depth",
    type    => "integer",
    allowed => [8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768],
    default => 64,
  });

  &validate_parameter ({  # depth of read_fifo
    hash    => $Opt,
    name    => "read_depth",
    type    => "integer",
    allowed => [8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768],
    default => 64,
  });

  &validate_parameter ({  # irq level of write_fifo
    hash    => $Opt,
    name    => "write_threshold",
    type    => "integer",
    allowed => [0 .. 255],
    default => 8,
  });

  &validate_parameter ({  # irq level of read_fifo
    hash    => $Opt,
    name    => "read_threshold",
    type    => "integer",
    allowed => [0 .. 255],
    default => 8,
  });

  #########################################################################################
  # copy config content from .tcl or derived parameter to local variable 
  #########################################################################################                                      
  $allow_legacy_signals = $Opt->{allow_legacy_signals};		
  $write_depth = $Opt->{write_depth};			
  $read_depth = $Opt->{read_depth};			
  $write_threshold = $Opt->{write_threshold};		
  $read_threshold = $Opt->{read_threshold};		
  $read_char_stream = $Opt->{read_char_stream};		
  $showascii = $Opt->{showascii};			
  $relativepath = $Opt->{relativepath};			    
  $read_le = $Opt->{read_le};			
  $write_le = $Opt->{write_le};
  $language = $Opt->{project_info}{language};
	
} # &validate_my_parameters

sub make_avalon_jtag
{
    my ($project, $Options, $module, $name) = (@_);
	
    #my $project = e_jtag_project->new(@_);
    #my %Options = %{$project->WSA()};
    #my $WSA = \%Options;
    #my $Get_options = {};
    
    # Grab the module that was created during handle_args.
    #my $module = $project->top();
    
    #$Get_options->{allow_legacy_signals} = $allow_legacy_signals;
	
    # poke interactive features into options hash to make it even sweeter:
    #my $int_in_section = 
    #    $project->spaceless_module_ptf($module->name())->{SIMULATION}{INTERACTIVE_IN};
    #my $int_out_section=
    #    $project->spaceless_module_ptf($module->name())->{SIMULATION}{INTERACTIVE_OUT};
    my $interactive_in = 0; # default to non-interactive mode.
    my $interactive_out= 0;     
    
    #my $int_key;
    #my $this_int_section;
    ## use foreach loop to avoid knowing the name of the INTERACTIVE section:
    #foreach $int_key (sort(keys (%{$int_in_section}))) {
    #    $this_int_section = $int_in_section->{$int_key};
    #    $interactive_in = $this_int_section->{enable};
    #}
    
    ## use foreach loop to avoid knowing the name of the INTERACTIVE section:
    #foreach $int_key (sort(keys (%{$int_out_section}))) {
    #    $this_int_section = $int_out_section->{$int_key};
    #    $interactive_out = $this_int_section->{enable};
    #    # print "$name: key = $int_key, enable = $interactive_out\n";
    #}
    
    # make sure my wizard script args are clean before building...
    &validate_my_parameters ($Options, $project);
    
    #my $version_file  = &ptf_parse::new_ptf_from_file
    #    ($project->_sopc_directory() . "/version.ptf");
    #my $major_version = &ptf_parse::get_data_by_path($version_file, "major");
    #&goldfish ("Warning: JTAG UART Component Requires ".
    #           "QuartusII Version 4.0SP1 or later.\n") if ($major_version < 4);

    ## back up any local system_build_dir/alt_jtag_atlantic.v, to force
    ## use of the quartusII4.0SP1+ installed version:

    my $alt_jtag_atlantic_file_root = "alt_jtag_atlantic.v";
    my $alt_jtag_atlantic_src =
        $project->_system_directory."/".$alt_jtag_atlantic_file_root;
    my $alt_jtag_atlantic_dst =
        $project->_system_directory."/".$alt_jtag_atlantic_file_root.".bak";
    if (-e $alt_jtag_atlantic_src) {
        print
            ("Warning: ALPHA file '".
             $alt_jtag_atlantic_src."'\n\tis being backed up to'".
             $alt_jtag_atlantic_dst."'\n\t'".
             $alt_jtag_atlantic_file_root."' should auto-link from Quartus".
             " install directory.\n");
        &Perlcopy ($alt_jtag_atlantic_src, $alt_jtag_atlantic_dst);
        unlink ($alt_jtag_atlantic_src);
    } # File Exists

    # Copy perl version of 'tail' if interactive out is selected.
    if ($interactive_out)
    {
        &Perlcopy ($project->_module_lib_dir . "/atail-f.pl",
                   $project->simulation_directory () . "/atail-f.pl" );
    } 
    
    ###
    ### Use Peter's new auto_instance_id generation
    ###
    my $instance_id = 0;
        #$project->assign_available_SLD_Node_Instance_Id ("avalon_jtag_slave");

    # Suppress warnings in design assistant
    if ($language =~ /verilog/i) {
        $module->add_attribute ( ALTERA_ATTRIBUTE => qq(SUPPRESS_DA_RULE_INTERNAL=\\"R101,C106,D101,D103\\")); 
    }
    else {
        $module->add_attribute ( ALTERA_ATTRIBUTE => qq(SUPPRESS_DA_RULE_INTERNAL=""R101,C106,D101,D103""));
    }

    # NB: SLD_Node_Info is mostly encapsulated in the alt_jtag_atlantic
    # megafunction -- it need not appear in any way in this file -- only the
    # instance_id is required to send into the alt_jtag_atlantic as a param.

    # SLD_Node_Info is the special identifying parameter for this module.
    # It must be unique.
    # my $SLD_Node_Info = 0;

    # Format of SLD_Node_Info is (courtesy Peter Hutkins):
    # +-----------+---------+-------------+---------------+
    # | 31     27 | 26   19 | 18        8 | 7           0 |
    # +-----------+---------+-------------+---------------+
    # | Node Ver  | Node ID | Node Mfg_ID | Node Inst ID  |
    # +-----------+---------+-------------+---------------+
    # (Ver of This|ID of This| Altera ID  |This Instance# )
    # +-----------+---------+-------------+---------------+
    # I arbitrarily selected Node ID as 0x81 because it's one higher than that
    # provided in the jtag_link_v1.v code.
    # $SLD_Node_Info |= ($sld_node_ver << 27); # Node Ver
    # $SLD_Node_Info |= ($sld_node_id  << 19); # Node ID
    # $SLD_Node_Info |= ($sld_mfg_id   << 8 ); # Mfg_ID (Altera)
    # $SLD_Node_Info |= ($instance_id & 0xff); # Node Inst ID

    # Establish I/O ports, avalon slave
    $module->add_contents
        (
         e_port->news
         (
          {name => "clk",            type => "clk"},
          {name => "rst_n",          type => "reset_n"},
          {name => "av_chipselect",  type => "chipselect"},
          {name => "av_address",     type => "address"},
          {name => "av_write_n",     type => "write_n"},
          {name => "av_writedata",   type => "writedata",
                                     width => 32},
          {name => "av_read_n",      type => "read_n"},
          {name => "av_readdata",    type => "readdata",
           direction => "output",    width => 32},
          {name => "av_waitrequest", type => "waitrequest",
           direction => "output"},
          {name => "av_irq",         type => "irq",
           direction => "output"},
          ), # I/O ports

         e_avalon_slave->new
         ({
             name     => "avalon_jtag_slave",
             type_map =>
             {
                 clk => "clk",
                 rst_n => "reset_n",
                 av_chipselect => "chipselect",
                 av_address => "address",
                 av_write_n => "write_n",
                 av_writedata => "writedata",
                 av_read_n => "read_n",
                 av_readdata => "readdata",
                 av_waitrequest => "waitrequest",
                 av_irq => "irq",
             },
         }), # Avalon slave

         ); # add_contents (I/O ports, slave)

    # Atlantic signals from fifo's to jtag_link submodule
    # Fifo width is always 8 (byte, char)
    my $FIFO_WIDTH = 8;
    #my $RD_WIDTHU = &ceil(&log2($read_depth));
    #my $WR_WIDTHU = &ceil(&log2($write_depth));
    # LOG2_??FIFO_DEPTH settings:
    my $RD_WIDTHU = &ceil(&log2($read_depth));
    my $WR_WIDTHU = &ceil(&log2($write_depth));

    # The JTAG module is instantiated slightly differently than the other
    # submodules, so that it may connect to the SLD hub.
    $module->add_contents
        (
         # special instance of JTAG, so that we can connect it to the hub
         # NB: Atlantic 'ports' are forcibly exported alt_jtag_atlantic/signals
         e_blind_instance->new
         ({
             name => $name."_alt_jtag_atlantic",
             module => 'alt_jtag_atlantic',
             tag => "synthesis",
             use_sim_models => 1,
             in_port_map =>
             {
                 # Avalon signals:
                 clk   => 'clk',
                 rst_n => 'rst_n',
                 r_val => 'r_val',
                 r_dat => 'r_dat',
                 t_dav => 't_dav',
                 # SLD Hub Signals:
                 # tck	=> 'open',
                 # tdi	=> 'open',
                 # rti	=> 'open',
                 # shift	=> 'open',
                 # update	=> 'open',
                 # usr1	=> 'open',
                 # clrn	=> 'open',
                 # ena	=> 'open',
                 # ir_in	=> 'open',
                 # raw_tck=> 'open',
                 # jtag_state_cdr => 'open',
                 # jtag_state_sdr => 'open',
                 # jtag_state_udr => 'open',
             },
             out_port_map =>
             {
                 # Avalon signals:
                 r_ena  => 'r_ena',
                 t_ena  => 't_ena',
                 t_dat  => 't_dat',
                 t_pause=> 't_pause',
                 # SLD Hub signals:
                 # tdo	=> 'open',
                 # irq	=> 'open',
                 # ir_out	=> 'open',
             },
             parameter_map =>
             {
                 #lpm_type           => qq("alt_jtag_atlantic"),
                 #lpm_hint           => qq("SLD_NODE_INFO=$SLD_Node_Info"),
                 #SLD_NODE_INFO => $SLD_Node_Info,
                 INSTANCE_ID => $instance_id,
                 LOG2_TXFIFO_DEPTH => $RD_WIDTHU,
                 LOG2_RXFIFO_DEPTH => $WR_WIDTHU,
                 SLD_AUTO_INSTANCE_INDEX => "\"YES\"",
             },
         }), # alt_jtag_atlantic instance
         
         # define "never export" signals, so that Q will suck them into the hub
         e_process->new
         ({
             tag => "simulation",
             clock => "clk",
             comment =>
                 " Tie off Atlantic Interface signals not used for simulation",
             contents =>
             [
              e_assign->news
              (
               ["sim_t_pause" => "1'b0"],
               ["sim_t_ena" => "1'b0"],
               ["sim_t_dat" => "t_dav ? r_dat : {".$FIFO_WIDTH."{r_val}}"],
               ["sim_r_ena" => "1'b0"],
               ),
              ], # contents
         }), # e_process
         e_assign->new
         ({
          tag => "simulation",
          lhs => "r_ena",
          rhs => "sim_r_ena",
         }),         
         e_assign->new
         ({
          tag => "simulation",
          lhs => "t_ena",
          rhs => "sim_t_ena",
         }),
         e_assign->new
         ({
          tag => "simulation",
          lhs => "t_dat",
          rhs => "sim_t_dat",
         }),
         e_assign->new
         ({
          tag => "simulation",
          lhs => "t_pause",
          rhs => "sim_t_pause",
         }),
         
         e_signal->news # ["signal", width, export, never_export]
         (
          ["tck",     1,  0,  1],
          ["tdi",     1,  0,  1],
          ["rti",     1,  0,  1],
          ["shift",   1,  0,  1],
          ["update",  1,  0,  1],
          ["usr1",    1,  0,  1],
          ["clrn",    1,  0,  1],
          ["ena",     1,  0,  1],
          ["ir_in",   2,  0,  1], # 8-bits wide?
          ["tdo",     1,  0,  1],
          ["irq",     1,  0,  1],
          ["ir_out",  2,  0,  1], # 8-bits wide?
          ),
         ); # add_contents (JTAG submodule)

    $module->add_contents
        (
         e_signal->news #: ["signal", width, export, never_export]
         (
          ["r_ena",     1,      0,      1],
          ["r_val",     1,      0,      1],
          ["r_dat", $FIFO_WIDTH,0,      1],
          ["t_dav",     1,      0,      1],
          ["t_ena",     1,      0,      1],
          ["t_dat", $FIFO_WIDTH,0,      1],
          ["t_pause",   1,      0,      1],
          ),
         ); # add_contents(Atlantic Signals)

    ###
    ### Set up character stream files, a-la UART, before we add fifo
    ###
    my $write_log_file  = $name . "_output_stream.dat";
    my $read_data_file  = $name . "_input_stream.dat";
    my $read_mutex_file = $name . "_input_mutex.dat";
    my $read_char_stream= $read_char_stream;
    #print "em_avalon_jtag: read_data_file = '$read_data_file'\n";
    #print "em_avalon_jtag: read_mutex_file= '$read_mutex_file'\n";
    #print "em_avalon_jtag: readcharstream = '$read_char_stream'\n";

    # Apologies to DVB: must make same character translations as UART
    # (see em_uart.pl/Setup_Input_Stream())

    # Allow certain backslash-escapes for 'funny' characters.
    # for now, we limit ourselves to "\n" and "\r" and "\"" for 
    # newline, carriage-return, and double-quote, respectively.
    my $newline      = "\n";
    my $cr           = "\n";
    my $double_quote = "\"";
    
    # First, convert any \n\r sequences into \n.  If by "\n\r" you meant
    # two carriage returns, you lose.
    $read_char_stream =~ s/\\n\\r/\n/sg;
    
    $read_char_stream     =~ s/\\n/$newline/sg;
    $read_char_stream     =~ s/\\r/$cr/sg;
    $read_char_stream     =~ s/\\\"/$double_quote/sg;
    # Now substitute CRLF-pairs for lone newline-chars, because GERMS likes it.
    my $crlf = "\n\r";
    $read_char_stream =~ s/\n/$crlf/smg;

    my $read_char_length = length ($read_char_stream);

    my $sim_dir_name = $project->simulation_directory();
    &Create_Dir_If_Needed($sim_dir_name);

    open (DATFILE, "> $sim_dir_name/$read_data_file") 
        or
        &ribbit("Cannot open $sim_dir_name/$read_data_file ($!)");

    my $read_size = 0;
    # always format as binary for jtag:
    foreach my $char (split (//, $read_char_stream)) {
        printf DATFILE "%08b\n", ord($char);
        $read_size++;
    }
    
#    printf ("em_avalon_jtag: got char_length = $read_char_length ; ".
#         "read_size = $read_size ; for char_stream:\n'$read_char_stream'\n");

    # Add null-terminator so q output is stable @ '0x0' if address is overrun.
    printf DATFILE "%08X\n", 0;
    close DATFILE;
    
    open (MUTFILE, "> $sim_dir_name/$read_mutex_file") 
        or 
        &ribbit("Cannot open $sim_dir_name/$read_mutex_file ($!)");
  
    # addr of terminal null is known unsafe in e_drom via this
    if ($interactive_in)
    { # force user to use interactive window if selected by making mutex 0
        printf MUTFILE "0\n";
        my $module_ptf = $project->module_ptf();
        # now modify exe, without using spaceless module ptf...
        my $i_i_exe =
            $module_ptf->{SIMULATION}->{"INTERACTIVE_IN drive"}->{exe};
        # kill everything after 'nios2_terminal' and rebuild
        $i_i_exe =~ s/ .*//;
        $i_i_exe .= " -t -M -n ".$name;
        $module_ptf->{SIMULATION}->{"INTERACTIVE_IN drive"}->{exe} =
            $i_i_exe;
    }
    else
    { # set up proper stream file size in Mutex:
       printf MUTFILE "%X\n", $read_size;
    }
    
    close MUTFILE;
    # end apology to DVB

    my $HEX_READ_DEPTH_STR =
        &Bits_To_Encode($read_depth).
        "'h".sprintf("%x",$read_depth);

    my $HEX_WRITE_DEPTH_STR =
        &Bits_To_Encode($write_depth).
        "'h".sprintf("%x",$write_depth);

    my $RD_EAB = qq("ON");
    $RD_EAB = qq("OFF") if ($read_le);

    my $WR_EAB = qq("ON");
    $WR_EAB = qq("OFF") if ($write_le);

    # Fifo instances:
    $module->add_contents
        (
         e_signal->news #: ["signal", width, export, never_export]
         (
          ["wfifo_used",   $WR_WIDTHU, 0, 1],
          ["rfifo_used",   $RD_WIDTHU, 0, 1],
          ["wfifo_empty",           1, 0, 1],
          ["rfifo_full",            1, 0, 1],
          ["fifo_wdata",  $FIFO_WIDTH, 0, 1],
          ["fifo_rdata",  $FIFO_WIDTH, 0, 1],
          ["fifo_wr",               1, 0, 1],
          ["fifo_rd",               1, 0, 1],
          ["fifo_EF",               1, 0, 1],
          ["fifo_FF",               1, 0, 1],
	  ["fifo_clear",            1, 0, 1],
          ), # fifo signals
         e_assign->news
         (
          ["rd_wfifo" => "(r_ena & ~wfifo_empty)"],
          ["wr_rfifo" => "(t_ena & ~rfifo_full)"],
          ), # safe req's to scfifos

	 e_assign->new
         (
          [fifo_clear => "~rst_n"]
	 ),

         e_instance->new
         ({
             module => e_module->new
                 ({
                     name => $name."_scfifo_w",
                     contents=>
                     [
                      e_blind_instance->new
                      ({
                          tag => "synthesis",
                          name => 'wfifo',
                          module => 'scfifo',
                          use_sim_models => 1,
                          in_port_map =>
                          {
                              clock => 'clk',
                              wrreq => 'fifo_wr',
                              data  => 'fifo_wdata',
                              rdreq => 'rd_wfifo',
			      aclr => 'fifo_clear'
                          },
                          out_port_map =>
                          {
                              usedw => 'wfifo_used',
                              full  => 'fifo_FF',
                              empty => 'wfifo_empty',
                              q     => 'r_dat',
                          },
                          parameter_map =>
                          {
                              lpm_type           => qq("scfifo"),
                              lpm_width          => $FIFO_WIDTH,
                              lpm_numwords       => $write_depth,
                              lpm_widthu         => $WR_WIDTHU,
                              lpm_showahead      => qq("OFF"),
                              overflow_checking  => qq("OFF"),
                              underflow_checking => qq("OFF"),
                              use_eab            => $WR_EAB,
                              lpm_hint           => qq("RAM_BLOCK_TYPE=AUTO"),
                          },
                      }), # wfifo instance
                      # the following are the simulation-only contents
                      # for emulating the scfifo outputs using e_log out...
                      # remove in/out interactive simulation, doesn't support in Qsys.
                      # display ascii char in transcript when receive data from master(like NIOS II)
                      e_instance->new
                      ({
                          tag => "simulation",
                          module => e_module->new
                              ({
                                  name => $name."_sim_scfifo_w",
                                  contents =>
                                      [
                      # e_log->new
                      # ({
                      #     name => $name."_log",
                      #     writememb => 1,
                      #     showascii => $showascii,
                      #     relativepath => $relativepath,
                      #     log_file => $write_log_file,
                      #     port_map  =>
                      #     {
                      #         "valid"	=> "fifo_wr",
                      #         "strobe"	=> "fifo_wr",
                      #         "data"	=> "fifo_wdata",
                      #     },
                      # }),
                      e_process->add 
                      ({ 
                        tag  => "simulation",
                        contents => [
                            e_if->new ({
                              tag  => "simulation",
                              condition       => "fifo_wr",
                              then            => [
                                  e_sim_write->new ({
                                    spec_string => '%c', 
                                    expressions => ["fifo_wdata"],
                                  })
                              ],
                            }),                        
                        ]
                      }), # process
                      e_assign->news
                      (
                       {
                           tag => "simulation",
                           lhs => "wfifo_used",
                           rhs => "{".$WR_WIDTHU."{1'b0}}",
                       },
                       {
                           tag => "simulation",
                           lhs => "r_dat",
                           rhs => "{".$FIFO_WIDTH."{1'b0}}",
                       },
                       {
                           tag => "simulation",
                           lhs => "fifo_FF",
                           rhs => "1'b0",
                       },
                       {
                           tag => "simulation",
                           lhs => "wfifo_empty",
                           rhs => "1'b1",
                       },
                       ),
                                       ], # contents
                              }), # module
                      }), # instance
                      ], # contents  
                 }), # e_module scfifo_w
         }), # e_instance wfifo

         e_instance->new
         ({
             module => e_module->new
                 ({
                     name => $name."_scfifo_r",
                     contents =>
                     [
                      # this here would be the synthesis-only actual scfifo:
                      e_blind_instance->new
                      ({
                          tag => "synthesis",
                          name => 'rfifo',
                          module => 'scfifo',
                          use_sim_models => 1,
                          in_port_map =>
                          {
                              clock => 'clk',
                              wrreq => 'wr_rfifo',
                              data  => 't_dat',
                              rdreq => 'fifo_rd',
			      aclr => 'fifo_clear',
                          },
                          out_port_map =>
                          {
                              usedw => 'rfifo_used',
                              full  => 'rfifo_full',
                              empty => 'fifo_EF',
                              q     => 'fifo_rdata',
                          },
                          parameter_map =>
                          {
                              lpm_type           => qq("scfifo"),
                              lpm_width          => $FIFO_WIDTH,
                              lpm_numwords       => $read_depth,
                              lpm_widthu         => $RD_WIDTHU,
                              lpm_showahead      => qq("OFF"),
                              overflow_checking  => qq("OFF"),
                              underflow_checking => qq("OFF"),
                              use_eab            => $RD_EAB,
                              lpm_hint           => qq("RAM_BLOCK_TYPE=AUTO"),
                          },
                      }), # rfifo instance
                      # the following are the simulation-only contents
                      # for emulating the scfifo outputs based on e_drom out:
                      ##remove in/out interactive simulation, doesn't support in Qsys 
                      e_instance->new
                      ({
                          tag => "simulation",
                          module => e_module->new
                              ({
                                  name => $name."_sim_scfifo_r",
                                  contents =>
                                      [
                      e_signal->news
                      (
                       {
                           name => "num_bytes",
                           width => 32,
                           never_export => 1,
                       },
                       {
                           name => "bytes_left",
                           width => 32,
                           never_export => 1,
                       },
                       {
                           name => "new_rom",
                           never_export => 1,
                       },
                       {
                           name => "safe",
                           never_export => 1,
                       },
                       {
                           name => "rfifo_used",
                           width => $RD_WIDTHU,
                       },
                       {
                           name => "rfifo_entries",
                           width => ($RD_WIDTHU + 1),
                       },
                       {
                           name => "rfifo_full",
                           export => 1,
                       },
                       {
                           name => "fifo_rd_d",
                           never_export => 1,
                       },
                       ),
                      # e_drom->new
                      # ({
                      #     # drom automagically has tag => simulation
                      #     # presume that software uses 2k buffers
                      #     name       => $name."_drom",
                      #     readmemb   => 1,
                      #     rom_size   => &max($read_size,2048),
                      #     dat_name   => $read_data_file,
                      #     mutex_name => $read_mutex_file,
                      #     interactive=> $interactive_in,
                      #     relativepath => $relativepath,
                      #     allow_missing_mutex_file => 1,
                      #     port_map   =>
                      #     {
                      #         "reset_n"   => "rst_n",
                      #         "q"         => "fifo_rdata",
                      #         "new_rom"   => "new_rom",
                      #         "incr_addr" => "fifo_rd_d",
                      #         "num_bytes" => "num_bytes",
                      #     },
                      # }),
                      # create sim-only usedw signal
                      e_process->new
                      ({
                          tag => "simulation",
                          clock => "clk",
                          reset => "rst_n",
                          comment =>
                              " Generate rfifo_entries for simulation",
                              asynchronous_contents =>
                              [
                               e_assign->news
                               (
                                # ["rfifo_entries" => "{".$RD_WIDTHU."{1'b0}}"],
                                ["bytes_left" => "32'h0"],
                                ["fifo_rd_d"  => "1'b0"],
                                ),
                               ],
                              contents =>
                              [
                               e_assign->news
                               (
                                ["fifo_rd_d" => "fifo_rd"],
                                ),
                               e_if->new
                               ({
                                   comment => " decrement on read",
                                   condition => "fifo_rd_d",
                                   then =>
                                       ["bytes_left" => "bytes_left - 1'b1"],
                               }), # endif
                               e_if->new
                               ({
                                   comment => " catch new contents",
                                   condition => "new_rom",
                                   then =>
                                       ["bytes_left" => "num_bytes"],
                               }), # endif
                               ], # contents
                           }), # e_process
                      e_assign->news
                      (
                       {
                           tag => "simulation",
                           lhs => "fifo_EF",
                           rhs => "bytes_left == 32'b0",
                       },
                       {
                           tag => "simulation",
                           lhs => "rfifo_full",
                           rhs => "bytes_left > $HEX_READ_DEPTH_STR",
                       },
                       {
                           tag => "simulation",
                           lhs => "rfifo_entries",
                           rhs => "(rfifo_full) ? ".
                               "$HEX_READ_DEPTH_STR : bytes_left",
                       },
                       {
                           tag => "simulation",
                           lhs => "rfifo_used",
                           rhs => "rfifo_entries[".($RD_WIDTHU-1).":0]",
                       },
                       # tie-off output signal(new_rom, num_bytes, q, safe) from e_drom
                       {
                           tag => "simulation",
                           lhs => "new_rom",
                           rhs => "1'b0",
                       },
                       {
                           tag => "simulation",
                           lhs => "num_bytes",
                           rhs => "32'b0",
                       },
                       {
                           tag => "simulation",
                           lhs => "fifo_rdata",
                           rhs => "8'b0",
                       },
                       ),
                                       ],
                              }),
                       }),
                      ], # contents
                 }), # module 'scfifo_r'
         }), # e_instance rfifo

         ); # add_contents(fifo instances)

    # Other signals (fsm, irq)
    $module->add_contents
        (
         e_signal->news #: ["signal", width, export, never_export]
         (
          ["fifo_AE",     1,      0,      1],
          ["fifo_AF",     1,      0,      1],
          ["ien_AE",      1,      0,      1],
          ["ien_AF",      1,      0,      1],
          ["ipen_AE",     1,      0,      1],
          ["ipen_AF",     1,      0,      1],
          ["activity",    1,      0,      1],
          ["ac",          1,      0,      1],
          ["read_0",      1,      0,      1],
          ["pause_irq",   1,      0,      1],
          ["rvalid",      1,      0,      1],
          ["woverflow",   1,      0,      1],
          ),
         ); # add_contents(fsm, irq)

    # Here are the meaty bits of the avalon_fifo code:
    $module->add_contents
        (
         e_assign->news
         (
          ["ipen_AE" => "(ien_AE & fifo_AE)"],
          ["ipen_AF" => "(ien_AF & (pause_irq | fifo_AF))"],
          ["av_irq" => "ipen_AE | ipen_AF"],
          ["activity" => "t_pause | t_ena"],
          ), # av_irq
         e_process->new
         ({
             clock => "clk",
             reset => "rst_n",
             asynchronous_contents =>
                 [
                  e_assign->news
                  (
                   ["pause_irq" => "1'b0"],
                   ),
                  ], # asynchronous_contents
             contents =>
             [
              e_if->new
              ({
                  comment => " only if fifo is not empty...",
                  condition => "(t_pause & ~fifo_EF)",
                  then => ["pause_irq" => "1'b1"],
                  elsif =>
                  {
                      condition => "read_0",
                      then => ["pause_irq" => "1'b0"],
                  },
              }), # endif
              ], # contents
          }), # pause_irq
         ); # add_contents(assign av_irq)

    $module->add_contents
        (
         e_process->new
         ({
             clock => "clk",
             reset => "rst_n",
             asynchronous_contents =>
                 [
                  e_assign->news
                  (
                   ["r_val" => "1'b0"],
                   ["t_dav" => "1'b1"],
                   ),
                  ], # asynchronous_contents
             contents =>
             [
              e_assign->news
              (
               ["r_val" => "(r_ena & ~wfifo_empty)"],
               ["t_dav" => "(~rfifo_full)"],
               ),
              ], # contents
          }),
         ); # add_contents(r_val/t_dav) process

    $module->add_contents
        (
         e_process->new
         ({
             clock => "clk",
             reset => "rst_n",
             asynchronous_contents =>
             [
              e_assign->news
              (
               ["fifo_AE" => "1'b0"],
               ["fifo_AF" => "1'b0"],
               ["fifo_wr" => "1'b0"],
               ["rvalid"  => "1'b0"],
               ["read_0"  => "1'b0"],
               ["ien_AE"  => "1'b0"],
               ["ien_AF"  => "1'b0"],
               ["ac"      => "1'b0"],
               ["woverflow" => "1'b0"],
               ["av_waitrequest" => "1'b1"],
               ),
              ], # asynchronous_contents
             contents =>
             [
              e_assign->news
              (
               ["fifo_AE" =>
                "({fifo_FF,wfifo_used} <= ".$write_threshold.")"],
               ["fifo_AF" => 
                "(".$HEX_READ_DEPTH_STR." - {rfifo_full,rfifo_used}) <= ".
                $read_threshold],
               ["fifo_wr" => "1'b0"],
               ["read_0"  => "1'b0"],
               ["av_waitrequest" =>
             "~(av_chipselect & (~av_write_n | ~av_read_n) & av_waitrequest)"],
               ), # assigns
              # read Activity/write activity
              e_if->new
              ({
                  condition => "activity",
                  then => ["ac" => "1'b1"],
              }),
              e_if->new
              ({
                  comment => " write",
                  condition => "av_chipselect & ~av_write_n & av_waitrequest",
                  then =>
                  [
                   e_if->new
                   ({
                       comment => " addr 1 is control; addr 0 is data",
                       condition => "av_address",
                       then =>
                       [
                        e_assign->news
                        (# Do NOT put concatenations on lhs like:
                         #{ien_AE,ien_AF} <= av_writedata[1:0]
                         ["ien_AF" => "av_writedata[0]"],
                         ["ien_AE" => "av_writedata[1]"],
                         ), 
                        e_if->new
                        ({
                             condition => "av_writedata[10] & ~activity",
                             then => ["ac" => "1'b0"],
                        }),
                        ], # if (av_address) then
                        else =>
                        [
                         e_assign->news
                         (
                          ["fifo_wr"   => "~fifo_FF"],
                          ["woverflow" => "fifo_FF"],
                          ), 
                         ], # if (av_address) else
                    }), # if (address)
                   ], # if (write) then
               }), # if (write)
              e_if->new
              ({
                  comment => " read",
                  condition => "av_chipselect & ~av_read_n & av_waitrequest",
                  then =>
                  [
                   e_if->new
                   ({
                       comment => " addr 1 is interrupt; addr 0 is data",
                       condition => "~av_address",
                       then => ["rvalid" => "~fifo_EF"],
                    }),
                   e_assign->news
                   (
                    ["read_0" => "~av_address"],
                    ), 
                   ], # if (read) then
               }), # if (read)
              ], # contents
          }), # process
         ); # add_contents(input fsm)

    $module->add_contents
        (
         e_assign->news
         (
          ["fifo_wdata" => "av_writedata[".($FIFO_WIDTH-1).":0]"],
          ["fifo_rd" =>
           "(av_chipselect & ~av_read_n & av_waitrequest & ~av_address)".
           " ? ~fifo_EF : 1'b0"],
          ["av_readdata" =>
           "read_0".
           " ? { {".(15-$RD_WIDTHU)."{1'b0}},".
               "rfifo_full,rfifo_used,".
               "rvalid,woverflow,~fifo_FF,~fifo_EF,1'b0,ac,ipen_AE,ipen_AF,".
               "fifo_rdata }".
           " : { {".(15-$WR_WIDTHU)."{1'b0}},".
               "(".$HEX_WRITE_DEPTH_STR." - {fifo_FF,wfifo_used}),".
               "rvalid,woverflow,~fifo_FF,~fifo_EF,1'b0,ac,ipen_AE,ipen_AF,".
               "{6{1'b0}},ien_AE,ien_AF }"
           ],
          ), # assigns
         ); # add_contents(output assigns)

    #streaming signals mode.  Looks like there's a bug in the
    #simulation fifo signals.  Too late to fix it there, so we fix it here
    $module->add_contents 
        (
         e_register->news
         ({
            out    => [readyfordata => 1],
            in     => "~fifo_FF",
            reset  => "rst_n",
            enable => 1,
         },
          #synthesis and simulation are different for dataavailable
          #we use a delay 0 register instead of an assignment which
          #allows the reg declaration to work for both sim and synth
          {
            tag    => 'synthesis',
            out    => [dataavailable => 1],
            in     => "~fifo_EF",
            reset  => "rst_n",
            enable => 1,
         },{
            tag    => 'simulation',
            out    => [dataavailable => 1],
            in     => "~fifo_EF",
            reset  => "rst_n",
            enable => 1,
            delay  => 0,
         })
         );
         
    if($allow_legacy_signals) {
    	$module->add_contents(
    	e_signal->new({name => "dataavailable", width => 1}),
    	e_signal->new({name => "readyfordata", width => 1})
    	);
    }     

    # spew out some source code:
    $project->output();
}

# pm's must end with a positive return value:
qq(
The white clouds
On the mountain tops
Poke halfway into this thatched hut
I had thought too cramped 
Even for myself 
- Koho Kennichi (1241-1316)
);

1;
