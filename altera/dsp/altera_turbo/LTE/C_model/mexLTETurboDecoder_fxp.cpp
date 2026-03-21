/* file: mexLTETurboDecoder_fxp.cpp

   Description: mex wrapper for run_lte_turbo_decoder_fxp

% The calling syntax is:
%     [detected_data] = LTETurboDecoder_fxp( ...
%       input_decoder_c, turbo_iterations, decoder_type, ...
%       num_engines, bit_width, en_et, crc_type, crc_reflect_out )
%
% output:
%     detected_data = a row vector containing the detected data
% input:
%     input_decoder_c = the decoder input, in the form of bit LLRs
%                       this could have multiple rows if the data is longer
%                       than the interleaver
%     turbo_iterations = the number of turbo iterations
%     decoder_type = the decoder type
%              = 0 For linear-log-MAP algorithm, i.e. correction function is a straght line.
%              = 1 For max-log-MAP algorithm (i.e. max*(x,y) = max(x,y) ), i.e. correction function = 0.
%              = 2 For Constant-log-MAP algorithm, i.e. correction function is a constant.
%              = 3 For log-MAP, correction factor from small nonuniform table and interpolation.
%              = 4 For log-MAP, correction factor uses C function calls.
%              = 5 For scaling max-log-MAP, scaling factor = 0.75.
%     num_engines = the size of subblocks for parallel windows
%     bit_width = [1x4] elements for internal data precision setting
%     en_et = enable for early termination (1= on, 0 = off)
%     crc_type = 0 = CRC24_A : 0x864CFB, 1 = CRC24_B : 0x800063
%     crc_reflect_out = crc reflect remainder
*/

/*
 void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
 Function description
 The mexfunction header to interface with Matlab code

*/

/* library of functions */
#include "mex.h"
#include <iostream>

using namespace std;

void run_lte_turbo_decoder_fxp
(int* decoded_data,  //decoder output
 double* decoder_input, // input to the decoder
 int block_size, // data length
 int decoder_type, 	// decoder type:
 //		= 0 For linear-log-MAP algorithm, i.e. correction function is a straght line.
 // 	= 1 For max-log-MAP algorithm (i.e. max*(x,y) = max(x,y) ), i.e. correction function = 0.
 // 	= 2 For Constant-log-MAP algorithm, i.e. correction function is a constant.
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

/* Input Arguments */
#define INPUT_DECODER_C  prhs[0]
#define TURBO_ITERATIONS prhs[1]
#define DECODER_TYPE     prhs[2]
#define NUM_ENGINES      prhs[3]
#define BIT_WIDTH        prhs[4]
#define EN_ET            prhs[5]
#define CRC_TYPE         prhs[6]
#define CRC_REFLECT_OUT  prhs[7]

#define DETECTED_DATA    plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  double *input_decoder_c;
  int input_length, block_size;
  int turbo_iterations;
  int decoder_type;
  int num_engines;
  int bit_width[4];
  double *bit_width_in;
  double* output;
  int *decoded_data;
  int oi;

  // crc check parameterisation
  int en_et, crc_type, crc_reflect_out;
  
  if (nrhs < 3 ) {
    mexErrMsgTxt("Usage: [output_data] = LTETurboDecoder_fxp(input_c, iter, decoder_type, num_engines, bit_width, enable_et, crc_type, crc_ref_out )");
  }


  input_decoder_c = (double *)mxGetPr(INPUT_DECODER_C);
  input_length = mxGetN(INPUT_DECODER_C);
  turbo_iterations = (int) mxGetScalar(TURBO_ITERATIONS);
  decoder_type = (int) mxGetScalar(DECODER_TYPE);
  num_engines = (int) mxGetScalar(NUM_ENGINES);
  bit_width_in = (double *)mxGetPr(BIT_WIDTH);
  en_et = (int) mxGetScalar(EN_ET);
  crc_type = (int) mxGetScalar(CRC_TYPE);
  crc_reflect_out = (int) mxGetScalar(CRC_REFLECT_OUT);

  // type conversion of double inputs
  for (int wi=0; wi<4; wi++) {
    bit_width[wi] = (int)bit_width_in[wi];
  }

  // block size is decoded output bit size
  // input bit counts are 3*(block_size+4)
  block_size = input_length/3-4;
  plhs[0] = mxCreateDoubleMatrix(1, block_size, mxREAL);
  output = (double *)mxGetData(DETECTED_DATA);
  decoded_data = (int *)mxCalloc(block_size, sizeof(int));

  run_lte_turbo_decoder_fxp(decoded_data, input_decoder_c, block_size,
              decoder_type, num_engines, turbo_iterations, bit_width, en_et, crc_type, crc_reflect_out);

  /* cast the output to double in order to interface with other Matlab
   * function */
  for (oi=0; oi<block_size; oi++) {
    output[oi] = (double)decoded_data[oi];
  }

  // free the memory before return
  mxFree(decoded_data);

  return;
}

