#define DEBUG_MODE 0

#include <stdio.h>
#include <io.h>
#include <system.h>

#include "vip_func.h"

//---------------Functions for Video IP blocks------------------------------

void SET_VIDEO_MODE (int i)
{
   int res_settings[5][19] = {
        // int, sam_cn, f0_lcn, f1_lcn, h_fr, h_syn, h_blk, v_fr, v_syn, v_blk, f0_vfr, f0_vsyn, f0_vblk, ap_ln, f0_vrise, f_rise, f_fall, anc_ln, f0_ancln
		   {0,    640,    480,     0,    16,   96,    160,   10,    2,     45,    0,      0,        0,     0,      0,        0,      0,     0,      0},  // 640x480p60
		   {0,    720,    480,     0,    16,   62,    138,   9,     6,     45,    0,      0,        0,     0,      0,        0,      0,     0,      0},  // 720x480p60
		   {0,   1280,    720,     0,    110,  40,    370,   5,     5,     30,    0,      0,        0,     26,     0,        0,      0,     10,     0},  // 1280x720p60
		   {0,   1920,   1080,     0,    88,   44,    280,   4,     5,     45,    0,      0,        0,     42,     0,        0,      0,     10,     0},  // 1920x1080p60
		   {0,   3840,   2160,     0,   1276,  88,   1660,   8,    10,     90,    0,      0,        0,     84,     0,        0,      0,     20,     0}   // 3840x2160p24
   };


   IOWR(ALT_VIP_CL_CVO_0_BASE, 4, 1);
   IOWR(ALT_VIP_CL_CVO_0_BASE, 30, 0); // Invalidate the mode bank

   IOWR(ALT_VIP_CL_CVO_0_BASE, 5 , res_settings[i][0]); // ModeX Control - Interlaced Bit
   IOWR(ALT_VIP_CL_CVO_0_BASE, 6 , res_settings[i][1]); // Mode N Sample Count
   IOWR(ALT_VIP_CL_CVO_0_BASE, 7 , res_settings[i][2]); // Mode N F0 Line Count
   IOWR(ALT_VIP_CL_CVO_0_BASE, 8 , res_settings[i][3]); // Mode N F1 Line Count
   IOWR(ALT_VIP_CL_CVO_0_BASE, 9 , res_settings[i][4]); // Mode N Horizontal Front Porch
   IOWR(ALT_VIP_CL_CVO_0_BASE, 10, res_settings[i][5]); // Mode N Horizontal Sync Length
   IOWR(ALT_VIP_CL_CVO_0_BASE, 11, res_settings[i][6]); // Mode N Horizontal Blanking
   IOWR(ALT_VIP_CL_CVO_0_BASE, 12, res_settings[i][7]); // Mode N Vertical Front Porch
   IOWR(ALT_VIP_CL_CVO_0_BASE, 13, res_settings[i][8]); // Mode N Vertical Sync Length
   IOWR(ALT_VIP_CL_CVO_0_BASE, 14, res_settings[i][9]); // Mode N Vertical Blanking
   IOWR(ALT_VIP_CL_CVO_0_BASE, 15, res_settings[i][10]); // Mode N F0 Vertical Front Porch
   IOWR(ALT_VIP_CL_CVO_0_BASE, 16, res_settings[i][11]); // Mode N F0 Vertical Sync Length
   IOWR(ALT_VIP_CL_CVO_0_BASE, 17, res_settings[i][12]); // Mode N F0 Vertical Blanking
   IOWR(ALT_VIP_CL_CVO_0_BASE, 18, res_settings[i][13]); // Mode N Active Picture Line
   IOWR(ALT_VIP_CL_CVO_0_BASE, 19, res_settings[i][14]); // Mode N F0 Vertical Rising
   IOWR(ALT_VIP_CL_CVO_0_BASE, 20, res_settings[i][15]); // Mode N Field Rising
   IOWR(ALT_VIP_CL_CVO_0_BASE, 21, res_settings[i][16]); // Mode N Field Falling
   IOWR(ALT_VIP_CL_CVO_0_BASE, 26, res_settings[i][17]); // Mode N Ancillary Line
   IOWR(ALT_VIP_CL_CVO_0_BASE, 27, res_settings[i][18]); // Mode N F0 Ancillary Line

   IOWR(ALT_VIP_CL_CVO_0_BASE, 22, 0); // Mode N Standard
   IOWR(ALT_VIP_CL_CVO_0_BASE, 23, 0); // Mode N SOF Sample
   IOWR(ALT_VIP_CL_CVO_0_BASE, 24, 0); // Mode N SOF Line
   IOWR(ALT_VIP_CL_CVO_0_BASE, 25, 0); // Mode N Vcoclk Divider

   IOWR(ALT_VIP_CL_CVO_0_BASE, 28, 1); // Mode N H-Sync Polarity
   IOWR(ALT_VIP_CL_CVO_0_BASE, 29, 1); // Mode N V-Sync Polarity
   IOWR(ALT_VIP_CL_CVO_0_BASE, 30, 1); // Validate the mode bank
}

