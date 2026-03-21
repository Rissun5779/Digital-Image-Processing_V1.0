#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>
#include "xcvr_gpll_rcfg.h"

//
// Functions for Transceiver/PLL Reconfiguration 
//
int GPLL_COMPARE (int PIX_RATE)
{
    int gpll_range;

    if      (PIX_RATE <  500000) gpll_range = 0;
    else if (PIX_RATE <  700000) gpll_range = 1;
    else if (PIX_RATE < 1000000) gpll_range = 2;
    else if (PIX_RATE < 1700000) gpll_range = 3;
    else if (PIX_RATE < 3400000) gpll_range = 4;
    else if (PIX_RATE < 6000000) gpll_range = 5;

    return gpll_range;
}

int TXPLL_COMPARE (int TMDS_CLK_FREQ, int TMDS_BIT_CLOCK_RATIO)
{
    int txpll_range;


	if(TMDS_BIT_CLOCK_RATIO) { //HDMI 2.0
		if      (TMDS_CLK_FREQ <  750000) txpll_range = 11;
		else if (TMDS_CLK_FREQ <  950000) txpll_range = 12;
		else if (TMDS_CLK_FREQ < 1000000) txpll_range = 13;
		else if (TMDS_CLK_FREQ < 1450000) txpll_range = 14;
		else if (TMDS_CLK_FREQ < 1500000) txpll_range = 15;
	} else {
		if      (TMDS_CLK_FREQ <  300000) txpll_range = 0;
		else if (TMDS_CLK_FREQ <  350000) txpll_range = 1;
		else if (TMDS_CLK_FREQ <  390000) txpll_range = 2;
		else if (TMDS_CLK_FREQ <  500000) txpll_range = 3;
		else if (TMDS_CLK_FREQ <  600000) txpll_range = 4;
		else if (TMDS_CLK_FREQ <  900000) txpll_range = 5;
		else if (TMDS_CLK_FREQ < 1000000) txpll_range = 6;
		else if (TMDS_CLK_FREQ < 1500000) txpll_range = 7;
		else if (TMDS_CLK_FREQ < 2250000) txpll_range = 8;
		else if (TMDS_CLK_FREQ < 3000000) txpll_range = 9;
		else if (TMDS_CLK_FREQ < 3400000) txpll_range = 10;
	}
   
    return txpll_range;
}

int TX_OS_ENC(int PIX_RATE)
{
	int tx_os;

	if      (PIX_RATE <  300000) 	tx_os = 3;
	else if (PIX_RATE <  350000) 	tx_os = 2;
	else if (PIX_RATE <  500000) 	tx_os = 1;
	else if (PIX_RATE < 1000000) 	tx_os = 3;
	else 							tx_os = 0;

	return tx_os;
}

//
// PLL Reconfiguration
//
void GPLL_RCFG_WRITE (int OFFSET, int VALUE)
{
	IOWR(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE, OFFSET, VALUE);
}

void READ_GPLL_RCFG_READY ()
{
	//while (IORD(TX_IOPLL_WAITREQUEST_PIO_BASE,0) == 0) {}
	while (IORD(TX_IOPLL_WAITREQUEST_PIO_BASE,0) == 1) {}
}

