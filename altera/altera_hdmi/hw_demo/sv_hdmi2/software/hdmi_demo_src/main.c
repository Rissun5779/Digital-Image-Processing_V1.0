
#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>
#include "alt_types.h"
//#include "vip_func.h"
#include "xcvr_gpll_rcfg.h"
#include "i2c.h"

void read_ssdc(unsigned int base)
{

	printf("SSDC_SINK_VERSION      %X\n",i2c_read(base, 0xA8 >> 1, 0x01)); // R Sink Version See Section 10.4.1.2
	printf("SSDC_SOURCE_VERSION    %X\n",i2c_read(base, 0xA8 >> 1, 0x02)); // R/W Source Version See Section 10.4.1.2
	printf("SSDC_UPDATE_0          %X\n",i2c_read(base, 0xA8 >> 1, 0x10)); // R/W Update_0 See Section 10.4.1.3
	printf("SSDC_UPDATE_1          %X\n",i2c_read(base, 0xA8 >> 1, 0x11)); // R/W Update_1 See Section 10.4.1.3

	printf("SSDC_TMDS_CONFIG       %X\n",i2c_read(base, 0xA8 >> 1, 0x20)); // R/W TMDS_Config See Section 10.4.1.4
	printf("SSDC_SCRAMBLER_STARTUS %X\n",i2c_read(base, 0xA8 >> 1, 0x21)); // R Scrambler_Status See Section 10.4.1.5
	printf("SSDC_CONFIG_0          %X\n",i2c_read(base, 0xA8 >> 1, 0x30)); // R/W Config_0 See Section 10.4.1.6

	printf("SSDC_STATUS_FLAG_0     %X\n",i2c_read(base, 0xA8 >> 1, 0x40)); //R Status_Flags_0 See Section 10.4.1.7
	printf("SSDC_STATUS_FLAG_1     %X\n",i2c_read(base, 0xA8 >> 1, 0x41)); //R Status_Flags_1 See Section 10.4.1.7

	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x50)); //R Err_Det_0_L See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x51)); // R Err_Det_0_H See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x52)); // R Err_Det_1_L See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x53)); // R Err_Det_1_H See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x54)); // R Err_Det_2_L See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_0_L        %X\n",i2c_read(base, 0xA8 >> 1, 0x55)); // R Err_Det_2_H See Sections 6.2 and 10.4.1.8
	printf("SSDC_ERR_DE_CHECKSUM   %X\n",i2c_read(base, 0xA8 >> 1, 0x56)); // R Err_Det_Checksum See Sections 6.2 and 10.4.1.8
	printf("SSDC_TEST_CONFIG_0     %X\n",i2c_read(base, 0xA8 >> 1, 0xC0)); // R/W Test_Config_0 See Section 10.4.1.9

	printf("SSDC_IEEE_OUI_2        %X\n",i2c_read(base, 0xA8 >> 1, 0xD0)); // R Manufacturer IEEE OUI, Third Octet See Section 10.4.1.10
	printf("SSDC_IEEE_OUI_1        %X\n",i2c_read(base, 0xA8 >> 1, 0xD1)); // R Manufacturer IEEE OUI, Second Octet See Section 10.4.1.10
	printf("SSDC_IEEE_OUI_0        %X\n",i2c_read(base, 0xA8 >> 1, 0xD2)); // R Manufacturer IEEE OUI, First Octet See Section 10.4.1.10"

}

