function hg_current_name -d "Get Mercurial current name (bookmark/branch)"
  hg_is_repo; and begin
    set -l branch (command hg branch 2> /dev/null)
    set -l bookmark (command hg bookmark 2> /dev/null | command grep \* | cut -d\  -f3)

    if [ "$bookmark" != '' ]
      echo "$branch @ $bookmark"
    else
      echo $branch
    end
  end
end
