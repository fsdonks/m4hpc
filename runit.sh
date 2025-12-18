#!/bin/bash
#we clean up our peer registry
rm ~/registry/*.*
#then kick off our interactive job submission
qsub -I peers.pbs
