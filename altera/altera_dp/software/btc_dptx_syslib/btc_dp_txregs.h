// ********************************************************************************
// DisplayPort Core Source register map
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/btc_dptx_syslib/btc_dp_txregs.h $
//
// Description:
//
// ********************************************************************************

#define DPTX_REG_TX_CONTROL   0x0
#define DPTX_REG_TX_STATUS    0x1
#define DPTX_REG_TX_VERSION   0x2

#define DPTX_REG_PRE_VOLT0    0x10
#define DPTX_REG_PRE_VOLT1    0x11
#define DPTX_REG_PRE_VOLT2    0x12
#define DPTX_REG_PRE_VOLT3    0x13
#define DPTX_REG_RECONFIG     0x14
#define DPTX_REG_TEST_80BIT_PATTERN1 0x15
#define DPTX_REG_TEST_80BIT_PATTERN2 0x16
#define DPTX_REG_TEST_80BIT_PATTERN3 0x17

#define DPTX_REG_TIMESTAMP    0x1f

#define DPTX0_REG_MSA_MVID    0x20
#define DPTX0_REG_MSA_NVID    0x21
#define DPTX0_REG_MSA_HTOTAL  0x22
#define DPTX0_REG_MSA_VTOTAL  0x23
#define DPTX0_REG_MSA_HSP     0x24
#define DPTX0_REG_MSA_HSW     0x25
#define DPTX0_REG_MSA_HSTART  0x26
#define DPTX0_REG_MSA_VSTART  0x27
#define DPTX0_REG_MSA_VSP     0x28
#define DPTX0_REG_MSA_VSW     0x29
#define DPTX0_REG_MSA_HWIDTH  0x2a
#define DPTX0_REG_MSA_VHEIGHT 0x2b
#define DPTX0_REG_MSA_MISC0   0x2c
#define DPTX0_REG_MSA_MISC1   0x2d
#define DPTX0_REG_MSA_COLOUR  0x2e
#define DPTX0_REG_VBID        0x2f
#define DPTX0_REG_CRC_R       0x30
#define DPTX0_REG_CRC_G       0x31
#define DPTX0_REG_CRC_B       0x32
#define DPTX0_REG_AUD_CONTROL 0x33

#define DPTX1_REG_MSA_MVID    0x40
#define DPTX1_REG_MSA_NVID    0x41
#define DPTX1_REG_MSA_HTOTAL  0x42
#define DPTX1_REG_MSA_VTOTAL  0x43
#define DPTX1_REG_MSA_HSP     0x44
#define DPTX1_REG_MSA_HSW     0x45
#define DPTX1_REG_MSA_HSTART  0x46
#define DPTX1_REG_MSA_VSTART  0x47
#define DPTX1_REG_MSA_VSP     0x48
#define DPTX1_REG_MSA_VSW     0x49
#define DPTX1_REG_MSA_HWIDTH  0x4a
#define DPTX1_REG_MSA_VHEIGHT 0x4b
#define DPTX1_REG_MSA_MISC0   0x4c
#define DPTX1_REG_MSA_MISC1   0x4d
#define DPTX1_REG_MSA_COLOUR  0x4e
#define DPTX1_REG_VBID        0x4f
#define DPTX1_REG_CRC_R       0x50
#define DPTX1_REG_CRC_G       0x51
#define DPTX1_REG_CRC_B       0x52
#define DPTX1_REG_AUD_CONTROL 0x53

#define DPTX2_REG_MSA_MVID    0x60
#define DPTX2_REG_MSA_NVID    0x61
#define DPTX2_REG_MSA_HTOTAL  0x62
#define DPTX2_REG_MSA_VTOTAL  0x63
#define DPTX2_REG_MSA_HSP     0x64
#define DPTX2_REG_MSA_HSW     0x65
#define DPTX2_REG_MSA_HSTART  0x66
#define DPTX2_REG_MSA_VSTART  0x67
#define DPTX2_REG_MSA_VSP     0x68
#define DPTX2_REG_MSA_VSW     0x69
#define DPTX2_REG_MSA_HWIDTH  0x6a
#define DPTX2_REG_MSA_VHEIGHT 0x6b
#define DPTX2_REG_MSA_MISC0   0x6c
#define DPTX2_REG_MSA_MISC1   0x6d
#define DPTX2_REG_MSA_COLOUR  0x6e
#define DPTX2_REG_VBID        0x6f
#define DPTX2_REG_CRC_R       0x70
#define DPTX2_REG_CRC_G       0x71
#define DPTX2_REG_CRC_B       0x72
#define DPTX2_REG_AUD_CONTROL 0x73

#define DPTX3_REG_MSA_MVID    0x80
#define DPTX3_REG_MSA_NVID    0x81
#define DPTX3_REG_MSA_HTOTAL  0x82
#define DPTX3_REG_MSA_VTOTAL  0x83
#define DPTX3_REG_MSA_HSP     0x84
#define DPTX3_REG_MSA_HSW     0x85
#define DPTX3_REG_MSA_HSTART  0x86
#define DPTX3_REG_MSA_VSTART  0x87
#define DPTX3_REG_MSA_VSP     0x88
#define DPTX3_REG_MSA_VSW     0x89
#define DPTX3_REG_MSA_HWIDTH  0x8a
#define DPTX3_REG_MSA_VHEIGHT 0x8b
#define DPTX3_REG_MSA_MISC0   0x8c
#define DPTX3_REG_MSA_MISC1   0x8d
#define DPTX3_REG_MSA_COLOUR  0x8e
#define DPTX3_REG_VBID        0x8f
#define DPTX3_REG_CRC_R       0x90
#define DPTX3_REG_CRC_G       0x91
#define DPTX3_REG_CRC_B       0x92
#define DPTX3_REG_AUD_CONTROL 0x93

