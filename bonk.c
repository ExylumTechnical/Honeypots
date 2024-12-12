#include <stdio.h>
#include <time.h>
#include <stdlib.h>


int main(){
	srand(time(NULL));
	for(int x=0; x<100;x++) {
		printf("\nSRDS: ");
		for(int y=0; y<100000; y++){
			int r = rand();
			printf("%x",r);
//			printf("0x00");
		};
	};
	printf("\n");
}
