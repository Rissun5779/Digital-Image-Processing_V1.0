#include "HSMC_HDMI.hpp"

// We should not have a dependency on drivers/VipUtil.h in this component_sw file.
// Tie missing VIP_INFO_MSG if necessary
#include <system.h>

#ifndef VIP_INFO_MSG
#if defined(ALT_STDOUT_IS_JTAG_UART) && !defined(NDEBUG)
#include <stdio.h>
#include <io.h>
#include <cstdarg>
#define VIP_INFO_MSG(...) printf(__VA_ARGS__)
#else
#define VIP_INFO_MSG(...)
#endif
#endif

HSMC_HDMI::HSMC_HDMI(long base_address, long clock_rate_KHz, int irq_number)
: I2C_Component(base_address, MAIN_SLAVE_ADDR, clock_rate_KHz, irq_number) {
}

/*
 * print out scdc information as info message
 */
void HSMC_HDMI::read_scdc()
{
    unsigned char val;

    VIP_INFO_MSG("SCDC: \n");
    i2c_read(0x01, val, EXT_SLAVE_ADDR); // R Sink Version See Section 10.4.1.2
    VIP_INFO_MSG("SCDC_SINK_VERSION      %X\n", val);
    i2c_read(0x02, val, EXT_SLAVE_ADDR); // R/W Source Version See Section 10.4.1.2
    VIP_INFO_MSG("SCDC_SOURCE_VERSION    %X\n", val);
    i2c_read(0x10, val, EXT_SLAVE_ADDR); // R/W Update_0 See Section 10.4.1.3
    VIP_INFO_MSG("SCDC_UPDATE_0          %X\n", val);
    i2c_read(0x11, val, EXT_SLAVE_ADDR); // R/W Update_1 See Section 10.4.1.3
    VIP_INFO_MSG("SCDC_UPDATE_1          %X\n", val);

    i2c_read(0x20, val, EXT_SLAVE_ADDR); // R/W TMDS_Config See Section 10.4.1.4
    VIP_INFO_MSG("SCDC_TMDS_CONFIG       %X\n", val);
    i2c_read(0x21, val, EXT_SLAVE_ADDR); // R Scrambler_Status See Section 10.4.1.5
    VIP_INFO_MSG("SCDC_SCRAMBLER_STARTUS %X\n", val);
    i2c_read(0x30, val, EXT_SLAVE_ADDR); // R/W Config_0 See Section 10.4.1.6
    VIP_INFO_MSG("SCDC_CONFIG_0          %X\n", val);

    i2c_read(0x40, val, EXT_SLAVE_ADDR); //R Status_Flags_0 See Section 10.4.1.7
    VIP_INFO_MSG("SCDC_STATUS_FLAG_0     %X\n", val);
    i2c_read(0x41, val, EXT_SLAVE_ADDR); //R Status_Flags_1 See Section 10.4.1.7
    VIP_INFO_MSG("SCDC_STATUS_FLAG_1     %X\n", val);

    i2c_read(0x50, val, EXT_SLAVE_ADDR); // R Err_Det_0_L See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_0_L        %X\n", val);
    i2c_read(0x51, val, EXT_SLAVE_ADDR); // R Err_Det_0_H See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_0_H        %X\n", val);
    i2c_read(0x52, val, EXT_SLAVE_ADDR); // R Err_Det_1_L See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_1_L        %X\n", val);
    i2c_read(0x53, val, EXT_SLAVE_ADDR); // R Err_Det_1_H See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_1_H        %X\n", val);
    i2c_read(0x54, val, EXT_SLAVE_ADDR); // R Err_Det_2_L See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_2_L        %X\n", val);
    i2c_read(0x55, val, EXT_SLAVE_ADDR); // R Err_Det_2_H See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_2_H        %X\n", val);
    i2c_read(0x56, val, EXT_SLAVE_ADDR); // R Err_Det_Checksum See Sections 6.2 and 10.4.1.8
    VIP_INFO_MSG("SCDC_ERR_DE_CHECKSUM   %X\n", val);
    i2c_read(0xC0, val, EXT_SLAVE_ADDR); // R/W Test_Config_0 See Section 10.4.1.9
    VIP_INFO_MSG("SCDC_TEST_CONFIG_0     %X\n", val);

    i2c_read(0xD0, val, EXT_SLAVE_ADDR); // R Manufacturer IEEE OUI, Third Octet See Section 10.4.1.10
    VIP_INFO_MSG("SCDC_IEEE_OUI_2        %X\n", val);
    i2c_read(0xD1, val, EXT_SLAVE_ADDR); // R Manufacturer IEEE OUI, Second Octet See Section 10.4.1.10
    VIP_INFO_MSG("SCDC_IEEE_OUI_1        %X\n", val);
    i2c_read(0xD2, val, EXT_SLAVE_ADDR); // R Manufacturer IEEE OUI, First Octet See Section 10.4.1.10
    VIP_INFO_MSG("SCDC_IEEE_OUI_0        %X\n", val);

    VIP_INFO_MSG("\n");
}

/*
 * Read first page (non-extended) of sink's EDID info.
 */
void HSMC_HDMI::read_edid()
{
    for (unsigned int local_addr = 0; local_addr < 256; ++local_addr)
    {
        unsigned char val;

        if (local_addr%8==0)
        {
            VIP_INFO_MSG("\nEDID %03d: ", local_addr);
        }
        i2c_read(local_addr, val, MAIN_SLAVE_ADDR);
        VIP_INFO_MSG(" %02X", val);
    }
    VIP_INFO_MSG("\n");
}
