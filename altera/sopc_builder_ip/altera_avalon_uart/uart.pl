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


#Copyright (C)1991-2003 Altera Corporation
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

# twayne: Thu Jul 25 18:42:10  2002

# Here's a little thing that tries to be a tty-like interface to a
# modelsim uart.  Arguments (which should appear in this order) are:
# 	mutex.dat	-- mutex indicator: if 0, OK to write, else wait
#	stream.dat	-- the raw data to be sucked into a modelsim memory
#	sim.log		-- raw data spit out of simulation (may be null)
#	stream.log	-- ascii version of all char's sent via stream.dat

# run via 'perl -- uart.pl mutex stream logfile'

# set program_name '$pname' to equivalent of csh's "$0:t"
@prog = split (/\/|\\/,$0) ; $pname = $prog[$#prog] ;

$SIG{'INT'} = 'quit';		# run &quit on ^C

&usage if @ARGV < 3;		# die without 3 file args

################################################################
# test files for veracity
################################################################

die if (&args_test(@ARGV) && sleep 5);

################################################################
# The real work: Poll the mutex, and send data if we have it.
# By definition, we can only write the stream if the mutex contains a
# '0', and once the stream is written, the mutex should be filled with
# the number of bytes sent to the stream.
#
# NB: at this point, any non-zero mutex value will do...
################################################################

# print STDERR "$pname: Starting Loop...\n";
$char_stream = "";

select (STDIN); $| = 1;		# make STDIN unbufferred
select (STDOUT);$| = 1;

# .dat file setup 'leveraged' from:
# excalibur/kit/components/altera_avalon_uart/em_uart.pl->Setup_Input_Stream

print "Always wait for the '+' prompt...\n";

while (1) {			# spin until interrupt
    &wait_mutex ($ARGV[0], $sim); # spin until mutex contains '0'
    print "+";			# prompt!
    $char_stream = <STDIN>;	# HACK ALERT!!! Verify this behavior with perl
    # rough equivalent of $char_stream in Setup_Input_Stream

# begin deadlift:
    # Allow certain backslash-escapes for 'funny' characters.
    # for now, we limit ourselves to "\n" and "\r" and "\"" for 
    # newline, carriage-return, and double-quote, respectively.
    my $newline      = "\n";
    my $cr           = "\n";
    my $double_quote = "\"";
    
    # First, convert any \n\r sequences into \n.  If by "\n\r" you meant
    # two carriage returns, you lose.
    $char_stream =~ s/\\n\\r/\n/sg;
    
    $char_stream     =~ s/\\n/$newline/sg;
    $char_stream     =~ s/\\r/$cr/sg;
    $char_stream     =~ s/\\\"/$double_quote/sg;
    # Now substitute CRLF-pairs for lone newline-chars, because GERMS likes it.
    # Comment out the newline replacement below. SPR:303079
    # my $crlf = "\n\r";
    # $char_stream =~ s/\n/$crlf/smg;
# end deadlift
    
    open (STREAM,">$ARGV[1]") || die "$pname: $ARGV[1]: $!\n";
    
# begin deadlift:s/STREAM/DATFILE/g
    my $addr = 0;
    foreach my $char (split (//, $char_stream)) {
	printf STREAM "\@%X\n", $addr++;
	printf STREAM "%X\n", ord($char);
    }
    # Add null-terminator...
    printf STREAM "\@%X\n", $addr;
    printf STREAM "%X\n", 0;
    
    close (STREAM);
# end deadlift

    open (LOG, ">>$ARGV[2]") || die "$pname: $ARGV[2]: $!\n";
    select (LOG); $| = 1;	# make LOG unbufferred
    select (STDOUT);		# reset to default output stream for print
    print LOG "$char_stream";
    close (LOG);

    open (MUTEX, ">$ARGV[0]") || die "$pname: $ARGV[0]: $!\n";
    printf MUTEX "%X\n", $addr;
    close (MUTEX);
} # while TRUE

################################################################
# subroutines
################################################################
sub usage {
    die "usage: $pname mutex.dat stream.dat logfile\n";
} # usage

sub quit {			# interrupt handler for exit
    local ($sig) = @_;
    print STDERR "Caught SIG$sig; Closing files and exiting...\n";
    close (MUTEX);
    close(STREAM);
    close   (LOG);
    sleep 1;
    exit;
} # quit
    
sub args_test {			# return 0 for success; return 1 for fail
    local (@files) = @_;
    local (@codes) = (" "," "," "," ");
    local ($die)   = 0;

    # print STDERR "$pname: Checking arguments...\n";

    if (defined (open (MUTEX, $files[0]))) { 
	close(MUTEX);		# success
    } else {
	$codes[0] = "$!\n";		# remember fail reason
    }
    if (defined (open (STREAM,$files[1]))) {
	close(STREAM);
    } else {
	$codes[1] = "$!\n";
    }
    if (defined (open (LOG,">$files[2]"))) {
	# open for write will bash old contents, next time we'll append
	close(LOG);
    } else {
	$codes[2] = "$!\n";
    }				# leave logfile open

    for ($i = 0; $i < 3; $i++) {
	if ($codes[$i] ne " ") {
	    print STDERR "$pname: Cannot open '$files[$i]': $codes[$i]";
	    $die = 1;		# remember any failure
	}
    }

    return $die;		# return any failure status.

} # args_test

sub wait_mutex {		# spin until mutex contains '0'
    local ($mutex,$sim) = @_;	# filenames passed in
    local ($bytes) = 0;		# init scalar number to be read from mutex file

    do {
	open (MUTEX,$mutex);
	while (<MUTEX>) {
	    $bytes = $_;
	    chomp ($bytes);
	    # print "\n$mutex pre hex: $bytes\n";
	    if ($bytes =~ /^@/) { # skip @ddress spec, if present.
		# print STDERR "$pname: ignoring @\n";
		next;
	    }
	    $bytes = hex($bytes);
	    # print "$bytes\n";
	    if ($bytes != 0) {
		# print "\n$bytes: sleeping...\n";
		sleep 1;
	    }
	    last;
	} # while MUTEX
	close(MUTEX);
    } while ($bytes != 0);

} # wait_mutex
