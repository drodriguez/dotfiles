function _gemedit_complete {
  local idx counter=1 command

  while [ $counter -lt $COMP_CWORD ]; do
    command="${COMP_WORDS[counter]}"; break
  done

  if [ -z "$command" ]; then return; fi

  if [ "$command" = "edit" ]; then
    COMPREPLY=($(compgen -W '$(ls `gem env gemdir`/gems)' -- ${COMP_WORDS[COMP_CWORD]}))
    return 0
  fi
}

complete -o default -o nospace -F _gemedit_complete gem
