#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset r rate 200 100
export TERMINAL=termite
xrdb ~/.Xresources
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#setxkbmap -layout us,us -variant colemak, -option grp:alt_shift_toggle -option "caps:escape"
# setxkbmap -layout us,us -variant colemak, -option grp:alt_shift_toggle -option "caps:escape"
xmodmap .Xmodmap

export SSH_AUTH_SOCK
xbindkeys
exec i3

if [ -x /usr/bin/nm-applet ] ; then
nm-applet --sm-disable &
fi

