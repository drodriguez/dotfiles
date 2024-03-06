function hg__acquire_changes

    alias _first_character "sed 's/^\(.\).*/\1/'"
    # I'm using a single-character variable here for convenience at the command
    # line. `c` contains every changed (staged, outstanding, or untracked) file.
    set -g c

    # this un/staged dance is to get the short-status list in the same order
    # that will show up in `git status`.
    set -l tracked_files
    set -l untracked_files
    for line in (command hg status)
        switch (echo $line | _first_character)
        case M A R C ! I # Modified, Added, Removed, Clean, Missing, or Ignored
            set tracked_files $tracked_files $line
        case '?'
            set untracked_files $untracked_files $line
        end
    end

    for line in $tracked_files $untracked_files
        switch (echo $line | _first_character)
        case '*'
            set c $c (echo $line | sed 's/^..//')
        end
    end
end
