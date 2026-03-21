/*
 * main.h
 */

#ifndef __ALT_JESD204B_ED_MAIN_H__
#define __ALT_JESD204B_ED_MAIN_H__

//User Parameters
#define DEBUG_MODE 0 //Turn on/off debug messages
#define PRINT_INTERRUPT_MESSAGES 1 //Turn on/off printing JESD204B error interrupt messages
#define PATCHK_EN 1 // 0: Pattern checker NOT included in design configuration
                    // 1: Pattern checker included in design configuration
#define DATAPATH 3 //1: TX only
                   //2: RX only
                   //3: Duplex mode
#define MAX_LINKS 1 //WARNING: Do not exceed 16
#define LOOPBACK_INIT 1
#define SOURCEDEST_INIT PRBS

//Constants
#define TICK_DURATION 2000000 //Set to 2000000 for mgmt_clk = 100Mhz
                              //Set to 1000000 for mgmt_clk = 50Mhz

#define MAX_NUM_OPTIONS 20 //Maximum number of options per command
#define MAX_OPTIONS_CHAR 10 //Maximum number of characters per option

#define RELEASE_RESETS 0
#define DO_NOT_RELEASE_RESETS 1

#define TX_MASK 0x1
#define RX_MASK 0x2

#define PLL_RESET_MASK             0x01
#define XCVR_RESET_MASK            0x02
#define CSR_RESET_MASK             0x24 // Set both tx_csr and rx_csr
#define LINK_RESET_MASK            0x48 // Set both tx_link and rx_link
#define FRAME_RESET_MASK           0x90 // Set both tx_frame and rx_frame
#define ALL_RESET_MASK             0xFF // Set ALL resets
#define HOLD_RESET_MASK            0x2
#define RELEASE_RESET_MASK         0x1
#define XCVR_LINK_FRAME_RESET_MASK 0xDA //Set xcvr, tx_link, tx_frame, rx_link, rx_frame
#define TX_LINK_FRAME_RESET_MASK   0x18 //Set tx_link, tx_frame
#define RX_LINK_FRAME_RESET_MASK   0xC0 //Set rx_link, rx_frame

#define STATUS_ERROR_SYNC_USER_DATA 0x2
#define STATUS_ERROR_PATCHK         0x4

#define USER (0x0)
#define ALT  (0x8)
#define RAMP (0x9)
#define PRBS (0xA)


#endif /* __ALT_JESD204B_ED_MAIN_H__ */
