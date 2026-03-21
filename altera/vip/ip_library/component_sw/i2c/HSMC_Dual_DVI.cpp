#include "HSMC_Dual_DVI.hpp"

HSMC_Dual_DVI::HSMC_Dual_DVI(long base_address, long clock_rate_KHz, int irq_number)
: I2C_Component(base_address, SLAVE_ADDR, clock_rate_KHz, irq_number) {
}
   
void HSMC_Dual_DVI::enable_output() {
    i2c_write(0x08, 0xBF); // Set TFP410 Mode
    i2c_write(0x09, 0x20); // Set TFP410 Mode
}
