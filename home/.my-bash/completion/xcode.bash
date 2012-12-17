function _xcode_complete {
  COMPREPLY=($(compgen -W '$(ls -d *.xcodeproj *.xcworkspace 2>/dev/null)' -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}

complete -o default -o nospace -F _xcode_complete xc
complete -o default -o nospace -F _xcode_complete xc45

