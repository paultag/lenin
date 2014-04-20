(require marx.language)
(import asyncio [lenin.kwzip [group-map keyword? one]])

(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


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
  (define [[binds (list-comp (.join `":" x) [x (:volumes data)])]]
    `(go (.start container {"Binds" [~@binds]}))))


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
    `(disown
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
      (broadcast "job" nil "deleted" container))))


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


(defmacro lenin [&rest body]
  `(marx
    (on :lenin (print (slice (get event "id") 0 8) ":"
                      (get event "class")
                      (get event "name") (get event "event")))
    ~@body))
