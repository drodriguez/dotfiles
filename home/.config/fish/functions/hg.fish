function hg
  set -l translated_argv

  if [ (count $argv) -lt 1 ]
    command hg
    return $status
  end

  # TODO: this won't detect command with e.g. `hg --cwd ...`
  set -l cmd $argv[1]
  set -e argv[1]

  set translated_argv (git__translate_argv $argv)

  switch $cmd
  case 'status' 'st'
    hg__acquire_changes
    _hg_status $translated_argv
    return $status
  case 'prev' 'next'
    # You normally pass a number, so skip the translation
    command hg $cmd $argv
  case '*'
    command hg $cmd $translated_argv
    return $status
  end
end

function _hg_status
  set -l statuses (command hg status $argv)
  set -l current_name (hg_current_name)
  set -l tracked_lines
  set -l untracked_lines
  for line in $statuses
    set -l file_state (echo $line | sed 's/^\(.\).*/\1/')

    switch $file_state
    case M A R C ! I
      set tracked_lines $tracked_lines $line
    case '*'
      set untracked_lines $untracked_lines $line
    end
  end

  echo On (set_color --bold)$current_name(set_color normal)
  echo

  if [ (count $tracked_lines) != 0 ]
      echo (set_color --bold green)Tracked files:(set_color normal)
      for line in $tracked_lines
          _tracked_status_line $line
      end
      echo
  end

  if [ (count $untracked_lines) != 0 ]
      echo (set_color --bold yellow)Untracked files:(set_color normal)
      for line in $untracked_lines
          _untracked_status_line $line
      end
      echo
  end
end

function _tracked_status_line
    set -l line $argv[1]
    set -l filename (echo $line | sed 's/..//')
    set -l state (echo $line | sed 's/^\(.\).*/\1/')

    _padding green
    switch $state
    case M; echo -n ' modified'
    case A; echo -n '    added'
    case R; echo -n '  removed'
    case C; echo -n '   copied'
    case !; echo -n '  missing'
    case I; echo -n '  ignored'
    case '*' # unknown state!?
      echo -n '         '$state
    end

    _display_filename $filename green
end

function _untracked_status_line
    set -l line $argv[1]
    set -l filename (echo $line | sed 's/..//')
    set -l state (echo $line | sed 's/^\(.\).*/\1/')

    _padding yellow
    switch $state
    case '?'; echo -n 'untracked'
    case '*' # unknown state!
      echo -n '         '$state
    end

    _display_filename $filename yellow
end

function _display_filename
    set -l filename $argv[1]
    set -l file_color $argv[2]

    echo -n ': ['(contains -i $filename $c)'] '
    set_color $file_color
    echo -n $filename

    echo
    set_color normal
end

function _padding
    set -l color $argv[1]
    echo -n (set_color --bold $color)'#'(set_color normal)'      '
end
