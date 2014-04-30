;;;;
;;;;
;;;;
;;;;

(require lenin.language)
(import [sh [hostname]])


(lenin "core"
  (let [[host (.strip (str (hostname "-f")))]
        [deployment "dev"]]
    ;;
    ;; SkyDNS
    ;;
    (daemon :name "skydns"
            :image "crosbymichael/skydns"
            :port-mapping "172.17.42.1:53:53/udp"
            :run "-nameserver" "8.8.8.8:53"
                 "-domain" host)

    ;;
    ;; SkyDock
    ;;
    (daemon :name "skydock"
            :image "crosbymichael/skydock"
            :requires "skydns"
            :volumes ["/var/run/docker.sock" "/docker.sock"]
            :run "-ttl" "30"
                 "-environment" deployment
                 "-s" "/docker.sock"
                 "-domain" host
                 "-name" "skydns")))

    ; (daemon :name "lenin"
    ;         :image "paultag/lenin"
    ;         :requires "skydock"
    ;         :volumes ["/run/docker.sock" "/run/docker.sock"]
    ;                  ["/srv/leliel.pault.ag/dev/lenin" "/lenin"]
    ;         :run "hy" "/lenin/services.hy")))
