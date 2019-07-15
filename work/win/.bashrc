#-------------------------------------------------------------
# Variables
#-------------------------------------------------------------

# my code projects folder
projects="C:/Users/JimMcMaster/projects"
msbuild_path="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"
onedrive="C:/Users/JimMcMaster/OneDrive - Medisked"
ticketDir="$onedrive/Tickets"

#-------------------------------------------------------------
# Functions
#-------------------------------------------------------------

# cd
cdp () {
	cd ${projects}/$1
}

# dotnet
publish () {
	 dotnet publish -c $1 -r win10-x64
}

# windows
serverReset () {
	net stop MSSQLSERVER
	iisreset
	net start MSSQLSERVER
}

# git
blame () {
	git log --follow -- $1
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

# build connect_net.sln
mcbuild () {
	"${msbuild_path}" "${projects}\connect_net\Connect.sln"
}

# build coordinate_net.sln and coordinate_webservice.sln
coorbuild () {
	"${msbuild_path}" "${projects}\coordinate_net\LifePlanBuilder2.sln"
	"${msbuild_path}" "${projects}\coordinate_webservice\coordinate_webservice.sln"
}

# build customer-portals.sln
cusbuild () {
	"${msbuild_path}" "${projects}\customer_portal\customer-portals\customer-portals.sln"
}

# build .sln files in the current directory
build () {
	"${msbuild_path}" ./*.sln
}

# delete apex AppData folder
apex () {
	read -p "Are you sure you want to delete the Apex AppData folder and all of its contents? (y/n)" conf
	
	if [ "$conf" != "y" ] 
	then
		echo "Close call..." 
		return
	fi
	
	rm -rf /c/Users/Medisked/AppData/Local/ApexSQL/ApexSQL\ Source\ Control/
}

tdir () {
	mkdir $ticketDir/"$1"
}

#-------------------------------------------------------------
# Aliases
#-------------------------------------------------------------

# git alias autocompletes
__git_complete gc _git_checkout
__git_complete gd _git_diff
__git_complete gdt _git_diff
__git_complete gl _git_log
__git_complete gm _git_merge
__git_complete gmt _git_merge
__git_complete gp _git_pull
__git_complete gs _git_status
__git_complete update-index _git_update-index

# bash
alias bashrc=". ~/.bashrc" 
alias cl="clear && ls"
alias coordb="cd ${projects}/coordinate_database"
alias coordev="cd ${projects}/coordinate"
alias coornet="cd ${projects}/coordinate_net"
alias coorws="cd ${projects}/coordinate_webservice"
alias cs="clear && git status"
alias cus="cd ${projects}/customer_portal"
alias mcdb="cd ${projects}/connect_database"
alias mcdev="cd ${projects}/connectdev"
alias mcnet="cd ${projects}/connect_net"
alias ssrs="cd ${projects}/\"SSRS Reports\""
alias lsa="ls -al"
alias python='winpty python.exe'

# git
alias commit="git commit"
alias ga="git add"
alias gc="git checkout"
alias gd="git diff"
alias gdt="git difftool"
alias gf="git fetch"
alias gl="git log"
alias gm="git merge"
alias gmt="git mergetool"
alias gs="git status"
alias gcddd="git checkout -- ."
alias gp="git pull"
alias push="git push"
alias gtree="git log --graph --oneline --decorate"
alias mergetool="git mergetool"
alias qa="(git checkout qa &> /dev/null ||git checkout coordinate-qa &> /dev/null) && git pull" 
alias master="git checkout master && git pull"
alias bump="echo bump >> readme.txt && git add readme.txt && git commit -m "bump" && git push"
alias coconfig="git checkout *.config"
alias ttlclean="git clean -f && git checkout ."

# Color!
alias ls='command ls --color=auto'
alias grep='command grep --color=auto'
