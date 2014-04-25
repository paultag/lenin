(require lenin.language)


(lenin "databases"

  (daemon :name "snitchd"
          :image "paultag/snitch"
          :env ["SNITCH_MONGO_DB_HOST" "mongodb.dev.leliel.pault.ag"]
          :run "hy" "/opt/hylang/snitch/debian.hy"))
