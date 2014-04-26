;;;;
;;;;
;;;;
;;;;

(require lenin.language)


(lenin "services"

  ;;
  ;; MongoDB
  ;;
  (daemon :name "mongodb"
          :image "paultag/mongodb"
          :volumes ["/srv/leliel.pault.ag/dev/mongodb" "/var/lib/mongodb"]
          :run "/usr/local/bin/paultag-mongodb")

  ;;
  ;;PostgreSQL
  ;;
  (daemon :name "postgres"
          :image "paultag/postgres"
          :volumes ["/srv/leliel.pault.ag/dev/postgres/9.3/main"
                    "/var/lib/postgresql/9.3/main"]
          :run "/usr/local/bin/paultag-psqld")

  ;;
  ;; Apt Cacher
  ;;
  (daemon :name "apt-cacher-ng"
          :image "paultag/apt-cacher-ng"
          :run "/usr/sbin/apt-cacher-ng" "ForeGround=1")

  ;;
  ;; Snitch Daemon Debian
  ;;
  (daemon :name "snitchd-debian"
          :image "paultag/snitch"
          :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
          :run "hy" "/opt/hylang/snitch/debian.hy"))
  ;;
  ;; Snitch web worker
  ;;
  ;(daemon :name "snitch-web"
  ;        :image "paultag/snitch"
  ;        :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
  ;        :run "hy" "/opt/hylang/snitch/debian.hy"))
