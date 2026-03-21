#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "system.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "main.h"
#include "functions.h"
#include "macros.h"
#include "altera_jesd204_regs.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_timer.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_jtag_uart_regs.h"
#include "altera_avalon_jtag_uart.h"

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void ISR_JESD_RX (void *);
static void ISR_JESD_TX (void *);
static void ISR_SPI (void *);
#else
static void ISR_JESD_RX (void *, alt_u32);
static void ISR_JESD_TX (void *, alt_u32);
static void ISR_SPI (void *, alt_u32);
#endif /*ALT_ENHANCED_INTERRUPT_API_PRESENT*/

int main()
{
   int link = 0;
   int write_val = 0;
   int initialize_ret = 0;
   char *options[MAX_NUM_OPTIONS][MAX_OPTIONS_CHAR] = {{NULL}};
   int held_resets[MAX_LINKS] = {0x0};  //Bit positions: {7, 6, 5, 4, 3, 2, 1, 0} = {rx_frame, rx_link, rx_csr, tx_frame, tx_link, tx_csr, xcvr, pll}

   //Assert complete reset sequencing for each link
   printf("INFO: Asserting complete reset sequencing for each link...\n");

   for (link = 0; link < MAX_LINKS; link++)
   {
      if (ResetSeq(link, held_resets) != 0)
      {
         printf("ERROR: Initial reset sequencing failed for link %d!\n", link);
         printf("ERROR: Exiting terminal...\n");
         exit(0);
      }
   }

   //Disable certain TX/RX Error Interrupt Enable CSR registers in JESD204B IP Core
   printf("INFO: Disabling certain TX/RX error interrupt enables from JESD204B CSR for each link...\n");

   for (link = 0; link < MAX_LINKS; link++)
   {
#if DEBUG_MODE
      printf("\n");
      printf("DEBUG: Validating tx_err_enable CSR before write...\n");
      printf("DEBUG: tx_err_enable value for link %d is 0x%x\n", link, IORD_JESD204_TX_ERR_EN_REG(link));
      printf("DEBUG: Validating rx_err_enable CSR before write...\n");
      printf("DEBUG: rx_err_enable value for link %d is 0x%x\n", link, IORD_JESD204_RX_ERR_EN_REG(link));
      printf("\n");
#endif

      //Write to TX error interrupt enable register
      write_val = IORD_JESD204_TX_ERR_EN_REG(link) & ~(ALTERA_JESD204_TX_ERR_EN_REG_XCVR_PLL_LOCKED_ERR_EN_MASK |
                                                       ALTERA_JESD204_TX_ERR_EN_REG_PCFIFO_FULL_ERR_EN_MASK |
                                                       ALTERA_JESD204_TX_ERR_EN_REG_PCFIFO_EMPTY_ERR_EN_MASK);
#if DEBUG_MODE
      printf("DEBUG: Value to be written in to TX Error Interrupt Enable register for link %d is 0x%x\n", link, write_val);
#endif
      IOWR_JESD204_TX_ERR_EN_REG(link, write_val);

      //Write to RX error interrupt enable register
      write_val = IORD_JESD204_RX_ERR_EN_REG(link) & ~(ALTERA_JESD204_RX_ERR_EN_REG_RX_LOCKED_TO_DATA_ERR_EN_MASK |
                                                       ALTERA_JESD204_RX_ERR_EN_REG_PCFIFO_FULL_ERR_EN_MASK |
                                                       ALTERA_JESD204_RX_ERR_EN_REG_PCFIFO_EMPTY_ERR_EN_MASK);
#if DEBUG_MODE
      printf("DEBUG: Value to be written in to RX Error Interrupt Enable register for link %d is 0x%x\n", link, write_val);
#endif
      IOWR_JESD204_RX_ERR_EN_REG(link, write_val);

#if DEBUG_MODE
      printf("\n");
      printf("DEBUG: Validating tx_err_enable CSR after write...\n");
      printf("DEBUG: tx_err_enable value for link %d is 0x%x\n", link, IORD_JESD204_TX_ERR_EN_REG(link));
      printf("DEBUG: Validating rx_err_enable CSR after write...\n");
      printf("DEBUG: rx_err_enable value for link %d is 0x%x\n", link, IORD_JESD204_RX_ERR_EN_REG(link));
      printf("\n");
#endif

      // Write 1 to clear all the valid and active status in RX Error status 0, RX Error status 1, TX Error status register
      IOWR_JESD204_RX_ERR0_REG(link, ALTERA_JESD204_RX_ERR_STATUS_0_CLEAR_ERROR_MASK);
      IOWR_JESD204_RX_ERR1_REG(link, ALTERA_JESD204_RX_ERR_STATUS_1_CLEAR_ERROR_MASK);
      IOWR_JESD204_TX_ERR_REG(link, ALTERA_JESD204_TX_ERR_STATUS_CLEAR_ERROR_MASK);
   }

   initialize_ret = Initialize(options, held_resets);

   if (initialize_ret == 0)
      printf("INFO: Initialization successful!\n");
   else if (initialize_ret == 1)
      printf("ERROR: Initialization FAILED!\n");
   else
   {
      if ((initialize_ret & STATUS_ERROR_SYNC_USER_DATA) == STATUS_ERROR_SYNC_USER_DATA)
         printf("WARNING: Initialization completed but link errors found!\n");

#if PATCHK_EN
      if ((initialize_ret & STATUS_ERROR_PATCHK) == STATUS_ERROR_PATCHK)
         printf("WARNING: Initialization completed but pattern check errors found!\n");
#endif
   }

   printf("INFO: Reset link and clear JESD204B error status registers for each link...\n");

   for (link = 0; link < MAX_LINKS; link++)
   {
      //Assert and hold XCVR, link, frame resets
      if (ResetForce(link, XCVR_LINK_FRAME_RESET_MASK, HOLD_RESET_MASK, held_resets) != 0)
         return 1;

      //Relese XCVR, link and frame resets
      if (Reset_X_L_F_Release (link, held_resets) != 0)
         return 1;

      // Write 1 to clear all the valid and active status in RX Error status 0, RX Error status 1, TX Error status register
      IOWR_JESD204_RX_ERR0_REG(link, ALTERA_JESD204_RX_ERR_STATUS_0_CLEAR_ERROR_MASK);
      IOWR_JESD204_RX_ERR1_REG(link, ALTERA_JESD204_RX_ERR_STATUS_1_CLEAR_ERROR_MASK);
      IOWR_JESD204_TX_ERR_REG(link, ALTERA_JESD204_TX_ERR_STATUS_CLEAR_ERROR_MASK);
   }

   //Initialize (i.e register) ISRs
   InitISR();

   printf("INFO: End JESD204B initialization sequence\n");

  return 0;
}

