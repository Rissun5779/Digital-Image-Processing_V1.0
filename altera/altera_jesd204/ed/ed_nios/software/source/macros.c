#include <stdio.h>
#include "main.h"
#include "macros.h"
#include "altera_jesd204_regs.h"
#include "io.h"
#include "system.h"

int CALC_BASE_ADDRESS_LINK (int base, int link)
{
   return (base | (link << 16)); //For AV: link << 12; For A10: link << 16
}

int CALC_BASE_ADDRESS_XCVR_PLL (int base, int instance)
{
   return (base | (instance << 12));
}

int IORD_RESET_SEQUENCER_STATUS_REG (int link)
{
   int val;
   int base;

   //base = JESD204B_SUBSYSTEM_0_RESET_SEQ_BASE | (link << 3);
   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_RESET_SEQ_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_RESET_SEQUENCER_STATUS_REG_OFFSET);

   return val;
}

int IORD_RESET_SEQUENCER_RESET_ACTIVE (int link)
{
   int val;

   val = IORD_RESET_SEQUENCER_STATUS_REG(link);

#if DEBUG_MODE
   printf ("Checking reset active val for link %d...\n", link);
#endif

   if((val & ALTERA_RESET_SEQUENCER_RESET_ACTIVE_MASK) == ALTERA_RESET_SEQUENCER_RESET_ACTIVE_ASSERT)
      return 1;
   else
      return 0;
}

void IOWR_RESET_SEQUENCER_INIT_RESET_SEQ (int link)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_RESET_SEQ_BASE, link);
#if DEBUG_MODE
   printf ("Base address: 0x0%x\n", base);
#endif

   IOWR_32DIRECT(base, ALTERA_RESET_SEQUENCER_CONTROL_REG_OFFSET, 0x1);
#if DEBUG_MODE
   printf ("Executing complete reset sequencing on link %d...\n", link);
#endif
}

void IOWR_RESET_SEQUENCER_FORCE_RESET (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_RESET_SEQ_BASE, link);
#if DEBUG_MODE
   printf ("Executing forced reset...\n");
#endif
   IOWR_32DIRECT(base, ALTERA_RESET_SEQUENCER_SW_DIRECT_CONTROLLED_RESETS_OFFSET, val);
}

int IORD_JESD204_TX_STATUS0_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_STATUS0_REG_OFFSET);

   return val;
}

int IORD_JESD204_TX_SYNCN_SYSREF_CTRL_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_SYNCN_SYSREF_CTRL_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_SYNCN_SYSREF_CTRL_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing val 0x%x to TX syncn_sysref_ctrl reg on link %d...\n", val, link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_SYNCN_SYSREF_CTRL_REG_OFFSET, val);

}

int IORD_JESD204_TX_DLL_CTRL_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_DLL_CTRL_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_DLL_CTRL_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing val 0x%x to TX dll_ctrl reg on link %d...\n", val, link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_DLL_CTRL_REG_OFFSET, val);

}

int IORD_JESD204_RX_STATUS0_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_STATUS0_REG_OFFSET);

   return val;
}

int IORD_JESD204_RX_SYNCN_SYSREF_CTRL_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_SYNCN_SYSREF_CTRL_REG_OFFSET);

   return val;
}

void IOWR_JESD204_RX_SYNCN_SYSREF_CTRL_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing val 0x%x to RX syncn_sysref_ctrl reg on link %d...\n", val, link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_SYNCN_SYSREF_CTRL_REG_OFFSET, val);
}

int IORD_JESD204_TX_ILAS_DATA1_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA1_REG_OFFSET);

   return val;
}

int IORD_JESD204_RX_ILAS_DATA1_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA1_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_ILAS_DATA1_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX ILAS DATA1 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA1_REG_OFFSET, val);
}

void IOWR_JESD204_RX_ILAS_DATA1_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX ILAS DATA1 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA1_REG_OFFSET, val);
}

int IORD_JESD204_TX_ILAS_DATA2_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA2_REG_OFFSET);

   return val;
}

int IORD_JESD204_RX_ILAS_DATA2_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA2_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_ILAS_DATA2_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX ILAS DATA2 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA2_REG_OFFSET, val);
}

void IOWR_JESD204_RX_ILAS_DATA2_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX ILAS DATA2 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA2_REG_OFFSET, val);
}

int IORD_JESD204_TX_ILAS_DATA12_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA12_REG_OFFSET);

   return val;
}

int IORD_JESD204_RX_ILAS_DATA12_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA12_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_ILAS_DATA12_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX ILAS DATA12 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA12_REG_OFFSET, val);
}

