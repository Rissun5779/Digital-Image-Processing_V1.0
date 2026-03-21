#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>

#include "xcvr_gpll_rcfg.h"

//
// Functions for Transceiver/PLL Reconfiguration
// Range Detect
//
int GPLL_COMPARE (int PIX_RATE)
{
    int gpll_range;

    if      (PIX_RATE <  400000) gpll_range = 0;
    else if (PIX_RATE <  600000) gpll_range = 1;
    else if (PIX_RATE < 1600000) gpll_range = 2;
    else if (PIX_RATE < 3400000) gpll_range = 3;
    else if (PIX_RATE < 6000000) gpll_range = 4;

    return gpll_range;
}

int TXCHN_COMPARE (int PIX_RATE)
{
    int txchn_range;

    if      (PIX_RATE <  610000) txchn_range = 0;
    else if (PIX_RATE < 1050000) txchn_range = 1;
    else if (PIX_RATE < 3050000) txchn_range = 2;
    else if (PIX_RATE < 6050000) txchn_range = 3;

    return txchn_range;
}

int TXPLL_COMPARE (int PIX_RATE)
{
    int txpll_range;

    if      (PIX_RATE <  290000) txpll_range = 0;
    else if (PIX_RATE <  610000) txpll_range = 1;
    else if (PIX_RATE < 1450000) txpll_range = 2;
    else if (PIX_RATE < 3150000) txpll_range = 3;
    else if (PIX_RATE < 6050000) txpll_range = 4;

    return txpll_range;
}

//
// PLL Reconfiguration
//
void GPLL_RCFG_WRITE (int OFFSET, int VALUE)
{
	IOWR(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE, OFFSET, VALUE);
}

void READ_GPLL_RCFG_READY ()
{
	int ready_reg;

	do
	{
		ready_reg = IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE, 0x1);
	}
	while (ready_reg == 0);
}

void GPLL_RECONFIG(int GPLL_RANGE, int BPC)
{
	if (DEBUG_MODE)
	{
		printf("GPLL_RANGE = %d\n", GPLL_RANGE);
		printf("BPC = %d\n", BPC);
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x3, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x3));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x4, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x4));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x8, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x8));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0x9, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x9));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xA, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xA));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xB, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xB));
		printf("GPLL RCFG MGMT BEFORE RCFG, OFFSET = 0xC, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xC));
	}

	switch (GPLL_RANGE)
	{
		case 0: // <40MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x01414);                     // pll_m 40
			GPLL_RCFG_WRITE(0x5, 0x000404);                    // pll_c0 8
			GPLL_RCFG_WRITE(0x5, 0x042828);                    // pll_c1 80
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x082828); // pll_c2 80 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x083232); // pll_c2 100 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x083C3C); // pll_c2 120 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x085050); // pll_c2 160 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x7);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;

		case 1: // <60MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00A0A);                     // pll_m 20
			GPLL_RCFG_WRITE(0x5, 0x000202);                    // pll_c0 4
			GPLL_RCFG_WRITE(0x5, 0x041414);                    // pll_c1 40
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x081414); // pll_c2 40 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x081919); // pll_c2 50 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x081E1E); // pll_c2 60 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x082828); // pll_c2 80 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x7);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;

		case 2: // <160MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00505);                     // pll_m 10
			GPLL_RCFG_WRITE(0x5, 0x0000505);                   // pll_c0 10
			GPLL_RCFG_WRITE(0x5, 0x0040A0A);                   // pll_c1 20
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080A0A); // pll_c2 20 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080C0D); // pll_c2 25 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080F0F); // pll_c2 30 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x081414); // pll_c2 40 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x3);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;

		case 3: // <340MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00202);                     // pll_m 4
			GPLL_RCFG_WRITE(0x5, 0x000202);                    // pll_c0 4
			GPLL_RCFG_WRITE(0x5, 0x040404);                    // pll_c1 8
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080404); // pll_c2 8 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080505); // pll_c2 10 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080606); // pll_c2 12 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x080808); // pll_c2 16 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;

		case 4: // <600MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x000404);                    // pll_m 8
			GPLL_RCFG_WRITE(0x5, 0x000101);                    // pll_c0 2
			GPLL_RCFG_WRITE(0x5, 0x040202);                    // pll_c1 4
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080202); // pll_c2 4 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080203); // pll_c2 5 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080303); // pll_c2 6 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x080404); // pll_c2 8 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;

		default: // <600MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x000404);                    // pll_m 8
			GPLL_RCFG_WRITE(0x5, 0x000101);                    // pll_c0 2
			GPLL_RCFG_WRITE(0x5, 0x040202);                    // pll_c1 4
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080202); // pll_c2 4 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080203); // pll_c2 5 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080303); // pll_c2 6 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x080404); // pll_c2 8 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY ();
			break;
	}

	if (DEBUG_MODE)
	{
		printf("GPLL_RANGE = %d\n", GPLL_RANGE);
		printf("BPC = %d\n", BPC);
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0x3, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x3));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0x4, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x4));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0x8, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x8));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0x9, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0x9));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0xA, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xA));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0xB, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xB));
		printf("GPLL RCFG MGMT AFTER RCFG, OFFSET = 0xC, data = %x\n", IORD(TX_GPLL_RCFG_MGMT_TRANSLATOR_BASE,0xC));
	}
}

