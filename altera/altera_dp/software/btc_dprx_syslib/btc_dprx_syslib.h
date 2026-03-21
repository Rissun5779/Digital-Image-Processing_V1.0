// ********************************************************************************
// DisplayPort Sink System Library public definitions
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/btc_dprx_syslib/btc_dprx_syslib.h $
//
// Description:
//
// ********************************************************************************

#ifndef _BTC_DPRX_SYSLIB_H_
#define _BTC_DPRX_SYSLIB_H_

#include <stdio.h>
#include "btc_dp_dpcd.h"
#include "btc_dp_types.h"
#include "btc_dp_rxregs.h"

#ifndef BTC_DPRX_SYSLIB_VER
#define BTC_DPRX_SYSLIB_VER "X.X.X"
#endif

#define BTC_100US_RXTICKS     1 //number of timer time ticks equ to 100 us

// RX instance options
#define BTC_DPRX_OPT_DISABLE_ERRMON		0x0001

// Enable / Disable IRQ on AUX Requests from source
#define BTC_DPRX_ENABLE_IRQ(rx_idx)     IOWR(btc_dprx_baseaddr(rx_idx),DPRX_REG_AUX_CONTROL,IORD(btc_dprx_baseaddr(rx_idx),DPRX_REG_AUX_CONTROL) | (1 << 8))
#define BTC_DPRX_DISABLE_IRQ(rx_idx)    IOWR(btc_dprx_baseaddr(rx_idx),DPRX_REG_AUX_CONTROL,IORD(btc_dprx_baseaddr(rx_idx),DPRX_REG_AUX_CONTROL) & ~(1 << 8))
#define BTC_DPRX_ISENABLED_IRQ(rx_idx)  ((IORD(btc_dprx_baseaddr(rx_idx),DPRX_REG_AUX_CONTROL) >> 8) & 0x01)

//********** btc_dprx_common.c *********//
int btc_dprx_syslib_add_rx(BYTE rx_idx,
                           unsigned int rx_base_addr,
                           unsigned int rx_irq_id,
                           unsigned int rx_irq_num,
                           unsigned int rx_num_of_sinks,
                           unsigned int options);
int btc_dprx_syslib_init(void);
int btc_dprx_syslib_monitor(void);
void btc_dprx_syslib_info(BYTE *max_sink_num, BYTE *mst_support);
unsigned int btc_dprx_baseaddr(BYTE rx_idx);
int btc_dprx_set_dpcd_ver(BYTE rx_idx, BYTE ver);
void btc_dprx_sw_ver(BYTE *major,BYTE *minor, unsigned int *rev);
void btc_dprx_rtl_ver(BYTE *major,BYTE *minor, unsigned int *rev);

//********** btc_dprx_aux_ch.c *********//
int btc_dprx_aux_get_request(BYTE rx_idx,BYTE *cmd,unsigned int *address,BYTE *length,BYTE *data);
int btc_dprx_aux_post_reply(BYTE rx_idx,BYTE cmd,BYTE size,BYTE *data);
int btc_dprx_aux_handler(BYTE rx_idx,BYTE cmd,unsigned int address,BYTE length,BYTE *data);
void btc_dprx_aux_set_i2c(BYTE rx_idx,BYTE i2c_idx,BYTE start_addr,BYTE end_addr);

//********** btc_dprx_dpcd.c *********//
int btc_dprx_dpcd_gpu_access(BYTE rx_idx,BYTE wrcmd,unsigned int address,BYTE length,BYTE *data);

//********** btc_dprx_edid.c *********//
int btc_dprx_edid_set(BYTE rx_idx,BYTE port,BYTE *edid_data,BYTE num_blocks);

//********** btc_dprx_hpd.c *********//
void btc_dprx_hpd_set(BYTE rx_idx,int level);
int btc_dprx_hpd_get(BYTE rx_idx);
void btc_dprx_hpd_pulse(BYTE rx_idx,BYTE dev_irq_vect0,BYTE dev_irq_vect1,BYTE link_irq_vect0);

//********** btc_dprx_lt.c *********//
void btc_dprx_lt_force(BYTE rx_idx);
int btc_dprx_lt_eyeq_init(BYTE rx_idx, BYTE enabled, BYTE log_chan_from, BYTE log_chan_to, unsigned int rcnf_base_addr);

#endif /* _BTC_DPRX_SYSLIB_H_ */
