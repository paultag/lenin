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
            :run "hy" "/opt/hylang/lenin/eg/metatron.pault.ag/services.hy"))
