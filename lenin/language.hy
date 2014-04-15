(require marx.language)
(import [lenin.kwzip [group-map keyword?]])


(defmacro disown [&rest forms]
  `(.async asyncio ((fn/coroutine [] ~@forms))))


(defmacro job [&rest forms]
  (define [[data (group-map keyword? forms)]]
    ; {:volumes [['/vcs' '/srv/marx.pault.ag/vcs']]
    ;  :run ['vcs-do-sync']
    ;  :image ['paultag/vcs']
    ;  :workdir ['/vcs/']}

    `(run-every ~@(:every data)
      (disown
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
                   ; "Binds":["/tmp:/tmp"],
                   ; "LxcConf":{"lxc.utsname":"docker"},
                   ; "PortBindings":{ "22/tcp": [{ "HostPort": "11022" }] },
                   ; "PublishAllPorts":false,
                   ; "Privileged":false
                 }))]]
          (go (.wait container)))))))


(defmacro lenin [&rest body]
  `(marx ~@body))
