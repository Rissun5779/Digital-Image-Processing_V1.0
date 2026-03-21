#include "HLS/hls.h"
#include "defines.h" //this file will be created automatically at generation time

// Architecture descriptions
// 0 - Text book example of matrix multiply
// 1 - Tiled loop architecture with a multi channel accumulator
// 2 - Tiled loop architecture with a multi channel accumulator. This one is simpler to write and 
//     understand but not as efficient as No. 1. It also does not have the , BLOCKS >= DOT_VECTOR_SIZE/C_COLS
//     restriction
// 3 - Non-tiled. Store partial products and add them later using a parallel adder to reduce latency.

typedef ihc::stream_in<MATRIX_ELEMENT_TYPE> my_operand;
typedef ihc::stream_out<MATRIX_ELEMENT_TYPE> my_result;

#if ARCH==0
__attribute__((max_concurrency(2)))
component extern "C" void altera_fp_matrixmult(my_operand &a, my_operand &b, my_result &c){
	MATRIX_ELEMENT_TYPE A_local[A_ROWS][A_COLS];
	MATRIX_ELEMENT_TYPE B_local[B_ROWS][B_COLS];

   //the pragma unroll 1 directives are needed to stop the compiler from
   //unrolling these loops and then complaining about mutiple IO read/write sites
   #pragma unroll 1
   for(int row=0; row < A_ROWS; ++row){
      #pragma unroll 1
      for(int col=0; col < A_COLS; ++col){
         A_local[row][col] = a.read(); 
      }
   }
   #pragma unroll 1
   for(int row=0; row < B_ROWS; ++row){
      #pragma unroll 1
      for(int col=0; col < B_COLS; ++col){
         B_local[row][col] = b.read(); 
      }
   }

   #pragma unroll 1
   for(int row=0; row< C_ROWS; ++row){
      #pragma unroll 1
      for(int col=0; col < C_COLS; ++col){
      	MATRIX_ELEMENT_TYPE running_sum = MAKE_MATRIX_ELEMENT(0.0, 0.0);
         for(int d=0; d < A_COLS; ++d) {
#ifndef COMPLEX_DATA_TYPE
            running_sum += A_local[row][d] * B_local[d][col];
#else
#ifdef KARATSUBA_COMPLEX_MULTIPLY
      	   DATA_TYPE s1 = A_local[row][d].real_part * B_local[d][col].real_part;
      	   DATA_TYPE s2 = A_local[row][d].imaginary_part * B_local[d][col].imaginary_part;
      	   DATA_TYPE s3 = (A_local[row][d].real_part + A_local[row][d].imaginary_part)
      	   		       * (B_local[d][col].real_part + B_local[d][col].imaginary_part);
      	   running_sum.real_part      += (s1 - s2);
      	   running_sum.imaginary_part += s3 - (s1 + s2);
#else
         	running_sum.real_part += (A_local[row][d].real_part * B_local[d][col].real_part)
         			                 - (A_local[row][d].imaginary_part * B_local[d][col].imaginary_part);
         	running_sum.imaginary_part += (A_local[row][d].real_part * B_local[d][col].imaginary_part)
               			                + (A_local[row][d].imaginary_part * B_local[d][col].real_part);
#endif
#endif // COMPLEX_DATA_TYPE
         }
         c.write(running_sum);
      }
   }
}
#elif ARCH==1
#define num_iter_per_elem  (A_COLS/DOT_VECTOR_SIZE)
#define VEC_BLOCK_RATIO (DOT_VECTOR_SIZE/BLOCKS)
#define A_I_MASK (BLOCKS + BLOCKS_PADDING - 1) 
__attribute__((max_concurrency(2)))
component extern "C" void altera_fp_matrixmult(my_operand &a, my_operand &b, my_result &c){
   //A_local memory has less bandwidth than B_local memory
   //You can read BLOCKS number of matrix elements from the A_local memory. Or if we can
   //widen the memory and fit two matrix elements in a single location then we can read
   //2*BLOCKS matrix elements from the A_local memory.
   //You can read DOT_VECTOR_SIZE number of matrix elements from the B_local memory.
   //That's why we have A_local_regs and the tiled loop structure. So that we can read a
   //chunk of A_local slowly into A_local_regs and then fully reuse that chunk of A_local 
   //before reading another chunk of A_local into A_local_regs.
   //Because of the tiled loop structure necessary for this data reuse, the consecutive
   //partial products computed contribute to different output elements and not to the same
   //output element as is the case with a more natural matrix multiply loop structure.
   const int a_size = A_ROWS * (A_COLS+A_COLS_PADDING);
   MATRIX_ELEMENT_TYPE hls_singlepump hls_numbanks(A_BANKS) hls_bankwidth(A_BANKWIDTH) A_local[a_size];
   //store transposed so that reads are sequential, parallel reads can then be achieved by
   //either a wider memory or banked memory (compiler currently only banks on lower address bits)
   MATRIX_ELEMENT_TYPE hls_singlepump hls_numbanks(B_BANKS) hls_bankwidth(B_BANKWIDTH) B_local[B_COLS][B_ROWS+B_ROWS_PADDING];
   MATRIX_ELEMENT_TYPE A_local_regs[DOT_VECTOR_SIZE], A_local_regs_stable[DOT_VECTOR_SIZE];
   //partial_products represents a memory with depth C_COLS and parallel access to num_iter_per_elem items
   MATRIX_ELEMENT_TYPE running_sums_for_col[C_COLS * RUNNING_SUM_MULT];
 
#ifdef A_I_TYPE
   A_I_TYPE a_i = 0;
#else
   unsigned int a_i = 0;
#endif

//TODO can reduce these sizes further
#ifdef B_R_TYPE
   B_R_TYPE b_r_high = 0; 
   B_R_TYPE b_r_low = 0; 
#else
   unsigned short b_r_high = 0; 
   unsigned short b_r_low = 0; 
#endif

#ifdef B_C_TYPE
   B_C_TYPE b_c = 0;
#else
   unsigned short b_c = 0; 
#endif
   bool load_a = true;
   bool load_b = true;
   #pragma unroll 1
   while( load_a || load_b ) {
      bool a_success = false;
      bool b_success = false;
      load_a = a_i < a_size;
      load_b = b_r_high < num_iter_per_elem;
      if( load_a ) { A_local[a_i] = a.tryRead(a_success); }
      if( load_b ) { B_local[b_c][b_r_high * (DOT_VECTOR_SIZE+VECTOR_PADDING) + b_r_low] = b.tryRead(b_success); }
      if (a_success) {
         if ((a_i & A_I_MASK) == BLOCKS-1){
            a_i += BLOCKS_PADDING + 1;
         } else {
            a_i++;
         }
      }
      if (b_success) {
         if(b_c == B_COLS-1) {
            b_c = 0;
            if (b_r_low == DOT_VECTOR_SIZE-1) {
               b_r_low = 0;
               b_r_high++;
            } else {
               b_r_low++;
            }
         } else {
            b_c++;
         }
      }
   }

#ifdef K_TYPE
   K_TYPE k = 0;
#else
   int k = 0;
#endif

#ifdef I_TYPE
   I_TYPE i = -1;
#else
   int i = -1;
#endif

#ifdef J_TYPE
   J_TYPE j = 0;
#else
   int j = 0;
#endif

#ifdef S_TYPE
   S_TYPE s = num_iter_per_elem - 1;
#else
   int s = num_iter_per_elem - 1;
#endif

   for( ; k < num_iter_per_elem * C_COLS * C_ROWS + C_COLS; ++k) {
       bool last_s_itr = s == num_iter_per_elem-1;
       // load the cache
      
       // latch A_local_regs
       if (j == 0) {
          #pragma unroll 
          for (int d = 0; d < DOT_VECTOR_SIZE; d++) {
             A_local_regs_stable[d] = A_local_regs[d];
          }
       }
       #pragma unroll
       for (int d = 0; d < DOT_VECTOR_SIZE - BLOCKS; ++d) {
           A_local_regs[d] = A_local_regs[d+BLOCKS];
       }
       // Start loading a new full row of A, once end of an output row is approaching
       // BLOCKS elements of the row are loaded concurrently
       #pragma unroll
       for(int d=0; d < BLOCKS; ++d) {
           MATRIX_ELEMENT_TYPE val;
           if (j >= C_COLS - DOT_VECTOR_SIZE / BLOCKS) {
              //When padding is zero ((BLOCKS + BLOCKS_PADDING) * VEC_BLOCK_RATIO) == DOT_VECTOR_SIZE 
              val = A_local[(i*(A_COLS+A_COLS_PADDING))+(s + 1) * (BLOCKS + BLOCKS_PADDING) * VEC_BLOCK_RATIO + (j - C_COLS + DOT_VECTOR_SIZE / BLOCKS) * (BLOCKS + BLOCKS_PADDING) + d];
              
           }
           A_local_regs[d + DOT_VECTOR_SIZE - BLOCKS] = val;
       }

       // compute partial products
#ifndef COMPLEX_DATA_TYPE
       MATRIX_ELEMENT_TYPE running_sum = 0.0f;
       #pragma unroll
       for(int d=0; d < DOT_VECTOR_SIZE; ++d) {
           running_sum += A_local_regs_stable[d] * B_local[j][(s * (DOT_VECTOR_SIZE+VECTOR_PADDING) + d)];
       }
       MATRIX_ELEMENT_TYPE sum = running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1] = (s < RUNNING_SUM_MULT ? 0.0f : running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1]) + running_sum;
       MATRIX_ELEMENT_TYPE final_sum = sum;
       #pragma unroll
       for (int d = 1; d < RUNNING_SUM_MULT; d++) {
          final_sum += running_sums_for_col[(RUNNING_SUM_MULT - d) * C_COLS - 1];
       }
