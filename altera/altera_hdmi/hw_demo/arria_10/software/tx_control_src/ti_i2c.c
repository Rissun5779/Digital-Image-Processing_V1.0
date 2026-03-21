/*
 *  tmds181_i2c.c
 *
 *  This file contains the i2c API routines for the tmds181 device.
 *
 *  All rights reserved. Property of Bitec Ltd, UK.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.
 *
 *  Copyright Bitec Ltd 2006
 *
 */

#include "system.h"
#include "ti_i2c.h"
#include <stdio.h>

#define NBR_OF_REGISTERS 33

static unsigned char register_bank [32] ;

void ti_i2c_write		(long port,
							 unsigned char address,
							 unsigned char reg_address,
							 unsigned char data) ;

void ti_i2c_read		(long port,
							 unsigned char address,
							 unsigned char *data);

void ti_i2c_wait_tip	(long port);



void ti_init_i2c(long port) {
  int prescale = 10000000/(5*100000);
  IOWR_I2C_PRERLO(port, prescale & 0xff);
  IOWR_I2C_PRERHI(port, (prescale & 0xff00)>>8);
  // Enable core
  IOWR_I2C_CTR(port, 0x80);
}


void ti_i2c_write(long port, unsigned char address, unsigned char reg_address, unsigned char data) {

  ti_i2c_wait_tip(port);

  // write address
  IOWR_I2C_TXR(port, address<<1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR | I2C_CR_ACK);
  ti_i2c_wait_tip(port);

  // write address for reading
  IOWR_I2C_TXR(port, reg_address);
  IOWR_I2C_CR(port, I2C_CR_WR | I2C_CR_ACK);
  ti_i2c_wait_tip(port);

  IOWR_I2C_TXR(port, data);
  IOWR_I2C_CR(port, I2C_CR_WR  | I2C_CR_IACK | I2C_CR_STO);

  ti_i2c_wait_tip(port);
}

void ti_i2c_read(long port, unsigned char address, unsigned char *data) {

	int i;
  ti_i2c_wait_tip(port);

  IOWR_I2C_TXR(port, address<<1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR);
  ti_i2c_wait_tip(port);

  // write register address
  IOWR_I2C_TXR(port, 0x00);
  IOWR_I2C_CR(port, I2C_CR_WR);
  ti_i2c_wait_tip(port);


  // write address for reading
  IOWR_I2C_TXR(port, address<<1  | 1);
  IOWR_I2C_CR(port, I2C_CR_STA | I2C_CR_WR );
  ti_i2c_wait_tip(port);
  
  // read data
  for(i=0;i<NBR_OF_REGISTERS;i++)
  {
	IOWR_I2C_TXR(port, *(data+i));
    if(i==(NBR_OF_REGISTERS-1))
      IOWR_I2C_CR(port, I2C_CR_RD  | I2C_CR_STO | I2C_CR_ACK);
    else
      IOWR_I2C_CR(port, I2C_CR_RD   );

    ti_i2c_wait_tip(port);
    *(data+i) = IORD_I2C_RXR(port);

  }
  return ;
}

void ti_i2c_wait_tip(long port) {
  while ((IORD_I2C_SR(port) & I2C_SR_TIP) > 0) {}
}

void ti_i2c_write_regs(unsigned int base, unsigned int addr, unsigned int reg, unsigned int val)
{
//	while (1) {
		ti_i2c_write(base, addr >> 1, reg, val);
		for(int i=0;i<0xffff;i++);
		ti_i2c_read(base, addr >> 1, register_bank);
		//printf("reg[%02X] = %02X\n", reg, register_bank[reg]);
//	}
}


void ti_i2c_read_regs(unsigned int base, unsigned int addr)
{
	unsigned int i;

	ti_i2c_read(base, addr >> 1, register_bank);

	for(i=0;i<NBR_OF_REGISTERS;i++){
	  printf("reg[%02X] = %02X\n", i, register_bank[i]);
	}

}
