/*
 *  tmds181_i2c.h
 *
 *  This file contains the tmds181 i2c API routines.
 *
 *  All rights reserved. Property of Bitec Ltd, UK.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.fr
 *
 *  Copyright Bitec Ltd 2006
 *
 */

#ifndef __ti_I2C_H
#define __ti_I2C_H

#include <io.h>

#define TI_RETIMER_I2C_ADDRESS 0xBA
#define TI_TPD158_I2C_ADDRESS 0xBC

// Overall status and control
#define IOWR_I2C_PRERLO(port,data)  IOWR(port, 0, data)
#define IOWR_I2C_PRERHI(port,data)  IOWR(port, 1, data)
#define IOWR_I2C_CTR(port,data)  IOWR(port, 2, data)
#define IOWR_I2C_TXR(port,data)  IOWR(port, 3, data)
#define IOWR_I2C_CR(port,data)  IOWR(port, 4, data)
#define IORD_I2C_PRERLO(port)  IORD(port, 0)
#define IORD_I2C_PRERHI(port)  IORD(port, 1)
#define IORD_I2C_CTR(port)  IORD(port, 2)
#define IORD_I2C_RXR(port)  IORD(port, 3)
#define IORD_I2C_SR(port)  IORD(port, 4)

#define I2C_CR_STA 0x80
#define I2C_CR_STO 0x40
#define I2C_CR_RD 0x20
#define I2C_CR_WR 0x10
#define I2C_CR_ACK 0x08
#define I2C_CR_IACK 0x01

#define I2C_SR_TIP 0x2

void ti_init_i2c	(long port);

void ti_i2c_write_regs	(unsigned int base,
						 unsigned int addr,
						 unsigned int reg,
						 unsigned int val);

void ti_i2c_read_regs	(unsigned int base,
						 unsigned int addr);

#endif /* __I2C_H */
