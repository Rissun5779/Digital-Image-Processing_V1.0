// ********************************************************************************
// DisplayPort Core Sink register map
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
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/software/btc_dprx_syslib/btc_dp_rxregs.h $
//
// Description:
//
// ********************************************************************************

#define DPRX_REG_RX_CONTROL    0x00
#define DPRX_REG_RX_STATUS     0x01
#define DPRX_REG_BER_CONTROL   0x02
#define DPRX_REG_BER_CNT0      0x03
#define DPRX_REG_BER_CNT1      0x04
#define DPRX_REG_TIMESTAMP     0x05
#define DPRX_REG_BER_CNTI0     0x06
#define DPRX_REG_BER_CNTI1     0x07
#define DPRX_REG_RX_VERSION    0x08

#define DPRX_REG_PRE_VOLT0     0x10
#define DPRX_REG_PRE_VOLT1     0x11
#define DPRX_REG_PRE_VOLT2     0x12
#define DPRX_REG_PRE_VOLT3     0x13
#define DPRX_REG_RECONFIG      0x14

#define DPRX0_REG_MSA_MVID     0x20
#define DPRX0_REG_MSA_NVID     0x21
#define DPRX0_REG_MSA_HTOTAL   0x22
#define DPRX0_REG_MSA_VTOTAL   0x23
#define DPRX0_REG_MSA_HSP      0x24
#define DPRX0_REG_MSA_HSW      0x25
#define DPRX0_REG_MSA_HSTART   0x26
#define DPRX0_REG_MSA_VSTART   0x27
#define DPRX0_REG_MSA_VSP      0x28
#define DPRX0_REG_MSA_VSW      0x29
#define DPRX0_REG_MSA_HWIDTH   0x2a
#define DPRX0_REG_MSA_VHEIGHT  0x2b
#define DPRX0_REG_MSA_MISC0    0x2c
#define DPRX0_REG_MSA_MISC1    0x2d
#define DPRX0_REG_MSA_COLOUR   0x2e
#define DPRX0_REG_VBID         0x2f
#define DPRX0_REG_AUD_MAUD     0x30
#define DPRX0_REG_AUD_NAUD     0x31
#define DPRX0_REG_AUD_AIF0     0x32
#define DPRX0_REG_AUD_AIF1     0x33
#define DPRX0_REG_AUD_AIF2     0x34
#define DPRX0_REG_AUD_AIF3     0x35
#define DPRX0_REG_AUD_AIF4     0x36

#define DPRX1_REG_MSA_MVID     0x40
#define DPRX1_REG_MSA_NVID     0x41
#define DPRX1_REG_MSA_HTOTAL   0x42
#define DPRX1_REG_MSA_VTOTAL   0x43
#define DPRX1_REG_MSA_HSP      0x44
#define DPRX1_REG_MSA_HSW      0x45
#define DPRX1_REG_MSA_HSTART   0x46
#define DPRX1_REG_MSA_VSTART   0x47
#define DPRX1_REG_MSA_VSP      0x48
#define DPRX1_REG_MSA_VSW      0x49
#define DPRX1_REG_MSA_HWIDTH   0x4a
#define DPRX1_REG_MSA_VHEIGHT  0x4b
#define DPRX1_REG_MSA_MISC0    0x4c
#define DPRX1_REG_MSA_MISC1    0x4d
#define DPRX1_REG_MSA_COLOUR   0x4e
#define DPRX1_REG_VBID         0x4f
#define DPRX1_REG_AUD_MAUD     0x50
#define DPRX1_REG_AUD_NAUD     0x51
#define DPRX1_REG_AUD_AIF0     0x52
#define DPRX1_REG_AUD_AIF1     0x53
#define DPRX1_REG_AUD_AIF2     0x54
#define DPRX1_REG_AUD_AIF3     0x55
#define DPRX1_REG_AUD_AIF4     0x56

#define DPRX2_REG_MSA_MVID     0x60
#define DPRX2_REG_MSA_NVID     0x61
#define DPRX2_REG_MSA_HTOTAL   0x62
#define DPRX2_REG_MSA_VTOTAL   0x63
#define DPRX2_REG_MSA_HSP      0x64
#define DPRX2_REG_MSA_HSW      0x65
#define DPRX2_REG_MSA_HSTART   0x66
#define DPRX2_REG_MSA_VSTART   0x67
#define DPRX2_REG_MSA_VSP      0x68
#define DPRX2_REG_MSA_VSW      0x69
#define DPRX2_REG_MSA_HWIDTH   0x6a
#define DPRX2_REG_MSA_VHEIGHT  0x6b
#define DPRX2_REG_MSA_MISC0    0x6c
#define DPRX2_REG_MSA_MISC1    0x6d
#define DPRX2_REG_MSA_COLOUR   0x6e
#define DPRX2_REG_VBID         0x6f
#define DPRX2_REG_AUD_MAUD     0x70
#define DPRX2_REG_AUD_NAUD     0x71
#define DPRX2_REG_AUD_AIF0     0x72
#define DPRX2_REG_AUD_AIF1     0x73
#define DPRX2_REG_AUD_AIF2     0x74
#define DPRX2_REG_AUD_AIF3     0x75
#define DPRX2_REG_AUD_AIF4     0x76

