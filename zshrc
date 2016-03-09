# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gdefermin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit colors
promptinit
colors

source /usr/share/zsh/scripts/antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme lukerandall


bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# xsd to rnc converter
# USAGE: xsdtornc xsd_file [out_file]
function xsdtornc() { 
    xsltproc ~/xsl/XSDtoRNG.xsl $1 | xsltproc -o ${2:--} ~/xsl/RngToRnc-1_4/RngToRncText.xsl -
}

# Disabled, it slows down the cli
# source /usr/share/doc/pkgfile/command-not-found.zsh

