#!/usr/bin/sh

for file in $(ls); do
    [ -e ~/.$file ] &&
	echo "Warning: ~/.$file exists, backed up to ~/.${file}.bkp" &&
	rm -rf ~/.${file}.bkp &&
        mv ~/.$file ~/.${file}.bkp
    [ "$file" = "LICENSE" ] || [ "$file" = "linkfiles.sh" ] &&
	continue
    ln -s dotfiles/$file ~/.$file
done