#define DPRX3_REG_MSA_MVID     0x80
#define DPRX3_REG_MSA_NVID     0x81
#define DPRX3_REG_MSA_HTOTAL   0x82
#define DPRX3_REG_MSA_VTOTAL   0x83
#define DPRX3_REG_MSA_HSP      0x84
#define DPRX3_REG_MSA_HSW      0x85
#define DPRX3_REG_MSA_HSTART   0x86
#define DPRX3_REG_MSA_VSTART   0x87
#define DPRX3_REG_MSA_VSP      0x88
#define DPRX3_REG_MSA_VSW      0x89
#define DPRX3_REG_MSA_HWIDTH   0x8a
#define DPRX3_REG_MSA_VHEIGHT  0x8b
#define DPRX3_REG_MSA_MISC0    0x8c
#define DPRX3_REG_MSA_MISC1    0x8d
#define DPRX3_REG_MSA_COLOUR   0x8e
#define DPRX3_REG_VBID         0x8f
#define DPRX3_REG_AUD_MAUD     0x90
#define DPRX3_REG_AUD_NAUD     0x91
#define DPRX3_REG_AUD_AIF0     0x92
#define DPRX3_REG_AUD_AIF1     0x93
#define DPRX3_REG_AUD_AIF2     0x94
#define DPRX3_REG_AUD_AIF3     0x95
#define DPRX3_REG_AUD_AIF4     0x96

#define DPRX_REG_MST_CONTROL1  0xa0
#define DPRX_REG_MST_STATUS1   0xa1
#define DPRX_REG_MST_VCPTAB0   0xa2
#define DPRX_REG_MST_VCPTAB1   0xa3
#define DPRX_REG_MST_VCPTAB2   0xa4
#define DPRX_REG_MST_VCPTAB3   0xa5
#define DPRX_REG_MST_VCPTAB4   0xa6
#define DPRX_REG_MST_VCPTAB5   0xa7
#define DPRX_REG_MST_VCPTAB6   0xa8
#define DPRX_REG_MST_VCPTAB7   0xa9

#define DPRX_REG_LPM_CONTROL   0xc0
#define DPRX_REG_LPM_STATUS    0xc1
#define DPRX_REG_LPM_GAIN      0xc2

#define DPRX_REG_AUX_CONTROL  0x100
#define DPRX_REG_AUX_STATUS   0x101
#define DPRX_REG_AUX_COMMAND  0x102
#define DPRX_REG_AUX_BYTE0    0x103
#define DPRX_REG_AUX_BYTE1    0x104
#define DPRX_REG_AUX_BYTE2    0x105
#define DPRX_REG_AUX_BYTE3    0x106
#define DPRX_REG_AUX_BYTE4    0x107
#define DPRX_REG_AUX_BYTE5    0x108
#define DPRX_REG_AUX_BYTE6    0x109
#define DPRX_REG_AUX_BYTE7    0x10a
#define DPRX_REG_AUX_BYTE8    0x10b
#define DPRX_REG_AUX_BYTE9    0x10c
#define DPRX_REG_AUX_BYTE10   0x10d
#define DPRX_REG_AUX_BYTE11   0x10e
#define DPRX_REG_AUX_BYTE12   0x10f
#define DPRX_REG_AUX_BYTE13   0x110
#define DPRX_REG_AUX_BYTE14   0x111
#define DPRX_REG_AUX_BYTE15   0x112
#define DPRX_REG_AUX_BYTE16   0x113
#define DPRX_REG_AUX_BYTE17   0x114
#define DPRX_REG_AUX_BYTE18   0x115
#define DPRX_REG_AUX_I2C0     0x116
#define DPRX_REG_AUX_I2C1     0x117
#define DPRX_REG_AUX_RESET    0x118
#define DPRX_REG_HPD          0x119

#define DPRX0_REG_CRC_R       0x120
#define DPRX0_REG_CRC_G       0x121
#define DPRX0_REG_CRC_B       0x122
#define DPRX1_REG_CRC_R       0x123
#define DPRX1_REG_CRC_G       0x124
#define DPRX1_REG_CRC_B       0x125

#define DPRX_REG_HDCP1_CONTROL  0x180
#define DPRX_REG_HDCP1_STATUS   0x181
#define DPRX_REG_HDCP1_R0       0x182
#define DPRX_REG_HDCP1_BKSV0    0x183
#define DPRX_REG_HDCP1_BKSV1    0x184
#define DPRX_REG_HDCP1_AKSV0    0x185
#define DPRX_REG_HDCP1_AKSV1    0x186
#define DPRX_REG_HDCP1_AN0      0x187
#define DPRX_REG_HDCP1_AN1      0x188
#define DPRX_REG_HDCP1_V0       0x189
#define DPRX_REG_HDCP1_V1       0x18a
#define DPRX_REG_HDCP1_V2       0x18b
#define DPRX_REG_HDCP1_V3       0x18c
#define DPRX_REG_HDCP1_V4       0x18d

#define DPRX_REG_HDCP2_CONTROL   0x1c0
#define DPRX_REG_HDCP2_STATUS    0x1c1
#define DPRX_REG_HDCP2_MSGDATA   0x1c2
#define DPRX_REG_HDCP2_RXCAPS    0x1c3
