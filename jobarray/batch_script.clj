;;A simplistic script file for HPC scripting on array jobs on
;;PBS or other systems.
(ns taa.batch-script
  (:require [spork.util [io :as io]]
            [taa [core :as core]]))

(defn env [x] (System/getenv x))
;;assuming we're in a PBS job array submission deal.
(def job-index (parse-long (env "PBS_ARRAY_INDEX")))
(def plan      (env "PLANPATH"))
(println [:CURRENT-PLAN plan])

;;just load up a relative file. assuming we're running this from a clojure repl
;;through leiningen in the taa project, the below path is accurate.

;;actual usage needs to change relative to actual path on production system.
(load-file (io/file-path "~/m4hpc/jobarray/batch_test.clj"))
;;alias the namespace we just loaded for convenience.
(require '[taa.batch_test :as batch])
;;an alternate simplified assumption: scripts and data are in the cwd.
#_(load-file "batch_test.clj")

;;perform a run for the "AP" designs.
;;assume we have a run plan path correctly bound to $PLAN:
(defn run-me []
  (core/run-from-plan plan job-index batch/input-map-AP))

;;then we can leverage a bash invocation like ./batch.pbs
