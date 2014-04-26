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
    ;; Lenin
    ;;
    (daemon :name "lenin"
            :image "paultag/lenin"
            :volumes ["/run/docker.sock" "/run/docker.sock"]
            :run "hy" "/opt/hylang/lenin/eg/metatron.pault.ag/services.hy")

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
            :volumes ["/var/run/docker.sock" "/docker.sock"]
            :run "-ttl" "30"
                 "-environment" deployment
                 "-s" "/docker.sock"
                 "-domain" host
                 "-name" "skydns")))