void IOWR_JESD204_RX_ILAS_DATA12_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX ILAS DATA12 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_ILAS_DATA12_REG_OFFSET, val);
}

int IORD_JESD204_TX_GET_L_VAL (int link)
{
   int val;

   val = IORD_JESD204_TX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_L_VAL_MASK;

   return val;
}

int IORD_JESD204_RX_GET_L_VAL (int link)
{
   int val;

   val = IORD_JESD204_RX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_L_VAL_MASK;

   return val;
}

int IORD_JESD204_TX_GET_F_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_F_VAL_MASK) >> ALTERA_JESD204_TX_RX_F_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_F_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_F_VAL_MASK) >> ALTERA_JESD204_TX_RX_F_VAL_POS;

   return val;
}

int IORD_JESD204_TX_GET_K_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_K_VAL_MASK) >> ALTERA_JESD204_TX_RX_K_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_K_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_K_VAL_MASK) >> ALTERA_JESD204_TX_RX_K_VAL_POS;

   return val;
}

int IORD_JESD204_TX_GET_M_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_M_VAL_MASK) >> ALTERA_JESD204_TX_RX_M_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_M_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA1_REG(link) & ALTERA_JESD204_TX_RX_M_VAL_MASK) >> ALTERA_JESD204_TX_RX_M_VAL_POS;

   return val;
}

int IORD_JESD204_TX_GET_N_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_N_VAL_MASK);

   return val;
}

int IORD_JESD204_RX_GET_N_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_N_VAL_MASK);

   return val;
}

int IORD_JESD204_TX_GET_NP_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_NP_VAL_MASK) >> ALTERA_JESD204_TX_RX_NP_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_NP_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_NP_VAL_MASK) >> ALTERA_JESD204_TX_RX_NP_VAL_POS;

   return val;
}

int IORD_JESD204_TX_GET_S_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_S_VAL_MASK) >> ALTERA_JESD204_TX_RX_S_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_S_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_S_VAL_MASK) >> ALTERA_JESD204_TX_RX_S_VAL_POS;

   return val;
}

int IORD_JESD204_TX_GET_HD_VAL (int link)
{
   int val;

   val = (IORD_JESD204_TX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_HD_VAL_MASK) >> ALTERA_JESD204_TX_RX_HD_VAL_POS;

   return val;
}

int IORD_JESD204_RX_GET_HD_VAL (int link)
{
   int val;

   val = (IORD_JESD204_RX_ILAS_DATA2_REG(link) & ALTERA_JESD204_TX_RX_HD_VAL_MASK) >> ALTERA_JESD204_TX_RX_HD_VAL_POS;

   return val;
}

int IORD_JESD204_TX_LANE_CTRL_REG (int link, int offset)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, offset);

   return val;
}

int IORD_JESD204_RX_LANE_CTRL_REG (int link, int offset)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, offset);

   return val;
}

void IOWR_JESD204_TX_LANE_CTRL_REG (int link, int offset, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX Lane Control register at offset 0x%x on link %d...\n", offset, link);
#endif
   IOWR_32DIRECT(base, offset, val);
}

void IOWR_JESD204_RX_LANE_CTRL_REG (int link, int offset, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX Lane Control register at offset 0x%x on link %d...\n", offset, link);
#endif
   IOWR_32DIRECT(base, offset, val);
}

int IORD_PIO_CONTROL_REG (void)
{
   int val;

   val = IORD_32DIRECT(NIOS_SUBSYSTEM_PIO_CONTROL_BASE, 0x0);

   return val;
}

void IOWR_PIO_CONTROL_REG (int val)
{
#if DEBUG_MODE
   printf ("Writing value: 0x0%x to PIO Control...\n", val);
#endif
   IOWR_32DIRECT(NIOS_SUBSYSTEM_PIO_CONTROL_BASE, 0x0, val);
}

int IORD_PIO_STATUS_REG (void)
{
   int val;

   val = IORD_32DIRECT(NIOS_SUBSYSTEM_PIO_STATUS_BASE, 0x0);

   return val;
}

int IORD_JESD204_TX_TEST_MODE_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_TEST_MODE_REG_OFFSET);

   return val;
}

int IORD_JESD204_RX_TEST_MODE_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_RX_TEST_MODE_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_TEST_MODE_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX test mode register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_TEST_MODE_REG_OFFSET, val);
}

void IOWR_JESD204_RX_TEST_MODE_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX test mode register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_RX_TEST_MODE_REG_OFFSET, val);
}

int IORD_JESD204_RX_ERR0_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_RX_ERR_STATUS_0_REG_OFFSET);

   return val;
}

