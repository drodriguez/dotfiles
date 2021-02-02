SHELL := bash

.PHONY: install
install:
	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc"

.PHONY: update
update: update-pathogen update-plugins

.PHONY: update-plugins
update-plugins:
	git submodule update --init --recursive
	git submodule update --remote
	git submodule foreach 'git pull --recurse-submodules origin `git rev-parse --abbrev-ref HEAD`'

.PHONY: update-pathogen
update-pathogen:
	curl -LSso $(CURDIR)/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
