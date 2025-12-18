#!/bin/bash

#We invoke this from our root node on an interactive session. From there, we get
#n ssh sessions with remote peers setup, then have our master node running on a
#Clojure repl. All peers should autoregister and discover eachother (hazelcast
#will log cluster activity early on).

#This allows us to have a simple interactive M4 cluster within a PBS job, which
#mimics exactly our on-premises workflow.

echo "LAUNCHING"
#we have to recompute the node_list.txt file since it's not technically
#available on the peers and only existed during PBS job construction time.
cat $PBS_NODEFILE | sort -u > node_list.txt
#Now the master node knows about the other nodes. Count the number of nodes.
NNODES=$(cat node_list.txt | wc -l)
HNAME=$(hostname)

#Collect a file of nodes that are not us.
grep -v $HNAME node_list.txt | sort -u > others.txt

NOTHERS=$NNODES-1

echo "Launching from Host $HNAME"

#Traverse each node in others, and kick off a M4 peer node.
for ((i=1; i<=$NOTHERS;i++))
   do
       MYNODE=$(sed "${i}q;d" others.txt)
       echo "launching peer $MYNODE"
       ssh $MYNODE ./runpeer.sh &
   done

#Synchronously launch a clojure peer from this (the master) node and expose to
#the user. This will drop the user's ssh session into an interactive clojure
#REPL in the m4peer namespace, with clustering enabled.

#We can process all kinds of workflows, including predefined TAA analyses, or
#ad-hoc general purpose computation, or just live-code the cluster. clojure +
#hazelcast allows for dynamic recompilation across the cluster, so we can define
#new functions, load scripts, etc. and have them available for distributed
#workflows pretty seamlessly.

#When we are done, we can tell all the peers (of which the master node is one)
#to shutdown via

#(hazeldemo.client/eval-all! '(System/exit 0))
#We'll include simpler "tear down" hooks in the future as part of the api.
#In the worst case, we can nuke the job from our login node using qdel.
./runmaster.sh