#endif // not COMPLEX_DATA_TYPE
#ifdef COMPLEX_DATA_TYPE
       MATRIX_ELEMENT_TYPE running_sum = MATRIX_ELEMENT_ZERO;
       #pragma unroll
       for(int d=0; d < DOT_VECTOR_SIZE; ++d) {
      	  DATA_TYPE a_real      = A_local_regs_stable[d].real_part;
      	  DATA_TYPE a_imaginary = A_local_regs_stable[d].imaginary_part;
      	  DATA_TYPE b_real      = B_local[j][(s * (DOT_VECTOR_SIZE+VECTOR_PADDING) + d)].real_part;
      	  DATA_TYPE b_imaginary = B_local[j][(s * (DOT_VECTOR_SIZE+VECTOR_PADDING) + d)].imaginary_part;
#ifdef KARATSUBA_COMPLEX_MULTIPLY
      	  DATA_TYPE s1 = a_real * b_real;
      	  DATA_TYPE s2 = a_imaginary * b_imaginary;
      	  DATA_TYPE s3 = (a_real + a_imaginary) * (b_real + b_imaginary);
      	  running_sum.real_part      += (s1 - s2);
      	  running_sum.imaginary_part += s3 - (s1 + s2);
#else
           running_sum.real_part      += (a_real * b_real) - (a_imaginary * b_imaginary);
           running_sum.imaginary_part += (a_real * b_imaginary) + (a_imaginary * b_real);
#endif // KARATSUBA_COMPLEX_MULTIPLY
       }
       MATRIX_ELEMENT_TYPE sum;
       sum.real_part = running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1].real_part
      		         = ((s < RUNNING_SUM_MULT) ? (DATA_TYPE)0.0 : running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1].real_part)
      		           + running_sum.real_part;
       sum.imaginary_part = running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1].imaginary_part
      		         = ((s < RUNNING_SUM_MULT) ? (DATA_TYPE)0.0 : running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1].imaginary_part)
      		           + running_sum.imaginary_part;
       MATRIX_ELEMENT_TYPE final_sum = sum;
       #pragma unroll
       for (int d = 1; d < RUNNING_SUM_MULT; d++) {
          final_sum.real_part      += running_sums_for_col[(RUNNING_SUM_MULT - d) * C_COLS - 1].real_part;
          final_sum.imaginary_part += running_sums_for_col[(RUNNING_SUM_MULT - d) * C_COLS - 1].imaginary_part;
       }
