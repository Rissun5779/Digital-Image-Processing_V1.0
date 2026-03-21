/*
 * THIS IS MEMORY MAP FOR KR IP
 * THIS DEFINES DIFFERNT BASE ADDRESSES FOR PIO AS WELL AVMM-CSR 
 */
#include "system.h"

// definition of PIO-IN OFFSETS

#define LT_RESTART 0x1
#define LT_ENABLE  0x0
#define FRAME_LOCK 0x2

#define POST 0x5
#define VOD 0x3
#define PRE 0x1
#define PRESET 0x7
#define INIT 0x6


// definition of PIO-OUT OFFSETS

// Bits in training_sts_export
#define FRM_LCK_FILT 0
#define RX_TRAINED 1
#define TR_ERR 2
#define TR_LCK_ERR 3
#define NO_LCK_RXEQ 4

// Bits in rxeq_sts_export
#define FAIL_CTLE 8
#define LAST_DFE_MD 4
#define LAST_CTLE_MD 2
#define LAST_DFE_RC 1

// Base Address for PHY (CSR/HSSI)
// Assume single channel 
#define AVMM_BASE 0x00000  // this should match with QSYS file
#define AVMM_HSSI 0x00000
#define AVMM_CSR  0x00400

   