int StringIsNumeric (char *str)
{
   while (*str)
   {
      if (!isdigit(*str))
      {
         return 0;
      }
      str++;
   }

   return 1;
}

void DelayCounter(alt_u32 count)
{
   alt_u32 tick;
   alt_u32 tock = 0;

   for (tock = 0; tock < count; tock++)
   {
      for (tick = 0; tick < TICK_DURATION; tick++)
         ; //NOP
#if DEBUG_MODE
      printf("DEBUG: Count: %d\n", (int) tock+1);
#endif
   }
}

int Initialize(char *options[][MAX_OPTIONS_CHAR], int *held_resets)
{
   char *null_options[MAX_NUM_OPTIONS][MAX_OPTIONS_CHAR] = {{NULL}};
   char *current_option;
   int i = 0;
   int ret_val = 0;

   printf("INFO: Initialization in progress...\n");

   for (i = 0; options[i][MAX_OPTIONS_CHAR] != NULL; i++)
   {
      current_option = options[i][MAX_OPTIONS_CHAR];

      if (i == 0 && StringIsNumeric(current_option)) //Do nothing
         printf("INFO: Current option value: %s\n", current_option);
      else
      {
         if (strcmp("n", current_option) == 0)
         {
            printf("INFO: Initializing to user mode...\n");
         }
         else
         {
            printf("ERROR: Option entered: %s is invalid!\n", current_option);
            return 1;
         }
      }
   }

   if (Test(options, held_resets) != 0)
   {
      printf("ERROR: While setting Test mode\n");
      return 1;
   }

   //Pulse sysref
   printf("INFO: Pulse sysref...\n");
   Sysref();

   printf("INFO: Wait for 10 seconds...\n");
   DelayCounter(10); //Delay for 10 "seconds"

   //Report Status 0 registers and pattern checker error status (for test mode only)
   ret_val = Status(null_options);

   return ret_val;
}

