(require marx.language)
(import [lenin.kwzip [group-map keyword?]])


(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defmacro job [&rest forms]
  ; (job :every 15 minutes
  ;      :returns 0
  ;      :image "paultag/vcs"
  ;      :volumes [["/vcs" "/srv/marx.pault.ag/vcs"]]
  ;      :workdir "/vcs/"
  ;      :run ["vcs-do-sync"]))

  (define [[data (group-map keyword? forms)]]
    `(run-every ~@(:every data)
      (disown (print (go (.list docker.containers)))))))


(defmacro lenin [&rest body]
  `(marx ~@body))
