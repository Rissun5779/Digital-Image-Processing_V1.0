/*
 * functions.h
 */

#ifndef __ALT_JESD204B_ED_FUNCTIONS_H__
#define __ALT_JESD204B_ED_FUNCTIONS_H__

#include "alt_types.h"

int StringIsNumeric (char *);
void DelayCounter(alt_u32);
int Initialize(char *[][MAX_OPTIONS_CHAR], int *);
int Status(char *[][MAX_OPTIONS_CHAR]);
int Loopback (char *[][MAX_OPTIONS_CHAR], int *, int);
int SourceDest (char *[][MAX_OPTIONS_CHAR], int *, int);
int Test(char *[][MAX_OPTIONS_CHAR], int *);
void Sysref(void);
int ResetSeq (int, int *);
int ResetForce (int, int, int, int *);
int Reset_X_L_F_Release (int, int *);
void InitISR (void);

#endif /* __ALT_JESD204B_ED_FUNCTIONS_H__ */