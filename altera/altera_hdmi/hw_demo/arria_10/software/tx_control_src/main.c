#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>
#include <unistd.h>
#include "alt_types.h"
//#include "vip_func.h"
#include "xcvr_gpll_rcfg.h"
#include "i2c.h"
#include "ti_i2c.h"

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

void read_tx_edid(unsigned int base)
{
	printf("\n\n****************************************************************************\n");
	printf("TX EDID \n");
	printf("\n\n****************************************************************************\n");

	printf("Offset 0x00: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x00));
	printf("Offset 0x01: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x01));
	printf("Offset 0x02: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x02));
	printf("Offset 0x03: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x03));
	printf("Offset 0x04: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x04));
	printf("Offset 0x05: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x05));
	printf("Offset 0x06: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x06));
	printf("Offset 0x07: Header = %X\n", i2c_read(base, 0xA0 >> 1, 0x07));
	printf("Offset 0x08: Manufacturer's Code Name = %X\n", i2c_read(base, 0xA0 >> 1, 0x08));
	printf("Offset 0x09: Manufacturer's Code Name = %X\n", i2c_read(base, 0xA0 >> 1, 0x09));
	printf("Offset 0x0A: ID Product Code = %X\n", i2c_read(base, 0xA0 >> 1, 0x0A));
	printf("Offset 0x0B: ID Product Code = %X\n", i2c_read(base, 0xA0 >> 1, 0x0B));
	printf("Offset 0x0C: ID Serial Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x0C));
	printf("Offset 0x0D: ID Serial Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x0D));
	printf("Offset 0x0E: ID Serial Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x0E));
	printf("Offset 0x0F: ID Serial Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x0F));
	printf("Offset 0x10: 1st Week of Manufacture = %X\n", i2c_read(base, 0xA0 >> 1, 0x10));
	printf("Offset 0x11: Year of Manufacture = %X\n", i2c_read(base, 0xA0 >> 1, 0x11));
	printf("Offset 0x12: EDID Version Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x12));
	printf("Offset 0x13: EDID Revision Number = %X\n", i2c_read(base, 0xA0 >> 1, 0x13));

	printf("\n\n");
}

unsigned int read_rx_edid_iord(unsigned int base, unsigned int offset)
{
	unsigned int readdata;
	readdata = (IORD(base, offset) >> 24) & 0xFF;

	return readdata;
}

void read_rx_edid(unsigned int base)
{


	printf("\n\n****************************************************************************\n");
	printf("RX EDID \n");
	printf("\n\n****************************************************************************\n");
	printf("Offset 0x00: Header = %X\n", read_rx_edid_iord(base, 0x00));
	printf("Offset 0x01: Header = %X\n", read_rx_edid_iord(base, 0x01));
	printf("Offset 0x02: Header = %X\n", read_rx_edid_iord(base, 0x02));
	printf("Offset 0x03: Header = %X\n", read_rx_edid_iord(base, 0x03));
	printf("Offset 0x04: Header = %X\n", read_rx_edid_iord(base, 0x04));
	printf("Offset 0x05: Header = %X\n", read_rx_edid_iord(base, 0x05));
	printf("Offset 0x06: Header = %X\n", read_rx_edid_iord(base, 0x06));
	printf("Offset 0x07: Header = %X\n", read_rx_edid_iord(base, 0x07));
	printf("Offset 0x08: Manufacturer's Code Name = %X\n", read_rx_edid_iord(base, 0x08));
	printf("Offset 0x09: Manufacturer's Code Name = %X\n", read_rx_edid_iord(base, 0x09));
	printf("Offset 0x0A: ID Product Code = %X\n", read_rx_edid_iord(base, 0x0A));
	printf("Offset 0x0B: ID Product Code = %X\n", read_rx_edid_iord(base, 0x0B));
	printf("Offset 0x0C: ID Serial Number = %X\n", read_rx_edid_iord(base, 0x0C));
	printf("Offset 0x0D: ID Serial Number = %X\n", read_rx_edid_iord(base, 0x0D));
	printf("Offset 0x0E: ID Serial Number = %X\n", read_rx_edid_iord(base, 0x0E));
	printf("Offset 0x0F: ID Serial Number = %X\n", read_rx_edid_iord(base, 0x0F));
	printf("Offset 0x10: 1st Week of Manufacture = %X\n", read_rx_edid_iord(base, 0x10));
	printf("Offset 0x11: Year of Manufacture = %X\n", read_rx_edid_iord(base, 0x11));
	printf("Offset 0x12: EDID Version Number = %X\n", read_rx_edid_iord(base, 0x12));
	printf("Offset 0x13: EDID Revision Number = %X\n", read_rx_edid_iord(base, 0x13));

	printf("\n\n");
}

int main()
{	unsigned int TX_EDID[256];
	unsigned int RX_EDID[256];
	int pix_rate;
	int tmds_clk_freq;
	int gpll_range = 20;
	int prev_gpll_range;
	int txpll_range = 40;
	int prev_txpll_range;
	int tmds_bit_clock_ratio = 0;
	int prev_tmds_bit_clock_ratio;
	int color_depth = 0;
	int prev_color_depth;
	int tx_hpd_req;
	int gpll_xcvr_rcfg = 1;
	int tx_os=0;

	IOWR(WD_TIMER_BASE, 0x1, 0x8); // stop the timer
	IOWR(TX_OS_PIO_BASE, 0, 0); // set to non-oversampling mode
  	IOWR(TX_RST_PLL_PIO_BASE, 0, 1); // assert reset for TX PLL
	IOWR(TX_RST_PLL_PIO_BASE, 0, 0); // deassert reset for TX PLL
	IOWR(TX_HPD_ACK_PIO_BASE, 0, 0); // set TX HPD acknowledge bit to 0
	IOWR(EDID_RAM_ACCESS_PIO_BASE, 0, 0); //release access to edid RAM

	init_i2c(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE);
	if (DEBUG_MODE) read_ssdc(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE);

	//printf("TPD158\n");
	ti_init_i2c(OC_I2C_MASTER_TI_BASE);
	if (DEBUG_MODE) ti_i2c_read_regs (OC_I2C_MASTER_TI_BASE, 0xBC);

	//printf("TMDS181\n");
	if (DEBUG_MODE) ti_i2c_read_regs (OC_I2C_MASTER_TI_BASE, TI_RETIMER_I2C_ADDRESS);

	/* Swap lanes */
	ti_i2c_write_regs (OC_I2C_MASTER_TI_BASE, TI_TPD158_I2C_ADDRESS, 0x09, 0x92);

	ti_i2c_write_regs (OC_I2C_MASTER_TI_BASE, TI_RETIMER_I2C_ADDRESS, 0x0B, 0x0A);
	ti_i2c_write_regs (OC_I2C_MASTER_TI_BASE, TI_RETIMER_I2C_ADDRESS, 0x0C, 0x6C);

	while(1)
	{
		// Check if TX hot plug event has happened
		tx_hpd_req = IORD(TX_HPD_REQ_PIO_BASE,0);

		// Wait for measure_valid assertion
		while ((IORD(MEASURE_VALID_PIO_BASE,0) == 0) && (tx_hpd_req == 0))
		//while (IORD(MEASURE_VALID_PIO_BASE,0) == 0)
		{
			//IOWR(WD_TIMER_BASE, 0x0, 0x0);
			//IOWR(WD_TIMER_BASE, 0x2, 0x1);
			// Poll TX hpd signal
			tx_hpd_req = IORD(TX_HPD_REQ_PIO_BASE,0);
		}

		// Placeholder for next revision of Bitec HDMI 2.0 FMC daughter card
		// The current revision has level shifter issue 
		// Check if TX hot plug event has happened
		//tx_hpd_req = IORD(TX_HPD_REQ_PIO_BASE,0);
		if (tx_hpd_req)
		{
			if (DEBUG_MODE) printf("TX hot plug event is detected...\n");
		
			// If it is 2.0 rate, resend SCDC bit as it is required by the 2.0 sink
			if(IORD(TMDS_BIT_CLOCK_RATIO_PIO_BASE, 0)==1){
				i2c_write(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20, 0x3);
				if (DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20));
			}

			int scdc_locked_status=0;

			scdc_locked_status = i2c_read(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x40) & 0xF;
			if (DEBUG_MODE) printf("scdc_locked_status = 0x%x\n",scdc_locked_status);

			if (DEBUG_MODE) read_ssdc(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE);

			if (DEBUG_MODE) printf("TX EDID \n");

			int EDID_BYTE_COUNT=256;
			for (int i=0; i<EDID_BYTE_COUNT; i++) {
				TX_EDID[i] = i2c_read(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA0 >> 1, i);
				if (DEBUG_MODE) printf("Offset 0x%d: TX EDID %X\n", i, TX_EDID[i]);
			}

			IOWR(EDID_RAM_ACCESS_PIO_BASE, 0, 1); //gain access to edid RAM

			for (int i=0; i<EDID_BYTE_COUNT; i++) {
				IOWR(EDID_RAM_SLAVE_TRANSLATOR_BASE, i, TX_EDID[i]);
			}

			if (DEBUG_MODE) {
				for (int i=0; i<EDID_BYTE_COUNT; i++) {
					RX_EDID[i] = read_rx_edid_iord(EDID_RAM_SLAVE_TRANSLATOR_BASE, i);
				}

				printf("\n\nEDID Check\n\n");


				for (int i=0; i<EDID_BYTE_COUNT; i++) {
					if(RX_EDID[i] != TX_EDID[i]) {
						printf("Error: Offset %d: Rx EDID = 0x%x, TX EDID = 0x%X\n", i, RX_EDID[i], TX_EDID[i]);
					} else {
						printf("Passed: Offset %d: Rx/Tx EDID = 0x%x\n", i, RX_EDID[i]);
					}
				}
			}


			usleep(1000000); //wait for 1s to toggle RX HPD to initiate updated EDID information read
			IOWR(EDID_RAM_ACCESS_PIO_BASE, 0, 0); //release access to edid RAM
			if (DEBUG_MODE) printf("Info: RX EDID RAM Update completed, release access");

			// Send acknowledge bit to pull down tx_hpd_req
			IOWR(TX_HPD_ACK_PIO_BASE, 0, 1);
			IOWR(TX_HPD_ACK_PIO_BASE, 0, 0);                  
		}
		
		prev_tmds_bit_clock_ratio = tmds_bit_clock_ratio;
		tmds_bit_clock_ratio = IORD(TMDS_BIT_CLOCK_RATIO_PIO_BASE, 0);

		tmds_clk_freq = IORD(MEASURE_PIO_BASE,0);
		
		// Get pixel clock rate
		if (IORD(TMDS_BIT_CLOCK_RATIO_PIO_BASE, 0)==1){
			pix_rate = tmds_clk_freq << 2;
		} else {
			pix_rate = tmds_clk_freq;
		}

		// Do nothing if rate detect returns all 1's (invalid rate)
		if (pix_rate < 0xFFFFFF) {

			tx_os = TX_OS_ENC(pix_rate);
			IOWR(TX_OS_PIO_BASE, 0, tx_os);

			prev_color_depth = color_depth;
			color_depth = IORD(COLOR_DEPTH_PIO_BASE, 0);
						
			prev_gpll_range = gpll_range;
			gpll_range = GPLL_COMPARE(pix_rate);

			prev_txpll_range = txpll_range;
			txpll_range = TXPLL_COMPARE(tmds_clk_freq, tmds_bit_clock_ratio);

			gpll_xcvr_rcfg = prev_gpll_range != gpll_range || prev_txpll_range != txpll_range || prev_color_depth != color_depth || prev_tmds_bit_clock_ratio != tmds_bit_clock_ratio;
		} else {
			gpll_xcvr_rcfg = 0;
	 	}

		// Reconfig TX IOPLL and TX XCVR PLL
		if (gpll_xcvr_rcfg)
		{	
			if (tmds_bit_clock_ratio == 1){
				i2c_write(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20, 0x3);
				if (DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20));
			} else {
				i2c_write(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20, 0x0);
				if (DEBUG_MODE) printf("TMDS_STATUS  : %X\n", i2c_read(OC_I2C_MASTER_AV_SLAVE_TRANSLATOR_BASE, 0xA8 >> 1, 0x20));
			}

			// Reconfig TX IOPLL
			if ((prev_gpll_range != gpll_range) || prev_color_depth != color_depth || (prev_tmds_bit_clock_ratio != tmds_bit_clock_ratio))
			{
				if (DEBUG_MODE)
				{
					printf("GPLL current range = %d\n", gpll_range);
					printf("Color depth = %d\n", color_depth);
					printf("Pixel rate = %d\n", pix_rate);
					printf("Reconfiguring GPLL...\n");
				}

				GPLL_RECONFIG(gpll_range, color_depth);
				if (DEBUG_MODE) printf("Resetting GPLL...\n");
				IOWR(TX_RST_PLL_PIO_BASE, 0, 1);
				IOWR(TX_RST_PLL_PIO_BASE, 0, 0);
			}

			// Reconfig TX XCVR PLL
			if (DEBUG_MODE)
			{
				printf("TX PLL current range = %d\n", txpll_range);
				printf("Pixel rate = %d\n", pix_rate);                       
				printf("Reconfiguring TX PLL (FPLL) ...\n");
			}
			if (DEBUG_MODE) printf("Resetting XCVR...\n");
			IOWR(TX_RST_XCVR_PIO_BASE, 0, 1);

			TX_PLL_RECONFIG(txpll_range);

			// Reset XCVR
			if (DEBUG_MODE) printf("Releasing XCVR reset...\n");
			IOWR(TX_RST_XCVR_PIO_BASE, 0, 0);
			if (DEBUG_MODE) printf("-----------------------------------\n");
        }
	}

	return 0;
}


