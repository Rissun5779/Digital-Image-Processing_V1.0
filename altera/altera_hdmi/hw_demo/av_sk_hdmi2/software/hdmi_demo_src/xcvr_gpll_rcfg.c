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
    else if (PIX_RATE <  800000) gpll_range = 1;
    else if (PIX_RATE < 1000000) gpll_range = 2;
    else if (PIX_RATE < 2000000) gpll_range = 3;
    else if (PIX_RATE < 3400000) gpll_range = 4;
    else if (PIX_RATE < 6000000) gpll_range = 5;

    return gpll_range;
}

int TXCHN_COMPARE (int PIX_RATE)
{
    int txchn_range;

    if      (PIX_RATE <  610000) txchn_range = 0;
    else if (PIX_RATE < 1010000) txchn_range = 1;
    else if (PIX_RATE < 1050000) txchn_range = 2;
    else if (PIX_RATE < 3050000) txchn_range = 3;
    else if (PIX_RATE < 5050000) txchn_range = 4;
    else if (PIX_RATE < 6050000) txchn_range = 5;

    return txchn_range;
}

int TXPLL_COMPARE (int PIX_RATE)
{
    int txpll_range;

    if      (PIX_RATE <  380000)  txpll_range = 0;
    else if (PIX_RATE <  780000)  txpll_range = 1;
    else if (PIX_RATE < 1000000)  txpll_range = 2;
    else if (PIX_RATE < 1950000)  txpll_range = 3;
    else if (PIX_RATE < 3900000)  txpll_range = 4;
    else if (PIX_RATE < 6000000)  txpll_range = 5;

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

		case 0: // 40MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                         // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                     // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x01414);                     // pll_m 40
			GPLL_RCFG_WRITE(0x5, 0x000404);                    // pll_c0 8
			GPLL_RCFG_WRITE(0x5, 0x045050);                    // pll_c1 160
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x085050); // pll_c2 160 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x086464); // pll_c2 200 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x087878); // pll_c2 240 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x08A0A0); // pll_c2 320 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                         // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x7);                         // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                         // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		case 1: // 80MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00A0A);                      // pll_m 20
			GPLL_RCFG_WRITE(0x5, 0x000202);                     // pll_c0 4
			GPLL_RCFG_WRITE(0x5, 0x042828);                     // pll_c1 80
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x082828);  // pll_c2 80 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x083232);  // pll_c2 100 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x083C3C);  // pll_c2 120 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x085050);  // pll_c2 160 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x7);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		case 2: // 100MHz 
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1 
			GPLL_RCFG_WRITE(0x4, 0x00807);                      // pll_m 15
			GPLL_RCFG_WRITE(0x5, 0x00201);                      // pll_c0 3
			GPLL_RCFG_WRITE(0x5, 0x041E1E);                     // pll_c1 60
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x081E1E);  // pll_c2 60 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x082625);  // pll_c2 75 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x082D2D);  // pll_c2 90 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x083C3C);  // pll_c2 120 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x3);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		case 3: // 200MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00404);                      // pll_m 8
			GPLL_RCFG_WRITE(0x5, 0x000404);                     // pll_c0 8
			GPLL_RCFG_WRITE(0x5, 0x041010);                     // pll_c1 32
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x081010);  // pll_c2 32 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x081414);  // pll_c2 40 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x081818);  // pll_c2 48 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x082020);  // pll_c2 64 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x3);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		case 4: // 340MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00202);                      // pll_m 4
			GPLL_RCFG_WRITE(0x5, 0x000202);                     // pll_c0 4
			GPLL_RCFG_WRITE(0x5, 0x040808);                     // pll_c1 16
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080808);  // pll_c2 16 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080A0A);  // pll_c2 20 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080C0C);  // pll_c2 24 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x081010);  // pll_c2 32 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x2);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		case 5: // 600MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00404);                      // pll_m 8
			GPLL_RCFG_WRITE(0x5, 0x000101);                     // pll_c0 2
			GPLL_RCFG_WRITE(0x5, 0x040404);                     // pll_c1 8
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080404);  // pll_c2 8 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080505);  // pll_c2 10 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080606);  // pll_c2 12 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x080808);  // pll_c2 16 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x3);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;

		default: // 600MHz
			GPLL_RCFG_WRITE(0x0, 0x1);                          // mode register to polling mode
			GPLL_RCFG_WRITE(0x3, 0x10000);                      // pll_n 1
			GPLL_RCFG_WRITE(0x4, 0x00404);                      // pll_m 8
			GPLL_RCFG_WRITE(0x5, 0x000101);                     // pll_c0 2
			GPLL_RCFG_WRITE(0x5, 0x040404);                     // pll_c1 8
			if      (BPC == 0) GPLL_RCFG_WRITE(0x5, 0x080404);  // pll_c2 8 (8bpc)
			else if (BPC == 1) GPLL_RCFG_WRITE(0x5, 0x080505);  // pll_c2 10 (10bpc)
			else if (BPC == 2) GPLL_RCFG_WRITE(0x5, 0x080606);  // pll_c2 12 (12bpc)
			else               GPLL_RCFG_WRITE(0x5, 0x080808);  // pll_c2 16 (16bpc)
			GPLL_RCFG_WRITE(0x9, 0x3);                          // pll_cp
			GPLL_RCFG_WRITE(0x8, 0x8);                          // pll_bw
			GPLL_RCFG_WRITE(0x2, 0x0);                          // Write trigger
			READ_GPLL_RCFG_READY();
			break;
	}
  
	if (DEBUG_MODE)
	{
		printf("GPLL_RANGE = %d\n", GPLL_RANGE);
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

void RECONFIG_READ_MODIFY_WRITE2 (int LOGICAL_CHANNEL_VALUE, int OFFSET_VALUE, int RECONFIG_MASK, int RECONFIG_VALUE1, int RECONFIG_VALUE_POS1, int RECONFIG_VALUE2, int RECONFIG_VALUE_POS2)
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
	data_reg = (readdata_reg & RECONFIG_MASK) | (RECONFIG_VALUE1 << RECONFIG_VALUE_POS1) | (RECONFIG_VALUE2 << RECONFIG_VALUE_POS2);
	if (DEBUG_MODE) printf("writedata_reg = %x\n", data_reg);

	XCVR_RCFG_WRITE (0x3C, data_reg); // data_reg: Write to data register
	XCVR_RCFG_WRITE (0x3A, 0x5);      // CONTROL_STATUS_REGISTER: Perform write operation
	READ_XCVR_RCFG_BUSY ();

	if (DEBUG_MODE) printf("Done reconfiguring channel %d\n", LOGICAL_CHANNEL_VALUE);
}

