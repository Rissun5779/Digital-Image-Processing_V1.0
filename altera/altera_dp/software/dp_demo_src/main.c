// ********************************************************************************
// DisplayPort Core test code main
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/dp_demo/main.c $
//
// Description:
//
// ********************************************************************************

#include <stdio.h>
#include <unistd.h>
#include <io.h>
#include <fcntl.h>
#include <string.h>
#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "btc_dprx_syslib.h"
#include "btc_dptx_syslib.h"
#include "btc_dptxll_syslib.h"
#include "debug.h"
#include "i2c.h"
#include "config.h"
#include "tx_utils.h"

void bitec_menu_print();
void bitec_menu_cmd();
void bitec_dprx_init();

int main()
{
  // Force non-blocking jtag uart
  fcntl(STDOUT_FILENO, F_SETFL, O_NONBLOCK);
  fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
  printf("Started...\n");

#ifdef ALT_VIP_MIX_0_BASE
  // Enable TPG Background : Disable DP image
  IOWR(ALT_VIP_MIX_0_BASE, 0, 0); // Stop
  IOWR(ALT_VIP_MIX_0_BASE, 2, 0); // Stream 0 offset X
  IOWR(ALT_VIP_MIX_0_BASE, 3, 0); // Stream 0 offset Y
  IOWR(ALT_VIP_MIX_0_BASE, 4, 0); // Stream 0 off
  IOWR(ALT_VIP_MIX_0_BASE, 5, 1920/2); // Stream 1 offset X
  IOWR(ALT_VIP_MIX_0_BASE, 6, 0); // Stream 1 offset Y
  IOWR(ALT_VIP_MIX_0_BASE, 7, 0); // Stream 1 off
  IOWR(ALT_VIP_MIX_0_BASE, 8, 0); // Stream 2 offset X
  IOWR(ALT_VIP_MIX_0_BASE, 9, 600); // Stream 2 offset Y
  IOWR(ALT_VIP_MIX_0_BASE, 10, 0); // Stream 2 off
  IOWR(ALT_VIP_MIX_0_BASE, 11, 1920/2); // Stream 3 offset X
  IOWR(ALT_VIP_MIX_0_BASE, 12, 600); // Stream 3 offset Y
  IOWR(ALT_VIP_MIX_0_BASE, 13, 0); // Stream 3 off
  IOWR(ALT_VIP_MIX_0_BASE, 0, 1); // Go
#endif

  // Init Bitec DP system library
  btc_dptx_syslib_add_tx(0,
                         DP_TX_MGMT_BASE,
                         DP_TX_MGMT_IRQ_INTERRUPT_CONTROLLER_ID,
                         DP_TX_MGMT_IRQ);
  btc_dptx_syslib_init();
  btc_dprx_syslib_add_rx(0,
                         DP_RX_MGMT_BASE,
                         DP_RX_MGMT_IRQ_INTERRUPT_CONTROLLER_ID,
                         DP_RX_MGMT_IRQ,
                         DP_RX_MGMT_BITEC_CFG_RX_MAX_NUM_OF_STREAMS,
                         0);
#if BITEC_RX_GPUMODE
  btc_dprx_syslib_init();
#endif

  // Init the SN75DP130 on the Bitec Sink main link input
  // (on the Bitec daughter board)
  // Set the SN75DP130 equaliser as required by your design
  {
    unsigned char data[32];

    bitec_i2c_init(OC_I2C_MASTER_0_BASE);

    bitec_i2c_write(0x58, 0x01, 0x03);
    bitec_i2c_write(0x58, 0x03, 0x18); //disable squelch
    bitec_i2c_write(0x58, 0x05, 0xD2); //force EQ for lane 0, pre-emph 0_1, EQ_I2C_ENABLE
    bitec_i2c_write(0x58, 0x06, 0x10); //force EQ for lane 0, pre-emph 2_3
    bitec_i2c_write(0x58, 0x07, 0x52); //force EQ for lane 1, pre-emph 0_1
    bitec_i2c_write(0x58, 0x08, 0x10); //force EQ for lane 1, pre-emph 2_3
    bitec_i2c_write(0x58, 0x09, 0x52); //force EQ for lane 2, pre-emph 0_1
    bitec_i2c_write(0x58, 0x0A, 0x10); //force EQ for lane 2, pre-emph 2_3
    bitec_i2c_write(0x58, 0x0B, 0x52); //force EQ for lane 3, pre-emph 0_1
    bitec_i2c_write(0x58, 0x0C, 0x10); //force EQ for lane 3, pre-emph 2_3
    bitec_i2c_write(0x58, 0x00, 0x00); //reset the RD reg. address

    bitec_i2c_read(0x59, data, 32);
  }

  // Init sink and source
  bitec_dptx_init();
#if BITEC_RX_GPUMODE
  btc_dprx_hpd_set(0,0); // HPD = 0
  bitec_dprx_init();

  BTC_DPRX_ENABLE_IRQ(0); // Enable IRQ on AUX Requests from the source

  // Wait for 500 ms to have a long HPD
  {
    unsigned int tout;
    alt_timestamp_start();
    tout = alt_timestamp_freq()/2;
    while(alt_timestamp() < tout);
  }
  btc_dprx_hpd_set(0,1); // HPD = 1
#endif

#if BITEC_AUX_DEBUG
  bitec_dp_dump_aux_debug_init(AUX_RX_DEBUG_FIFO_IN_CSR_BASE);
  bitec_dp_dump_aux_debug_init(AUX_TX_DEBUG_FIFO_IN_CSR_BASE);
#endif

  BTC_DPTX_ENABLE_HPD_IRQ(0); // Enable IRQ on HPD changes from the sink

  // Main loop
  while(1)
  {
#ifdef ALT_VIP_MIX_0_BASE
    if(IORD(btc_dprx_baseaddr(0), DPRX0_REG_VBID) & 0x80)
      IOWR(ALT_VIP_MIX_0_BASE, 4, 1); // MSA lock -> Enable DP image
    else
      IOWR(ALT_VIP_MIX_0_BASE, 4, 0); // MSA not locked -> Disable DP image

    if(IORD(btc_dprx_baseaddr(0), DPRX1_REG_VBID) & 0x80)
      IOWR(ALT_VIP_MIX_0_BASE, 7, 1); // MSA lock -> Enable DP image
    else
      IOWR(ALT_VIP_MIX_0_BASE, 7, 0); // MSA not locked -> Disable DP image

    if(IORD(btc_dprx_baseaddr(0), DPRX2_REG_VBID) & 0x80)
      IOWR(ALT_VIP_MIX_0_BASE, 10, 1); // MSA lock -> Enable DP image
    else
      IOWR(ALT_VIP_MIX_0_BASE, 10, 0); // MSA not locked -> Disable DP image

    if(IORD(btc_dprx_baseaddr(0), DPRX3_REG_VBID) & 0x80)
      IOWR(ALT_VIP_MIX_0_BASE, 13, 1); // MSA lock -> Enable DP image
    else
      IOWR(ALT_VIP_MIX_0_BASE, 13, 0); // MSA not locked -> Disable DP image
#endif

    // Serve Syslib periodic tasks
    btc_dptx_syslib_monitor();
#if BITEC_TX_CAPAB_MST
    btc_dptxll_syslib_monitor();
#endif
#if BITEC_RX_GPUMODE
    btc_dprx_syslib_monitor();
#endif

#if BITEC_TX_CAPAB_MST
    // Simulate the user MST TX application
    bitec_dptx_pc();
#endif

#if BITEC_AUX_DEBUG
    // Dump AUX channel traffic
    bitec_dp_dump_aux_debug(AUX_RX_DEBUG_FIFO_IN_CSR_BASE, AUX_RX_DEBUG_FIFO_OUT_BASE, 1);
    bitec_dp_dump_aux_debug(AUX_TX_DEBUG_FIFO_IN_CSR_BASE, AUX_TX_DEBUG_FIFO_OUT_BASE, 0);
#endif

    // Serve menu commands, if any
    bitec_menu_cmd();

    if(IORD(PIO_0_BASE,0))
    {
      // User pushbutton pressed
#if 0
#if BITEC_RX_GPUMODE
      btc_dprx_hpd_set(0,0); // HPD = 0

      // Wait for 500 ms to have a long HPD
      {
        unsigned int tout;
        alt_timestamp_start();
        tout = alt_timestamp_freq()/2;
        while(alt_timestamp() < tout);
      }
      btc_dprx_hpd_set(0,1); // HPD = 1
#endif
#else

      // Wait for 500 ms to avoid bouncing
      {
        unsigned int tout;
        alt_timestamp_start();
        tout = alt_timestamp_freq()/2;
        while(alt_timestamp() < tout);
      }

#if BITEC_STATUS_DEBUG
      // Dump MSA
      bitec_dp_dump_source_msa(btc_dptx_baseaddr(0));
      bitec_dp_dump_source_config(btc_dptx_baseaddr(0));
      bitec_dp_dump_sink_msa(btc_dprx_baseaddr(0));
      bitec_dp_dump_sink_config(btc_dprx_baseaddr(0));
#endif

#endif
    }
  }

  return 0; // Should never get here
}

