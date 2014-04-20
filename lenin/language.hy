(require marx.language)
(import asyncio [lenin.kwzip [group-map keyword? one]])

(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defmacro broadcast [class name event container]
  (define [[ename (gensym)]]
    `(define [[~ename {"class" ~class
                      "name" ~name
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
           [name (one `nil (:name data))]
           [creation-code (lenin-create data)]
           [run-code (lenin-run data)]]
    `(disown
      ~creation-code
      (broadcast "job" ~name "setup" container)
      ~run-code
      (broadcast "job" ~name "start" container))))


(defmacro lenin [&rest body]
  `(marx
    (on :lenin (print (get event "event")))
    ~@body))
