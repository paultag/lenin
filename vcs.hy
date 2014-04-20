(require lenin.language)

(lenin "vcs"
  (job :every 2 seconds
       :image "debian:unstable"
       :returns 0
       :run "sleep" "1")

  (daemon :name "test"
          :image "debian:7.4"
          :run "sleep" "8"))