void GPLL_RECONFIG(int GPLL_RANGE, int COLOR_DEPTH)
{
	IOWR(WD_TIMER_BASE, 0x0, 0x0); // clear timeout flag
	IOWR(WD_TIMER_BASE, 0x2, 0x1); // reset internal counter
	IOWR(WD_TIMER_BASE, 0x1, 0x4); // start timer

	if (DEBUG_MODE)
	{
		printf("GPLL_RANGE = %d\n", GPLL_RANGE);
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x3, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0x3));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x4, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0x4));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x8, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0x8));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x9, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0x9));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xA, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0xA));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xB, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0xB));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xC, data = %x\n", IORD(TX_IOPLL_RCFG_MGMT_TRANSLATOR_BASE,0xC));
	}

	switch (GPLL_RANGE)
	{
		case 0: // <50MHz
	        GPLL_RCFG_WRITE(0x90, 0x00000F0F);                            // m 30
	        GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	        GPLL_RCFG_WRITE(0xC0, 0x00000303);                            // c0 6
	        GPLL_RCFG_WRITE(0xC1, 0x00001E1E);                            // c1 60
	        if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00001E1E); // c2 60
	        else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00002625); // c2 75
	        else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00002D2D); // c2 90
	        else                       GPLL_RCFG_WRITE(0xC2, 0x00003C3C); // c2 120
	        GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	        GPLL_RCFG_WRITE(0x40, 0x00000100);                            // bw
	        GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	        break;

	    case 1: // <70MHz
	    	GPLL_RCFG_WRITE(0x90, 0x00000A0A);                            // m 20
	    	GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	    	GPLL_RCFG_WRITE(0xC0, 0x00000202);                            // c0 4
	    	GPLL_RCFG_WRITE(0xC1, 0x00001414);                            // c1 40
	    	if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00001414); // c2 40
	    	else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00001919); // c2 50
	    	else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00001E1E); // c2 60
	    	else                       GPLL_RCFG_WRITE(0xC2, 0x00002828); // c2 80
	    	GPLL_RCFG_WRITE(0x20, 0x0000000B);                            // cp
	    	GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	    	GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	    	break;

	    case 2: // <100MHz
	    	GPLL_RCFG_WRITE(0x90, 0x00000505);                            // m 10
	    	GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	    	GPLL_RCFG_WRITE(0xC0, 0x00000101);                            // c0 2
	    	GPLL_RCFG_WRITE(0xC1, 0x00000A0A);                            // c1 20
	    	if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00000A0A); // c2 20
	    	else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00000D0C); // c2 25
	    	else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00000F0F); // c2 30
	    	else                       GPLL_RCFG_WRITE(0xC2, 0x00001414); // c2 40
	    	GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	    	GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	    	GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	    	break;

	    case 3: // <170MHz
	    	GPLL_RCFG_WRITE(0x90, 0x00000404);                            // m 8
	    	GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	    	GPLL_RCFG_WRITE(0xC0, 0x00000404);                            // c0 8
	    	GPLL_RCFG_WRITE(0xC1, 0x00000808);                            // c1 16
	    	if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00000808); // c2 16
	    	else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00000A0A); // c2 20
	    	else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00000C0C); // c2 24
	    	else                       GPLL_RCFG_WRITE(0xC2, 0x00001010); // c2 32
	    	GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	    	GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	    	GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	    	break;

	    case 4: // <340MHz
	        GPLL_RCFG_WRITE(0x90, 0x00000202);                            // m 4
	        GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	        GPLL_RCFG_WRITE(0xC0, 0x00000202);                            // c0 4
	        GPLL_RCFG_WRITE(0xC1, 0x00000404);                            // c1 8
	        if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00000404); // c2 8
	        else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00000505); // c2 10
	        else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00000606); // c2 12
	        else                       GPLL_RCFG_WRITE(0xC2, 0x00000808); // c2 16
	        GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	        GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	        GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	        break;

	    case 5: // <600MHz
	        GPLL_RCFG_WRITE(0x90, 0x00000404);                            // m 8
	        GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	        GPLL_RCFG_WRITE(0xC0, 0x00000101);                            // c0 2
	        GPLL_RCFG_WRITE(0xC1, 0x00000202);                            // c1 4
	        if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00000202); // c2 4
	        else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00000302); // c2 5
	    	else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00000303); // c2 6
	    	else                       GPLL_RCFG_WRITE(0xC2, 0x00000404); // c2 8
	        GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	        GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	        GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	        break;

	    default: // <600MHz
	    	GPLL_RCFG_WRITE(0x90, 0x00000404);                            // m 8
	    	GPLL_RCFG_WRITE(0xA0, 0x00010000);                            // n 1
	    	GPLL_RCFG_WRITE(0xC0, 0x00000101);                            // c0 2
	    	GPLL_RCFG_WRITE(0xC1, 0x00000202);                            // c1 4
	    	if      (COLOR_DEPTH == 0) GPLL_RCFG_WRITE(0xC2, 0x00000202); // c2 4
	    	else if (COLOR_DEPTH == 1) GPLL_RCFG_WRITE(0xC2, 0x00000302); // c2 5
			else if (COLOR_DEPTH == 2) GPLL_RCFG_WRITE(0xC2, 0x00000303); // c2 6
			else                       GPLL_RCFG_WRITE(0xC2, 0x00000404); // c2 8
	    	GPLL_RCFG_WRITE(0x20, 0x00000010);                            // cp
	    	GPLL_RCFG_WRITE(0x40, 0x000000C0);                            // bw
	    	GPLL_RCFG_WRITE(0x00, 0x00000001);                            // Write trigger
	    	break;
        }

        READ_GPLL_RCFG_READY ();

        IOWR(WD_TIMER_BASE, 0x1, 0x8); // stop the timer
        IOWR(WD_TIMER_BASE, 0x0, 0x0); // clear timeout flag
        IOWR(WD_TIMER_BASE, 0x2, 0x1); // reset internal counter
}

