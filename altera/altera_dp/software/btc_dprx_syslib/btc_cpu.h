// ********************************************************************************
// DisplayPort Sink System Library global (library private) definitions
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/btc_dprx_syslib/btc_globals.h $
//
// Description:
// CPU-specific definitions (private to this library)
//
// ********************************************************************************

#ifndef __BTC_CPU_H__
#define __BTC_CPU_H__

#ifdef BTC_CPU_ARM

////////////
// ARM CPU
////////////

// Peripherals I/O
unsigned int _btc_rdio(volatile unsigned int *addr, unsigned int regnum);
void _btc_wrio(volatile unsigned int *addr, unsigned int regnum, unsigned int data);

// Note: 32-bit addressing
#define IORD(BASE, REGNUM) _btc_rdio((volatile unsigned int *) BASE, (unsigned int) REGNUM)
#define IOWR(BASE, REGNUM, DATA) _btc_wrio((volatile unsigned int *) BASE, (unsigned int) REGNUM, (unsigned int) DATA)

// Critical section begin - end
void _btc_disable_irqs();
void _btc_enable_irqs();

#define BRX_CRITICAL_BEGIN      _btc_disable_irqs()
#define BRX_CRITICAL_END        _btc_enable_irqs()

// DP Core interrupts enable/disable
void _btc_irq_enable(unsigned int irq_id, unsigned int irq_num);
int _btc_irq_enabled(unsigned int irq_id, unsigned int irq_num);
void _btc_irq_disable(unsigned int irq_id, unsigned int irq_num);


#else // Altera NIOS

//////////////
// Nios CPU
//////////////

#include <io.h>
#include <sys/alt_irq.h>

// Critical section begin - end
#define BRX_CRITICAL_BEGIN      alt_irq_context ctx; ctx = alt_irq_disable_all()
#define BRX_CRITICAL_END        alt_irq_enable_all(ctx)

// DP Core interrupts enable/disable
#define _btc_irq_enable(irq_id, irq_num)     alt_ic_irq_enable(irq_id, irq_num)
#define _btc_irq_enabled(irq_id, irq_num)    alt_ic_irq_enabled(irq_id, irq_num)
#define _btc_irq_disable(irq_id, irq_num)    alt_ic_irq_disable(irq_id, irq_num)

#endif // BTC_CPU_ARM


#endif // __BTC_CPU_H__

