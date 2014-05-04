;;;;
;;;;
;;;;
;;;;

(require lenin.language)


(lenin "snitch"

  ;;
  ;; Snitch Daemon Debian
  ;;
  (daemon :name "snitchd-debian"
          :image "paultag/snitchd"
          :requires "mongodb"
          :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
          :run "hy" "/opt/hylang/snitch/debian.hy")
  ;;
  ;; Snitch web worker
  ;;
  (daemon :name "snitchweb"
          :image "paultag/snitchweb"
          :requires "mongodb"
          :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
          :volumes ["/srv/leliel.pault.ag/dev/nginx/serve/" "/serve/"]
          :run "uwsgi"
                 "--ini" "/etc/uwsgi/apps-enabled/uwsgi.ini"
                "--chown-socket" "snitch"
                 "--uid" "snitch"
                 "--check-static" "/opt/hylang/snitch/web/"))
