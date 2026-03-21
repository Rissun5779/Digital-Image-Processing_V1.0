// ================================================================================
// Legal Notice: Copyright (C) 2007-2008 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.
// ================================================================================
//
// File: test_LTETurboDecoder_fxp.cpp
//
// Description: This program tests the LTE Turbo decoder fixed-point simulation model
//

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

void run_lte_turbo_decoder_fxp(int* decoded_data,  //decoder output
	double* decoder_input, // input to the decoder
	int block_size, // data length
	int decoder_type, 	// decoder type:
						//		= 0 For linear-log-MAP algorithm, i.e. correction function is a straght line.
						// 		= 1 For max-log-MAP algorithm (i.e. max*(x,y) = max(x,y) ), i.e. correction function = 0.
						// 		= 2 For Constant-log-MAP algorithm, i.e. correction function is a constant.
						//		= 3 For log-MAP, correction factor from small nonuniform table and interpolation.
						//		= 4 For log-MAP, correction factor uses C function calls.
						//		= 5 For scaling max-log-MAP, scaling factor = 0.75.
	int num_engines,  // the number of parallel engines
	int max_num_iter,  // the maximum number of iterations
	int* bit_width,   // bit widths of input and internal precision, e.g., [8 2 12 2] is for 8 total bits for input
					  // which includes 2 bits after decimal point, 12 bits for internal data including 2 bits after
					  // decimal point
    // Early termination control
    int en_et,
    int crc_type,
    int crc_reflect_out
);

int main( )
{
	int decoder_type = 5;
	int *decoded_data;
	double *decoder_input;
	int block_size = 40;
	int num_engines = 8;
	int max_num_iter = 8;
	int bit_width[] = {8, 0, 13, 0};

    // early termination support
    int en_et = 1;
    int crc_type = 0;
    int crc_reflect_out = 0;

	ifstream blksize_file("ctc_blksize.txt");

	if (!blksize_file.is_open())
    {
		cout << "Error in reading blksize file!" << endl;
		return -1;
	}

	string line;
	getline (blksize_file,line);
	sscanf( line.c_str(), "%d", &block_size);
	block_size -= 4;

	cout << "Block size under testing: " << block_size << endl;
	blksize_file.close();

	decoder_input = (double*) calloc( (block_size+4)*3, sizeof(double) );

	if (decoder_input == NULL)
	{
		cout <<  "Out of memory!\n";
		return -1;
	}
	decoded_data = (int*) calloc( block_size, sizeof(int) );
	if (decoded_data == NULL)
	{
		cout <<  "Out of memory!\n";
		return -1;
	}

	ifstream input_file("ctc_data_input.txt");

	if (!input_file.is_open())
    {
		cout << "Error in reading input file!" << endl;
		return -1;
	}

	int i = 0;

    while (! input_file.eof() && i < block_size + 4)
    {
      getline (input_file,line);
	  sscanf( line.c_str(), "%f %f %f", &decoder_input[3*i], &decoder_input[3*i+1], &decoder_input[3*i+2] );
	  i++;
    }

	input_file.close();

	// The input data were from a file for RTL testing and were converted to integers.
	// We now convert them back to fixed-point values (assume 2 digits after decimal point).
	for(i = 0; i < (block_size+4)*3; i++)
	{
		decoder_input[i] /= (1 << bit_width[1]);
	}

	run_lte_turbo_decoder_fxp(decoded_data, decoder_input,block_size,
	   decoder_type, num_engines, max_num_iter, bit_width, en_et, crc_type, crc_reflect_out);

	ofstream output_file("ctc_decoded_output_gold.txt");
	if (!output_file.is_open())
    {
		cout << "Error in writing output file!" << endl;
		return -1;
	}

	for(i = 0; i < block_size; i++)
	{
		output_file << decoded_data[i] << endl;
	}

	output_file.close();
	if (decoder_input != NULL)
		free(decoder_input);
	if (decoded_data != NULL)
		free(decoded_data);

	return 0;
}

