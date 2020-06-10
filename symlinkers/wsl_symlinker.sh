#! /usr/bin/env zsh
echo "\nONLY PROCEED IF YOU'VE BACKED UP ALL OF THE DOTFILES IN YOUR HOME DIRECTORY"
echo "THIS SCRIPT WILL DELETE THEM\n"

# work or home?
vared -p "work(w) or home(h)? " -c place

if ! [[ $place =~ '[wh]' ]] ; then
	echo "Invalid option"
	exit 1
elif [[ $place == 'w' ]] ; then
	place='work'
else 
	place='home'
fi

# common
ln -s -f ~/projects/dotfiles/common/wsl/.tmux.conf ~/.tmux.conf
ln -s -f ~/projects/dotfiles/common/wsl/.vimrc ~/.vimrc
ln -s -f ~/projects/dotfiles/common/wsl/.zshrc ~/.zshrc
ln -s -f ~/projects/dotfiles/common/wsl/.keybindings ~/.keybindings
ln -s -f ~/projects/dotfiles/common/wsl/.dircolors ~/.dircolors
ln -s -f ~/projects/dotfiles/$place/wsl/.bashrc ~/.bashrc
ln -s -f ~/projects/dotfiles/$place/wsl/.startup ~/.startup
ln -s -f ~/projects/dotfiles/$place/wsl/.functions ~/.functions

# place specific
ln -s -f ~/projects/dotfiles/$place/wsl/.ohmyzshconf ~/.ohmyzshconf
ln -s -f ~/projects/dotfiles/$place/wsl/.aliases ~/.aliases
ln -s -f ~/projects/dotfiles/$place/wsl/.globals ~/.globals
ln -s -f ~/projects/dotfiles/$place/wsl/.path ~/.path
ln -s -f ~/projects/dotfiles/$place/wsl/.gitconfig ~/.gitconfig
ln -s -f ~/projects/dotfiles/$place/wsl/.taskrc ~/.taskrc

exit 0