//
// Transceiver Reconfiguration
//
void XCVR_RCFG_WRITE (int OFFSET, int VALUE)
{
	IOWR(XCVR_RCFG_TRANSLATOR_BASE, OFFSET, VALUE);
}

void READ_XCVR_RCFG_BUSY ()
{
	int busy_reg;

	do
	{
		busy_reg = IORD(XCVR_RCFG_TRANSLATOR_BASE, 0x3A);
	}
	while ((busy_reg >> 8) == 1);
}

void RECONFIG_READ_MODIFY_WRITE (int LOGICAL_CHANNEL_VALUE, int OFFSET_VALUE, int RECONFIG_MASK, int RECONFIG_VALUE, int RECONFIG_VALUE_POS)
{
	if (DEBUG_MODE) printf("Start reconfiguring channel %d\n", LOGICAL_CHANNEL_VALUE);

	int readdata_reg;
	int data_reg;

	// Check busy signal to make sure that there is no other process going on
	READ_XCVR_RCFG_BUSY ();

	XCVR_RCFG_WRITE (0x38, LOGICAL_CHANNEL_VALUE); // LOGICAL_CHANNEL_REGISTER
	XCVR_RCFG_WRITE (0x3A, 0x4);                   // CONTROL_STATUS_REGISTER: Set MIF mode 1
	XCVR_RCFG_WRITE (0x3B, OFFSET_VALUE);          // OFFSET_REGISTER
	XCVR_RCFG_WRITE (0x3A, 0x6);                   // CONTROL_STATUS_REGISTER: Perform read operation
	READ_XCVR_RCFG_BUSY ();

	readdata_reg = IORD(XCVR_RCFG_TRANSLATOR_BASE, 0x3C); // data_reg: Read from Data Register
	if (DEBUG_MODE) printf("readdata_reg = %x\n", readdata_reg);

	// READ MODIFY WRITE
	data_reg = (readdata_reg & RECONFIG_MASK) | (RECONFIG_VALUE << RECONFIG_VALUE_POS);
	if (DEBUG_MODE) printf("writedata_reg = %x\n", data_reg);

	XCVR_RCFG_WRITE (0x3C, data_reg); // data_reg: Write to data register
	XCVR_RCFG_WRITE (0x3A, 0x5);      // CONTROL_STATUS_REGISTER: Perform write operation
	READ_XCVR_RCFG_BUSY ();

	if (DEBUG_MODE) printf("Done reconfiguring channel %d\n", LOGICAL_CHANNEL_VALUE);
}

void TX_CHN_RECONFIG (int TXCHN_RANGE)
{
	int MASK_TX_CH_0x02  = 0xFFFFFE3F;
	int slew;

	switch (TXCHN_RANGE)
	{
		case 0: // 61
			slew = 0x2;
			break;
		case 1: // 105
			slew = 0x1;
			break;
		case 2: // 305
			slew = 0x2;
			break;
		case 3: // 605
			slew = 0x3;
			break;
		default: // 605
			slew = 0x3;
			break;
	}

	if (DEBUG_MODE) printf("TXCHN_RANGE = %d\n", TXCHN_RANGE);
	// TX CH 3
	RECONFIG_READ_MODIFY_WRITE (0x3, 0x2, MASK_TX_CH_0x02, slew, 6);
	// TX CH 4
	RECONFIG_READ_MODIFY_WRITE (0x4, 0x2, MASK_TX_CH_0x02, slew, 6);
	// TX CH 5
	RECONFIG_READ_MODIFY_WRITE (0x5, 0x2, MASK_TX_CH_0x02, slew, 6);
	// TX CH 6
	RECONFIG_READ_MODIFY_WRITE (0x6, 0x2, MASK_TX_CH_0x02, slew, 6);
}

void TX_PLL_RECONFIG (int TXPLL_RANGE)
{
	int MASK_TX_PLL_0x0C = 0xFFFFF3FF;
	int MASK_TX_PLL_0x0E = 0xFFFFFF3F;
	int lpfd;
	int pfd_bwctrl;

	switch (TXPLL_RANGE)
 	{
 		case 0: // 29
 			lpfd = 0x3;
 			pfd_bwctrl = 0x1;
 			break;
 		case 1: // 61
 			lpfd = 0x2;
 			pfd_bwctrl = 0x1;
 			break;
 		case 2: // 145
 			lpfd = 0x3;
 			pfd_bwctrl = 0x1;
 			break;
 		case 3: // 315
 			lpfd = 0x02;
 			pfd_bwctrl = 0x1;
 			break;
 		case 4: // 605
 			lpfd = 0x01;
 			pfd_bwctrl = 0x0;
 			break;
 		default: // 605
 			lpfd = 0x1;
 			pfd_bwctrl = 0x0;
 			break;
	}

	if (DEBUG_MODE) printf("TXPLL_RANGE = %d\n", TXPLL_RANGE);
 	// TX PLL OFFSET 0x0c
	RECONFIG_READ_MODIFY_WRITE (0x7, 0xC, MASK_TX_PLL_0x0C, lpfd, 10);
 	// TX PLL OFFSET 0x0e
 	RECONFIG_READ_MODIFY_WRITE (0x7, 0xE, MASK_TX_PLL_0x0E, pfd_bwctrl, 6);
}