void RECONFIG_CVO (int width, int height)
{
    int encode_value;
	//if (DEBUG_MODE) printf("CVI detects F1 active line %d\n", IORD(ALT_VIP_CL_CVI_0_BASE, 6));
	//if (DEBUG_MODE) printf("CVI detects F1 total line %d\n", IORD(ALT_VIP_CL_CVI_0_BASE, 9));
    if (DEBUG_MODE) printf("Htotal x Vtotal = %d x %d\n", width, height);

    // The encode_value here is with respect to the line number of res_settings array in SET_VIDEO_MODE function.
    switch (width) {
    case 800: // 640x480p60
    	encode_value = 0;
    	break;

    case 858 : // 720x480p60
    	encode_value = 1;
    	break;

    case 1650 : // 1280x720p60
    	encode_value = 2;
    	break;

    case 2200 : // 1920x1080p60
    	encode_value = 3;
        break;

    case 5500: // 3840x2160p24
    	encode_value = 4;
    	break;

    default :
    	encode_value = 3;
    	break;
    }

    if (DEBUG_MODE) printf("CVO encode = %d\n", encode_value);
    SET_VIDEO_MODE(encode_value);
}


void CVI_DETECT ()
{
    int cvi_status_reg;
    int cvi_interrupts;

    cvi_status_reg = IORD(ALT_VIP_CL_CVI_0_BASE, 1);
    cvi_interrupts = IORD(ALT_VIP_CL_CVI_0_BASE, 2);

    if (cvi_interrupts != 0) {
        switch (cvi_interrupts) {
            case 2 :
                // Status update only
    	        if ((cvi_status_reg & (0x01<<9)) != 0) {
    	        	if (DEBUG_MODE) printf("Overflow detected; Clearing sticky bit\n");
    	            IOWR(ALT_VIP_CL_CVI_0_BASE, 1, (cvi_status_reg));
    	        }
    	        if (DEBUG_MODE) printf("Exiting  CVI status update;\n");
                IOWR(ALT_VIP_CL_CVI_0_BASE, 2, 2); // Clear interrupt
                break;

            case 4 :
                // End of frame
                //printf("Clearing EOF interrupt\n");
                IOWR(ALT_VIP_CL_CVI_0_BASE, 2, 4); // Clear interrupt
                break;

            case 6 :
                // End of frame and status update
    	        if ((cvi_status_reg & (0x01<<9)) != 0) {
    	        	if (DEBUG_MODE) printf("Overflow detected; Clearing sticky bit\n");
    	            IOWR(ALT_VIP_CL_CVI_0_BASE, 1, (cvi_status_reg));
    	        }
    	        if (DEBUG_MODE) printf("Exiting CVI status update; (End of frame)\n");
                IOWR(ALT_VIP_CL_CVI_0_BASE, 2, 6); // Clear interrupts
                break;

            default :
                IOWR(ALT_VIP_CL_CVI_0_BASE, 2, 6); // Clear interrupts
                break;
        }
    }
}
