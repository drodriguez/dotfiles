if type -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

test -e /opt/homebrew/bin/brew ; and eval (/opt/homebrew/bin/brew shellenv)

# eval (python -m virtualfish)

direnv hook fish | source

zoxide init --cmd cd fish | source

for file in /etc/fish/completions/*.fish
  source $file
end
