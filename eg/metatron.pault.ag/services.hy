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
  ;; OpenVPN
  ;;
  (daemon :name "openvpn"
          :privileged true
          :port-mapping "0.0.0.0:1194:1194"
          :image "openvpn"
          :run "/usr/bin/paultag-openvpnd")

  ;;
  ;;PostgreSQL
  ;;
  (daemon :name "postgres"
          :image "paultag/postgres"
          :volumes ["/srv/leliel.pault.ag/dev/postgres/9.3/main"
                    "/var/lib/postgresql/9.3/main"]
          :run "/usr/local/bin/paultag-psqld"))