#endif // COMPLEX_DATA_TYPE
       // rotate running sums
       MATRIX_ELEMENT_TYPE tmp = running_sums_for_col[0];
       #pragma unroll
       for (int d = 0; d < RUNNING_SUM_MULT * C_COLS - 1; d++) {
          running_sums_for_col[d] = running_sums_for_col[d + 1];
       }
       // only rotate if we need to
       // this should remove the false dependency on the
       // result of the partial addition
       if (num_iter_per_elem > RUNNING_SUM_MULT) {
          running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1] = tmp;
       } else {
          running_sums_for_col[RUNNING_SUM_MULT * C_COLS - 1] = MATRIX_ELEMENT_ZERO;
       }

       if (last_s_itr && i >= 0) {
           c.write(final_sum);
       }
       if (j == C_COLS - 1) {
          j = 0;
          if (last_s_itr) {
             s = 0;
             i++;
          } else {
             s++;
          }
       } else {
          j++;
       }
   }
}
#elif ARCH==2
__attribute__((max_concurrency(2)))
component extern "C" void altera_fp_matrixmult(my_operand &a, my_operand &b, my_result &c){
   const int a_size = A_ROWS * A_COLS;
   const int b_size = B_ROWS * B_COLS;
   //this was a const int before, but Andrei changed this to a define to help the compiler.
   #define num_iter_per_elem  (A_COLS/DOT_VECTOR_SIZE)
   //A_local memory has less bandwidth than B_local memory
   //You can read BLOCKS number of matrix elements from the A_local memory. Or if we can
   //widen the memory and fit two matrix elements in a single location then we can read
   //2*BLOCKS matrix elements from the A_local memory.
   //You can read DOT_VECTOR_SIZE number of matrix elements from the B_local memory.
   //That's why we have A_local_regs and the tiled loop structure. So that we can read a
   //chunk of A_local slowly into A_local_regs and then fully reuse that chunk of A_local 
   //before reading another chunk of A_local into A_local_regs.
   //Because of the tiled loop structure necessary for this data reuse, the consecutive
   //partial products computed contribute to different output elements and not to the same
   //output element as is the case with a more natural matrix multiply loop structure.
   MATRIX_ELEMENT_TYPE A_local[A_ROWS * A_COLS];
   MATRIX_ELEMENT_TYPE B_local[B_ROWS * B_COLS];
   MATRIX_ELEMENT_TYPE A_local_regs[DOT_VECTOR_SIZE];
   //running_sums_for_col represents a memory with depth C_COLS
   MATRIX_ELEMENT_TYPE running_sums_for_col[C_COLS];
   
   int a_i = 0;
   int b_i = 0; 
   bool load_a = true;
   bool load_b = true;
   while( load_a || load_b ) {
      bool a_success;
      bool b_success;
      load_a = a_i < a_size;
      load_b = b_i < b_size;
      if( load_a ) { A_local[a_i] = a.tryRead(a_success); }
      if( load_b ) { B_local[b_i] = b.tryRead(b_success); }
      int a_incr = a_success ? 1 : 0;
      int b_incr = b_success ? 1 : 0;
      a_i = a_i + a_incr;
      b_i = b_i + b_incr;
  }

  for(int i=0, s=0, k=0, j=-DOT_VECTOR_SIZE/BLOCKS; k< C_ROWS * num_iter_per_elem * (DOT_VECTOR_SIZE/BLOCKS + C_COLS); ++k){
      bool last_s_iter = s==num_iter_per_elem-1;
      if (j < 0) {
           #pragma unroll
           for (int d = 0; d < DOT_VECTOR_SIZE - BLOCKS; ++d) {
              A_local_regs[d] = A_local_regs[d+BLOCKS];
           }
           #pragma unroll
           for(int d=0; d < BLOCKS; ++d) {
              //A_local_regs[d] = A_local[i][s*DOT_VECTOR_SIZE + d];
              A_local_regs[d + DOT_VECTOR_SIZE - BLOCKS] = A_local[i * A_COLS + s*DOT_VECTOR_SIZE + (j+DOT_VECTOR_SIZE/BLOCKS)*BLOCKS + d];
           }
        } else {
      	  MATRIX_ELEMENT_TYPE running_sum = MATRIX_ELEMENT_ZERO;
           #pragma unroll DOT_VECTOR_SIZE
           for(int d=0; d < DOT_VECTOR_SIZE; ++d) {
#ifndef COMPLEX_DATA_TYPE
              //running_sum += A_local_regs[d] * B_local[s * DOT_VECTOR_SIZE + d][j];
              running_sum += A_local_regs[d] * B_local[(s * DOT_VECTOR_SIZE + d) * B_COLS + j];
#else
              MATRIX_ELEMENT_TYPE b_elt = B_local[(s * DOT_VECTOR_SIZE + d) * B_COLS + j];
#ifdef KARATSUBA_COMPLEX_MULTIPLY
              DATA_TYPE s1 = A_local_regs[d].real_part * b_elt.real_part;
              DATA_TYPE s2 = A_local_regs[d].imaginary_part * b_elt.imaginary_part;
              DATA_TYPE s3 = (A_local_regs[d].real_part + A_local_regs[d].imaginary_part)
            		         * (b_elt.real_part + b_elt.imaginary_part);
              running_sum.real_part      += (s1 - s2);
              running_sum.imaginary_part += (s3 - (s1 + s2));
#else
              running_sum.real_part      += (A_local_regs[d].real_part * b_elt.real_part)
            		                        - (A_local_regs[d].imaginary_part * b_elt.imaginary_part);
              running_sum.imaginary_part += (A_local_regs[d].real_part * b_elt.imaginary_part)
            		                        + (A_local_regs[d].imaginary_part * b_elt.real_part);
#endif
#endif // COMPLEX_DATA_TYPE
           }
           //I've tried to write this in a hardware friendly way, Simon Finn thinks that having
           //the mux before the adder should help the mux get absorbed into the adder itself.
           //We always do the memory read to reduce any control overhead in LSU stuff
           MATRIX_ELEMENT_TYPE prev = running_sums_for_col[C_COLS-1];  // use fixed element to infer shift register
           MATRIX_ELEMENT_TYPE prev_or_zero = s==0 ? MATRIX_ELEMENT_ZERO : prev;
           MATRIX_ELEMENT_TYPE sum;
#ifndef COMPLEX_DATA_TYPE
           sum = prev_or_zero + running_sum;
#else
           sum.real_part      = prev_or_zero.real_part      + running_sum.real_part;
           sum.imaginary_part = prev_or_zero.imaginary_part + running_sum.imaginary_part;
#endif
           running_sums_for_col[C_COLS-1] = sum;
           
           // shift all running sums in a circular fashion
           MATRIX_ELEMENT_TYPE tmp = running_sums_for_col[0];
           #pragma unroll
           for (int d = 0; d < C_COLS; d++) {
              running_sums_for_col[d] = running_sums_for_col[d + 1];
           }
           running_sums_for_col[C_COLS - 1] = tmp;

           if(last_s_iter){
              c.write(sum);
           }
     }
     bool last_j_iter = j == C_COLS-1;
     j = last_j_iter ? -DOT_VECTOR_SIZE/BLOCKS : j+1;
     int s_incr = last_j_iter ? 1 : 0; 
     s = last_s_iter && last_j_iter ? 0 : s+s_incr;
     int i_incr = last_s_iter && last_j_iter ? 1 : 0;
     i = i + i_incr;
  }
}
#else
__attribute__((max_concurrency(2)))
component extern "C" void altera_fp_matrixmult(my_operand &a, my_operand &b, my_result &c){
   const int a_size = A_ROWS * A_COLS;
   const int b_size = B_ROWS * B_COLS;
   //this was a const int before, but Andrei changed this to a define to help the compiler.
   #define num_iter_per_elem  (A_COLS/DOT_VECTOR_SIZE)
   MATRIX_ELEMENT_TYPE A_local[A_ROWS * A_COLS];
   MATRIX_ELEMENT_TYPE B_local[B_ROWS * B_COLS];
   
   int a_i = 0;
   int b_i = 0; 
   bool load_a = true;
   bool load_b = true;
   while( load_a || load_b ) {
      bool a_success;
      bool b_success;
      load_a = a_i < a_size;
      load_b = b_i < b_size;
      if( load_a ) { A_local[a_i] = a.tryRead(a_success); }
      if( load_b ) { B_local[b_i] = b.tryRead(b_success); }
      int a_incr = a_success ? 1 : 0;
      int b_incr = b_success ? 1 : 0;
      a_i = a_i + a_incr;
      b_i = b_i + b_incr;
   }
   
   MATRIX_ELEMENT_TYPE running_sum[num_iter_per_elem];
   for(int k=0,i=0,j=0,s=0; k< (C_ROWS * C_COLS * num_iter_per_elem); ++k){
   	MATRIX_ELEMENT_TYPE tmp_running_sum = MATRIX_ELEMENT_ZERO;
      #pragma unroll
      for(int d=0; d < DOT_VECTOR_SIZE; ++d) {
#ifndef COMPLEX_DATA_TYPE
         tmp_running_sum += A_local[i*A_COLS + (s*DOT_VECTOR_SIZE) + d ] * B_local[(s * DOT_VECTOR_SIZE + d) * B_COLS + j];
#else
         MATRIX_ELEMENT_TYPE a_elt = A_local[i*A_COLS + (s*DOT_VECTOR_SIZE) + d ];
         MATRIX_ELEMENT_TYPE b_elt = B_local[(s * DOT_VECTOR_SIZE + d) * B_COLS + j];
#ifdef KARATSUBA_COMPLEX_MULTIPLY
         DATA_TYPE s1 = a_elt.real_part * b_elt.real_part;
         DATA_TYPE s2 = a_elt.imaginary_part * b_elt.imaginary_part;
         DATA_TYPE s3 = a_elt.real_part + a_elt.imaginary_part) * (b_elt.real_part + b_elt.imaginary_part);
         tmp_running_sum.real_part      += (s1 - s2);
         tmp_running_sum.imaginary_part += (s3 - (s1 + s2));
#else
         tmp_running_sum.real_part += (a_elt.real_part * b_elt.real_part) - (a_elt.imaginary_part * b_elt.imaginary_part);
         tmp_running_sum.imaginary_part += (a_elt.real_part * b_elt.imaginary_part) + (a_elt.imaginary_part * b_elt.real_part);
#endif
#endif // COMPLEX_DATA_TYPE
      }
      running_sum[s] = tmp_running_sum;
      bool last_s = s==num_iter_per_elem-1;
      if(last_s){
         MATRIX_ELEMENT_TYPE sum = MATRIX_ELEMENT_ZERO;
         #pragma unroll
         for(int pp=0; pp < num_iter_per_elem; ++pp){
#ifndef COMPLEX_DATA_TYPE
            sum += running_sum[pp];
#else
            sum.real_part      += running_sum[pp].real_part;
            sum.imaginary_part += running_sum[pp].imaginary_part;
#endif //COMPLEX_DATA_TYPE
         }
         c.write(sum); 
      }
      bool last_j = j==C_COLS-1;
      s =  last_s ? 0: s+1;
      int j_incr = last_s ? 1 : 0;
      j = last_s & last_j ? 0 : j + j_incr;
      int i_incr = last_s && last_j ? 1 : 0;  
      i = i + i_incr;
   }
}
#endif



