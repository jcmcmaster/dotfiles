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

# win or wsl?
vared -p "win(w) or wsl(l) " -c env

if ! [[ $env =~ '[wl]' ]] ; then
	echo "Invalid option"
	exit 1
elif [[ $env == 'w' ]] ; then
	env='win'
else
	env='wsl'
fi

# make links
ln -s -f ~/projects/dotfiles/common/$env/.tmux.conf ~/.tmux.conf
ln -s -f ~/projects/dotfiles/common/$env/.vimrc ~/.vimrc
ln -s -f ~/projects/dotfiles/common/$env/.zshrc ~/.zshrc

ln -s -f ~/projects/dotfiles/$place/$env/.ohmyzshconf ~/.ohmyzshconf
ln -s -f ~/projects/dotfiles/$place/$env/.aliases ~/.aliases
ln -s -f ~/projects/dotfiles/$place/$env/.functions ~/.functions
ln -s -f ~/projects/dotfiles/$place/$env/.gitconfig ~/.gitconfig
ln -s -f ~/projects/dotfiles/$place/$env/.bashrc ~/.bashrc
ln -s -f ~/projects/dotfiles/$place/$env/.taskrc ~/.taskrc

if ! [[ $env == "wsl" ]] ; then
	ln -s -f ~/projects/dotfiles/$place/$env/.vsvimrc ~/.vsvimrc
fi

exit 0
