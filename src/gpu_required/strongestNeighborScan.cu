/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

// http://users.wfu.edu/choss/CUDA/docs/Lecture%205.pdf

__global__ void strongestNeighborScan_gpu
(
	int * src, 
	int * oldDst, int * newDst, 
	int * oldWeight, int * newWeight, 
	int * madeChanges, int distance, int numEdges
) {
	int numThreads = blockDim.x * gridDim.x;
	int tid = threadIdx.x + (blockIdx.x * blockDim.x);

	// If 19 edges & 9 threads, each thread gets 3
	int edgesPerThread = (int)((double)(numEdges / numThreads) + 1);

	// If more threads than edges, make some idled threads
	if (edgesPerThread == 0) {
		edgesPerThread = 1;
	}

	// Calculate start and end edge for this thread
	int i = tid * edgesPerThread;
	int max = i + edgesPerThread;
	if (max > numEdges) {
		max = numEdges;
	}

	// Iterate through each edge
	while (i < max) {
		// if L is unavailable
		if (i - distance < 0 || src[i] != src[i-distance]) {
			goto rBigger;
		}

		// if R is bigger
		if (oldWeight[i] > oldWeight[i-distance]) {
			goto rBigger;
		}

		/* goto locations */
		/*lBigger:*/ // if oldDst[i-distance] is larger
			newDst[i] = oldDst[i-distance];
			newWeight[i] = oldWeight[i-distance];
			*madeChanges = 1;
			++i;
			continue;

		rBigger: // if oldDst[i] is larger
			newDst[i] = oldDst[i];
			newWeight[i] = oldWeight[i];
			++i;
			continue;
	}

	return;
}
