function hg_is_touched -d "Check if the Mercurial repo has any changes"
  hg_is_repo; and begin
    test -n (echo (command hg status))
  end
end
