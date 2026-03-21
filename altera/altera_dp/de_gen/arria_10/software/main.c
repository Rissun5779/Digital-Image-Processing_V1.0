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

BYTE altera_4k_edid[128] =
{
  0x00,0xff,0xff,0xff,0xff,0xff,0xff,0x00,
  0x4c,0x2d,0x80,0x0b,0x00,0x00,0x00,0x00,
  0x34,0x17,0x01,0x04,0xb5,0x3d,0x23,0x78,
  0x00,0x5f,0xb1,0xa2,0x57,0x4f,0xa2,0x28,
  0x0f,0x50,0x54,0x00,0x01,0x00,0x81,0x0f,
  0x81,0x19,0x81,0x80,0x81,0x8f,0xa9,0xc0,
  0xb3,0x00,0x95,0x00,0xd1,0x00,0x4d,0xd0,
  0x00,0xa0,0xf0,0x70,0x3e,0x80,0x30,0x20,
  0x35,0x00,0x5f,0x59,0x21,0x00,0x00,0x1a,
  0x26,0x68,0x00,0xa0,0xf0,0x70,0x3e,0x80,
  0x30,0x20,0x35,0x00,0x5f,0x59,0x21,0x00,
  0x00,0x1a,0x00,0x00,0x00,0xfd,0x00,0x38,
  0x78,0x1e,0x86,0x36,0x00,0x0a,0x20,0x20,
  0x20,0x20,0x20,0x20,0x00,0x00,0x00,0xfc,
  0x00,0x55,0x32,0x38,0x44,0x35,0x39,0x30,
  0x0a,0x20,0x20,0x20,0x20,0x20,0x00,0xe3
};

void bitec_menu_print();
void bitec_menu_cmd();
void bitec_dprx_init();

extern int new_rx;
BYTE tx_edid_data[512]; // TX copy of Sink EDID

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
#if DP_SUPPORT_TX
  btc_dptx_syslib_add_tx(0,
  						 DP_TX_DP_SOURCE_BASE,
                         DP_TX_DP_SOURCE_IRQ_INTERRUPT_CONTROLLER_ID,
                         DP_TX_DP_SOURCE_IRQ);
  btc_dptx_syslib_init();
#endif
#if DP_SUPPORT_RX
#if BITEC_RX_GPUMODE
  btc_dprx_syslib_add_rx(0,
                         DP_RX_DP_SINK_BASE,
                         DP_RX_DP_SINK_IRQ_INTERRUPT_CONTROLLER_ID,
                         DP_RX_DP_SINK_IRQ,
                         DP_RX_DP_SINK_BITEC_CFG_RX_MAX_NUM_OF_STREAMS,
                         0);
  btc_dprx_syslib_init();
#endif
#endif

#if BITEC_DP_CARD_REV
  // Init the PS8460 I2C interface
  bitec_i2c_init(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE);

  // Set the PS8460 P4 registers
  // Set the PS8460 equaliser as required by your design
  bitec_i2c_write(0x18, 0x09, 0x02);
  bitec_i2c_write(0x18, 0x0B, 0xC4); // Enable EQ from I2C register,squelch enabled
  bitec_i2c_write(0x18, 0x0C, 0x55); // HBR RBR EQ
  bitec_i2c_write(0x18, 0x0D, 0x85); // HBR2 EQ
  bitec_i2c_write(0x18, 0x0E, 0x05); // HBR3 EQ
  bitec_i2c_write(0x18, 0x9A, 0x88); // L1_VOD L1_PRE L0_VOD L0_PRE
  bitec_i2c_write(0x18, 0x9B, 0x88); // L3_VOD L3_PRE L2_VOD L2_PRE
  bitec_i2c_write(0x18, 0xA4, 0x08); // Full Jitter cleaning mode
#endif

  // Init sink and source

#if DP_SUPPORT_EDID_PASSTHRU
  bitec_dptx_init();
  // Added 100ms delay //
  {
    unsigned int tout;
    alt_timestamp_start();
    tout = alt_timestamp_freq()/10;
    while(alt_timestamp() < tout);
  }
  {
    unsigned int sr;
    sr = IORD(btc_dptx_baseaddr(0),DPTX_REG_TX_STATUS); // Reading SR clears IRQ

    if(sr & 0x04)
    {
      btc_dptx_edid_read(0,tx_edid_data); // Read the sink EDID
      btc_dprx_edid_set(0,0,tx_edid_data,tx_edid_data[126]+1); // EDID Passthru from Sink to Source
    }
    else
    {
      btc_dprx_edid_set(0,0,altera_4k_edid,sizeof(altera_4k_edid)/128);
    }
  }
#else
      btc_dprx_edid_set(0,0,altera_4k_edid,sizeof(altera_4k_edid)/128);
#endif


#if DP_SUPPORT_RX && BITEC_RX_GPUMODE
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
#if DP_SUPPORT_RX
  bitec_dp_dump_aux_debug_init(DP_RX_AUX_RX_DEBUG_FIFO_IN_CSR_BASE);
#endif
#if DP_SUPPORT_TX
  bitec_dp_dump_aux_debug_init(DP_TX_AUX_TX_DEBUG_FIFO_IN_CSR_BASE);
#endif
#endif

