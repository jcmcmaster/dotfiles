sudo apt update -y && sudo apt install -y \
 git\
 htop\
 python3\
 zsh\
 fortune\
 cowsay\
 taskwarrior\
 nodejs\
 curl\
 wget\
 python3-pip\
 man\
 ripgrep\
 docker

# setup neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update -y && sudo apt upgrade -y
sudo apt install neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.config/nvim/
cd && mkdir projects && cd projects
git clone https://github.com/jcmcmaster/dotfiles
git clone https://github.com/jcmcmaster/scripts

pip3 install pynvim

# zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# symlinks
chmod 700 ~/projects/dotfiles/symlinkers/wsl_symlinker.sh
~/projects/dotfiles/symlinkers/wsl_symlinker.sh