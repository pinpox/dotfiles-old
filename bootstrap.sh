#!/bin/bash
GIT_REPO="https://gitlab.com/binaryplease/dotfiles.git"
CONF_DIR_NAME=".dotfiles"

function backup_conf() {
	while read fn
	do
		echo "working on $fn"
		con="$(dirname $fn)"
		con=".config-backup/$con"
		echo "creating $con"
		mkdir -p $con
		echo "moving $fn to $(realpath	$con)"
		mv $fn $(realpath $con)
	done
}

function set_dotfiles() {
	cd ~
	git clone --bare $GIT_REPO $HOME/$CONF_DIR_NAME
	function config {
		/usr/bin/git --git-dir=$HOME/$CONF_DIR_NAME/ --work-tree=$HOME $@
	}
	echo "$CONF_DIR_NAME" >> .gitignore
	mkdir -p .config-backup
	echo "Backing up pre-existing dot files.";
	config checkout 2>&1 | grep '^\s' | awk {'print $1'} | backup_conf
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
set_dotfiles
# set_zsh


