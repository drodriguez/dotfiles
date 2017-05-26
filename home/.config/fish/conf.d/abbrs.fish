if not set -q abbrs_initialized
  abbr -a be bundle exec
  abbr -a f open -a Finder
  abbr -a g git
  abbr -a ga git add
  abbr -a gap git add --patch
  abbr -a gc git commit
  abbr -a gcb git checkout -b
  abbr -a gco git checkout
  abbr -a gd git diff
  abbr -a gdc git diff --cached
  abbr -a gl git lg
  abbr -a gmt git mergetool
  abbr -a gpl git pull
  abbr -a grs git reset
  abbr -a grc git rebase --continue
  abbr -a gs git status
  abbr -a ll ls -al
  abbr -a mategem gem edit -e mate
  abbr -a pi bundle exec pod install

  set -U abbrs_initialized
end
