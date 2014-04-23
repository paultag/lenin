(require lenin.language)


(lenin "webapps"

  (daemon :name "snitch"
          :image "paultag/snitch"
          :run "uwsgi" ...)

  (daemon :name "mongodb"
          :image "paultag/mongodb"
          :run "mongod")

  ;(daemon :name "postgres"
  ;        :image "paultag/postgres"
  ;        :volumes ["/var/lib/postgresql/" "/srv/metatron.pault.ag/postgres"]
  ;        :run "/usr/lib/postgresql/9.3/bin/postgres"
  ;             "-D" "/var/lib/postgresql/9.3/main"
  ;             "-c" "config_file=/etc/postgresql/9.3/main/postgresql.conf"))
