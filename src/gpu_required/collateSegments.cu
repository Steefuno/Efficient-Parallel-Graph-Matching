/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void collateSegments_gpu
(
	int * src, int * scanResult, int * output, int numEdges
) {
	int src_i = 0;
	int output_i = 0;

	// check each in src with next
	while (src_i < numEdges-1) {
		if (src[src_i] != src[src_i+1]) {
			output[output_i++] = scanResult[src_i];
		}
		src_i++;
	}
	// insert last in src
	output[output_i] = scanResult[src_i];

	return;
}