int Status(char *options[][MAX_OPTIONS_CHAR])
{
   char *current_option;
   int i = 0;
   int link = 0;
   int link_indicator = 0;
   int link_id;
   int opt = 0;
   int ret_val = 0;
   alt_u32 status0;
   alt_u32 patchk_error_mask   = 0x0;
   alt_u32 patchk_error_assert = 0x0;

   printf("INFO: Reporting link status...\n");

   for (i = 0; options[i][MAX_OPTIONS_CHAR] != NULL; i++)
   {
      current_option = options[i][MAX_OPTIONS_CHAR];

      if (i == 0 && StringIsNumeric(current_option))
      {
         link_id = atoi(current_option);
         if (link_id >= MAX_LINKS)
         {
            printf("ERROR: Link indicated: %d must be less than MAX_LINKS: %d\n", link_id, MAX_LINKS);
            return 1;
         }
         else
         {
            link_indicator = 1;
            printf("INFO: Link indicated: %d\n", link_id);
         }
      }
      else
      {
         if (strcmp("t", current_option) == 0)
         {
            printf("INFO: TX option detected...\n");
            opt |= TX_MASK;
         }
         else if (strcmp("r", current_option) == 0)
         {
            printf("INFO: RX option detected...\n");
            opt |= RX_MASK;
         }
         else
         {
            printf("ERROR: Option entered: %s is invalid!\n", current_option);
            return 1;
         }
      }
   }

   //If no options indicated, set default options
   if (opt == 0)
      opt = DATAPATH; //1: TX only
                      //2: RX only
                      //3: Duplex mode

   //Report status of each link
   for (link = 0; link < MAX_LINKS; link++)
   {
      if (link_indicator == 1 && link != link_id)
         continue;
      else
      {
         if ((opt & TX_MASK) == TX_MASK)
         {
            status0 = IORD_JESD204_TX_STATUS0_REG(link);
            printf("\n");
            printf("INFO: TX status 0 register for link %d: 0x%08X\n", link, (unsigned int) status0);
            if (((status0 & ALTERA_JESD204_TX_RX_STATUS0_REG_SYNCN_MASK) != ALTERA_JESD204_TX_RX_STATUS0_REG_SYNCN_DEASSERT) ||
               ((status0 & ALTERA_JESD204_TX_RX_STATUS0_REG_DLL_STATE_MASK) != ALTERA_JESD204_TX_RX_STATUS0_REG_USER_DATA_MODE))
            {
               printf("WARNING: TX Link %d is not in sync or link is not in user data mode\n", link);
               ret_val |= STATUS_ERROR_SYNC_USER_DATA;
            }
         }

         if ((opt & RX_MASK) == RX_MASK)
         {
            status0 = IORD_JESD204_RX_STATUS0_REG(link);
            printf("\n");
            printf("INFO: RX status 0 register for link %d: 0x%08X\n", link, (unsigned int) status0);
            if ((status0 & ALTERA_JESD204_TX_RX_STATUS0_REG_SYNCN_MASK) != ALTERA_JESD204_TX_RX_STATUS0_REG_SYNCN_DEASSERT)
            {
               printf("WARNING: RX Link %d is not in sync\n", link);
               ret_val |= STATUS_ERROR_SYNC_USER_DATA;
            }
         }
#if PATCHK_EN
         printf("\n");
         printf("INFO: Reporting pattern checker status...\n");

         patchk_error_mask = ALTERA_PIO_STATUS_PATCHK_ERROR_0_MASK << (3*link);
         patchk_error_assert = ALTERA_PIO_STATUS_PATCHK_ERROR_0_ASSERT << (3*link);

#if DEBUG_MODE
         printf("\n");
         printf("DEBUG: patchk_error_mask value for link %d: 0x%x\n", link, (unsigned int) patchk_error_mask);
         printf("DEBUG: patchk_error_assert value for link %d: 0x%x\n", link, (unsigned int) patchk_error_assert);
         printf("DEBUG: IORD_PIO_STATUS_REG value: 0x%x\n", IORD_PIO_STATUS_REG());
         printf("\n");
#endif

         if ((IORD_PIO_STATUS_REG() & patchk_error_mask) == patchk_error_assert)
         {
            printf("WARNING: Pattern checker error detected on link %d\n", link);
            ret_val |= STATUS_ERROR_PATCHK;
         }
         else
            printf("INFO: No pattern checker error detected on link %d\n", link);
#endif
      }
   }

return ret_val;
}

int Loopback (char *options[][MAX_OPTIONS_CHAR], int *held_resets, int dnr)
{
   char *current_option;
   int i = 0;
   int link = 0;
   int link_indicator = 0;
   int link_id;
   int loopback_flag = LOOPBACK_INIT;
   int write_val = 0;

   printf("INFO: Setting loopback mode in progress...\n");

   for (i = 0; options[i][MAX_OPTIONS_CHAR] != NULL; i++)
   {
      current_option = options[i][MAX_OPTIONS_CHAR];

      if (i == 0 && StringIsNumeric(current_option))
      {
         link_id = atoi(current_option);
         if (link_id >= MAX_LINKS)
         {
            printf("ERROR: Link indicated: %d must be less than MAX_LINKS: %d\n", link_id, MAX_LINKS);
            return 1;
         }
         else
         {
            link_indicator = 1;
            printf("INFO: Link indicated: %d\n", link_id);
         }
      }
      else
      {
         if (strcmp("n", current_option) == 0)
         {
            printf("INFO: Loopback disable detected...\n");
            loopback_flag = 0;
         }
         else
         {
            printf("ERROR: Option entered: %s is invalid!\n", current_option);
            return 1;
         }
      }
   }

   if (loopback_flag == 1)
      printf("INFO: Loopback enable detected...\n");
   else if (loopback_flag == 0)
      printf("INFO: Loopback disable detected...\n");

   for (link = 0; link < MAX_LINKS; link++)
   {
      if (link_indicator == 1 && link != link_id)
      {
         continue;
      }
      else
      {
         if (loopback_flag == 1)
            write_val = IORD_PIO_CONTROL_REG() | (ALTERA_PIO_CONTROL_RX_SERIALLPBKEN_0_MASK << link); //Force loopback PIO registers to 1 (but leave other PIO registers untouched)
         else if (loopback_flag == 0)
            write_val = IORD_PIO_CONTROL_REG() & ~(ALTERA_PIO_CONTROL_RX_SERIALLPBKEN_0_MASK << link); //Force loopback PIO registers to 0 (but leave other PIO registers untouched)
         else
            printf("FATAL ERROR: Invalid value for loopback_flag\n"); // FATAL ERROR: Should never arrive here during normal operation

         //Assert and hold XCVR, link, frame resets while writing to JESD CSR
         if (ResetForce(link, XCVR_LINK_FRAME_RESET_MASK, HOLD_RESET_MASK, held_resets) != 0)
            return 1;
#if DEBUG_MODE
         printf("DEBUG: Value to be written to PIO control: 0x0%x\n", write_val);
         printf("DEBUG: Writing loopback value to PIO control...\n");
#endif
         IOWR_PIO_CONTROL_REG(write_val);

         if (dnr != DO_NOT_RELEASE_RESETS)
         {
            //Relese XCVR, link and frame resets after done writing to JESD CSR
            if (Reset_X_L_F_Release (link, held_resets) != 0)
               return 1;
         }
      }
   }

   return 0;
}

