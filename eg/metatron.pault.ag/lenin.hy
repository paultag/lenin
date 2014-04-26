;;;;
;;;;
;;;;
;;;;

(require lenin.language)


(lenin "lenin"
    ;;
    ;; Lenin
    ;;
    (daemon :name "lenin"
            :image "paultag/lenin"
            :volumes ["/run/docker.sock" "/run/docker.sock"]
                     ["/srv/leliel.pault.ag/dev/lenin" "/lenin"]
            :run "hy" "/lenin/services.hy"))
