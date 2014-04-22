(require lenin.language)

(lenin "vcs"
  (daemon :name "skydns"
          :image "crosbymichael/skydns"
          :port-mapping "172.17.42.1:53:53/udp"
          :run "-nameserver" "8.8.8.8:53" "-domain" "docker")

  (daemon :name "postgres"
          :image "paultag/postgres"
          :volumes ["/var/lib/postgresql/" "/srv/metatron.pault.ag/postgres"]
          :run "/usr/lib/postgresql/9.3/bin/postgres"
               "-D" "/var/lib/postgresql/9.3/main"
               "-c" "config_file=/etc/postgresql/9.3/main/postgresql.conf"))
