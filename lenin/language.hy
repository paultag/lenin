(require marx.language)
(import asyncio [lenin.kwzip [group-map keyword?]])

(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defn one [default args]
  (cond
    [(= (len args) 0) default]
    [(= (len args) 1) (get args 0)]
    [true (raise (TypeError "Too many args passed in."))]))


(defmacro/g! daemon-run [&rest forms]
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
                               "StdinOnce" false}))]
              [~g!leader  (+ :lenin-daemon "-" ~name "-")]
              [~g!start   (+ ~g!leader "start")]
              [~g!started (+ ~g!leader "started")]
              [~g!failed  (+ ~g!leader "failed")]]

      (go (.start container {"Binds" [~@binds]}))
      (emit ~g!started container)
      (emit :lenin-daemon-started {
        :name ~name
        :container container
      })
      (go (.wait container))
      (emit ~g!failed container)
      (emit :lenin-daemon-failure {
        :name ~name
        :container container
      }))))


(defmacro daemon [&rest forms]
  `(disown
    (while true (daemon-run ~@forms))
))


(defmacro lenin [&rest body]
  `(marx

    (on :lenin-daemon-failure
      (print (:name event) "failed. ouch."))

    ~@body))
