// ********************************************************************************
// DisplayPort Core test code I2C handling definitions
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
//
// (C) Copyright Bitec 2012
//    All rights reserved
//
// Author         : $Author: psgswbuild $ @ bitec-dsp.com
// Department     :
// Date           : $Date: 2018/07/18 $
// Revision       : $Revision: #1 $
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/dp_demo/i2c.h $
//
// Description:
//
// ********************************************************************************

void bitec_i2c_init(unsigned int baseaddr);
void bitec_i2c_write(unsigned char address, unsigned char reg, unsigned char data);
void bitec_i2c_read(unsigned char address, unsigned char *data, unsigned char len);
