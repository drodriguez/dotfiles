function hg_current_name -d "Get Mercurial current name (bookmark/branch)"
  hg_is_repo; and begin
    set -l branch (command hg branch ^/dev/null)
    set -l bookmark (command hg bookmark | command grep \* | cut -d\  -f3)

    if [ "$bookmark" != '' ]
      echo "$branch @ $bookmark"
    else
      echo $branch
    end
  end
end
