#ifndef __HSMC_HDMI_HPP__
#define __HSMC_HDMI_HPP__

#include "I2C_Component.hpp"

class HSMC_HDMI: public I2C_Component
{
public:
    static const unsigned char MAIN_SLAVE_ADDR = 0xA1;   // main slave address (DDC)
    static const unsigned char EXT_SLAVE_ADDR  = 0xA8;   // second address (HDMI 2.0 extensions)

    HSMC_HDMI(long base_address, long clock_rate_KHz, int irq_number = -1);

    /**
     * @post    print out scdc information as info message
     */
    void read_scdc();

    /**
     * @post    print out edid information as info message
     */
    void read_edid();
    
    inline void set_tmds(unsigned char tmds_value) {
        i2c_write(0x20, tmds_value, EXT_SLAVE_ADDR);
    }
};

#endif  // __HSMC_HDMI_HPP__
