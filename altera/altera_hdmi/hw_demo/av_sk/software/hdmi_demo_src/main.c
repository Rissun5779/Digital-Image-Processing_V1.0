
#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>
#include "alt_types.h"
#include "vip_func.h"
#include "xcvr_gpll_rcfg.h"


int main()
{
	int pix_rate;
	int gpll_range = 20;
	int prev_gpll_range;
	int txchn_range = 20;
	int prev_txchn_range;
	int txpll_range = 20;
	int prev_txpll_range;
	int bpc = 0;
	int prev_bpc;
	//int tmds_bit_clock_ratio = 0;
	//int prev_tmds_bit_clock_ratio;
 	int gpll_xcvr_rcfg = 1;
	//int tx_hpd_req;
	int prev_cvi_width;
 	int prev_cvi_height;
	int cvi_width = 2160;
	int cvi_height = 3840;
	int cvo_reconfig = 0;
	int cvi_status_reg;
  
  	//init_i2c(OC_I2C_MASTER_0_BASE);
	//if(DEBUG_MODE) read_ssdc(OC_I2C_MASTER_0_BASE);

	if (DEBUG_MODE) printf("Started in debug mode...\n");
	IOWR(WD_TIMER_BASE, 0x0, 0x0); // clear timeout flag
	IOWR(WD_TIMER_BASE, 0x2, 0x1); // reset counter
	IOWR(WD_TIMER_BASE, 0x1, 0x4); // start timer	

	SET_VIDEO_MODE(3);
	IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 1); // Turn on CVO
	IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0xF); // Turn on the CVI and its interrupts
 
	IOWR(TX_OS_PIO_BASE, 0, 0); // set to non-oversampling mode
	IOWR(TX_RST_PLL_PIO_BASE, 0, 1); // assert reset for TX PLL
	IOWR(TX_RST_PLL_PIO_BASE, 0, 0); // deassert reset for TX PLL
	//IOWR(TX_HPD_ACK_PIO_BASE, 0, 0); // set TX HPD acknowledge bit to 0
     
	while(1)
	{
		// Wait for measure_valid assertion
		while (IORD(MEASURE_VALID_PIO_BASE,0) == 0)
		{
			IOWR(WD_TIMER_BASE, 0x0, 0x0);
			IOWR(WD_TIMER_BASE, 0x2, 0x1);
		}

		// Get pixel clock rate
		pix_rate = IORD(MEASURE_PIO_BASE,0);
		
		if (pix_rate < 0xFFFFFF) {	
			if (pix_rate < 610000)
				IOWR(TX_OS_PIO_BASE, 0, 1);
			else
				IOWR(TX_OS_PIO_BASE, 0, 0);

			prev_bpc = bpc;
			bpc = IORD(BPC_PIO_BASE, 0);
			
			prev_gpll_range = gpll_range;
			gpll_range = GPLL_COMPARE(pix_rate);

			prev_txchn_range = txchn_range;
			txchn_range = TXCHN_COMPARE(pix_rate);

			prev_txpll_range = txpll_range;
			txpll_range = TXPLL_COMPARE(pix_rate);

			gpll_xcvr_rcfg = prev_gpll_range != gpll_range || prev_txchn_range != txchn_range || prev_txpll_range != txpll_range || prev_bpc != bpc;
		} else {
			gpll_xcvr_rcfg = 0;
		}
		
		CVI_DETECT();
		prev_cvi_width = cvi_width;
		prev_cvi_height = cvi_height;
		cvi_width = IORD(ALT_VIP_CL_CVI_0_BASE, 4);  //Active samples in a line
		cvi_height = IORD(ALT_VIP_CL_CVI_0_BASE, 5); //Active lines
		cvo_reconfig = (prev_cvi_width != cvi_width || prev_cvi_height != cvi_height);

		// Reconfig GPLL on TX and TX xcvr
		if (gpll_xcvr_rcfg)
		{
			if (DEBUG_MODE) printf("GPLL range = %d\n", gpll_range);
			if (DEBUG_MODE) printf("TX channel range = %d\n", txchn_range);
			if (DEBUG_MODE) printf("TX PLL range = %d\n", txpll_range);
			if (DEBUG_MODE) printf("BPC = %d\n", bpc);
			
			IOWR(TX_RST_CORE_PIO_BASE, 0, 1); // Reset core
			IOWR(WD_TIMER_BASE, 0x0, 0x0);    // Restart timer
			IOWR(WD_TIMER_BASE, 0x2, 0x1);
			IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 0); // Turn off CVO
			IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0); // Turn off CVI

			if (prev_gpll_range != gpll_range  || prev_bpc != bpc)
			{
				//prev_bpc = bpc;

				if (DEBUG_MODE)
				{
					printf("Pixel rate = %d\n", pix_rate);
					printf("Reconfiguring GPLL...\n");
				}

				GPLL_RECONFIG(gpll_range, bpc);
				if (DEBUG_MODE) printf("Resetting GPLL...\n");
				IOWR(TX_RST_PLL_PIO_BASE, 0, 1);
				IOWR(TX_RST_PLL_PIO_BASE, 0, 0);
			}


			if (prev_txchn_range != txchn_range || prev_bpc != bpc)
			{
				if (DEBUG_MODE)
				{
					printf("Pixel rate = %d\n", pix_rate);
					printf("Reconfiguring TX Channel...\n");
				}
				TX_CHN_RECONFIG(txchn_range);
			}


			if (prev_txpll_range != txpll_range || prev_bpc != bpc)
			{
				if (DEBUG_MODE)
				{
					printf("Pixel rate = %d\n", pix_rate);
					printf("Reconfiguring TX PLL (CMU)...\n");
				}
				TX_PLL_RECONFIG(txpll_range);
			}


			if (prev_txchn_range != txchn_range || prev_txpll_range != txpll_range || prev_bpc != bpc) 
			{
				if (DEBUG_MODE) printf("Resetting XCVR...\n");
				IOWR(TX_RST_XCVR_PIO_BASE, 0, 1);
				IOWR(TX_RST_XCVR_PIO_BASE, 0, 0);
			}
		}

		// Configure CVO if necessary
		if (cvo_reconfig)
		{
			if (DEBUG_MODE) printf("CVI detected new resolution %d x %d\n", cvi_width, cvi_height);

			IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 0); // Turn off CVO
			IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0); // Turn off CVI
			RECONFIG_CVO(IORD(ALT_VIP_CL_CVI_0_BASE, 7), IORD(ALT_VIP_CL_CVI_0_BASE, 8)); //Pass total width and height

		} else {
			cvi_status_reg = IORD(ALT_VIP_CL_CVI_0_BASE, 1);

	        if ((cvi_status_reg & (0x01<<9)) != 0) {
	        	if (DEBUG_MODE) printf("Overflow detected; Clearing sticky bit\n");
	            IOWR(ALT_VIP_CL_CVI_0_BASE, 1, cvi_status_reg);
	        }
		}

		// End of loop
		if (gpll_xcvr_rcfg || cvo_reconfig)
		{
			IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 1); // Turn on CVO
			IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 1); // Turn on CVI
			gpll_xcvr_rcfg = 0;
			cvo_reconfig = 0;
			IOWR(TX_RST_CORE_PIO_BASE, 0, 0); // Release core reset
			IOWR(WD_TIMER_BASE, 0x0, 0x0); //Reset timer
			IOWR(WD_TIMER_BASE, 0x2, 0x1);
			if (DEBUG_MODE) printf("-----------------------------------\n");
		}
	}

	return 0;
}


