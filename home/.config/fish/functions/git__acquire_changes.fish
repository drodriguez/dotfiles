function git__acquire_changes
    set -g git__changes_filename

    # this un/staged dance is to get the short-status list in the same order
    # that will show up in `git status`.
    set -l staged_lines
    set -l unstaged_lines
    set -l unknown_lines
    # TODO: what if some format other than --short is here?
    for line in (command git status --short $argv)
        set -l staged_state (string sub --length 1 $line)
        set -l unstaged_state (string sub --start 2 --length 1 $line)

        switch $staged_state
        case ' ' '?'
        case '*'
            set -a staged_lines $line
        end

        switch $unstaged_state
        case ' '
        case '?'
            set -a unknown_lines $line
        case '*'
            set -a unstaged_lines $line
        end
    end

    set -g git__changes_unstaged_lines $unstaged_lines
    set -g git__changes_staged_lines $staged_lines
    set -g git__changes_unknown_lines $unknown_lines

    for line in $staged_lines $unstaged_lines $unknown_lines
        switch (string trim --left $line | string sub --length 1)
        case R C # 'R' in a short-status indicates a staged renamed file. 'C'
                 # is a staged copied file. In both cases we have two
                 # filenames to think about. This code will break in the
                 # inexcusable case that the old filename contained ' -> '.
            for file in (string sub --start 4 $line | string split ' -> ')
                set -a git__changes_filename $file
            end
        case '*'
            set -a git__changes_filename (string sub --start 4 $line)
        end
    end

end