void TX_CHN_RECONFIG (int TXCHN_RANGE)
{
    int MASK_TX_CH_0x02  = 0xFFFFFC7F;
    int slew;

    switch (TXCHN_RANGE)
    {
     	case 0: // 61
     		slew = 0x2;
     		break;
     	case 1: // 101
     		slew = 0x3;
     		break;
     	case 2: // 105
     		slew = 0x1;
     		break;
     	case 3: // 305
     		slew = 0x2;
     		break;
     	case 4: // 505
     		slew = 0x3;
     		break;
     	case 5: // 600
     		slew = 0x7;
     		break; 
     	default:
     		slew = 0x7;
     		break;
    }

    if (DEBUG_MODE) printf("TXCHN_RANGE = %d\n", TXCHN_RANGE);
    // TX CH 3
    RECONFIG_READ_MODIFY_WRITE (0x3, 0x2, MASK_TX_CH_0x02, slew, 7);
    // TX CH 4
    RECONFIG_READ_MODIFY_WRITE (0x4, 0x2, MASK_TX_CH_0x02, slew, 7);
    // TX CH 5
    RECONFIG_READ_MODIFY_WRITE (0x5, 0x2, MASK_TX_CH_0x02, slew, 7);
    // TX CH 6
    RECONFIG_READ_MODIFY_WRITE (0x6, 0x2, MASK_TX_CH_0x02, slew, 7);
}

void TX_PLL_RECONFIG (int TXPLL_RANGE)
{
    int MASK_TX_PLL_0x0E = 0xFFFFFCFF;
    int MASK_TX_PLL_0x10 = 0xFFFFF8CF;
    int MASK_TX_PLL_0x11 = 0xFFFFFF03;
    int MASK_TX_PLL_0x12 = 0xFFFFFFDF;

    int lpfd;
    int pfd_bwctrl;
    int isel;
    int icp_high;
    int rgla_isel;
    int pcie_mode_sel;

    switch (TXPLL_RANGE)
    {
    	case 0: // 38
    		lpfd = 0x2;
    		isel = 0x4;
    		pfd_bwctrl = 0x1;
    		icp_high = 0x0;
    		rgla_isel = 0x4;
    		pcie_mode_sel = 0x0;
    		break;

    	case 1: // 78
    		lpfd = 0x1;
    		isel = 0x4;
    		pfd_bwctrl = 0x0;
    		icp_high = 0x1;
    		rgla_isel = 0x0;
    		pcie_mode_sel = 0x1;
    		break; 
 
    	case 2: // 100
    		lpfd = 0x0;
    		isel = 0x3;
    		pfd_bwctrl = 0x0;
    		icp_high = 0x0;
    		rgla_isel = 0x0;
    		pcie_mode_sel = 0x1;
    		break;

    	case 3: // 195
    		lpfd = 0x2;
    		isel = 0x4;
    		pfd_bwctrl = 0x1;
    		icp_high = 0x0;
    		rgla_isel = 0x4;
    		pcie_mode_sel = 0x0;
    		break;

    	case 4: // 395
    		lpfd = 0x1;
    		isel = 0x4;
    		pfd_bwctrl = 0x0;
    		icp_high = 0x1;
    		rgla_isel = 0x0;
    		pcie_mode_sel = 0x1;
    		break;

    	case 5: // 600
    		lpfd = 0x0;
    		isel = 0x3;
    		pfd_bwctrl = 0x0;
    		icp_high = 0x0;
    		rgla_isel = 0x0;
    		pcie_mode_sel = 0x1;
    		break;

    	default: // 600
    		lpfd = 0x0;
    		isel = 0x3;
    		pfd_bwctrl = 0x0;
    		icp_high = 0x0;
    		rgla_isel = 0x0;
    		pcie_mode_sel = 0x1;
    		break;
    }

    if (DEBUG_MODE) printf("TXPLL_RANGE = %d\n", TXPLL_RANGE);
    // TX PLL OFFSET 0x0e
    RECONFIG_READ_MODIFY_WRITE (0x7, 0x0E, MASK_TX_PLL_0x0E, lpfd, 8);
    // TX PLL OFFSET 0x0f
    RECONFIG_READ_MODIFY_WRITE2 (0x7, 0x10, MASK_TX_PLL_0x10, isel, 8, pfd_bwctrl, 4);
    // TX PLL OFFSET 0x11
    RECONFIG_READ_MODIFY_WRITE2 (0x7, 0x11, MASK_TX_PLL_0x11, icp_high, 5, rgla_isel, 2);
    // TX PLL OFFSET 0x12
    RECONFIG_READ_MODIFY_WRITE (0x7, 0x12, MASK_TX_PLL_0x12, pcie_mode_sel, 5);
}
