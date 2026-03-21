#ifndef __HSMC_DUAL_DVI_HPP__
#define __HSMC_DUAL_DVI_HPP__

#include "I2C_Component.hpp"

class HSMC_Dual_DVI: public I2C_Component
{
public:
    static const unsigned int SLAVE_ADDR = 0x70; // slave address, bit 0 is the write bit
   
    HSMC_Dual_DVI(long base_address, long clock_rate_KHz, int irq_number = -1);
   
    void enable_output();
};

#endif   // __HSMC_DUAL_DVI_HPP__
