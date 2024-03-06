function hg_is_repo -d "Check if directory is a Mercurial repository"
  test -d .hg; or command hg root > /dev/null ^/dev/null
end
