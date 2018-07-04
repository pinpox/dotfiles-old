# http://bit.do/zshconfig
# https://ptpb.pw/MCeR

# Prevents grep options deprecation message
alias grep="/usr/bin/grep --color=auto $GREP_OPTIONS"
unset GREP_OPTIONS

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

alias q="exit"
alias v="nvim"
alias vim="nvim"
alias "rubocop --version"="echo 0.29.1"
alias "git igpush"="git commit -m\"ignore\" && git push"
alias y="yaourt"
alias paste=" curl -F c=@- https://ptpb.pw/"
alias snvim="sudo -E nvim"
alias weather='curl -4 http://wttr.in/Koeln'
alias qr_gen="qrencode -t ansi -o-"
alias cats='highlight -O ansi'
alias pupdate='sudo pacman -Syu'
alias get_esp32="export PATH=$PATH:$HOME/esp/xtensa-esp32-elf/bin"

# History search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

export EDITOR=/usr/bin/nvim
export GOPATH=~/.go
export PATH="$PATH:\
	/usr/bin/core_perl:\
	/usr/bin/site_perl:\
	/usr/bin/vendor_perl:\
	/usr/bin:\
	~/.go/bin:\
	/usr/lib/jvm/default/bin:\
	/usr/local/bin:\
	.local/bin:\
	/home/binaryplease/.cargo/bin:\
	/home/binaryplease/.local/bin:\
	/usr/local/sbin"

export VISUAL=/usr/bin/nvim


# zplug
if [[ ! -d ~/.zplug ]]; then
	git clone https://github.com/zplug/zplug ~/.zplug
	source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
zplug "arzzen/calc.plugin.zsh"
zplug "rupa/z", use:z.sh
zplug "lib/completion", from:oh-my-zsh
zplug "lib/colorize", from:oh-my-zsh
zplug "lib/colored-man-pages", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"

# Also prezto
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "lib/completion", from:oh-my-zsh, ignore:oh-my-zsh.sh

# Install packages that have not been installed yet
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	else
		echo
	fi
fi

zplug load

bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
bindkey "$terminfo[kcud1]" down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

transfer() {
	if [ $# -eq 0 ]; then
		echo -e "Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md";
		return 1
	fi
	tmpfile=$( mktemp -t transferXXX )
	if tty -s; then
		basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
		curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
	else
		curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
	fi
	cat $tmpfile
	rm -f $tmpfile
}

# fkill - kill process
fkill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

	if [ "x$pid" != "x" ]
	then
		echo $pid | xargs kill -${1:-9}
	fi
}


function extract {
	if [ -z "$1" ]; then
		# display usage if no parameters given
		echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
	else
		if [ -f $1 ] ; then
			# NAME=${1%.*}
			# mkdir $NAME && cd $NAME
			case $1 in
				*.tar.bz2)   tar xvjf ../$1    ;;
				*.tar.gz)    tar xvzf ../$1    ;;
				*.tar.xz)    tar xvJf ../$1    ;;
				*.lzma)      unlzma ../$1      ;;
				*.bz2)       bunzip2 ../$1     ;;
				*.rar)       unrar x -ad ../$1 ;;
				*.gz)        gunzip ../$1      ;;
				*.tar)       tar xvf ../$1     ;;
				*.tbz2)      tar xvjf ../$1    ;;
				*.tgz)       tar xvzf ../$1    ;;
				*.zip)       unzip ../$1       ;;
				*.Z)         uncompress ../$1  ;;
				*.7z)        7z x ../$1        ;;
				*.xz)        unxz ../$1        ;;
				*.exe)       cabextract ../$1  ;;
				*)           echo "extract: '$1' - unknown archive method" ;;
			esac
		else
			echo "$1 - file does not exist"
		fi
	fi
}

#mktar_serial() { name="${${1:t}:r}"; tar cfJ "$name".tar.xz "$@"; }
mktar() { name="${${1:t}:r}"; tar -I pxz -cf "$name".tar.xz "$@"; }

alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
export GEM_HOME=$HOME/.gem
[ -f ~/.fzf.colors ] && source ~/.fzf.colors
