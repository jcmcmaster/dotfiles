# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jim_mcmaster/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# DEFAULT_USER=$USER
# prompt_context() {}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#-------------------------------------------------------------
# Variables
#-------------------------------------------------------------

# code projects folder
projects="/mnt/c/users/JimMcMaster/projects"
onedrive="/mnt/c/Users/JimMcMaster/OneDrive - Medisked"
ticketDir="$onedrive/Tickets"

# appending exe folders to PATH
export PATH=$PATH:"mnt/c/users/JimMcMaster/onedrive - medisked/scripts/bash"
export PATH=$PATH:"${projects}/jdb/jdb/bin/Release/netcoreapp2.1/win10-x64/"

#-------------------------------------------------------------
# Functions
#-------------------------------------------------------------

#cd
cdp () {
	cd ${projects}/$1
}

cdt () {
	cd "${ticketDir}"/"$1"
}

#dotnet
publish () {
	 dotnet.exe publish -c $1 -r win10-x64
}

#windows
serverReset () {
	net stop MSSQLSERVER	
	net start MSSQLSERVER
	iisreset 
}

#git
blame () {
	git log --follow -- $1
}


gdtfactory () { 
	git difftool origin/master $( git diff --name-only origin/master | grep 'connect.Common/Entity/.*Factory' )
}

gac () {
	git add -A
	git commit -m "$1"
}

gacp () {
	git add -A
	git commit -m "$1"
	git push
}
    
# undo all changes at all costs (DANGER ZONE ;])
grip () { 
	read -p "Are you sure? (y/n)" conf
	
	if [ "$conf" != "y" ] 
	then
		echo "Close call..." 
		return
	fi
	
	curBranch=$(git symbolic-ref -q HEAD)
	curBranch=${curBranch##refs/heads/}
	curBranch=${curBranch:-HEAD}
	git reset --hard
	git clean -f
	git checkout -- .
	git checkout -B grip_false_branch
	git branch -D $curBranch
	git checkout $curBranch
	git branch -D grip_false_branch
	git status
}

# build .sln files in the current directory
build () {
	"${msbuild_path}" ./*.sln
}

ctrlp() {
	fzf_output=$(fzf)
	if [[ $fzf_output != "" ]] ; then
		</dev/tty vim $fzf_output
	fi
}

jot() {
	echo "$*" >> ~/misc/jot
}

tdir() {
	mkdir $ticketDir/"$1"
}

# deploy () {
#   git fetch
# 	git checkout master
# 	git merge origin/staging
# 	git push
# }

#-------------------------------------------------------------
# Aliases
#-------------------------------------------------------------

#bash
alias cl="clear && ls"
alias cs="clear && git status"
alias coordb="cd ${projects}/coordinate_database"
alias coordev="cd ${projects}/coordinate"
alias coornet="cd ${projects}/coordinate_net"
alias coorws="cd ${projects}/coordinate_webservice"
alias cus="cd ${projects}/customer_portal"
alias mcdb="cd ${projects}/connect_database"
alias mcdev="cd ${projects}/connectdev"
alias mcnet="cd ${projects}/connect_net"
alias ssrs="cd ${projects}/\"SSRS Reports\""
alias onedrive="cd \"${onedrive}\""
alias tickets="cd \"${ticketDir}\""
alias home="cd /mnt/c/users/medisked"
alias py="python3"
alias pth='echo $PATH | tr : "\n" | less'

#git
alias commit="git commit"
alias ga="git add"
alias gc="git checkout"
alias gcm="git commit -m"
alias gd="git diff"
alias gdt="git difftool"
alias gf="git fetch"
alias gl="git log"
alias gs="git status"
alias gcdd="git checkout -- ."
alias gp="git pull"
alias gtree="git log --graph --oneline --decorate"
alias master="git checkout master && git pull"
alias lineblame="git blame -L"

#taskwarrior
alias t="task"
alias tl="task list"
alias tlcoorse="task list project:coorse"
alias ta="task add"
alias tah"task add pri:H"
alias tacoorse="task add project:coorse"
alias tm="task modify"
alias tap="task append"
alias td="task done"

#-------------------------------------------------------------
# Startup
#-------------------------------------------------------------

# fzf + ripgrep
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
cd

#-------------------------------------------------------------
# Keybindings
#-------------------------------------------------------------

bindkey -v # vim editing mode in zsh

zle -N ctrlp
bindkey "^p" ctrlp

source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.purepower
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
