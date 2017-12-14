#!/bin/bash

GIT_REPO="https://gitlab.com/binaryplease/dotfiles.git"
CONF_DIR_NAME=".dotfiles"

function set_dotfiles() {
	cd ~
	git clone --bare $GIT_REPO $HOME/$CONF_DIR_NAME
	function config {
		/usr/bin/git --git-dir=$HOME/$CONF_DIR_NAME/ --work-tree=$HOME $@
	}
	echo "$CONF_DIR_NAME" >> .gitignore
	mkdir -p .config-backup
	config checkout
	if [ $? = 0 ]; then
		echo "Checked out config.";
	else
		echo "Backing up pre-existing dot files.";
		config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
	fi;
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
set_zsh
