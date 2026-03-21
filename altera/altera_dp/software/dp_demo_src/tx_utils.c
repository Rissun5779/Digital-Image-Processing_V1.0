#include <stdio.h>
#include <string.h>
#include <io.h>
#include "btc_dptx_syslib.h"
#include "btc_dptxll_syslib.h"
#include "config.h"
#include "tx_utils.h"
#include "i2c.h"
#include "sys/alt_irq.h"
#include "sys/alt_timestamp.h"
#include "../btc_dprx_syslib/btc_dp_dpcd.h" // For Eclipse to find symbols (Eclipse bug)
#include "../btc_dprx_syslib/btc_dp_types.h" // For Eclipse to find symbols (Eclipse bug)

#define DEBUG_PRINT_ENABLED 0
#if DEBUG_PRINT_ENABLED
#define DGB_PRINTF printf
#else
#define DGB_PRINTF(format, args...) ((void)0)
#endif

#if BITEC_TX_CAPAB_MST

// MST peer device types
#define BTC_PEER_DEV_NONE               0x00
#define BTC_PEER_DEV_SOURCE             0x01
#define BTC_PEER_DEV_BRANCH             0x02
#define BTC_PEER_DEV_SST_SINK           0x03
#define BTC_PEER_DEV_DP_TO_LEGACY       0x04
#define BTC_PEER_DEV_DP_TO_WIRELESS     0x05
#define BTC_PEER_DEV_WIRELESS_TO_DP     0x06

// MST status variables
BTC_PC_STATE pc_fsm = PC_FSM_IDLE; // PC fsm state
BTC_MST_DEVPORT *dev_ports; // Device ports of connected sink
BTC_MST_DEVICE_PORT *aPort;
int port_idx;
BYTE num_of_ports;
BYTE *edid;
BTC_STREAM *myStream;
BYTE tavg_ts;
int pc_fsm_force_hpd0,pc_fsm_force_hpd1;

#endif

// Dashboard bitfields
#define DASH_BPP18_MASK    0x0
#define DASH_BPP24_MASK    0x1
#define DASH_BPP30_MASK    0x2
#define DASH_BPP36_MASK    0x3
#define DASH_BPP48_MASK    0x4

BYTE tx_edid_data[128*4]; // TX copy of Sink EDID
unsigned int T100uS = 0;

void bitec_dptx_hpd_isr(void* context);
void bitec_dptx_hpd_irq();
void bitec_csn_callback(BTC_MST_CONN_STAT_NOTIFY *csn_data);
unsigned int bitec_dptx_test_autom();

//***************************************************************
// Derived by legacy alt_irq_interruptible().
// Allows for nested interrupts using the Enhanced Interrupt API
// but without requiring the External Interrupt Controller (EIC)
// and the Vectored Interrupt Controller (VIC)
//
// Input: priority  IRQ number (priority) of the invoking ISR
//                  (IRQ0 has the highest priority)
//***************************************************************
static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE bitec_alt_irq_interruptible(alt_u32 priority)
{
  extern volatile alt_u32 alt_priority_mask; // One bit for each unmasked IRQ (bit0 = IRQ0, bit1 = IRQ1, etc.)
  alt_u32 old_priority;
  int status;

  old_priority = alt_priority_mask;

#if 0
  {
    extern volatile alt_u32 alt_irq_active; // One bit for each instantiated and enabled IRQ (bit0 = IRQ0, bit1 = IRQ1, etc.)

    // Unmask (enable) only IRQs with higher priority than "priority"
    alt_priority_mask = (1 << priority) - 1;
    NIOS2_WRITE_IENABLE (alt_irq_active & alt_priority_mask);
  }
#endif

  // Re-enable global Nios interrupts
  NIOS2_READ_STATUS(status);
  status |= NIOS2_STATUS_PIE_MSK;
  NIOS2_WRITE_STATUS(status);
  return old_priority;
}

