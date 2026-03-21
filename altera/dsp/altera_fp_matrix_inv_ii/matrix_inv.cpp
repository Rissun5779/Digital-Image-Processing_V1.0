
#include "HLS/hls.h"
#include "HLS/math.h"
#include "defines.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if FP_PRECISION==1
#define DATA_TYPE float
#define RECIPSQRT(X) (1.0f / sqrtf(X))
#define RECIP(X) (1.0f / X)
#endif
#if FP_PRECISION==2
#define DATA_TYPE double
#define RECIPSQRT(X) (1.0 / sqrt(X))
#define RECIP(X) (1.0 / X)
#endif

#define MATRIX_A a
#define MATRIX_B b
#define COLUMNS_B c
#define MATRIX_X x

#define TRIANGLE_SIZE (MATRIX_SIZE*(MATRIX_SIZE+1)/2)

typedef ihc::stream_in<DATA_TYPE> InputMatrixStream;
typedef ihc::stream_in<uint16_t> InputSizeStream;
typedef ihc::stream_out<DATA_TYPE> OutputMatrixStream;

__attribute__((max_concurrency(2)))
component extern "C" void altera_fp_matrixinv(
                               InputMatrixStream& MATRIX_A,
#if FUNCTION==1 
                               InputMatrixStream& MATRIX_B, 
                               InputSizeStream& COLUMNS_B, 
#endif
#ifdef OUTPUT_L_FACTOR
                               OutputMatrixStream& streamL,
#endif
                               OutputMatrixStream& MATRIX_X)
{
    DATA_TYPE matL[TRIANGLE_SIZE];

    DATA_TYPE column[MATRIX_SIZE];
    for (uint8_t i0 = 0; i0 < MATRIX_SIZE; ++i0) {
        column[i0] = 0.0;
    }

    int index0 = 0;
    for (int icol = 0; icol < MATRIX_SIZE; ++icol) {

        // 3 nested loops flattened into 1 pipeline in order to have
        // the reciprocal square-root pipeline operating in parallel with
        // the scalar product pipeline
        
        // number of blocks to divide rows into
        int nblock = (MATRIX_SIZE - icol + SCALARPROD_PIPELINE - 1) / SCALARPROD_PIPELINE;
        // the number of iterations needed to completely flush the unified pipeline
        int nIterMultAcc = SCALARPROD_PIPELINE * icol;
        bool firstColumn = (icol == 0);
        int nIter = 1 + nblock * nIterMultAcc
            + (firstColumn ? MATRIX_SIZE : SCALARPROD_PIPELINE) 
            + RSQRT_PIPELINE + MULT_PIPELINE;
        
        // scalar product pipeline
        DATA_TYPE dotprod_pipeline[SCALARPROD_PIPELINE];

        // inverse square-root and subtraction pipeline with bypass
        DATA_TYPE rsqrt_pipeline[RSQRT_PIPELINE];
        DATA_TYPE bypass_pipeline[RSQRT_PIPELINE];

        // multiply pipeline
        DATA_TYPE mult_pipeline[MULT_PIPELINE];

        int block_start = icol;
        int index_x0 = icol;
        int index_x1 = icol;
        int index_y0 = icol;
        int index_y1 = icol;
        int stepx = MATRIX_SIZE - 1;
        int stepy = MATRIX_SIZE - SCALARPROD_PIPELINE;
        int irow = icol;
        int readRow = icol;
        int j0 = 1;
        int jcol = 1;
        int resultRow = icol;
        DATA_TYPE recipSqrt = 0.0f;

        // pipeline control schedule
        int nStartRead = nIterMultAcc;
        int nStopRead = nStartRead 
            + (firstColumn ? MATRIX_SIZE : SCALARPROD_PIPELINE);
        int nSaveRecipSqrt = 1 + nIterMultAcc + RSQRT_PIPELINE;
        int nStartResult = nSaveRecipSqrt + MULT_PIPELINE - 1;
        int nStopResult = nStartResult
            + (firstColumn ? MATRIX_SIZE : SCALARPROD_PIPELINE);
        bool first = false;
        bool valid = false;
        bool lastRow = (j0 == SCALARPROD_PIPELINE);
        bool lastCol = (jcol == icol);
        for (int i0 = 0; i0 < nIter; ++i0) {
            if (i0 > nStartResult) {
                if (resultRow >= icol && resultRow < MATRIX_SIZE) {

                    column[resultRow] = mult_pipeline[0];
                }
                resultRow++;
            }
            if (i0 >= nStopResult) {
                nStartResult += nIterMultAcc;
                nStopResult += nIterMultAcc;
            }

            if (nSaveRecipSqrt == i0) {
                // store result of reciprocal sqrt emerging from pipeline
                recipSqrt = rsqrt_pipeline[0];
            }
            DATA_TYPE subL = bypass_pipeline[0];
            // entering multiply pipeline

            mult_pipeline[0] = subL * recipSqrt;


            DATA_TYPE y = valid ? matL[index_y0] : 0.0f;
            DATA_TYPE x = matL[index_x0];

            DATA_TYPE sumProd = first ? 0.0f : dotprod_pipeline[0];

            if (i0 > nStartRead) {
                if (readRow >= icol && readRow < MATRIX_SIZE) {
                    DATA_TYPE elemA = MATRIX_A.read();
                    DATA_TYPE d = elemA - (firstColumn ? 0.0f : dotprod_pipeline[0]);
                    
                    rsqrt_pipeline[0] = RECIPSQRT(d);
                    bypass_pipeline[0] = d;

                }
                ++readRow;
            }
            if (i0 >= nStopRead) {
                nStartRead += nIterMultAcc;
                nStopRead += nIterMultAcc;
            }

            //DATA_TYPE tmp = dotprod_pipeline[0];
            #pragma unroll
            for (uint8_t k = 0; k < SCALARPROD_PIPELINE - 1; ++k) {
                dotprod_pipeline[k] = dotprod_pipeline[k + 1]; 
            }
            dotprod_pipeline[SCALARPROD_PIPELINE - 1] =  sumProd + x * y;

            DATA_TYPE tmp1 = rsqrt_pipeline[0];
            #pragma unroll
            for (uint8_t k = 0; k < RSQRT_PIPELINE - 1; ++k) {
                rsqrt_pipeline[k] = rsqrt_pipeline[k + 1]; 
            }
            rsqrt_pipeline[RSQRT_PIPELINE - 1] = tmp1;

            DATA_TYPE tmp2 = bypass_pipeline[0];
            #pragma unroll
            for (uint8_t k = 0; k < RSQRT_PIPELINE - 1; ++k) {
                bypass_pipeline[k] = bypass_pipeline[k + 1]; 
            }
            bypass_pipeline[RSQRT_PIPELINE - 1] = tmp2;

            DATA_TYPE tmp3 = mult_pipeline[0];
            #pragma unroll
            for (uint8_t k = 0; k < MULT_PIPELINE - 1; ++k) {
                mult_pipeline[k] = mult_pipeline[k + 1]; 
            }
            mult_pipeline[MULT_PIPELINE - 1] = tmp3;
            
            // manipulate indices to mimic 3 nested for-loops
            index_x0 = index_x1;
            index_y0 = index_y1;
            first = (jcol == 1);
            valid = (irow < MATRIX_SIZE);
            if (lastRow) {
                j0 = 1;
                if (lastCol) {
                    jcol = 1;
                    block_start += SCALARPROD_PIPELINE;
                    index_y1 = block_start;
                    stepy = MATRIX_SIZE - SCALARPROD_PIPELINE;
                    index_x1 = icol;
                    stepx = MATRIX_SIZE - 1;
                } else {
                    ++jcol;
                    index_y1 += stepy;
                    --stepy;
                    index_x1 += stepx;
                    --stepx;
                }
                irow = block_start;
            } else {
                ++j0;
                ++index_y1;
                ++irow;
            }
            lastRow = (j0 == SCALARPROD_PIPELINE);
            lastCol = (jcol == icol);

        }

        for (uint8_t irow = icol; irow < MATRIX_SIZE; ++irow) {
            DATA_TYPE elemL = column[irow];
#ifdef OUTPUT_L_FACTOR
            // output L
            streamL.write(elemL);
#endif
            matL[index0] = elemL;
            ++index0;
        }

    }// for icol


    // pre-compute reciprocals
    index0 = 0;
    int step0 = MATRIX_SIZE;
    DATA_TYPE recip[MATRIX_SIZE];
    for (int i = 0; i < MATRIX_SIZE; ++i) {
        recip[i] = RECIP(matL[index0]);
        index0 += step0;
        step0--;
    }
    // @todo can latency be overlapped with forward substitution?

    uint16_t numCols = 0;
    uint16_t bindex = 0;
#if FUNCTION==2
    // inverse: solve for X where L L^T X = I
        
    // naive implementation
        
    numCols = MATRIX_SIZE;
    bindex = 0;
    while (bindex < MATRIX_SIZE) {
#endif

        
#if FUNCTION==1
    for (;;) {
        if (numCols == bindex) {
            numCols = COLUMNS_B.read();
            bindex = 0;
        }
        if (numCols == 0) {
            break;
        }

        // Solve for x where L (L^T x) = b
        // First solve for w where Lw = b 
#endif
        
        DATA_TYPE vecB[B_SHIFT][MATRIX_SIZE];


        // read in column b
        uint16_t colsUsed = 0;
        for (int icol = 0; icol < B_SHIFT && bindex < numCols; ++icol) {
            for (int irow = 0; irow < MATRIX_SIZE; ++irow) {
#if FUNCTION==1
                vecB[icol][irow] = MATRIX_B.read();
#endif
#if FUNCTION==2
                // set up B as an identity matrix
                vecB[icol][irow] = (bindex == irow) ? 1.0 : 0.0;
#endif
            }
            bindex++;
            colsUsed++;
        }


        DATA_TYPE vecW[B_SHIFT][MATRIX_SIZE];

        // forward substitution
        DATA_TYPE fwdShiftMult[B_SHIFT];
        DATA_TYPE fwdShiftMultSub[B_SHIFT];

        index0 = 0;
        int step0 = 0;
        int icol0 = 0;
        int irow0 = 0;
        int irow1 = 0;
        for (int i0 = 0; i0 <= TRIANGLE_SIZE; ++i0) {

            bool diagonal = (irow0 == icol0);
            bool firstColumn = (icol0 == 0);
            DATA_TYPE elemL = (irow0 < MATRIX_SIZE) ? matL[index0] : 0.0;

            for (int j0 = 0; j0 < B_SHIFT; ++j0) {

                DATA_TYPE b = firstColumn ? vecB[j0][irow0] : fwdShiftMultSub[0];

                DATA_TYPE w = fwdShiftMult[0];
                if (firstColumn && !diagonal) {

                    vecW[j0][irow1] = w;
                }

                fwdShiftMultSub[0] = b - elemL * ((irow1 == 0 && firstColumn) ? w : vecW[j0][icol0]);

                fwdShiftMult[0] = b * recip[irow0];



                DATA_TYPE tmp0 = fwdShiftMultSub[0];
#pragma unroll
                for (uint8_t k = 0; k < B_SHIFT - 1; ++k) {
                    fwdShiftMultSub[k] = fwdShiftMultSub[k + 1]; 
                }
                fwdShiftMultSub[B_SHIFT - 1] = tmp0;

                DATA_TYPE tmp1 = fwdShiftMult[0];
#pragma unroll
                for (uint8_t k = 0; k < B_SHIFT - 1; ++k) {
                    fwdShiftMult[k] = fwdShiftMult[k + 1]; 
                }
                fwdShiftMult[B_SHIFT - 1] = tmp1;

            }

            if (diagonal) {
                irow1 = irow0;
                ++irow0;
                index0 = irow0;
                step0 = MATRIX_SIZE - 1;
                icol0 = 0;
            } else {
                index0 += step0;
                --step0;
                ++icol0;
            }

        }

        DATA_TYPE vecX[B_SHIFT][MATRIX_SIZE];
        // Then solve for x where L^T x = w

        // forward substitution
        DATA_TYPE bkwdShiftMult[B_SHIFT];
        DATA_TYPE bkwdShiftMultSub[B_SHIFT];

        index0 = TRIANGLE_SIZE - 1;
        icol0 = MATRIX_SIZE - 1;
        irow0 = MATRIX_SIZE - 1;
        irow1 = irow0;
        for (int i0 = 0; i0 <= TRIANGLE_SIZE; ++i0) {

            bool diagonal = (irow0 == icol0);
            bool lastColumn = (icol0 == MATRIX_SIZE - 1);
            DATA_TYPE elemL = (irow0 >= 0) ? matL[index0] : 0.0;

            for (int j0 = 0; j0 < B_SHIFT; ++j0) {

                DATA_TYPE w = lastColumn ? vecW[j0][irow0] : bkwdShiftMultSub[0];

                DATA_TYPE x = bkwdShiftMult[0];
                if (lastColumn && !diagonal) {

                    vecX[j0][irow1] = x;
                }

                bkwdShiftMultSub[0] = w - elemL * ((irow1 == MATRIX_SIZE - 1 && lastColumn) ? x : vecX[j0][icol0]);

                bkwdShiftMult[0] = w * recip[irow0];


                DATA_TYPE tmp0 = bkwdShiftMultSub[0];
#pragma unroll
                for (uint8_t k = 0; k < B_SHIFT - 1; ++k) {
                    bkwdShiftMultSub[k] = bkwdShiftMultSub[k + 1]; 
                }
                bkwdShiftMultSub[B_SHIFT - 1] = tmp0;

                DATA_TYPE tmp1 = bkwdShiftMult[0];
#pragma unroll
                for (uint8_t k = 0; k < B_SHIFT - 1; ++k) {
                    bkwdShiftMult[k] = bkwdShiftMult[k + 1]; 
                }
                bkwdShiftMult[B_SHIFT - 1] = tmp1;

            }

            --index0;
            if (diagonal) {
                irow1 = irow0;
                --irow0;
                icol0 = MATRIX_SIZE - 1;
            } else {
                --icol0;
            }

        }
        for (int j0 = 0; j0 < colsUsed; ++j0) {
          for (int i = 0; i < MATRIX_SIZE; ++i) {
            MATRIX_X.write(vecX[j0][i]);
          }
        }
    }

}


