#!/usr/bin/sh

for file in $(ls); do
    [ "$1" = "--safe" ] && [ -e ~/.$file ] &&
	echo "Warning: ~/.$file exists, backed up to ~/.${file}~"
    [ "$file" = "LICENSE" ] || [ "$file" = "linkfiles.sh" ] &&
	continue
    ln -sb dotfiles/$file ~/.$file
done
