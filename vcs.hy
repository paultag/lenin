(require lenin.language)

(lenin "vcs"
  (daemon :name "test"
          :image "debian:7.4"
          :run "sleep" "8"))
