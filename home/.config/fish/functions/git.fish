function git
  set -l translated_argv

  if [ (count $argv) -lt 1 ]
    command git
    return $status
  end

  # TODO: this won't detect command with e.g. `git --git-dir ...`
  set -l cmd $argv[1]
  set -e argv[1]

  set translated_argv (git__translate_argv $argv)

  switch $cmd
  case 'status'
    git__acquire_changes
    _git_status $translated_argv
    return $status
  case '*'
    command git $cmd $translated_argv
    return $status
  end
end

function _git_status
  # TODO: what if some format other than --short is here?
  set -l short_status (command git status --short $argv)
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed 's:refs/heads/::')
  set -l staged_lines
  set -l unstaged_lines
  set -l unknown_lines
  for line in $short_status
    set -l staged_state (echo $line | sed 's/^\(.\).*/\1/')
    set -l unstaged_state (echo $line | sed 's/^.\(.\).*/\1/')

    switch $staged_state
    case '\?' ' '
    case '*'
        set staged_lines $staged_lines $line
    end

    switch $unstaged_state
    case ' '
    case '\?'
        set unknown_lines $unknown_lines $line
    case '*'
        set unstaged_lines $unstaged_lines $line
    end
  end

  echo On branch (set_color --bold)$branch(set_color normal)
  echo

  if [ (count $staged_lines) != 0 ]
      echo (set_color --bold green)Changes to be committed:(set_color normal)
      for line in $staged_lines
          _staged_status_line $line
      end
      echo
  end

  if [ (count $unstaged_lines) != 0 ]
      echo (set_color --bold yellow)Unstaged changes:(set_color normal)
      for line in $unstaged_lines
          _unstaged_status_line $line
      end
      echo
  end

  if [ (count $unknown_lines) != 0 ]
      echo (set_color --bold red)Untracked files:(set_color normal)
      for line in $unknown_lines
          _unknown_status_line $line
      end
      echo
  end
end

function _staged_status_line
    set -l line $argv[1]
    set -l filename (echo $line | sed 's/...//')
    set -l state (echo $line | sed 's/^\(.\).*/\1/')

    _padding green
    switch $state
    case M; echo -n '  modified'
    case A; echo -n '  new file'
    case D; echo -n '   deleted'
    case R; echo -n '   renamed'
    case C; echo -n '    copied'
    case T; echo -n 'typechange'
    # U is actually "unmerged." Can non-conflict cases cause a U?
    case U; echo -n '  conflict'
    case ' ' '\?'
    case '*' # unknown state!?
        echo -n '         '$state
    end

    _display_filename $filename green
end

function _unstaged_status_line
    set -l line $argv[1]
    set -l filename (echo $line | sed 's/...//')
    set -l state (echo $line | sed 's/^.\(.\).*/\1/')

    _padding yellow
    switch $state
    case M; echo -n '  modified'
    case D; echo -n '   deleted'
    case T; echo -n 'typechange'
    # U is actually "unmerged." Can non-conflict cases cause a U?
    case U; echo -n '  conflict'
    case ' ' '\?'
    case '*' # unknown state!
    echo -n '         '$state
    end

    _display_filename $filename yellow
end

function _unknown_status_line
    set -l line $argv[1]
    set -l filename (echo $line | sed 's/...//')

    _padding red
    echo -n ' untracked'
    _display_filename $filename red
end

function _display_filename
    set -l filename $argv[1]
    set -l file_color $argv[2]

    switch $filename
    case '* -> *'
        set -l old (echo $filename | sed 's/ -> .*//')
        set -l new (echo $filename | sed 's/.* -> //')
        echo -n ': ['(contains -i $old $c)'] '
        set_color $file_color
        echo -n $old
        set_color normal
        echo -n ' -> ['(contains -i $new $c)'] '
        set_color $file_color
        echo -n $new
    case '*'
        echo -n ': ['(contains -i $filename $c)'] '
        set_color $file_color
        echo -n $filename
    end
    echo
    set_color normal
end

function _padding
    set -l color $argv[1]
    echo -n (set_color --bold $color)'#'(set_color normal)'      '
end