//***************************************************************
// Derived by legacy alt_irq_non_interruptible().
// Allows for nested interrupts using the Enhanced Interrupt API
// but without requiring the External Interrupt Controller (EIC)
// and the Vectored Interrupt Controller (VIC)
//
// Input: mask  the value returned by bitec_alt_irq_interruptible()
//***************************************************************
static ALT_INLINE void ALT_ALWAYS_INLINE bitec_alt_irq_non_interruptible(alt_u32 mask)
{
  extern volatile alt_u32 alt_priority_mask; // One bit for each unmasked IRQ (bit0 = IRQ0, bit1 = IRQ1, etc.)
  int status;

  // Disable global Nios interrupts
  NIOS2_READ_STATUS(status);
  status &= ~NIOS2_STATUS_PIE_MSK;
  NIOS2_WRITE_STATUS(status);

#if 0
  {
    extern volatile alt_u32 alt_irq_active; // One bit for each instantiated and enabled IRQ (bit0 = IRQ0, bit1 = IRQ1, etc.)

    // Restore the original IRQ mask
    alt_priority_mask = mask;
    NIOS2_WRITE_IENABLE (mask & alt_irq_active);
  }
#endif
}

//******************************************************
// Initialize the TX
//******************************************************
void bitec_dptx_init()
{
  unsigned int tx_link_rate, tx_lane_count, dash_setup;

  // Get the core capabilities (defined in QSYS and ported to system.h)
  tx_link_rate = DP_TX_MGMT_BITEC_CFG_TX_MAX_LINK_RATE;
  tx_lane_count = DP_TX_MGMT_BITEC_CFG_TX_MAX_LANE_COUNT;

  // Write the capabilities as default settings for the Dashboard
  dash_setup = tx_link_rate << 21;
  dash_setup |= tx_lane_count << 5;
  dash_setup |= DASH_BPP24_MASK << 2;
  IOWR(XDASH_BASE,0, dash_setup);

#if BITEC_TX_CAPAB_MST
  btc_dptxll_syslib_add_tx(0,tx_link_rate,tx_lane_count,DP_TX_MGMT_BITEC_CFG_TX_MAX_NUM_OF_STREAMS,tx_edid_data);
  btc_dptxll_syslib_init();
  btc_dptxll_mst_set_csn_callback(0,bitec_csn_callback);
  btc_dptxll_stream_set_color_space(0,0,0,1,0,0,0); // Set Stream 0 video color space

  pc_fsm_force_hpd0 = 0;
  pc_fsm_force_hpd1 = 0;
#endif

  // dummy use of btc_dptx_hdcp_status() needed by the linker to find
  // library function btc_dptx_cp_irq();
  btc_dptx_hdcp_status(0,(BTC_HDCPTX_STAT *)tx_edid_data);

  // Register the interrupt handler
  alt_ic_isr_register(DP_TX_MGMT_IRQ_INTERRUPT_CONTROLLER_ID,
                      DP_TX_MGMT_IRQ,
                      bitec_dptx_hpd_isr,
                      NULL,
                      0x0);
}

//******************************************************
// Perform Link Training
//******************************************************
void bitec_dptx_linktrain()
{
  unsigned int link_rate, lane_count, bpc;

  // Read the TX configuration values from the dashboard
  link_rate = (IORD(XDASH_BASE,0) >> 21) & 0xFF;
  lane_count = (IORD(XDASH_BASE,0) >> 5) & 0x1F;
  bpc = (IORD(XDASH_BASE,0) >> 2) & 0x07;

  btc_dptx_edid_read(0,tx_edid_data); // Read the sink EDID
  btc_dptx_set_color_space(0,0,bpc,0,0,0); // Set TX video color space
  btc_dptx_link_training(0,link_rate,lane_count); // Do link training
}

