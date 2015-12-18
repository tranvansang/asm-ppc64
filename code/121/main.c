#define nmax (1 << 19)
#define vmax ((1ll<<31) -1)
#define n_run nmax
#define run_count 1000

#define VERBOSE_DETAIL 0
#define STOP_IF_SORT_FAILED 1
//print array when sort failed or not
#define DEBUG_ON 0

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
extern qsort_asm(int* low, int *high);

void generate(int *array, int n){
	srand((unsigned int)(time(NULL)));
	while(n--)
		array[n] = rand()%vmax;
}

unsigned long long int gettime(struct timeval start, struct timeval stop){
	return (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec;
}

int is_equal(int *a, int *b, int n){
	while(n--)
		if (a[n] != b[n])
			return 0;
	
	return 1;
}

static int compar(const void * px, const void * py){
	int x = *((int*)px);
	int y = *((int*)py);
	return x < y ? -1 : x > y ? 1 : 0;
}

void show(int *a, int n){
	int i;
	printf("[");
	for(i = 0; i < n; i++)
		printf("%d%s", a[i], i < n - 1 ? ", " : "");
	puts("]");
}

void test(int *a, int *b, int *c, int n, int times){
	puts("Configuration:");
	printf("\tArray size: %d\n", n);
	printf("\tMax value: %d\n", vmax);
	printf("\tRun count: %d\n", run_count);
	printf("\tVerbose detail: %s\n", VERBOSE_DETAIL ? "yes" : "no");
	printf("\tStop if sort failed: %s\n", STOP_IF_SORT_FAILED ? "yes" : "no");
	printf("\tDebug mode: %s\n", DEBUG_ON ? "yes" : "no");
	puts("");
	unsigned long long int system_time = 0;
	unsigned long long int asm_time = 0;
	struct timeval start, stop;
	unsigned long long int small_time;
	int i;
	VERBOSE_DETAIL && printf("Start test %d times with array'size of %d...\n\n", times, n);
	for(i = 0; i < times; i++){
		VERBOSE_DETAIL && printf("Test No.%02d:\n", i + 1);
		VERBOSE_DETAIL && printf("\tGenerate array...\n");
		generate(a, n);
		memcpy(c, a, n * sizeof(int));
		memcpy(b, a, n * sizeof(int));

		VERBOSE_DETAIL && printf("\tSort by qsort: ");
		gettimeofday(&start, NULL);
		qsort(b, n, sizeof(int), compar);
		gettimeofday(&stop, NULL);
		small_time = gettime(start, stop);
		system_time += small_time;
		VERBOSE_DETAIL && printf("%.3lf (ms)\n", (double)small_time / 1000);

		VERBOSE_DETAIL && printf("\tSort by asm sort: ");
		gettimeofday(&start, NULL);
		qsort_asm(c + 0, c + n -1);
		gettimeofday(&stop, NULL);
		small_time = gettime(start, stop);
		asm_time += small_time;
		VERBOSE_DETAIL && printf("%.3lf (ms)\n", (double)small_time / 1000);

		//test
		VERBOSE_DETAIL && printf("\tTest result... ");
		if (is_equal(b, c, n))
			VERBOSE_DETAIL && printf("OK\n\n");
		else{
			if (DEBUG_ON){
				if (VERBOSE_DETAIL)
					printf("FAILED\n\n");
				printf("DEBUG: Original array, system sort, asm sort:\n");
				show(a, n);
				show(b, n);
				show(c, n);
			}else if (VERBOSE_DETAIL)
				printf("FAILED\n\n");
			if (STOP_IF_SORT_FAILED){
				VERBOSE_DETAIL && printf("Sort failed at test number %d. Stop now!\n", i);
				break;
			}
		}
	}
	printf("\nTotal time by system qsort: %.3lf (ms)\n", (double)system_time / 1000);
	printf("Total time by asm sort: %.3lf (ms)\n", (double)asm_time / 1000);
}

int main(){
	int a[nmax], b[nmax], c[nmax];
	test(a, b, c, n_run, run_count);
	return 0;
}
