/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void check_handshaking_gpu(int * strongNeighbor, int * matches, int numNodes) {
	int numThreads = blockDim.x * gridDim.x;
	int tid = threadIdx.x + (blockIdx.x * blockDim.x);

	// If 19 nodes & 9 threads, each thread gets 3
	int nodesPerThread = (int)((double)(numNodes / numThreads) + 1);

	// If more threads than nodes, make some idled threads
	if (nodesPerThread == 0) {
		nodesPerThread = 1;
	}

	// Calculate start and end nodes for this thread
	int i = tid * nodesPerThread;
	int max = i + nodesPerThread;
	if (max > numNodes) {
		max = numNodes;
	}

	// Iterate through select nodes
	while (i < max) {
		// If already matched
		if (matches[i] > -1) {
			continue;
		}

		// Get i's strongNeighbor, j
		int j = strongNeighbor[i];
		// If j's strongNeighbor is i
		if (strongNeighbor[j] == i) {
			matches[i] = j;
			// we have a synchronization problem here
			// another thread may do this at same time
			// wastes GPU, no memory issues
			matches[j] = i;
		}
	}

	return;
}
