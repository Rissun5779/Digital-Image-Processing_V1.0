// ********************************************************************************
// DisplayPort Core test code configuration
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/dp_demo/config.h $
//
// Description:
//
// ********************************************************************************

#define BITEC_AUX_DEBUG             0 // Set to 1 to enable AUX CH traffic monitoring
#define BITEC_STATUS_DEBUG          1 // Set to 1 to enable MSA and link status monitoring

#define BITEC_RX_GPUMODE            1 // Set to 1 to enable Sink GPU-mode

// RX Capabilities (for Sink GPU-mode)
#define BITEC_RX_CAPAB_MST          1 // Set to 1 to enable MST support
#define BITEC_DP_0_AV_RX_CONTROL_BITEC_CFG_RX_SUPPORT_MST 1
#define BITEC_RX_FAST_LT_SUPPORT    1 // Set to 1 to enable Fast Link Training support
#define BITEC_RX_LQA_SUPPORT        1 // Set to 1 to enable Link Quality Analysis support
#define BITEC_EDID_800X600_AUDIO    1 // Set to 1 to use an EDID with max resolution 800 x 600

// TX Capabilities
#define BITEC_TX_CAPAB_MST          1 // Set to 1 to enable MST support
#define BITEC_TX_PHY_TEST_PATTERN   0 // Set to 1 to enable support for PHY_TEST_PATTERN Test Automation


