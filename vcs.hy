(require lenin.language)

(lenin "vcs"
  (job :every 15 minutes
       :returns 0
       :image "paultag/vcs"
       :volumes [["/vcs" "/srv/marx.pault.ag/vcs"]]
       :workdir "/vcs/"
       :run ["vcs-do-sync"]))
