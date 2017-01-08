HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch share_history
bindkey -e

autoload -Uz compinit
compinit

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

# Only run work-related code if ros is installed
if [ -d '/opt/ros/jade' ]; then
  source /opt/ros/jade/setup.zsh
  export AEROSTACK_WORKSPACE=$HOME/workspace/ros/aerostack_catkin_ws
  export AEROSTACK_STACK=$AEROSTACK_WORKSPACE/src/aerostack_stack
  export DRONE_STACK=$AEROSTACK_STACK
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'

  EMACS_FLAG='-DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  PYTHON_FLAGS=''
  if [[ "$(python --version | awk '{print $2}' | awk -F '.' '{print $1}')" == "3" ]]; then
    PYTHON_FLAGS="$PYTHON_FLAGS -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYTHON_INCLUDE_DIR=/usr/include/python2.7"
    PYTHON_FLAGS="$PYTHON_FLAGS -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so"
  fi

  CM_FLAGS="$EMACS_FLAG $PYTHON_FLAGS"

  alias cm="cmake $CM_FLAGS"
  alias ckm="catkin_make $CM_FLAGS"
  alias ckmp="catkin_make $CM_FLAGS --pkg"

  cki() {
    touch $AEROSTACK_STACK/$1/CATKIN_IGNORE
  }

  ckni() {
    rm $AEROSTACK_STACK/$1/CATKIN_IGNORE
  }

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

  # Source aerostack
  source $AEROSTACK_WORKSPACE/devel/setup.zsh
fi


# Ubuntu aliases
alias ai='sudo apt-get install'
alias au='sudo apt-get update'
alias as='apt-cache search'
alias appa='sudo add-apt-repository'


# Spacemacs alias
alias spacemacs='HOME=$HOME/spacemacs emacs'

# tail -f alias
alias tf='tail -n 500 -f'
