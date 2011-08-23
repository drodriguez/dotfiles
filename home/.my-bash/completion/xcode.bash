function _xcode_complete {
  COMPREPLY=($(compgen -W '$(ls -d *.xcodeproj)' -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}

complete -o default -o nospace -F _xcode_complete x4
complete -o default -o nospace -F _xcode_complete x3

