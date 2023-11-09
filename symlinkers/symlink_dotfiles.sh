#! /usr/bin/env zsh

# make links
ln -s -f ~/projects/dotfiles/linux/.aliases ~/.aliases
ln -s -f ~/projects/dotfiles/linux/.bashrc ~/.bashrc
rm -rf ~/.config/nvim && ln -s -f ~/projects/dotfiles/linux/.config/nvim ~/.config/
ln -s -f ~/projects/dotfiles/linux/.dircolors ~/.dircolors
ln -s -f ~/projects/dotfiles/linux/.functions ~/.functions
ln -s -f ~/projects/dotfiles/linux/.gitconfig ~/.gitconfig
ln -s -f ~/projects/dotfiles/linux/.globals ~/.globals
ln -s -f ~/projects/dotfiles/linux/.keybindings ~/.keybindings
ln -s -f ~/projects/dotfiles/linux/.ohmyzshconf ~/.ohmyzshconf
ln -s -f ~/projects/dotfiles/linux/.path ~/.path
ln -s -f ~/projects/dotfiles/linux/.startup ~/.startup
ln -s -f ~/projects/dotfiles/linux/.taskrc ~/.taskrc
ln -s -f ~/projects/dotfiles/linux/.tmux.conf ~/.tmux.conf
ln -s -f ~/projects/dotfiles/linux/.vimrc ~/.vimrc
ln -s -f ~/projects/dotfiles/linux/.zshrc ~/.zshrc
ln -s -f ~/projects/dotfiles/linux/init.vim ~/.config/nvim/init.vim

exit 0