// Printout all menu commands
void bitec_menu_print()
{
#if BITEC_STATUS_DEBUG
	printf("h = Help\n");
	printf("s = Status\n");
	printf("c = Read Sink DPCD CRC\n");
  printf("v = Print versions\n");
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP1
	printf("ha1 = HDCP 1.3 TX authenticate\n");
#endif
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP2
  printf("ha2 = HDCP 2.2 TX authenticate\n");
#endif
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP1 || BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP2
	printf("h0 = HDCP TX encryption off\n");
	printf("h1 = HDCP TX encryption on\n");
#endif
#endif
}

// Implementation of menu commands
void bitec_menu_cmd()
{
#if BITEC_STATUS_DEBUG
	char *cmd;

	cmd = bitec_get_stdin();
    if(cmd != NULL)
    {
        if(cmd[0] == 'c')
        {
          BYTE d[6];
          // Sink CRC
          d[0]=1;
          btc_dptx_aux_write(0,DPCD_ADDR_TEST_SINK,1,d);
          usleep(50000);
          btc_dptx_aux_read(0,DPCD_ADDR_TEST_CRC_R_CR_LSB,6,d);
          printf("CRC R : %4.4x  CRC G : %4.4x  CRC B : %4.4x\n", d[0]+(d[1]<<8),d[2]+(d[3]<<8),d[4]+(d[5]<<8));
          d[0]=0;
          btc_dptx_aux_write(0,DPCD_ADDR_TEST_SINK,1,d);
        }
      if(cmd[0] == 's')
      {
        // Dump MSA
        bitec_dp_dump_source_msa(btc_dptx_baseaddr(0));
        bitec_dp_dump_source_config(btc_dptx_baseaddr(0));
        bitec_dp_dump_sink_msa(btc_dprx_baseaddr(0));
        bitec_dp_dump_sink_config(btc_dprx_baseaddr(0));
      }
      if(cmd[0] == 'v')
      {
        BYTE maj,min;
        unsigned int ver;
        // Print versions
        btc_dptx_sw_ver(&maj,&min,&ver);
        printf("TX SW library ver. %u.%u.%u\n",maj,min,ver);
        btc_dptx_rtl_ver(&maj,&min,&ver);
        printf("TX RTL core ver. %u.%u.%u\n",maj,min,ver);
#if BITEC_RX_GPUMODE
        btc_dprx_sw_ver(&maj,&min,&ver);
        printf("RX SW library ver. %u.%u.%u\n",maj,min,ver);
        btc_dprx_rtl_ver(&maj,&min,&ver);
        printf("RX RTL core ver. %u.%u.%u\n",maj,min,ver);
#endif
      }
      if((cmd[0] == 'h') && (cmd[1] == 0))
		bitec_menu_print();
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP1
      if((cmd[0] == 'h') && (cmd[1] == 'a') && (cmd[2] == '1'))
      {
        BYTE An[8] = {0x34,0x27,0x1c,0x13,0x0c,0x07,0x04,0x03};
        btc_dptx_hdcp1_authenticate(0,An);
      }
#endif
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP2
      if((cmd[0] == 'h') && (cmd[1] == 'a') && (cmd[2] == '2'))
        btc_dptx_hdcp2_authenticate(0,1);
#endif
#if BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP1 || BITEC_DP_0_AV_TX_CONTROL_BITEC_CFG_TX_SUPPORT_HDCP2
      if((cmd[0] == 'h') && (cmd[1] == '0'))
      {
        if(btc_dptx_hdcp_encryption_enable(0,0,0))
          printf("Encryption stop error\n");
        else
          printf("Encryption stop Ok\n");
      }
      if((cmd[0] == 'h') && (cmd[1] == '1'))
      {
        BTC_HDCPTX_STAT s;
        btc_dptx_hdcp_status(0,&s);
        if((s.state != BTC_HDCPTX_STATE_HDCP1_AUTH) && (s.state != BTC_HDCPTX_STATE_HDCP2_AUTH))
          printf("HDCP not Authenticated\n");
        else
        {
            printf("HDCP Authentication ok\n");
            if(btc_dptx_hdcp_encryption_enable(0,0,1))
              printf("Encryption start error\n");
            else
              printf("Encryption start Ok\n");
        }
      }
#endif
    }
#endif
}


