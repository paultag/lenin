(require lenin.language)


(lenin "databases"
  (daemon :name "mongodb"
          :image "paultag/mongodb"
          :volumes ["/srv/leliel.pault.ag/dev/mongodb" "/var/lib/mongodb"]
          :run "mongod" "--bind_ip" "0.0.0.0" "--config" "/etc/mongodb.conf"))

;  (daemon :name "postgres"
;          :image "paultag/postgres"
;          :volumes ["/srv/leliel.pault.ag/dev/postgres/9.3/main"
;                    "/var/lib/postgresql/9.3/main"]
;          :run "/usr/lib/postgresql/9.3/bin/postgres"
;               "-D" "/var/lib/postgresql/9.3/main"
;               "-c" "config_file=/etc/postgresql/9.3/main/postgresql.conf"))