int SourceDest (char *options[][MAX_OPTIONS_CHAR], int *held_resets, int dnr)
{
   char *current_option;
   int i = 0;
   int link = 0;
   int link_indicator = 0;
   int link_id;
   int sd = 0;
   int opt_set = 0;
   int mask_val = 0xF;

   printf("INFO: Setting source/destination mode in progress...\n");

   for (i = 0; options[i][MAX_OPTIONS_CHAR] != NULL; i++)
   {
      current_option = options[i][MAX_OPTIONS_CHAR];

      if (i == 0 && StringIsNumeric(current_option))
      {
         link_id = atoi(current_option);
         if (link_id >= MAX_LINKS)
         {
            printf("ERROR: Link indicated: %d must be less than MAX_LINKS: %d\n", link_id, MAX_LINKS);
            return 1;
         }
         else
         {
            link_indicator = 1;
            printf("INFO: Link indicated: %d\n", link_id);
         }
      }
      else
      {
     	 if (strcmp("s", current_option) == 0)
         {
            printf("INFO: TX datapath detected...\n");
            sd |= TX_MASK;
         }
     	 else if (strcmp("d", current_option) == 0)
         {
            printf("INFO: RX datapath detected...\n");
            sd |= RX_MASK;
         }
     	 else if ((strcmp("u", current_option) == 0) || (strcmp("n", current_option) == 0))
         {
            printf("INFO: User data detected...\n");
            if (opt_set == 1)
            {
               printf("ERROR: Too many options entered!\n");
               return 1;
            }
            else
            {
               mask_val = ALTERA_JESD204_TX_RX_TEST_MODE_NO_TEST_MASK;
               opt_set = 1;
            }
         }
         else if (strcmp("a", current_option) == 0)
         {
            printf("INFO: Alternate pattern detected...\n");
            if (opt_set == 1)
            {
               printf("ERROR: Too many options entered!\n");
               return 1;
            }
            else
            {
               mask_val = ALTERA_JESD204_TX_RX_TEST_MODE_ALT_MASK;
               opt_set = 1;
            }
         }
         else if (strcmp("r", current_option) == 0)
         {
            printf("INFO: Ramp pattern detected...\n");
            if (opt_set == 1)
            {
               printf("ERROR: Too many options entered!\n");
               return 1;
            }
            else
            {
               mask_val = ALTERA_JESD204_TX_RX_TEST_MODE_RAMP_MASK;
               opt_set = 1;
            }
         }
         else if (strcmp("p", current_option) == 0)
         {
            printf("INFO: PRBS pattern detected...\n");
            if (opt_set == 1)
            {
               printf("ERROR: Too many options entered!\n");
               return 1;
            }
            else
            {
               mask_val = ALTERA_JESD204_TX_RX_TEST_MODE_PRBS_MASK;
               opt_set = 1;
            }
         }
         else
         {
        	 printf("ERROR: Option entered: %s is invalid!\n", current_option);
        	 return 1;
         }
      }
   }

   //Default options checking
   if (sd == 0)
      sd = DATAPATH; //1: TX only
                     //2: RX only
                     //3: Duplex mode

   if (mask_val == 0xF) //No options set
   {
      printf("INFO: Defaulting to PRBS pattern generator/checker...\n");
      mask_val = SOURCEDEST_INIT;
#if DEBUG_MODE
      printf("\n");
      printf("DEBUG: Default mask_val is 0x%X\n", mask_val);
      printf("\n");
#endif
   }

   for (link = 0; link < MAX_LINKS; link++)
   {
      if (link_indicator == 1 && link != link_id)
         continue;
      else
      {
         //Assert and hold XCVR, link, frame resets while writing to JESD CSR
         if (ResetForce(link, XCVR_LINK_FRAME_RESET_MASK, HOLD_RESET_MASK, held_resets) != 0)
            return 1;

         if ((sd & TX_MASK) == TX_MASK)
         {
#if DEBUG_MODE
            printf("DEBUG: TX test mode register value at link %d before write: 0x%08X\n", link, IORD_JESD204_TX_TEST_MODE_REG(link));
            printf("DEBUG: Writing to TX test mode register...\n");
#endif
            IOWR_JESD204_TX_TEST_MODE_REG (link, mask_val);
#if DEBUG_MODE
            printf("DEBUG: TX test mode register value at link %d after write: 0x%08X\n", link, IORD_JESD204_TX_TEST_MODE_REG(link));
#endif
         }

         if ((sd & RX_MASK) == RX_MASK)
         {
#if DEBUG_MODE
            printf("DEBUG: RX test mode register value at link %d before write: 0x%08X\n", link, IORD_JESD204_RX_TEST_MODE_REG(link));
            printf("DEBUG: Writing to RX test mode register...\n");
#endif
            IOWR_JESD204_RX_TEST_MODE_REG (link, mask_val);
#if DEBUG_MODE
            printf("DEBUG: RX test mode register value at link %d after write: 0x%08X\n", link, IORD_JESD204_RX_TEST_MODE_REG(link));
#endif
         }

         if (dnr != DO_NOT_RELEASE_RESETS)
         {
            //Relese XCVR, link and frame resets after done writing to JESD CSR
            if (Reset_X_L_F_Release (link, held_resets) != 0)
               return 1;
         }
      }
   }

   return 0;
}

