function ge
  set -l translated_argv
  set translated_argv (git__translate_argv $argv)
  eval $translated_argv
end