//******************************************************
// HPD activity service routine
//******************************************************
void bitec_dptx_hpd_isr(void* context)
{
  unsigned int status_reg;
  unsigned int link_rate, lane_count, bpc;
  alt_u32 mask;

  // Disable TX Core HPD interrupts
  BTC_DPTX_DISABLE_HPD_IRQ(0);

  // Allow for nested interrupts
  mask = bitec_alt_irq_interruptible(DP_TX_MGMT_IRQ);

  // Read the TX configuration values from the dashboard
  link_rate = (IORD(XDASH_BASE,0) >> 21) & 0xFF;
  lane_count = (IORD(XDASH_BASE,0) >> 5) & 0x1F;
  bpc = (IORD(XDASH_BASE,0) >> 2) & 0x07;

  status_reg = IORD(btc_dptx_baseaddr(0),DPTX_REG_TX_STATUS); // Reading SR clears IRQ
  if(status_reg & 0x1)
  {
    // Long HPD
    if(status_reg & 0x4)
    {
      // HPD is at '1'

#if BITEC_TX_CAPAB_MST
      pc_fsm_force_hpd1 = 1;
#else
      // Check Automated test request
      btc_dptx_hpd_change(0,1);
      bitec_dptx_test_autom(); // Only TEST_EDID_READ uses HPD rising edge
      btc_dptx_edid_read(0,tx_edid_data); // Read the sink EDID
      btc_dptx_set_color_space(0,0,bpc,0,0,0); // Set TX video color space
      btc_dptx_link_training(0,link_rate,lane_count); // Do link training
#endif
    }
    else
    {
      // HPD is at '0'

#if BITEC_TX_CAPAB_MST
      pc_fsm_force_hpd0 = 1;
#else
      // Send the idle pattern
      btc_dptx_hpd_change(0,0);
      btc_dptx_video_enable(0,0);
#endif
    }
  }
  else
  {
    // HPD short pulse (IRQ)

#if BITEC_TX_CAPAB_MST
    btc_dptxll_hpd_irq(0);
#else
    bitec_dptx_hpd_irq(0);
#endif
  }

  // Prevent nested interrupts
  bitec_alt_irq_non_interruptible(mask);

  // Enable TX Core HPD interrupts
  BTC_DPTX_ENABLE_HPD_IRQ(0);
}

//******************************************************
// HPD IRQ (short pulse) handler
//******************************************************
void bitec_dptx_hpd_irq()
{
  BYTE data[8];
  unsigned int status_ok, lane_count, link_rate;
  BYTE edid_data[128 * 4];

  // Check for Test Automation requests
  if(bitec_dptx_test_autom())
    return;

  btc_dptx_aux_read(0,DPCD_ADDR_LINK_BW_SET,2,data);
  link_rate = data[0] & 0xFF;
  lane_count = data[1] & 0x1F;

  btc_dptx_aux_read(0,DPCD_ADDR_SINK_COUNT,6,data); // Read link status

  // Check CP_IRQ
  if(data[1] & 0x04)
  {
    // HDCP CP_IRQ
    btc_dptx_cp_irq(0);
    return;
  }

  // Check Downstream port status change
  if(data[4] & (1<<6))
    btc_dptx_edid_read(0,edid_data); // Read the sink EDID

  // Check link status
  status_ok = data[4] & 0x01; // Get inter-lane align
  switch(lane_count)
  {
    case 1 : status_ok &= ((data[2] & 0x07) == 0x07); break;
    case 2 : status_ok &= ((data[2] & 0x77) == 0x77); break;
    case 4 : status_ok &= ((data[2] & 0x77) == 0x77) & ((data[3] & 0x77) == 0x77); break;
    default : break;
  }
  if(!status_ok)
    btc_dptx_link_training(0,link_rate,lane_count);
}

