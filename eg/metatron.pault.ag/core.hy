(require lenin.language)
(import [sh [hostname]])


(lenin "core"
  (let [[host (.strip (str (hostname "-f")))]
        [deployment "dev"]
        [root (.join "/" "/srv" host deployment)]]
        ; host       "leliel.pault.ag"
        ; deployment "dev"
        ; root       "/srv/leliel.pault.ag/dev/"

;    (daemon :name "lenin-webapps"
;            :image "paultag/lenin"
;            :volumes ["/var/run/docker.sock" "/docker.sock"]
;                     [(+ root "lenin") "/lenin"]
;            :run "hy" "/lenin/webapps.hy")

    (daemon :name "skydns"
            :image "crosbymichael/skydns"
            :port-mapping "172.17.42.1:53:53/udp"
            :run "-nameserver" "8.8.8.8:53"
                 "-domain" host)

    (daemon :name "skydock"
            :image "crosbymichael/skydock"
            :volumes ["/var/run/docker.sock" "/docker.sock"]
            :run "-ttl" "30"
                 "-environment" deployment
                 "-s" "/docker.sock"
                 "-domain" host
                 "-name" "skydns")))
