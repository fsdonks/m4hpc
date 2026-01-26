#!bin/bash
export MEM=4g
export M4JAR=~/m4hpc/m4-2.25.jar
export PLANPATH=~/m4hpc/jobarray/small-planAP.edn
export PBS_ARRAY_INDEX=0

java -XX:+UseParallelGC -Xmx$MEM -jar $M4JAR clojure.main demo.clj