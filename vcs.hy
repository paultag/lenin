(require lenin.language)

(lenin "vcs"
  (job :every 15 minutes
       :returns 0
       :image "debian:7.4"
       :volumes ["/vcs" "/srv/marx.pault.ag/vcs"]
       :workdir "/vcs/"
       :run "sleep" "10"))
