// INC
#include <stdio.h>
#include <unistd.h>
#include "system.h"
// DEFINE
#define LED_REG (*(volatile uint32_t*) PIO_LED_BASE)

#define ms 1000
// MAIN
int main(){
  uint8_t i=0x01;
  while(1){
    while(LED_REG!=0xFF){
      LED_REG = i;
      usleep(500*ms);
      i = (i<<1)+0x01;
    }

    while(LED_REG!=0x01){
      LED_REG = i;
      usleep(500*ms);
      i>>=1;
    }
    i = 0x80;
    while(i!=0xFF){
      LED_REG = i;
      usleep(500*ms);
      i = (i>>1)+0x80;
    }
  }
  return 0;
}