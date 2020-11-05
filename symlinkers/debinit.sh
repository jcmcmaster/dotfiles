sudo apt update -y

sudo apt install -y \
 git\
 neovim\
 htop\
 python3\
 zsh\
 tmux\
 fortune\
 cowsay\
 taskwarrior\
 nodejs\
 curl\
 wget\
 python3-pip\
 man\
 ripgrep

sudo apt update -y && sudo apt upgrade -y

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.config/nvim/

cd && mkdir projects && cd projects

git clone https://github.com/jcmcmaster/dotfiles

git clone https://github.com/jcmcmaster/scripts

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

chmod 700 ~/projects/dotfiles/symlinkers/symlink_dotfiles.sh

pip3 install pynvim

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

~/projects/dotfiles/symlinkers/symlink_dotfiles.sh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
