#include "HSMC_Quad_Video.hpp"

HSMC_Quad_Video::HSMC_Quad_Video(long base_address, long clock_rate_KHz, int irq_number)
: I2C_Component(base_address, MAIN_SLAVE_ADDR, clock_rate_KHz, irq_number) {
}

void HSMC_Quad_Video::enable_input()
{
    i2c_write(0x15, 0x00);
    i2c_write(0x31, 0x00); //
    i2c_write(0x32, 0x23); //
    i2c_write(0x33, 0x08); //
    i2c_write(0x34, 0x16); //
    i2c_write(0x35, 0x30); // chrontel
    i2c_write(0x36, 0x60); //
    i2c_write(0x37, 0x00); //
    i2c_write(0x49, 0xc0); // Set DVI MODE
    i2c_write(0x21, 0x01 | 0x08); // DAC bypass
    i2c_write(0x22, 0x16); // BCO = VSYNC
    i2c_write(0x1f, 0x80); // Set Internal buffer
    i2c_write(0x1c, 0x04); // Invert XCLK Polarity

    // Initialise input channels
    unsigned int count = 1;
    do {
        unsigned char data;
        do {
            i2c_write(0xfe, count, SECOND_SLAVE_ADDR);
            i2c_write(0x7f, 0x00, SECOND_SLAVE_ADDR);
            i2c_write(0xff, count, SECOND_SLAVE_ADDR);
            i2c_read(0x81, data, SECOND_SLAVE_ADDR);
            if(data !=  0x54){
                count = 1;
            }
        } while (data !=  0x54);
        count = count << 1;
    } while(count <= 8);

    for(count = 1; count <= 8; count = (count << 1)){
        i2c_write(0xfe, count, SECOND_SLAVE_ADDR);
        i2c_write(0x7f, 0x00, SECOND_SLAVE_ADDR); //

        i2c_write(0x03,0x0D, SECOND_SLAVE_ADDR);  // Enable YCbCr, sync, control outputs
        //keep SCLK disabled i2c_write(base_address, 0xb8>>1, 0x05,0x08);  // Enable Clock 2 output
        i2c_write(0x17,0x5B, SECOND_SLAVE_ADDR);  // scaler powerdown for ROM2.0 and enable SAV/EAV codes, BLK set to powerdown scaler
        i2c_write(0x15,0x81, SECOND_SLAVE_ADDR);  // Enable Stable Sync mode
        i2c_write(0x00,0x00, SECOND_SLAVE_ADDR);  // Select video source
    }

    for(count = 1; count <= 8; count = (count << 1)) {
        i2c_write(0xff, count, SECOND_SLAVE_ADDR);
        unsigned char data;
        i2c_read(0x88, data, SECOND_SLAVE_ADDR);
        if (data & 0x06)  // Has vsync and hsync locked for this channel?
            i2c_write(0xfe, count, SECOND_SLAVE_ADDR);
    }
}