int Test(char *options[][MAX_OPTIONS_CHAR], int *held_resets)
{
   char *current_option;
   int i = 0;

   for (i = 0; options[i][MAX_OPTIONS_CHAR] != NULL; i++)
   {
      current_option = options[i][MAX_OPTIONS_CHAR];

      if (i == 0 && StringIsNumeric(current_option)) //Do nothing
         ;
      else
      {
         if (strcmp("n", current_option) == 0)
            printf("INFO: Test mode disabled detected...\n");
         else
         {
        	 printf("ERROR: Option entered: %s is invalid!\n", current_option);
        	 return 1;
         }
      }
   }

   //Execute SourceDest command
   if ( SourceDest( options, held_resets, DO_NOT_RELEASE_RESETS ) != 0 )
      return 1;

   //Execute Loopback command
   if ( Loopback( options, held_resets, RELEASE_RESETS ) != 0 )
      return 1;

   return 0;
}

void Sysref(void)
{
#if DEBUG_MODE
   printf("DEBUG: Force sysref to 0 before asserting...\n");
#endif
   IOWR_PIO_CONTROL_REG(IORD_PIO_CONTROL_REG() & ~ALTERA_PIO_CONTROL_SYSREF_MASK); //Force sysref PIO register to 0 (but leave other PIO registers untouched)

#if DEBUG_MODE
   printf("DEBUG: Asserting sysref...\n");
#endif
   IOWR_PIO_CONTROL_REG(IORD_PIO_CONTROL_REG() | ALTERA_PIO_CONTROL_SYSREF_MASK); //Force sysref PIO register to 1 (but leave other PIO registers untouched)

#if DEBUG_MODE
   printf("DEBUG: De-asserting sysref...\n");
#endif
   IOWR_PIO_CONTROL_REG(IORD_PIO_CONTROL_REG() & ~ALTERA_PIO_CONTROL_SYSREF_MASK); //Force sysref PIO register to 0 (but leave other PIO registers untouched)
}

int ResetSeq (int link, int *held)
{
#if DEBUG_MODE
   printf("DEBUG: Held resets for link %d at beginning of ResetSeq: 0x0%x\n", link, held[link]);
#endif

   //Wait until reset sequencer RESET_ACTIVE signal de-asserts before proceeding
   while (IORD_RESET_SEQUENCER_RESET_ACTIVE(link) == 1);

   //Clear any previous reset overwrite trigger enable settings
   IOWR_RESET_SEQUENCER_FORCE_RESET(link, 0x0);

   //Wait until reset sequencer RESET_ACTIVE signal de-asserts before proceeding
   while (IORD_RESET_SEQUENCER_RESET_ACTIVE(link) == 1);

   held[link] = 0x0; //Clear all held reset flags

   IOWR_RESET_SEQUENCER_INIT_RESET_SEQ(link);

#if DEBUG_MODE
   printf("DEBUG: Held resets for link %d at end of ResetSeq: 0x0%x\n", link, held[link]);
#endif

   return 0;
}

