# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch share_history
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/gdefermin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

ANTIGEN_DIR="~/.zsh/antigen"
if [[ ! -d "$ANTIGEN_DIR" ]]; then
  git clone https://github.com/zsh-users/antigen.git $ANTIGEN_DIR
fi

source $ANTIGEN_DIR/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen theme lukerandall
antigen apply

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

export EDITOR=emacs

source /opt/ros/jade/setup.zsh
export AEROSTACK_WORKSPACE=$HOME/workspace/ros/aerostack_catkin_ws
export AEROSTACK_STACK=$AEROSTACK_WORKSPACE/src/aerostack_stack
export DRONE_STACK=$AEROSTACK_STACK
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'

alias cm='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias ckm='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias ckmp='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --pkg'

cki() {
    touch $AEROSTACK_STACK/$1/CATKIN_IGNORE
}

ckni() {
    rm $AEROSTACK_STACK/$1/CATKIN_IGNORE
}

# Ubuntu aliases
alias ai='sudo apt-get install'
alias au='sudo apt-get update'
alias as='apt-cache search'
alias appa='sudo add-apt-repository'

# cd to workspace/stack
cdw() {
    cd $AEROSTACK_WORKSPACE/$1
}
cds() {
    cd $AEROSTACK_STACK/$1
}
# Completions for these commands
_cdw() {
    _path_files -W $AEROSTACK_WORKSPACE -/
}
_cds() {
    _path_files -W $AEROSTACK_STACK -/
}
compdef _cds cds
compdef _cdw cdw

compdef _cds cki
compdef _cds ckni

# Spacemac alias
alias spacemacs='HOME=$HOME/spacemacs emacs'

# Source aerostack
source $AEROSTACK_WORKSPACE/devel/setup.zsh

# tail -f alias
alias tf='tail -n 500 -f'
