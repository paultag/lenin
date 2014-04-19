(require marx.language)
(import asyncio [lenin.kwzip [group-map keyword?]])

(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defn one [default args]
  (cond
    [(= (len args) 0) default]
    [(= (len args) 1) (get args 0)]
    [true (raise (TypeError "Too many args passed in."))]))


(defmacro daemon-run [&rest forms]
  (define [[data (group-map keyword? forms)]
           [name (one nil (:name data))]
           [binds (list-comp (HyString (.join ":" x)) [x (:volumes data)])]
           [image (one `"debian:unstable" (:image data))]]

    `(define [[container (go (.create-or-replace
                              docker.containers
                              ~name
                              {"Cmd" [~@(:run data)]
                               "Image" ~image
                               "AttachStdin" false
                               "AttachStdout" true
                               "AttachStderr" true
                               "Tty" false
                               "OpenStdin" false
                               "StdinOnce" false}))]]

      (print "Starting container")
      (go (.start container {"Binds" [~@binds]}))
      (print "Started container")
      (go (.wait container))
      (print "OMGWTF")
)))


(defmacro daemon [&rest forms]
  `(disown
    (daemon-run ~@forms)
))


(defmacro lenin [&rest body]
  `(marx ~@body))
