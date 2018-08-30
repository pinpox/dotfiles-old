#!/bin/bash

hosts=(zitrone kartoffel tomate sellerie)
commands=('sudo pacman -Syu' 'sudo ./host_backup.sh')

echo "Hosts found: ${#hosts[*]}"
for ix in ${!hosts[*]}
do
	for iy in ${!commands[*]}
	do
		if [[ $(hostname) == ${hosts[$ix]} ]]; then
			printf "Running: '${commands[iy]}' locally on ${hosts[ix]}\n"
			eval ${commands[iy]}
		else
			if ping -c1 -W1 ${hosts[ix]}; then
				printf "Running: '${commands[iy]}' remotely on ${hosts[ix]}\n"
				ssh -t ${hosts[ix]} "${commands[iy]}"
			else
				echo "${hosts[ix]} is offline, skipping"
			fi
		fi
	done
done


