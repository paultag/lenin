(require lenin.language)

(lenin "vcs"
  (job :every 2 seconds
       :image "debian:unstable"
       :returns 0
       :run "sleep" "1")

  (daemon :name "test"
          :image "debian:unstable"
          :run "sleep" "8"))