//******************************************************
// Test Automation handler
//
// Return: 1 = Test Automation performed, 0 = no action
//******************************************************
unsigned int bitec_dptx_test_autom()
{
  BYTE data[2];

  // Check Automated test request
  btc_dptx_aux_read(0,DPCD_ADDR_DEVICE_SERVICE_IRQ_VECTOR,1,data);
  btc_dptx_aux_read(0,DPCD_ADDR_TEST_REQUEST,1,data+1);

  if((data[0] & 0x02) && (data[1] != 0x00))
  {
    // Test Automation request

#if BITEC_TX_PHY_TEST_PATTERN
    if(data[1] & 0x08)
    {
      // PHY TEST REQUEST

      // Set the SN75DP130 equaliser as required by PHY TEST PATTERN

      bitec_i2c_write(0x5C, 0x01, 0x03); //disable shutdown
      bitec_i2c_write(0x5C, 0x03, 0x18); //disable squelch
      bitec_i2c_write(0x5C, 0x04, 0x00); //disable LT
      bitec_i2c_write(0x5C, 0x05, 0x80); //force EQ for lane 0, pre-emph 0_1, EQ_I2C_ENABLE
      bitec_i2c_write(0x5C, 0x06, 0x00); //force EQ for lane 0, pre-emph 2_3
      bitec_i2c_write(0x5C, 0x07, 0x00); //force EQ for lane 1, pre-emph 0_1
      bitec_i2c_write(0x5C, 0x08, 0x00); //force EQ for lane 1, pre-emph 2_3
      bitec_i2c_write(0x5C, 0x09, 0x00); //force EQ for lane 2, pre-emph 0_1
      bitec_i2c_write(0x5C, 0x0A, 0x00); //force EQ for lane 2, pre-emph 2_3
      bitec_i2c_write(0x5C, 0x0B, 0x00); //force EQ for lane 3, pre-emph 0_1
      bitec_i2c_write(0x5C, 0x0C, 0x00); //force EQ for lane 3, pre-emph 2_3
      bitec_i2c_write(0x5C, 0x00, 0x00); //reset the RD reg. address

      btc_dptx_aux_read(0,DPCD_ADDR_TEST_LINK_RATE,1,data);
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x00); // DPCD 0x100
      bitec_i2c_write(0x5C, 0x1F, data[0]);

      btc_dptx_aux_read(0,DPCD_ADDR_TEST_LANE_COUNT,1,data);
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x01); // DPCD 0x101
      bitec_i2c_write(0x5C, 0x1F, data[0]);

      btc_dptx_aux_read(0,DPCD_ADDR_ADJUST_REQUEST_LANE0_1,2,data);
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x03); // DPCD 0x103
      bitec_i2c_write(0x5C, 0x1F, ((data[0] & 0x0C) << 1) | (data[0] & 0x03));
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x04); // DPCD 0x104
      bitec_i2c_write(0x5C, 0x1F, ((data[0] & 0xC0) >> 3) | ((data[0] & 0x30) >> 4));
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x05); // DPCD 0x105
      bitec_i2c_write(0x5C, 0x1F, ((data[1] & 0x0C) << 1) | (data[1] & 0x03));
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x01);bitec_i2c_write(0x5C, 0x1E, 0x06); // DPCD 0x106
      bitec_i2c_write(0x5C, 0x1F, ((data[1] & 0xC0) >> 3) | ((data[1] & 0x30) >> 4));

      btc_dptx_aux_read(0,DPCD_ADDR_TEST_LANE_COUNT,1,data);
      bitec_i2c_write(0x5C, 0x1C, 0x00);bitec_i2c_write(0x5C, 0x1D, 0x06);bitec_i2c_write(0x5C, 0x1E, 0x00); // DPCD 0x600
      bitec_i2c_write(0x5C, 0x1F, 0x01);
    }
#endif

    btc_dptx_test_autom(0);
    return 1;
  }

  return 0;
}

