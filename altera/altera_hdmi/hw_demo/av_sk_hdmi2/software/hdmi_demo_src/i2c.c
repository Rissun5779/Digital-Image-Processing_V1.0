/*
 *  i2c.c
 *
 *  This file contains the i2c API routines.
 *
 *  All rights reserved. Property of Bitec Ltd, UK.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.
 *
 *  Copyright Bitec Ltd 2006
 *
 */



#include "system.h"
#include "i2c.h"

void init_i2c(long port) {
  // Setup prescaler for 100KHz with sysclk of 75MHz
  int prescale = 75000000/(5*100000);
  IOWR_I2C_PRERLO(port, prescale & 0xff);
  IOWR_I2C_PRERHI(port, (prescale & 0xff00)>>8);
  // Enable core
  IOWR_I2C_CTR(port, 0x80);
}

void i2c_write(long port, unsigned char address, unsigned char reg, unsigned char data) {
  i2c_wait_tip(port);
  
  // write address
  IOWR_I2C_TXR(port, address<<1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR | I2C_CR_ACK);
  i2c_wait_tip(port);

  // write register address
  IOWR_I2C_TXR(port, reg);
  IOWR_I2C_CR(port, I2C_CR_WR | I2C_CR_ACK);
  i2c_wait_tip(port);

  // write data
  IOWR_I2C_TXR(port, data);
  IOWR_I2C_CR(port, I2C_CR_WR | I2C_CR_STO | I2C_CR_IACK);
  i2c_wait_tip(port);
}


unsigned char i2c_read(long port, unsigned char address, unsigned char reg) {
  i2c_wait_tip(port);
  
   // write address
  IOWR_I2C_TXR(port, address<<1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR);
  i2c_wait_tip(port);

  // write register address
  IOWR_I2C_TXR(port, reg);
  IOWR_I2C_CR(port, I2C_CR_WR);
  i2c_wait_tip(port);

  // write address for reading
  IOWR_I2C_TXR(port, (address<<1) | 1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR);
  i2c_wait_tip(port);

  // read data
  IOWR_I2C_CR(port, I2C_CR_RD | I2C_CR_ACK | I2C_CR_STO);
  i2c_wait_tip(port);
  
  return IORD_I2C_RXR(port);
}

unsigned char *i2c_read_page(long port, unsigned char address, unsigned char reg)
{
  int i;
  
  init_i2c(port);
  
  i2c_wait_tip(port);
  
   // write address
  IOWR_I2C_TXR(port, (0xa0) | 1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR );
  i2c_wait_tip(port);

  for(i=0;i<256;i++){
    // read data
    IOWR_I2C_CR(port, I2C_CR_RD  );
    i2c_wait_tip(port);
    //edid[i] =  IORD_I2C_RXR(port);
 
  }

  // read data
  IOWR_I2C_CR(port, I2C_CR_RD  | I2C_CR_ACK | I2C_CR_STO);
  i2c_wait_tip(port);
    
}

void i2c_wait_tip(long port) {
  while ((IORD_I2C_SR(port) & I2C_SR_TIP) > 0) {}
}
