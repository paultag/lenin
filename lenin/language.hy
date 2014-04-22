(require marx.language)
(import asyncio [lenin.kwzip [group-map keyword? one]])


(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defmacro lenin-debug [&rest forms]
  `(print ~@forms))


(defmacro broadcast [class name event container]
  (define [[ename (gensym)]]
    `(define [[~ename {"class" ~class
                       "name" ~name
                       "id" container._id
                       "event" ~event
                       "container" ~container}]]
      (emit :lenin ~ename)
      (emit (+ :lenin "-" ~class) ~ename)
      (emit (+ :lenin "-" ~class "-" ~event) ~ename)

      (if (is-not ~name nil)
        (do
          (emit (+ :lenin "-" ~name) ~ename)
          (emit (+ :lenin "-" ~class "-" ~name) ~ename)
          (emit (+ :lenin "-" ~class "-" ~name "-" ~event) ~ename))))))


(defn lenin-run [data]
  "Central run code"
  (defn parse-string [input]
      ;; "172.17.42.1:53:53/udp"
      (let [[(, host hport) (.rsplit input ":" 1)]
            [(, ip cport) (.rsplit host ":" 1)]
            [hport (HyString hport)]
            [ip (HyString ip)]
            [cport (HyString cport)]]
        `{"PortBindings" {~hport [{"HostIp" ~ip "HostPort" ~cport}]
        }}))

  (define [[binds (list-comp (HyString (.join ":" x)) [x (:volumes data)])]
           [iname (gensym)]
           [config `{"Binds" [~@binds]}]]

    (if (.get data :port-mapping)
      (setv config (+ config (parse-string (one 'nil (:port-mapping data))))))

    `(do
      (go-setv ~iname (.show container))
      (if (is (-> ~iname (get "State") (get "Running")) false)
        (go (.start container ~config))))))


(defn lenin-create [data]
  "Central creation code"
  (define [[name (one `nil (:name data))]
           [image (one `"debian:stable" (:image data))]]
    `(do
      (go-setv container (.create-or-replace docker.containers
                            ~name {"Cmd" [~@(:run data)]
                                   "Image" ~image
                                   "AttachStdin" false
                                   "AttachStdout" true
                                   "AttachStderr" true
                                   "Tty" false
                                   "OpenStdin" false
                                   "StdinOnce" false})))))


(defmacro job [&rest forms]
  (define [[data (group-map keyword? forms)]
           [creation-code (lenin-create data)]
           [run-code (lenin-run data)]]
    ; XXX: Remove `name' if it exists.

    `(run-every ~@(:every data)
      (disown
        ~creation-code
        (broadcast "job" nil "setup" container)
        ~run-code
        (broadcast "job" nil "start" container)
        (go (.wait container))
        (broadcast "job" nil "finished" container)
        (go-setv info (.show container))
        (if (= (int (-> info (get "State") (get "ExitCode"))) 0)
          (broadcast "job" nil "succeeded" container)
          (broadcast "job" nil "failed" container))
        (go (.delete container))
        (broadcast "job" nil "deleted" container)))))


(defmacro daemon [&rest forms]
  (define [[data (group-map keyword? forms)]
           [name (one `nil (:name data))]
           [creation-code (lenin-create data)]
           [run-code (lenin-run data)]]
    `(disown
      (while true
        ~creation-code
        (broadcast "daemon" ~name "setup" container)
        ~run-code
        (broadcast "daemon" ~name "start" container)
        (go (.wait container))
        (broadcast "daemon" ~name "died" container)))))


(defmacro lenin [set-name &rest body]
  `(marx
    (on :lenin (lenin-debug (slice (get event "id") 0 8) ":"
                      (get event "class")
                      (get event "name") (get event "event")))
    ~@body))