void IOWR_JESD204_RX_ERR0_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX Error 0 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_RX_ERR_STATUS_0_REG_OFFSET, val);
}

int IORD_JESD204_RX_ERR1_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_RX_ERR_STATUS_1_REG_OFFSET);

   return val;
}

void IOWR_JESD204_RX_ERR1_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX Error 1 register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_RX_ERR_STATUS_1_REG_OFFSET, val);
}

int IORD_JESD204_TX_ERR_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_ERR_STATUS_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_ERR_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX Error register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_ERR_STATUS_REG_OFFSET, val);
}

int IORD_JESD204_TX_ERR_EN_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_TX_ERR_EN_REG_OFFSET);

   return val;
}

void IOWR_JESD204_TX_ERR_EN_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to TX Error Enable register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_TX_ERR_EN_REG_OFFSET, val);
}

int IORD_JESD204_RX_ERR_EN_REG (int link)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);

   val = IORD_32DIRECT(base, ALTERA_JESD204_RX_ERR_EN_REG_OFFSET);

   return val;
}

void IOWR_JESD204_RX_ERR_EN_REG (int link, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_BASE, link);
#if DEBUG_MODE
   printf ("Writing to RX Error Enable register on link %d...\n", link);
#endif
   IOWR_32DIRECT(base, ALTERA_JESD204_RX_ERR_EN_REG_OFFSET, val);
}

int IORD_XCVR_NATIVE_A10_REG (int link, int offset)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_RECONFIG_AVMM_BASE, link);

   val = IORD_32DIRECT(base, offset);

   return val;
}

void IOWR_XCVR_NATIVE_A10_REG (int link, int offset, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_LINK(JESD204B_SUBSYSTEM_0_JESD204B_RECONFIG_AVMM_BASE, link);
#if DEBUG_MODE
   printf ("Writing value 0x%2x to A10 XCVR native PHY register on link %d...\n", val, link);
#endif
   IOWR_32DIRECT(base, offset, val);
}

int IORD_XCVR_ATX_PLL_A10_REG (int link, int instance, int offset)
{
   int val;
   int base;

   base = CALC_BASE_ADDRESS_XCVR_PLL( CALC_BASE_ADDRESS_LINK( JESD204B_SUBSYSTEM_0_XCVR_ATX_PLL_A10_0_BASE, link ), instance );

   val = IORD_32DIRECT(base, offset);

   return val;
}

void IOWR_XCVR_ATX_PLL_A10_REG (int link, int instance, int offset, int val)
{
   int base;

   base = CALC_BASE_ADDRESS_XCVR_PLL( CALC_BASE_ADDRESS_LINK( JESD204B_SUBSYSTEM_0_XCVR_ATX_PLL_A10_0_BASE, link ), instance );
#if DEBUG_MODE
   printf ("Writing value 0x%2x to A10 XCVR PLL register on link %d...\n", val, link);
#endif
   IOWR_32DIRECT(base, offset, val);
}

int IORD_CORE_PLL_RECONFIG_C0_COUNTER_REG (void)
{
	return IORD(CORE_PLL_RECONFIG_BASE, ALTERA_CORE_PLL_RECONFIG_C0_COUNTER_OFFSET);
}

int IORD_CORE_PLL_RECONFIG_C1_COUNTER_REG (void)
{
	return IORD(CORE_PLL_RECONFIG_BASE, ALTERA_CORE_PLL_RECONFIG_C1_COUNTER_OFFSET);
}

void IOWR_CORE_PLL_RECONFIG_C0_COUNTER_REG (int val)
{
#if DEBUG_MODE
   printf ("Writing value 0x%x to core PLL reconfig C0 counter register...\n", val);
#endif
   IOWR(CORE_PLL_RECONFIG_BASE, ALTERA_CORE_PLL_RECONFIG_C0_COUNTER_OFFSET, val);
}

void IOWR_CORE_PLL_RECONFIG_C1_COUNTER_REG (int val)
{
#if DEBUG_MODE
   printf ("Writing value 0x%x to core PLL reconfig C1 counter register...\n", val);
#endif
   IOWR(CORE_PLL_RECONFIG_BASE, ALTERA_CORE_PLL_RECONFIG_C1_COUNTER_OFFSET, val);
}

void IOWR_CORE_PLL_RECONFIG_START_REG (int val)
{
#if DEBUG_MODE
   printf ("Writing value 0x%x to core PLL start register...\n", val);
#endif
   IOWR(CORE_PLL_RECONFIG_BASE, ALTERA_CORE_PLL_RECONFIG_START_REGISTER_OFFSET, val);
}
