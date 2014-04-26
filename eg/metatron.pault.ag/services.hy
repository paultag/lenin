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
  ;; Snitch Daemon
  ;;
  (daemon :name "snitchd"
          :image "paultag/snitch"
          :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
          :run "hy" "/opt/hylang/snitch/debian.hy"))