#if DP_SUPPORT_TX
  // Check if a Sink is readily connected
  {
    unsigned int sr;
    sr = IORD(btc_dptx_baseaddr(0),DPTX_REG_TX_STATUS); // Reading SR clears IRQ

    if(sr & 0x04)
    {
#if BITEC_TX_CAPAB_MST
      btc_dptxll_hpd_change(0,1);
      pc_fsm = PC_FSM_START;
#else
      btc_dptx_hpd_change(0,1);
      bitec_dptx_linktrain(0);
#endif
    }
  }

  BTC_DPTX_ENABLE_HPD_IRQ(0); // Enable IRQ on HPD changes from the sink
#endif

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
#if DP_SUPPORT_TX
    btc_dptx_syslib_monitor();
#if BITEC_TX_CAPAB_MST
    btc_dptxll_syslib_monitor();
#endif
#endif

#if DP_SUPPORT_RX && BITEC_RX_GPUMODE
    btc_dprx_syslib_monitor();
#endif

#if TX_VIDEO_IM_ENABLE
    // Video Image video input in use:
    // copy RX MSA parameters to the TX
    {
      unsigned prx, ptx;

      prx = btc_dprx_baseaddr(0);
      ptx = btc_dptx_baseaddr(0);
      IOWR(ptx,DPTX0_REG_MSA_HTOTAL,IORD(prx,DPRX0_REG_MSA_HTOTAL));
      IOWR(ptx,DPTX0_REG_MSA_VTOTAL,IORD(prx,DPRX0_REG_MSA_VTOTAL));
      IOWR(ptx,DPTX0_REG_MSA_HSP,IORD(prx,DPRX0_REG_MSA_HSP));
      IOWR(ptx,DPTX0_REG_MSA_HSW,IORD(prx,DPRX0_REG_MSA_HSW));
      IOWR(ptx,DPTX0_REG_MSA_HSTART,IORD(prx,DPRX0_REG_MSA_HSTART));
      IOWR(ptx,DPTX0_REG_MSA_VSTART,IORD(prx,DPRX0_REG_MSA_VSTART));
      IOWR(ptx,DPTX0_REG_MSA_VSP,IORD(prx,DPRX0_REG_MSA_VSP));
      IOWR(ptx,DPTX0_REG_MSA_VSW,IORD(prx,DPRX0_REG_MSA_VSW));
    }
#endif
#if DP_SUPPORT_TX && BITEC_TX_CAPAB_MST
    // Simulate the user MST TX application
    bitec_dptx_pc();
#endif

#if BITEC_AUX_DEBUG
    // Dump AUX channel traffic
#if DP_SUPPORT_RX
    bitec_dp_dump_aux_debug(DP_RX_AUX_RX_DEBUG_FIFO_IN_CSR_BASE, DP_RX_AUX_RX_DEBUG_FIFO_OUT_BASE, 1);
#endif
#if DP_SUPPORT_TX
    bitec_dp_dump_aux_debug(DP_TX_AUX_TX_DEBUG_FIFO_IN_CSR_BASE, DP_TX_AUX_TX_DEBUG_FIFO_OUT_BASE, 0);
#endif
#endif

    // Serve menu commands, if any
    bitec_menu_cmd();

#if DP_SUPPORT_EDID_PASSTHRU
	// If new Sink detected, pass-thru the EDID from Sink to Source    
    if(new_rx)
    {
    int i;
        new_rx = 0;
 
        btc_dprx_hpd_set(0,0); // HPD = 0

        // Init the EDID(s)
      btc_dptx_edid_read(0,tx_edid_data); // Read the sink EDID
        btc_dprx_edid_set(0,0,tx_edid_data,tx_edid_data[126]+1);

      // Wait for 500 ms to have a long HPD
      {
         unsigned int tout;
         alt_timestamp_start();
         tout = alt_timestamp_freq()/2;
         while(alt_timestamp() < tout);
      }
      btc_dprx_hpd_set(0,1); // HPD = 1
        
    }

    // Detect RX Colormetry and update TX MSA accordingly
    unsigned int rx_color_enc, rx_color_range, rx_color_colorimetry, rx_color_bpc, rx_color_sdp; 
    unsigned int xdash, rx_misc0, tx_misc0, rx_color, tx_color;
	rx_color = IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) & 0xFFFF;
	rx_color_enc = (IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) >> 4) & 0x0f;
	rx_color_range = (IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) >> 12) & 0x01;
	rx_color_colorimetry = (IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) >> 8) & 0x0f;
	rx_color_bpc = (IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) >> 0) & 0x07;
	rx_color_sdp = (IORD(btc_dprx_baseaddr(0), DPRX0_REG_MSA_COLOUR) >> 13) & 0x01;
	tx_color = IORD(btc_dptx_baseaddr(0), DPTX0_REG_MSA_COLOUR) & 0xFFFF;
	if(rx_color != tx_color)
	{
		btc_dptx_video_enable(0,0);
		btc_dptx_set_color_space(0,rx_color_enc,rx_color_bpc,rx_color_range,rx_color_colorimetry,rx_color_sdp);
		btc_dptx_video_enable(0,1);
	}
	
#endif

#if DP_SUPPORT_RX
    if(IORD(DP_RX_PIO_0_BASE,0))
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
    #if DP_SUPPORT_TX
      bitec_dp_dump_source_msa(btc_dptx_baseaddr(0));
      bitec_dp_dump_source_config(btc_dptx_baseaddr(0));
    #endif
      bitec_dp_dump_sink_msa(btc_dprx_baseaddr(0));
      bitec_dp_dump_sink_config(btc_dprx_baseaddr(0));
  #endif

#endif
    }
#endif
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


