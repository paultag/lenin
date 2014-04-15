(require marx.language)
(import [lenin.kwzip [group-map keyword?]])


(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defmacro job [&rest forms]
  (define [[data (group-map keyword? forms)]
           [exit-code (get (:returns data) 0)]
           [binds (list-comp (HyString (.join ":" x)) [x (:volumes data)])]]

    `(run-every ~@(:every data)
      (disown
        ; fork job to the async queue
        (define [[containers docker.containers]
                 [container (go (.create containers {
                   "Cmd" [~@(:run data)]
                   "Image" ~@(:image data)
                   "AttachStdin" false
                   "AttachStdout" true
                   "AttachStderr" true
                   "WorkingDir" ~@(:workdir data)
                   "Tty" false
                   "OpenStdin" false
                   "StdinOnce" false}))]
                 [instance (go (.start container {
                   "Binds" [~@binds]
                 }))]]
          (go-setv info (.show container))
          (print "Started" (get info "Name"))
          (go (.wait container))
          (go-setv info (.show container))
          ; handle results.
          (if (= (int (-> info (get "State") (get "ExitCode")))
                 (int ~exit-code))
            (print "OK Run" (get info "Name"))
            (print "Failed run" (get info "Name")))
          (go (.delete container)))))))


(defmacro lenin [&rest body]
  `(marx ~@body))
