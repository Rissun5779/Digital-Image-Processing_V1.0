// INC
#include <stdio.h>
#include <unistd.h>
#include "system.h"
// DEFINE
#define LED_REG (*(volatile uint32_t*) PIO_LED_BASE)

#define ms 1000
// MAIN
int main(){
  int8_t i=0x01;
  while(1){
    LED_REG = i;
    i <<= 1;
    usleep(100*ms);
  }
  return 0;
}