#define DPTX_REG_MST_CONTROL1 0xa0
#define DPTX_REG_MST_VCPTAB0  0xa2
#define DPTX_REG_MST_VCPTAB1  0xa3
#define DPTX_REG_MST_VCPTAB2  0xa4
#define DPTX_REG_MST_VCPTAB3  0xa5
#define DPTX_REG_MST_VCPTAB4  0xa6
#define DPTX_REG_MST_VCPTAB5  0xa7
#define DPTX_REG_MST_VCPTAB6  0xa8
#define DPTX_REG_MST_VCPTAB7  0xa9
#define DPTX_REG_MST_TAVG_TS  0xaa
#define DPTX_REG_MST_ECF0     0xab
#define DPTX_REG_MST_ECF1     0xac

#define DPTX_REG_AUX_CONTROL  0x100
#define DPTX_REG_AUX_COMMAND  0x101
#define DPTX_REG_AUX_BYTE0    0x102
#define DPTX_REG_AUX_BYTE1    0x103
#define DPTX_REG_AUX_BYTE2    0x104
#define DPTX_REG_AUX_BYTE3    0x105
#define DPTX_REG_AUX_BYTE4    0x106
#define DPTX_REG_AUX_BYTE5    0x107
#define DPTX_REG_AUX_BYTE6    0x108
#define DPTX_REG_AUX_BYTE7    0x109
#define DPTX_REG_AUX_BYTE8    0x10a
#define DPTX_REG_AUX_BYTE9    0x10b
#define DPTX_REG_AUX_BYTE10   0x10c
#define DPTX_REG_AUX_BYTE11   0x10d
#define DPTX_REG_AUX_BYTE12   0x10e
#define DPTX_REG_AUX_BYTE13   0x10f
#define DPTX_REG_AUX_BYTE14   0x110
#define DPTX_REG_AUX_BYTE15   0x111
#define DPTX_REG_AUX_BYTE16   0x112
#define DPTX_REG_AUX_BYTE17   0x113
#define DPTX_REG_AUX_BYTE18   0x114
#define DPTX_REG_AUX_RESET    0x117

#define DPTX_REG_HDCP1_CONTROL  0x180
#define DPTX_REG_HDCP1_STATUS   0x181
#define DPTX_REG_HDCP1_R0       0x182
#define DPTX_REG_HDCP1_BKSV0    0x183
#define DPTX_REG_HDCP1_BKSV1    0x184
#define DPTX_REG_HDCP1_AKSV0    0x185
#define DPTX_REG_HDCP1_AKSV1    0x186
#define DPTX_REG_HDCP1_AN0      0x187
#define DPTX_REG_HDCP1_AN1      0x188
#define DPTX_REG_HDCP1_V0       0x189
#define DPTX_REG_HDCP1_V1       0x18a
#define DPTX_REG_HDCP1_V2       0x18b
#define DPTX_REG_HDCP1_V3       0x18c
#define DPTX_REG_HDCP1_V4       0x18d
#define DPTX_REG_HDCP1_BINFO    0x18e
#define DPTX_REG_HDCP1_KSV_RES  0x190
#define DPTX_REG_HDCP1_KSVFIFO  0x193

#define DPTX_REG_HDCP2_CONTROL     0x1c0
#define DPTX_REG_HDCP2_STATUS      0x1c1
#define DPTX_REG_HDCP2_TXCAPS      0x1c2
#define DPTX_REG_HDCP2_RXCAPS      0x1c3
#define DPTX_REG_HDCP2_RTX0        0x1c4
#define DPTX_REG_HDCP2_RTX1        0x1c5
#define DPTX_REG_HDCP2_RRX0        0x1c6
#define DPTX_REG_HDCP2_RRX1        0x1c7
#define DPTX_REG_HDCP2_RSA_CMD     0x1c8
#define DPTX_REG_HDCP2_RSA_STATUS  0x1c9
#define DPTX_REG_HDCP2_RSA_FIFO    0x1ca
#define DPTX_REG_HDCP2_SRAND       0x1cb
#define DPTX_REG_HDCP2_RN0         0x1cc
#define DPTX_REG_HDCP2_RN1         0x1cd
#define DPTX_REG_HDCP2_RIV0        0x1ce
#define DPTX_REG_HDCP2_RIV1        0x1cf
#define DPTX_REG_HDCP2_HPCMP       0x1d0
#define DPTX_REG_HDCP2_LPCMP       0x1d1
#define DPTX_REG_HDCP2_VPCMP       0x1d2
#define DPTX_REG_HDCP2_MPCMP       0x1d3
#define DPTX_REG_HDCP2_EKS         0x1d4
#define DPTX_REG_HDCP2_HMAC        0x1d5


