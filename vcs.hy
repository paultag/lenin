(require lenin.language)

(lenin "vcs"
  (job :every 5 seconds
       :returns 0
       :image "debian:7.4"
       :volumes ["/vcs" "/srv/marx.pault.ag/vcs"]
       :workdir "/vcs/"
       :run "sleep" "10"))