//void XCVR_RCFG_WRITE_DIRECT(int LOGICAL_CHANNEL_VALUE, int OFFSET_VALUE, int data_reg)
//{
//	XCVR_RCFG_WRITE (0x38, LOGICAL_CHANNEL_VALUE); //LOGICAL_CHANNEL_REGISTER
//	XCVR_RCFG_WRITE (0x3A, 0x4); //CONTROL_STATUS_REGISTER: Set MIF mode 1
//	XCVR_RCFG_WRITE (0x3B, OFFSET_VALUE); //OFFSET_REGISTER
//	XCVR_RCFG_WRITE (0x3C, data_reg); //data_reg: Write to data register
//	XCVR_RCFG_WRITE (0x3A, 0x5); //CONTROL_STATUS_REGISTER: Perform write operation
//	READ_XCVR_RCFG_BUSY ();
//}

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
        int tmds_bit_clock_ratio = 0;
        int prev_tmds_bit_clock_ratio;
 	int gpll_xcvr_rcfg = 1;
	//int tx_hpd_req;
	//int prev_cvi_width;
  	//int prev_cvi_height;
	//int cvi_width = 2160;
	//int cvi_height = 3840;
	//int cvo_reconfig = 0;
	//int cvi_status_reg;
  
 	init_i2c(OC_I2C_MASTER_0_BASE);
	if(DEBUG_MODE) read_ssdc(OC_I2C_MASTER_0_BASE);

	if (DEBUG_MODE) printf("Started in debug mode...\n");
	IOWR(WD_TIMER_BASE, 0x0, 0x0); // clear timeout flag
	IOWR(WD_TIMER_BASE, 0x2, 0x1); // reset counter
	IOWR(WD_TIMER_BASE, 0x1, 0x4); // start timer	

	//SET_VIDEO_MODE(3);
	//IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 1); // Turn on CVO
	//IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0xF); // Turn on the CVI and its interrupts
 
	IOWR(TX_OS_PIO_BASE, 0, 0); // set to non-oversampling mode
	IOWR(TX_RST_PLL_PIO_BASE, 0, 1); // assert reset for TX PLL
 	IOWR(TX_RST_PLL_PIO_BASE, 0, 0); // deassert reset for TX PLL
	IOWR(TX_HPD_ACK_PIO_BASE, 0, 0); // set TX HPD acknowledge bit to 0
     
	while(1)
	{
		// Placeholder - the current Bitec HSMC daughter card has level shifter issue 
		// Check if TX hot plug event has happened
		//tx_hpd_req = IORD(TX_HPD_REQ_PIO_BASE,0);

		// Wait for measure_valid assertion
		//while ((IORD(MEASURE_VALID_PIO_BASE,0) == 0) && (tx_hpd_req == 0))
		while (IORD(MEASURE_VALID_PIO_BASE,0) == 0)
		{
			 IOWR(WD_TIMER_BASE, 0x0, 0x0);
			 IOWR(WD_TIMER_BASE, 0x2, 0x1);
			 // Poll TX hpd signal
			 //tx_hpd_req = IORD(TX_HPD_REQ_PIO_BASE,0);
		}
 
		// Placeholder - the current Bitec HSMC daughter card has level shifter issue
		// Check if TX hot plug event has happened
		//if (tx_hpd_req)
		//{
		//		if(DEBUG_MODE) printf("TX hot plug event is detected...\n");
		//
		//		// If it is 2.0 rate, resend SCDC bit as it is required by the 2.0 sink
		//		if(IORD(TMDS_BIT_CLOCK_RATIO_PIO_BASE, 0)==1){
		//			i2c_write(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20, 0x3);
		//			if(DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20));
		//		}
		//
		//		// Send acknowledge bit to pull down tx_hpd_req
		//		IOWR(TX_HPD_ACK_PIO_BASE, 0, 1);
		//		IOWR(TX_HPD_ACK_PIO_BASE, 0, 0);                  
		//}

                prev_tmds_bit_clock_ratio = tmds_bit_clock_ratio;
                tmds_bit_clock_ratio = IORD(TMDS_BIT_CLOCK_RATIO_PIO_BASE, 0);

		if (tmds_bit_clock_ratio == 1) {
			pix_rate = IORD(MEASURE_PIO_BASE,0) << 2;
		} else {
			pix_rate = IORD(MEASURE_PIO_BASE,0);
                }

		// Do nothing if rate detect returns all 1's (invalid rate)
		if (pix_rate < 0xFFFFFF) {
		        if (pix_rate <= 600000) {
				IOWR(TX_OS_PIO_BASE, 0, 1);
			} else {
				IOWR(TX_OS_PIO_BASE, 0, 0);
                        }

			prev_bpc = bpc;
			bpc = IORD(BPC_PIO_BASE, 0);

			prev_gpll_range = gpll_range;
			gpll_range = GPLL_COMPARE(pix_rate);

			prev_txchn_range = txchn_range;
			txchn_range = TXCHN_COMPARE(pix_rate);

			prev_txpll_range = txpll_range;
			txpll_range = TXPLL_COMPARE(pix_rate);

			gpll_xcvr_rcfg = (prev_gpll_range != gpll_range || prev_txchn_range != txchn_range || prev_txpll_range != txpll_range || prev_bpc != bpc || prev_tmds_bit_clock_ratio != tmds_bit_clock_ratio);
		} else {
			gpll_xcvr_rcfg = 0;
	 	}

		//CVI_DETECT();
		//prev_cvi_width = cvi_width;
		//prev_cvi_height = cvi_height;
		//cvi_width = IORD(ALT_VIP_CL_CVI_0_BASE, 4);  //Active samples in a line
		//cvi_height = IORD(ALT_VIP_CL_CVI_0_BASE, 5); //Active lines
		//cvo_reconfig = (prev_cvi_width != cvi_width || prev_cvi_height != cvi_height);

		// Reconfig GPLL on TX and TX xcvr
		if (gpll_xcvr_rcfg)
		{
			if(DEBUG_MODE) printf("GPLL range = %d\n", gpll_range);
			if(DEBUG_MODE) printf("TX Channel range = %d\n", txchn_range);
			if(DEBUG_MODE) printf("TX PLL range = %d\n", txpll_range);
			if(DEBUG_MODE) printf("BPC = %d\n", bpc);

			if (tmds_bit_clock_ratio == 1) {
				i2c_write(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20, 0x3);
				if(DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20));
			} else {
				i2c_write(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20, 0x0);
				if(DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_0_BASE, 0xA8 >> 1, 0x20));
                        }

			IOWR(TX_RST_CORE_PIO_BASE, 0, 1); // Reset core
			IOWR(WD_TIMER_BASE, 0x0, 0x0);    // Restart timer
			IOWR(WD_TIMER_BASE, 0x2, 0x1);
			//IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 0); // Turn off CVO
			//IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0); // Turn off CVI

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
		//if (cvo_reconfig)
		//{
		//		if (DEBUG_MODE) printf("CVI detected new resolution %d x %d\n", cvi_width, cvi_height);
		//
		//		IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 0); // Turn off CVO
		//		IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 0); // Turn off CVI
		//		RECONFIG_CVO(IORD(ALT_VIP_CL_CVI_0_BASE, 7), IORD(ALT_VIP_CL_CVI_0_BASE, 8)); //Pass total width and height
		//
		//} else {
		//		cvi_status_reg = IORD(ALT_VIP_CL_CVI_0_BASE, 1);
		//
		//      if ((cvi_status_reg & (0x01<<9)) != 0) {
		//	    	if (DEBUG_MODE) printf("Overflow detected; Clearing sticky bit\n");
		//        		IOWR(ALT_VIP_CL_CVI_0_BASE, 1, cvi_status_reg);
		//      }
		//}
                
		// Reconfiguration done, Exiting loop
		//if (gpll_xcvr_rcfg || cvo_reconfig)
		if (gpll_xcvr_rcfg)
		{
			//IOWR(ALT_VIP_CL_CVO_0_BASE, 0, 1); // Turn on CVO
			//IOWR(ALT_VIP_CL_CVI_0_BASE, 0, 1); // Turn on CVI
			gpll_xcvr_rcfg = 0;
			//cvo_reconfig = 0;
			IOWR(TX_RST_CORE_PIO_BASE, 0, 0); // Release core reset
			IOWR(WD_TIMER_BASE, 0x0, 0x0); //Reset timer
			IOWR(WD_TIMER_BASE, 0x2, 0x1);
			if (DEBUG_MODE) printf("-----------------------------------\n");
		}
	}

	return 0;
}


