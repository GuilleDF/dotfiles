#!/bin/sh

for file in $(ls); do
  if [ "$file" = "LICENSE" ] || [ "$file" = "linkfiles.sh" ] || [ "$file" = "config" ]; then
    continue
  fi
  if [ -e ~/.$file ]; then
	  echo "Warning: ~/.$file exists, backed up to ~/.${file}.bkp"
	  rm -rf ~/.${file}.bkp
    mv ~/.$file ~/.${file}.bkp
  fi
  ln -s dotfiles/$file ~/.$file
done

for file in $(ls config); do
  ln -s dotfiles/config/$file ~/.config/$file
done
