#!/bin/bash
GIT_REPO="https://gitlab.com/binaryplease/dotfiles/"
CONF_DIR_NAME=".dotfiles"

function backup_conf() {
	while read fn
	do
		con="$(dirname $fn)"
		con=".config-backup/$con"
		mkdir -p $con
		mv $fn $(realpath $con)
	done
}

function setup_dotfiles() {
	cd ~
	git clone --bare $GIT_REPO $HOME/$CONF_DIR_NAME
	function config {
		/usr/bin/git --git-dir=$HOME/$CONF_DIR_NAME/ --work-tree=$HOME $@
	}
	echo "$CONF_DIR_NAME" >> .gitignore
	mkdir -p .config-backup
	echo "Backing up pre-existing dot files.";
	config checkout 2>&1 | awk '/^[[:space:]]/{print $1}' | backup_conf
	config checkout
	config config status.showUntrackedFiles no
}

function set_zsh() {
	read -p "Change shell to zsh? [Y/n]" -n 1 -r
	echo
	if [[ $REPLY =~ ^(y|Y| ) ]] || [[ -z $REPLY ]];
	then
		chsh -s /bin/zsh
	fi
}

function setup_vim() {
	if type "nvim" > /dev/null
	then
		nvim -c 'PlugClean|PlugInstall|qa'
	elif type "vim" > /dev/null
	then
		vim -c 'PlugClean|PlugInstall|qa'
	else
		echo "Vim/Neovim doesn't seem to be installed"
	fi
}

function install_base16_manager() {
	base16-manager install 0xdec/base16-rofi
	base16-manager instajj chriskempson/base16-vim
	base16-manager instajj chriskempson/base16-xresources
	base16-manager instajj khamer/base16-dunst
	base16-manager instajj khamer/base16-termite
	base16-manager instajj nicodebo/base16-fzf
}

function check_dependencies() {
	declare -a arr=("git" "base16-manager" "nvim")

	## now loop through the above array
	for i in "${arr[@]}"
	do
		if ! [ -x "$(command -v $i)" ]; then
			echo "Error: $i is not installed." >&2
			exit 1
		fi
	done
}

function setup_colors() {
	mkdir -p .config/rofi
	mkdir -p .Xresources.d

	base16-manager install nicodebo/base16-fzf
	base16-manager install 0xdec/base16-rofi
	base16-manager install chriskempson/base16-vim
	base16-manager install chriskempson/base16-xresources
	base16-manager install khamer/base16-termite
	base16-manager install khamer/base16-dunst
	base16-manager set materia
}

check_dependencies
setup_dotfiles
setup_vim
set_zsh
setup_colors
tic -x termite.terminfo


