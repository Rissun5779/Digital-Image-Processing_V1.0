// ********************************************************************************
// DisplayPort Source System Library global (library private) definitions
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
//
// (C) Copyright Bitec 2012
//    All rights reserved
//
// Author         : $Author: psgswbuild $ @ bitec-dsp.com
// Department     :
// Date           : $Date: 2018/07/18 $
// Revision       : $Revision: #1 $
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/btc_dptxll_syslib/btc_dptxll_globals.h $
//
// Description:
// These definitions are global to all library routines but private to this
// library.
// ********************************************************************************

#include "btc_cpu.h"

// Configuration data
#define BTXLL_MAX_NUM_OF_SOURCES                 4 // Max number of Source cores supported
#define BTXLL_MAX_NUM_OF_STRM_SOURCES            4 // Max number of Stream Sources supported
#define BTXLL_MAX_PATH_LEN                       8 // Max MST path (RAD) length (by DP specs = 15)
#define BTXLL_MAX_NUM_OF_DEVPORTS               16 // Max number of MST device ports supported

// TX instance type
typedef struct
{
  unsigned int num_of_strm_sources; // Number of MST Stream Sources
  unsigned int max_lane_count;      // Max lane count
  unsigned int max_link_rate;       // Max link rate (multiples of 270 Mbps)
  BYTE *sink_edid;                  // User-allocated 512-byte buffer for the connected Sink EDID data (or last read EDID data for MST)
} BTXLL_TXINSTANCE_TYPE;

//********** btc_dptxll_stream.c *********//
extern BTC_STREAM _btxll_stream[BTXLL_MAX_NUM_OF_SOURCES][BTXLL_MAX_NUM_OF_STRM_SOURCES];
void btc_dptxll_stream_init(BYTE tx_idx);

//********** btc_dptxll_mst.c *********//
void btc_dptxll_mst_init(BYTE tx_idx);
void btc_dptxll_mst_monitor();
int btc_dptxll_mst_new_sink(BYTE tx_idx);
int btc_dptxll_mst_allocate_act_fsm(BYTE tx_idx,BYTE start,BYTE strm_idx,BTC_MST_DEVPORT *dev_port);
int btc_dptxll_mst_delete_act_fsm(BYTE tx_idx,BYTE start,BYTE strm_idx);
int btc_dptxll_mst_sink_mst_cap(BYTE tx_idx);
BYTE *btc_dptxll_mst_sink_edid(BYTE tx_idx);

//********** btc_dptxll_common.c *********//
extern BTXLL_TXINSTANCE_TYPE _btxll_inst[BTXLL_MAX_NUM_OF_SOURCES];

