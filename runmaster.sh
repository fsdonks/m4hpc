#!/bin/bash
JAR="m4-2.23.jar"
MEM="200g"

#launch m4 in peer mode
#we expect a ~/hazelcast.edn file
#configured to read/write to ~/registry
#for cluster discovery.

#If we have anything different we
#want to do on the master node,
#like providing a script to run
#we can do it here.

#We might want to load a script that
#does all our analysis and kills the cluster.
#In that case, we could use a different invocation
#like

#java -Xmx$MEM -jar $JAR main the-script.clj

#For now, we facilitate interactive use.
java -Xmx$MEM -jar $JAR peer
