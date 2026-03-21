#ifndef __HSMC_QUAD_VIDEO_HPP__
#define __HSMC_QUAD_VIDEO_HPP__

#include "I2C_Component.hpp"

class HSMC_Quad_Video: public I2C_Component
{
public:
    static const unsigned char MAIN_SLAVE_ADDR = 0xEA;   // main slave address, bit 0 is the write bit
    static const unsigned char SECOND_SLAVE_ADDR = 0xB8; // second address, bit 0 is the write bit

    HSMC_Quad_Video(long base_address, long clock_rate_KHz, int irq_number = -1);

    void enable_input();
};

#endif  // __HSMC_QUAD_VIDEO_HPP__