int ResetForce (int link, int reset_val, int hr, int *held)
{
   int val = 0x0;
   int j = 0;

#if DEBUG_MODE
   printf("DEBUG: Held resets for link %d at beginning of ResetForce: 0x0%x\n", link, held[link]);
#endif

   if (hr == 0) //If pulse resets detected, set to reset assertion case first
      j = 2;
   else
      j = hr;

   switch (j)
   {
      case 2: //Force assert resets
      {
#if DEBUG_MODE
         printf ("DEBUG: Executing forced reset assertion on link %d...\n", link);
#endif
         //Set Reset Overwrite Trigger Enable register values
         val = ((held[link] | reset_val) << 16);
         //Set Reset Overwrite register values
         val |= (held[link] | reset_val);
#if DEBUG_MODE
         printf ("DEBUG: Reset val: 0x0%x\n", val);
#endif

         //Wait until reset sequencer RESET_ACTIVE signal de-asserts before proceeding
         while (IORD_RESET_SEQUENCER_RESET_ACTIVE(link) == 1);

         IOWR_RESET_SEQUENCER_FORCE_RESET(link, val);

         if (hr == 2) //If hold resets detected
         {
            //Update held resets info
            held[link] |= reset_val;
#if DEBUG_MODE
            printf("DEBUG: Held resets for link %d after reset_val update: 0x0%x\n", link, held[link]);
#endif
            return 0;
         }
         //else, pulse resets detected. Fall through to next statement
      }

      case 1:
      {
#if DEBUG_MODE
         printf ("DEBUG: Executing forced reset de-assertion on link %d...\n", link);
#endif
         //Set Reset Overwrite Trigger Enable register values
         val = ((held[link] | reset_val) << 16);
         //Set Reset Overwrite register values
         val |= (held[link] & (~reset_val));
#if DEBUG_MODE
         printf ("DEBUG: Reset val: 0x0%x\n", val);
#endif

         //Wait until reset sequencer RESET_ACTIVE signal de-asserts before proceeding
         while (IORD_RESET_SEQUENCER_RESET_ACTIVE(link) == 1);

         IOWR_RESET_SEQUENCER_FORCE_RESET(link, val);

         //Clear Reset Overwrite Trigger Enables that were released (but not held resets)
         val = ((held[link] & (~reset_val)) << 16);
         //Set Reset Overwrite register values
         val |= (held[link] & (~reset_val));
#if DEBUG_MODE
         printf ("DEBUG: Reset val: 0x0%x\n", val);
#endif

         //Wait until reset sequencer RESET_ACTIVE signal de-asserts before proceeding
         while (IORD_RESET_SEQUENCER_RESET_ACTIVE(link) == 1);

         IOWR_RESET_SEQUENCER_FORCE_RESET(link, val);

         //Update held resets info
         held[link] &= ~reset_val;
#if DEBUG_MODE
         printf("DEBUG: Held resets for link %d after reset_val update: 0x0%x\n", link, held[link]);
#endif
         return 0;
      }

      default:
      {
         printf ("ERROR: Unrecognized hold/release setting\n");
         return 1;
      }
   }

   return 0;
}

int Reset_X_L_F_Release (int link, int *held_resets)
{
   alt_u32 xcvr_ready_mask   = 0x0;
   alt_u32 xcvr_ready_assert = 0x0;

   //Relese XCVR reset after writing to JESD CSR
   if (ResetForce(link, XCVR_RESET_MASK, RELEASE_RESET_MASK, held_resets) != 0)
      return 1;

   xcvr_ready_mask = ALTERA_PIO_STATUS_ALL_TX_READY_0_MASK << (3*link);
   xcvr_ready_assert = ALTERA_PIO_STATUS_ALL_TX_READY_0_ASSERT << (3*link);

#if DEBUG_MODE
   printf("DEBUG: TX xcvr_ready_mask for link %d: 0x%x\n", link, (unsigned int) xcvr_ready_mask);
   printf("DEBUG: TX xcvr_ready_assert for link %d: 0x%x\n", link, (unsigned int) xcvr_ready_assert);
#endif

   //Wait for XCVR TX ready signal before proceeding to release tx_link and tx_frame resets
#if DEBUG_MODE
   printf("DEBUG: Checking XCVR TX ready...\n");
#endif
   while((IORD_PIO_STATUS_REG() & xcvr_ready_mask) != xcvr_ready_assert)
      ; //wait, do nothing

   //Release tx_link and tx_frame resets once XCVR tx_ready signal asserted
   if (ResetForce(link, TX_LINK_FRAME_RESET_MASK, RELEASE_RESET_MASK, held_resets) != 0)
      return 1;

   xcvr_ready_mask = ALTERA_PIO_STATUS_ALL_RX_READY_0_MASK << (3*link);
   xcvr_ready_assert = ALTERA_PIO_STATUS_ALL_RX_READY_0_ASSERT << (3*link);

#if DEBUG_MODE
   printf("DEBUG: RX xcvr_ready_mask for link %d: 0x%x\n", link, (unsigned int) xcvr_ready_mask);
   printf("DEBUG: RX xcvr_ready_assert for link %d: 0x%x\n", link, (unsigned int) xcvr_ready_assert);
#endif

   //Wait for XCVR RX ready signal before proceeding to release rx_link and rx_frame resets
#if DEBUG_MODE
   printf("DEBUG: Checking XCVR RX ready...\n");
#endif
   while((IORD_PIO_STATUS_REG() & xcvr_ready_mask) != xcvr_ready_assert)
      ; //wait, do nothing

   //Release rx_link and rx_frame resets once XCVR rx_ready signal asserted
   if (ResetForce(link, RX_LINK_FRAME_RESET_MASK, RELEASE_RESET_MASK, held_resets) != 0)
      return 1;

   return 0;
}

