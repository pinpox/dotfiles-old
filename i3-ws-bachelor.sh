#!/bin/bash


i3-msg "workspace 3; append_layout i3-workspace-ba.json"
evince ~/Documents/FH/Bachelorarbeit/bachelorarbeit/Latex/src/Hauptdatei.pdf &
termite -t "Bachelorarbeit Editor" --hold -d "Documents/FH/Bachelorarbeit/bachelorarbeit/Latex/src" &
chromium &