#if BITEC_TX_CAPAB_MST
//******************************************************
// Simulates a PC using the TX MST link
// Pick up one of the connected sink
// devices and try to output video to it
//
// Must be invoked periodically
//******************************************************
void bitec_dptx_pc()
{
  unsigned int i;
  BYTE vcp_size;

  switch(pc_fsm)
  {
    case PC_FSM_IDLE: // No sink detected
      break;

    case PC_FSM_HPD_0: // HPD set to 0
      btc_dptxll_hpd_change(0,0);
      pc_fsm = PC_FSM_IDLE;
      break;

    case PC_FSM_HPD_1: // HPD set to 1
      btc_dptxll_hpd_change(0,1);
      btc_dptxll_stream_set_color_space(0,0,0,1,0,0,0); // Set Stream 0 video color space
      pc_fsm = PC_FSM_START;
      break;

    case PC_FSM_START: // A new sink got connected
      {
        BYTE data;
          btc_dptx_aux_read(0,DPCD_ADDR_DPCD_REV,1,&data);
        if(data == 0x12)
        {
          // DPCD 1.2
          btc_dptx_aux_read(0,DPCD_ADDR_MST_CAP,1,&data);
          if(data & 1)
            pc_fsm = PC_FSM_GET_PORTS; // MST_CAP = 1
          else
            pc_fsm = PC_FSM_NOOUT; // MST_CAP = 0: use SST output
        }
        else
          pc_fsm = PC_FSM_NOOUT; // MST_CAP = 0: use SST output
      }
      break;

    case PC_FSM_GET_PORTS: // Determine DP device attached
      i = btc_dptxll_mst_get_device_ports(0,&dev_ports,&num_of_ports);
      if(i == 0)
      {
        // Topology discovery ready: search for a Stream 0 sink device
        for(i = 0; i < num_of_ports; i++)
        {
          aPort = &dev_ports[i].port;
          if(aPort->input_port == 0 &&
             aPort->displayport_device_plug_status == 1 &&
             (aPort->peer_device_type == BTC_PEER_DEV_SST_SINK && aPort->messaging_capability_status == 0))
            break;
        }

        if(i < num_of_ports)
        {
          // A suitable device port was found
          if(dev_ports[i].available_PBN > 0)
          {
            port_idx = i;
            btc_dptxll_mst_edid_read_req(0,&dev_ports[port_idx].RAD,dev_ports[port_idx].port.port_number);
            pc_fsm = PC_FSM_RDEDID;
          }
          else
            pc_fsm = PC_FSM_NOOUT;
        }
        else
          pc_fsm = PC_FSM_NOOUT;
      }
      else if(i == 1)
        pc_fsm = PC_FSM_NOOUT;
      break;

    case PC_FSM_RDEDID: // Wait for EDID read complete
      i = btc_dptxll_mst_edid_read_rep(0,&edid);
      if(i == 0)
        pc_fsm = PC_FSM_ALLOCATE_STREAM;
      else if(i == 1)
        pc_fsm = PC_FSM_NOOUT;
      break;

    case PC_FSM_ALLOCATE_STREAM: // Allocate Stream 0 to port_idx
      if(!btc_dptx_is_link_up(0))
        break;
      myStream = btc_dptxll_stream_get(0,0); // Just to get a pointer to the stream, for debug
      btc_dptxll_stream_set_pixel_rate(0,0,154000);
      vcp_size = btc_dptxll_stream_calc_VCP_size(0,0);
      if (!vcp_size || vcp_size > 63)
        break;
      btc_dptxll_stream_allocate_req(0,0,&dev_ports[port_idx]);
      pc_fsm = PC_FSM_WAIT_ALLOCATED;
      break;

    case PC_FSM_WAIT_ALLOCATED: // Wait for Stream 0 allocation
      i = btc_dptxll_stream_allocate_rep(0);
      if(i == 0)
        pc_fsm = PC_FSM_MST_DATA;
      else if(i == 1)
        pc_fsm = PC_FSM_ALLOCATE_STREAM; // Retry
      break;

    case PC_FSM_MST_DATA: // Send MST payload
      pc_fsm = PC_FSM_MST_ON;
      break;

    case PC_FSM_MST_ON: // MST ON!
      break;

    case PC_FSM_NOOUT: // No suitable sink device available
      break;
  }

  // Restart the FSM on HPD transitions
  if(pc_fsm_force_hpd0)
  {
    pc_fsm_force_hpd0 = 0;
    pc_fsm = PC_FSM_HPD_0;
  }
  else if(pc_fsm_force_hpd1)
  {
    pc_fsm_force_hpd1 = 0;
    pc_fsm = PC_FSM_HPD_1;
  }
}

//******************************************************
// CONNECTION_STATUS_NOTIFY callback
//******************************************************
void bitec_csn_callback(BTC_MST_CONN_STAT_NOTIFY *csn_data)
{

}

#endif