// JESD RX Core ISR
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void ISR_JESD_RX (void * context)
#else
static void ISR_JESD_RX (void * context, alt_u32 id)
#endif
{
   // Variable to store the error type register
   volatile unsigned int error_type;
   int link = 0;

   //link = (int) context;

#if DEBUG_MODE
   printf("DEBUG: Link indicated for ISR_JESD_RX: %d\n", link);
#endif

   // Read Rx Error 0 status register
   error_type = IORD_JESD204_RX_ERR0_REG(link);

#if PRINT_INTERRUPT_MESSAGES
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_SYSREF_LMFC_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_SYSREF_LMFC_ERROR)
   {
      printf("Rx Error 0: Sysref LMFC error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_DLL_DATA_RDY_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_DLL_DATA_RDY_ERROR)
   {
      printf("Rx Error 0: DLL Data Ready error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_FRAME_DATA_RDY_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_FRAME_DATA_RDY_ERROR)
   {
      printf("Rx Error 0: Transport Data Ready error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_LANE_ALIGN_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_LANE_ALIGN_ERROR)
   {
      printf("Rx Error 0: Lane Align error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_RX_LOCKED_TO_DATA_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_RX_LOCKED_TO_DATA_ERROR)
   {
      printf("Rx Error 0: RX locked to data error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_PCFIFO_FULL_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_PCFIFO_FULL_ERROR)
   {
      printf("Rx Error 0: PCFIFO full error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_0_REG_PCFIFO_EMPTY_MASK) == ALTERA_JESD204_RX_ERR_STATUS_0_REG_PCFIFO_EMPTY_ERROR)
   {
      printf("Rx Error 0: PCFIFO empty error happened\n");
   }
#endif

   // Write 1 to clear all the valid and active status in Rx Error status 0 register
   IOWR_JESD204_RX_ERR0_REG(link, ALTERA_JESD204_RX_ERR_STATUS_0_CLEAR_ERROR_MASK);

#if DEBUG_MODE
   if (IORD_JESD204_RX_ERR0_REG(link) != 0x0)
   {
      printf("Rx Error 0: Error and interrupt not cleared!!!\n");
   }
   else
   {
      printf("Rx Error 0: Error and interrupt all cleared!!!\n");
   }
#endif

   // Read Rx Error 1 status register
   error_type = IORD_JESD204_RX_ERR1_REG(link);

#if PRINT_INTERRUPT_MESSAGES
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_CGS_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_CGS_ERROR)
   {
      printf("Rx Error 1: CGS error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_FRAME_ALIGNMENT_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_FRAME_ALIGNMENT_ERROR)
   {
      printf("Rx Error 1: Frame Alignment error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_LANE_ALIGNMENT_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_LANE_ALIGNMENT_ERROR)
   {
      printf("Rx Error 1: Lane Alignment error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_UNEXP_K_CHAR_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_UNEXP_K_CHAR_ERROR)
   {
      printf("Rx Error 1: Unexpected K Char error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_NOT_IN_TABLE_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_NOT_IN_TABLE_ERROR)
   {
      printf("Rx Error 1: Not In Table error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_DISPARITY_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_DISPARITY_ERROR)
   {
      printf("Rx Error 1: Disparity error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_ILAS_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_ILAS_ERROR)
   {
      printf("Rx Error 1: ILAS error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_DLL_RSVD_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_DLL_RSVD_ERROR)
   {
      printf("Rx Error 1: DLL Rsvd error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_ECC_CORRECTED_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_ECC_CORRECTED_ERROR)
   {
      printf("Rx Error 1: ECC Corrected error happened\n");
   }
   if ((error_type & ALTERA_JESD204_RX_ERR_STATUS_1_ECC_FATAL_MASK) == ALTERA_JESD204_RX_ERR_STATUS_1_ECC_FATAL_ERROR)
   {
      printf("Rx Error 1: ECC Fatal error happened\n");
   }
#endif

   // Write 1 to clear all the valid and active status in Rx Error status 1 register
   IOWR_JESD204_RX_ERR1_REG(link, ALTERA_JESD204_RX_ERR_STATUS_1_CLEAR_ERROR_MASK);

#if DEBUG_MODE
   if (IORD_JESD204_RX_ERR1_REG(link) != 0x0)
   {
      printf("Rx Error 1: Error and interrupt not cleared!!!\n");
   }
   else
   {
      printf("Rx Error 1: Error and interrupt all cleared!!!\n");
   }
#endif

}

// JESD Tx Core ISR
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void ISR_JESD_TX (void * context)
#else
static void ISR_JESD_TX (void * context, alt_u32 id)
#endif
{
   // Variable to store the error type register
   volatile unsigned int error_type;
   int link = 0;

   //link = (int) context;

#if DEBUG_MODE
   printf("DEBUG: Link indicated for ISR_JESD_TX: %d\n", link);
#endif

   // Read Tx Error status register
   error_type = IORD_JESD204_TX_ERR_REG(link);

#if PRINT_INTERRUPT_MESSAGES
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_SYNCN_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_SYNCN_ERROR)
   {
      printf("Tx Error: SYNCN error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_SYSREF_LMFC_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_SYSREF_LMFC_ERROR)
   {
      printf("Tx Error: SYSREF LMFC error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_DLL_DATA_INVALID_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_DLL_DATA_INVALID_ERROR)
   {
      printf("Tx Error: DLL Data Invalid error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_FRAME_DATA_INVALID_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_FRAME_DATA_INVALID_ERROR)
   {
      printf("Tx Error: Frame Data Invalid error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_SYNCN_REINIT_REQ_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_SYNCN_REINIT_REQ_ERROR)
   {
      printf("Tx Error: SYNCN reinit error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_PLL_LOCKED_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_PLL_LOCKED_ERROR)
   {
      printf("Tx Error: PLL locked error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_PCFIFO_FULL_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_PCFIFO_FULL_ERROR)
   {
      printf("Tx Error: PCFIFO full error happened\n");
   }
   if ((error_type & ALTERA_JESD204_TX_ERR_STATUS_REG_PCFIFO_EMPTY_MASK) == ALTERA_JESD204_TX_ERR_STATUS_REG_PCFIFO_EMPTY_ERROR)
   {
      printf("Tx Error: PCFIFO empty error happened\n");
   }
#endif

   // Write 1 to clear all the valid and active status in Tx Error status register
   IOWR_JESD204_TX_ERR_REG(link, ALTERA_JESD204_TX_ERR_STATUS_CLEAR_ERROR_MASK);

#if DEBUG_MODE
   if (IORD_JESD204_TX_ERR_REG(link) != 0x0)
   {
      printf("Tx Error: Error and interrupt not cleared!!!\n");
   }
   else
   {
      printf("Tx Error: Error and interrupt all cleared!!!\n");
   }
#endif

}

// SPI ISR
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void ISR_SPI (void * context)
#else
static void ISR_SPI (void * context, alt_u32 id)
#endif
{
#if DEBUG_MODE
   printf("DEBUG: SPI Rx :) %x \n" ,  IORD_ALTERA_AVALON_SPI_RXDATA(SPI_0_BASE));
   printf("DEBUG: SPI Tx :) %x \n" ,  IORD_ALTERA_AVALON_SPI_TXDATA(SPI_0_BASE));
#endif

   //This resets the IRQ flag.
   IOWR_ALTERA_AVALON_SPI_STATUS(SPI_0_BASE, 0x0);

}

void InitISR (void)
{
   //int link = 1;
   //int base_irq_priority = JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_IRQ;

#if DEBUG_MODE
   printf("DEBUG: Start of InitISR function...\n");
#endif

   // Register interrupt handler
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
//   for (link = 0; link < MAX_LINKS; link++)
//   {
      alt_ic_isr_register (JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_IRQ_INTERRUPT_CONTROLLER_ID,
                           //(base_irq_priority*link),
                           JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_IRQ,
                           ISR_JESD_TX,
                           //(void *)link,
                           NULL,
                           0x0);

      alt_ic_isr_register (JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_IRQ_INTERRUPT_CONTROLLER_ID,
                           //((base_irq_priority*link) + 1),
                           JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_IRQ,
                           ISR_JESD_RX,
                           //(void *)link,
                           NULL,
                           0x0);
//   }

   alt_ic_isr_register (SPI_0_IRQ_INTERRUPT_CONTROLLER_ID,
                        SPI_0_IRQ,
                        ISR_SPI,
                        NULL,
                        0x0);
#else
//   for (link = 0; link < MAX_LINKS; link++)
//   {
      alt_irq_register (//(base_irq_priority*link),
                        JESD204B_SUBSYSTEM_0_JESD204B_JESD204_TX_AVS_IRQ,
                        //(void *)link,
                        NULL,
                        ISR_JESD_TX);

      alt_irq_register (//((base_irq_priority*link) + 1),
                        JESD204B_SUBSYSTEM_0_JESD204B_JESD204_RX_AVS_IRQ,
                        //(void *)link,
                        NULL,
                        ISR_JESD_RX);
//   }

   alt_irq_register (SPI_0_IRQ,
                     NULL,
                     ISR_SPI);
#endif

   // Disable timer and jtag uart interrupt generation.
   // Will let user to customize timer usage and it's corresponding ISR (eg: watchdog timer)
   IOWR_ALTERA_AVALON_TIMER_CONTROL(NIOS_SUBSYSTEM_TIMER_BASE, 0);
   IOWR_ALTERA_AVALON_JTAG_UART_CONTROL(NIOS_SUBSYSTEM_JTAG_UART_BASE, 0x0);

#if DEBUG_MODE
   printf("DEBUG: End of InitISR function...\n");
#endif

   return;
}
