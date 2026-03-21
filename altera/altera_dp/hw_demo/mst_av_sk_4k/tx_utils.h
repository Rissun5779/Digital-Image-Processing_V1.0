// ********************************************************************************
// DisplayPort Core test code debug routines definitions
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
// URL            : $URL: svn://10.8.0.1/share/svn/dp/trunk/software/dp_demo/debug.h $
//
// Description:
//
// ********************************************************************************

#if BITEC_TX_CAPAB_MST

typedef enum                      // PC fsm states
{
  PC_FSM_IDLE = 0,                // no operation
  PC_FSM_HPD_0,                   // HPD set to 0
  PC_FSM_HPD_1,                   // HPD set to 1
  PC_FSM_START,                   // start checking a new connected sink
  PC_FSM_GET_PORTS,               // find connected MST ports and a port for Stream 0
  PC_FSM_FIND_STREAM_1,           // find a port for Stream 1
  PC_FSM_RDEDID_0,                // EDID Stream 0 read
  PC_FSM_RDEDID_1,                // EDID Stream 1 read
  PC_FSM_ALLOCATE_STREAM_0,       // Allocate Stream 0 to port_idx
  PC_FSM_WAIT_ALLOCATED_0,        // Wait for Stream 0 allocation
  PC_FSM_ALLOCATE_STREAM_1,       // Allocate Stream 1 to port_idx
  PC_FSM_WAIT_ALLOCATED_1,        // Wait for Stream 1 allocation
  PC_FSM_MST_ON,                  // MST ON
  PC_FSM_NOOUT                    // no suitable output port available
}BTC_PC_STATE;

extern BTC_PC_STATE pc_fsm; // PC fsm state

void bitec_dptx_pc();

#endif

void bitec_dptx_init();
void bitec_dptx_linktrain();


