#!/bin/bash
JAR="m4-2.23.jar"
MEM="200g"

#launch m4 in peer mode
#we expect a ~/hazelcast.edn file
#configured to read/write to ~/registry
#for cluster discovery.
java -Xmx$MEM -jar $JAR peer
