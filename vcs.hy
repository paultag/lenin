(require lenin.language)

(lenin "vcs"
;  (on :docker (print event))

  (job :every 3 seconds
       :returns 0
       :image "debian:7.4"
       :volumes ["/vcs" "/srv/marx.pault.ag/vcs"]
       :workdir "/vcs/"
       :run "sleep" "10")

  (job :every 5 seconds
       :returns 0
       :image "debian:7.4"
       :volumes ["/vcs" "/srv/marx.pault.ag/vcs"]
       :workdir "/vcs/"
       :run "sleep" "10")

  (job :every 7 seconds
       :returns 0
       :image "debian:7.4"
       :volumes ["/vcs" "/srv/marx.pault.ag/vcs"]
       :workdir "/vcs/"
       :run "sleep" "10"))
