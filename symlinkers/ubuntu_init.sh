# apt
sudo apt update -y && sudo apt install -y \
 build-essential\
 git\
 zsh\
 fortune\
 cowsay\
 curl\
 wget\
 man\
 ripgrep\
 dotnet-sdk-7.0\
 fzf

mkdir ~/bin
mkdir ~/downloads

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
nvm install 18

# nvim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
mv ./nvim.appimage ~/bin/nvim
mkdir -p ~/.config/nvim/
cd && mkdir projects && cd projects
git clone https://github.com/jcmcmaster/dotfiles
rm ~/.config/nvim/init.vim

# zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# symlinks
chmod 700 ~/projects/dotfiles/symlinkers/wsl_symlinker.sh
~/projects/dotfiles/symlinkers/wsl_symlinker.sh
