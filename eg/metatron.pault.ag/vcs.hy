(require lenin.language)


(lenin "services"

  ;;
  ;; Sync VCSs
  ;;
  (job :every 5 minutes
       :image "paultag/vcs"
       :volumes ["/srv/leliel.pault.ag/dev/vcs" "/vcs"]
       :run "/opt/paultag/vcs/docron"))
