if type -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
end

# test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# eval (python -m virtualfish)

direnv hook fish | source

zoxide init --cmd cd fish | source
