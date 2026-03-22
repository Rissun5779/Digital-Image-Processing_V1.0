#include <stdio.h>
#include <stdint.h>
#include <system.h>
#include <unistd.h>
#include <io.h>
// Memory Map
#define LED_REG  (*(volatile uint32_t*)PIO_LED_BASE)
#define HEX0_REG (*(volatile uint32_t*)PIO_HEX_0_BASE)
#define HEX1_REG (*(volatile uint32_t*)PIO_HEX_1_BASE)
#define HEX2_REG (*(volatile uint32_t*)PIO_HEX_2_BASE)
#define HEX3_REG (*(volatile uint32_t*)PIO_HEX_3_BASE)
// VAR
#define ms		 		   1000

/****************
HEX_TBL(A-F)=>
   A: 000_1000
   B: 000_0011
   C: 100_0110
   D: 010_0001
   E: 000_0110
   F: 000_1110
 *****************/
unsigned char HEX_TBL[16]={
  0XC0, 0XF9, 0XA4, 0XB0, 0X99,
  0X92, 0X82, 0XF8, 0X80, 0X90,
  0x08, 0x03, 0x46, 0x21, 0x06,
  0x0e
};

/*****************
 * Timer Reg Map
 * ------------------
 * 0 | status   | 	      	  1     0
 * 				  	   	 	 run   to
 * 1 | control  | 3     2     1     0
 * 				 stop start cont  ito
 * 2 | periodl  | 15..0
 * 3 | periodh  | 31..16
 * 4 | snapl    | 15..0
 * 5 | snaph    | 31..16
 *
 *****************/

typedef struct{
	volatile uint32_t status;
	volatile uint32_t control;
	volatile uint32_t periodl;
	volatile uint32_t periodh;
	volatile uint32_t snapl;
	volatile uint32_t snaph;
}timer_reg;
#define TIMER ((timer_reg*)SYS_CLK_TIMER_BASE)
#define Lab2
#define LOOP 1000000
volatile uint32_t dummy;  // 全域變數
void Task(){
	uint32_t sum = 0;
	for(uint32_t i=0;i<LOOP;++i){
		sum += i;
	}
	dummy = sum;
}

int main()
{
#if defined(Lab1)
	int i = 0;

	// Set timer for 1 second
	TIMER->periodl = (uint16_t)(SYS_CLK_TIMER_FREQ & 0xFFFF);
	TIMER->periodh = (uint16_t)((SYS_CLK_TIMER_FREQ>>16) & 0xFFFF);
	// Set timer running
	TIMER->control = 0x06;

	while(1)
    {
		if(TIMER->status & 0x01)
		{
			TIMER->status = 0;

			printf("A second passed! it time %d \n", i);
			if(i<=0xFF){
			    LED_REG  = (uint32_t)i;
			    HEX0_REG = HEX_TBL[i%10];
			    HEX1_REG = HEX_TBL[(i%100)/10];
			    HEX2_REG = HEX_TBL[(i%1000)/100];
			  	HEX3_REG = HEX_TBL[(i%1000)/1000];
			}else{
			    i = 0;
			}
			i++;
		 }
    }
#elif defined(Lab2)
	TIMER->periodl = 0xFFFF;
	TIMER->periodh = 0xFFFF;
	TIMER->control = 0x06;

	// 量測 start
	TIMER->snapl = 0;
	uint32_t sl = TIMER->snapl;
	uint32_t sh = TIMER->snaph;
	uint32_t start = (sh << 16) | sl;
	printf("periodl: %lu\n", TIMER->periodl);

	Task();

	// 量測 end
	TIMER->snapl = 0;
	uint32_t el = TIMER->snapl;
	uint32_t eh = TIMER->snaph;
	uint32_t end = (eh << 16) | el;
	printf("periodh: %lu\n", TIMER->periodh);

	uint32_t cycles = start - end;  // down counter
	uint32_t instr_count = LOOP * 3;
	float cpi = (float)cycles / instr_count;

	printf("Cycles: %lu\n", cycles);
	printf("Instruction count: %lu\n", instr_count);
	printf("CPI: %.2f\n", cpi);
#endif
    return 0;
}
