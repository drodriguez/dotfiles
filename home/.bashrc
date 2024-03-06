# Many ideas and code lifted from https://github.com/revans/bash-it

# Unlike earlier versions, Bash4 sources your bashrc on non-interactive shells.
# The line below prevents anything in this file from creating output that will
# break utilities that use ssh as a pipe, including git and mercurial.
[ -z "$PS1" ] && return

alias reload='source ~/.bash_profile'

source ~/.my-bash/theme/colors.bash
source ~/.my-bash/theme/base.bash
source ~/.my-bash/theme/theme.bash

# Load the files inside .my-bash
for config_dir in lib aliases completion plugins functions
do
  for config_file in ~/.my-bash/$config_dir/*.bash
  do
    source $config_file
  done
done

unset config_file
unset config_dir

export PS1=$PROMPT

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
