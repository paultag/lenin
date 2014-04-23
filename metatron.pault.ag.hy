(require lenin.language)


(lenin ""

  (daemon :name "skydns"
          :image "crosbymichael/skydns"
          :port-mapping "172.17.42.1:53:53/udp"
          :run "-nameserver" "8.8.8.8:53" "-domain" "docker")

  (daemon :name "skydock"
          :image "crosbymichael/skydock"
          :volumes ["/var/run/docker.sock" "/docker.sock"]
          :run "-ttl" "30"
               "-environment" "dev"
               "-s" "/docker.sock"
               "-domain" "docker"
               "-name" "skydns")

  (daemon :name "postgres"
          :image "paultag/postgres"
          :volumes ["/var/lib/postgresql/" "/srv/metatron.pault.ag/postgres"]
          :run "/usr/lib/postgresql/9.3/bin/postgres"
               "-D" "/var/lib/postgresql/9.3/main"
               "-c" "config_file=/etc/postgresql/9.3/main/postgresql.conf"))
