
#!/bin/bash


GIT_REPO="https://gitlab.com/binaryplease/dotfiles.git"

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore
git clone --bare $GIT_REPO $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
mkdir -p .config-backup && \
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
	xargs -I{} mv {} .config-backup/{}
config checkout
config config --local status.showUntrackedFiles no