//
// Transceiver Reconfiguration
//
void READ_XCVR_RCFG_BUSY (int MGMT_ADDR_BASE)
{
	while ((IORD(MGMT_ADDR_BASE,0) && 0x01) == 1) {}
}

void READ_PLL_RECAL_BUSY ()
{
	int recal_busy_reg;

	do
	{
		recal_busy_reg = IORD(TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, 0x280);
	}
	while ((recal_busy_reg >> 1 & 0x01)  == 0);

	do
	{
		recal_busy_reg = IORD(TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, 0x280);
	}
	while ((recal_busy_reg >> 1 & 0x01) == 1);
}

void RECONFIG_READ_MODIFY_WRITE (int MGMT_ADDR_BASE, int ADDRESS, int BITMASK, int VALUEMASK)
{
	int readdata_reg;
	int data_reg;

	readdata_reg = IORD(MGMT_ADDR_BASE, ADDRESS);
	data_reg = (readdata_reg & ~BITMASK) | (VALUEMASK & BITMASK);
	IOWR (MGMT_ADDR_BASE, ADDRESS, data_reg);
}

void TX_PLL_RECONFIG (int TXPLL_RANGE)
{
	int ADDR_BITMASK_VALMASK[6][3];
	int i;
	int NUM_RCFG_WORD = 6;

	NUM_RCFG_WORD = 6;
	// address                          bitmask
	ADDR_BITMASK_VALMASK[0][0] = 0x12B; ADDR_BITMASK_VALMASK[0][1] = 0xFF; // [7:0] cmu_fpll_pll_m_counter
	ADDR_BITMASK_VALMASK[1][0] = 0x12C; ADDR_BITMASK_VALMASK[1][1] = 0xFF; // [7:3] cmu_fpll_pll_n_counter, [2:1] cmu_fpll_pll_l_counter, [0] cmu_fpll_pll_m_counter
	ADDR_BITMASK_VALMASK[2][0] = 0x133; ADDR_BITMASK_VALMASK[2][1] = 0x0C; // [3:2] cmu_fpll_pll_lf_resistance
	ADDR_BITMASK_VALMASK[3][0] = 0x134; ADDR_BITMASK_VALMASK[3][1] = 0x70; // [6:4] cmu_fpll_pll_cp_current_setting
	ADDR_BITMASK_VALMASK[4][0] = 0x135; ADDR_BITMASK_VALMASK[4][1] = 0x07; // [2:0] cmu_fpll_pll_cp_current_setting
	ADDR_BITMASK_VALMASK[5][0] = 0x136; ADDR_BITMASK_VALMASK[5][1] = 0x04; // [2] cmu_fpll_pll_vco_ph2_en
	       
	switch (TXPLL_RANGE)
	{
		case 0: // <30MHz, HDMI 1.4
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x64; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0C; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4E; 
			ADDR_BITMASK_VALMASK[3][2] = 0x10;
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;

		case 1: // <35MHz, HDMI 1.4
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x50;
			ADDR_BITMASK_VALMASK[1][2] = 0x0C;
			ADDR_BITMASK_VALMASK[2][2] = 0x4E;
			ADDR_BITMASK_VALMASK[3][2] = 0x10;
			ADDR_BITMASK_VALMASK[4][2] = 0x03;
			ADDR_BITMASK_VALMASK[5][2] = 0x21;
			break;

		case 2: // <39MHz, HDMI 1.4
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x78;
			ADDR_BITMASK_VALMASK[1][2] = 0x0E;
			ADDR_BITMASK_VALMASK[2][2] = 0x4E;
			ADDR_BITMASK_VALMASK[3][2] = 0x10;
			ADDR_BITMASK_VALMASK[4][2] = 0x03;
			ADDR_BITMASK_VALMASK[5][2] = 0x21;
			break;

		case 3: // <50MHz, HDMI 1.4
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x3C;
			ADDR_BITMASK_VALMASK[1][2] = 0x0C;
			ADDR_BITMASK_VALMASK[2][2] = 0x46;
			ADDR_BITMASK_VALMASK[3][2] = 0x10;
			ADDR_BITMASK_VALMASK[4][2] = 0x03;
			ADDR_BITMASK_VALMASK[5][2] = 0x21;
			break;


		case 4: // <60MHz, HDMI 1.4
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x64;
			ADDR_BITMASK_VALMASK[1][2] = 0x0C;
			ADDR_BITMASK_VALMASK[2][2] = 0x4E;
			ADDR_BITMASK_VALMASK[3][2] = 0x40;
			ADDR_BITMASK_VALMASK[4][2] = 0x03;
			ADDR_BITMASK_VALMASK[5][2] = 0x21;
			break;

		case 5: // <90MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x32; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;

		case 6: // <100MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x32; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x40; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
				
		case 7: // <150MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x28; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0E; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;

		case 8: // <225MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x14; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0C; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4A; 
			ADDR_BITMASK_VALMASK[3][2] = 0x50; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;

		case 9: // <300MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x14; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0C; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4A; 
			ADDR_BITMASK_VALMASK[3][2] = 0x50; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;

		case 10: // <340MHz, HDMI 1.4b
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4A; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
	
		case 11: // <75MHz, HDMI 2.0
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x50; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0C; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4E; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
			
		case 12: // <95MHz, HDMI 2.0
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x28; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
			
		case 13: // <100MHz, HDMI 2.0
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x28; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
			
		case 14: // <145MHz, HDMI 2.0
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x28; 
			ADDR_BITMASK_VALMASK[1][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[2][2] = 0x46; 
			ADDR_BITMASK_VALMASK[3][2] = 0x30; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x21; 
			break;
			
		case 15: // <150MHz, HDMI 2.0
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x14; 
			ADDR_BITMASK_VALMASK[1][2] = 0x08; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4A; 
			ADDR_BITMASK_VALMASK[3][2] = 0x50; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x25; 
			break;

		default: // <600MHz
			// valmask
			ADDR_BITMASK_VALMASK[0][2] = 0x0A; 
			ADDR_BITMASK_VALMASK[1][2] = 0x10; 
			ADDR_BITMASK_VALMASK[2][2] = 0x4A; 
			ADDR_BITMASK_VALMASK[3][2] = 0x50; 
			ADDR_BITMASK_VALMASK[4][2] = 0x03; 
			ADDR_BITMASK_VALMASK[5][2] = 0x25;
			break;
	}

	// Request user access to the internal configuration bus of TX PLL
 	IOWR (TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, 0x000, 0x00000002);

 	READ_XCVR_RCFG_BUSY(TX_PLL_WAITREQUEST_PIO_BASE); // Wait for waitrequest to be deasserted

 	for (i=0; i<NUM_RCFG_WORD; i=i+1)
	{
	   	int address = ADDR_BITMASK_VALMASK[i][0];
	   	int bitmask = ADDR_BITMASK_VALMASK[i][1];
	   	int valmask = ADDR_BITMASK_VALMASK[i][2];
	   	RECONFIG_READ_MODIFY_WRITE (TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, address, bitmask, valmask);
 	}

	READ_XCVR_RCFG_BUSY(TX_PLL_WAITREQUEST_PIO_BASE); // Wait for waitrequest to be deasserted

	IOWR (TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, 0x100, 0x00000002); // FPLL recalibration

	IOWR (TX_PLL_RCFG_MGMT_TRANSLATOR_BASE, 0x000, 0x00000001); // release user access

	READ_PLL_RECAL_BUSY(); //Wait for FPLL calibration busy goes low

	// TX PMA Recalibration
	IOWR(TX_RCFG_EN_PIO_BASE, 0, 1); //Assert the tx_reconfig_en in the XCVR Arbiter

	for (int CH=0; CH <4; CH++ ) {

		
		//if(DEBUG_MODE) printf("Calibrating TX PMA Channel %d\n", CH);

		IOWR(TX_PMA_CH_BASE, 0, CH);

		// Request user access to the internal configuration bus of TX PMA
		IOWR (TX_PMA_RCFG_MGMT_TRANSLATOR_BASE, ( 0x000), 0x00000002);

		READ_XCVR_RCFG_BUSY(TX_PMA_WAITREQUEST_PIO_BASE); // Wait for TX PMA AVMM waitrequest to be deasserted

		RECONFIG_READ_MODIFY_WRITE(TX_PMA_RCFG_MGMT_TRANSLATOR_BASE, (0x100), 0x60 ,0x20); //set 0x100[6] to 0 and 0x100[5] to 1 for TX PMA calibration

		//RECONFIG_READ_MODIFY_WRITE(TX_PMA_RCFG_MGMT_TRANSLATOR_BASE, (0x166), 0x80 ,0x00); //set 0x166[7] to 0 to set the Rate Switch Flag with different CDR bandwidth setting, this is only required when CMU PLL is used as TXPLL

		IOWR (TX_PMA_RCFG_MGMT_TRANSLATOR_BASE, ( 0x000), 0x00000001); // release user access

		READ_XCVR_RCFG_BUSY(TX_PMA_CAL_BUSY_PIO_BASE); // Wait for TX PMA Calibration Busy for all channels to be deasserted

	}
	



	//if(DEBUG_MODE) printf("TX PMA Calibration Done\n");

	
	IOWR(TX_RCFG_EN_PIO_BASE, 0, 0);

}
