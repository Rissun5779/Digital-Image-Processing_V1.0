#include <stdio.h>
#include <unistd.h>

void looper(){
	for(int i=0;i<1000;++i){
		printf("Hello world, now is %d...\n", i);
	}
}

int main(){
	looper();
	usleep(100*1000);
	printf("End the Nios V world!\n");
	fflush(stdout);
	return 0;
}
