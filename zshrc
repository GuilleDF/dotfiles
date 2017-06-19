HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch share_history
bindkey -e

autoload -U compinit
compinit

ANTIGEN_DIR="$HOME/.zsh/antigen"
if [[ ! -d "$ANTIGEN_DIR" ]]; then
  git clone https://github.com/zsh-users/antigen.git $ANTIGEN_DIR
fi

source $ANTIGEN_DIR/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen theme lukerandall

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

export EDITOR='atom -w'

# Only run work-related code if ros is installed
if [ -d '/opt/ros/kinetic' ]; then
  antigen bundle GuilleDF/zsh-rosaliases

  source /opt/ros/kinetic/setup.zsh
  export AEROSTACK_WORKSPACE=$HOME/workspace/ros/aerostack_catkin_ws
  export AEROSTACK_STACK=$AEROSTACK_WORKSPACE/src/aerostack_stack
  export DRONE_STACK=$AEROSTACK_STACK
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'

  EMACS_FLAG='-DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
  PYTHON_FLAGS=''
  if [[ "$(python --version | awk '{print $2}' | awk -F '.' '{print $1}')" == "3" ]] &>/dev/null; then
    PYTHON_FLAGS="$PYTHON_FLAGS -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYTHON_INCLUDE_DIR=/usr/include/python2.7"
    PYTHON_FLAGS="$PYTHON_FLAGS -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so"
  fi

  CM_FLAGS="$EMACS_FLAG $PYTHON_FLAGS"

  alias cm="cmake $CM_FLAGS"

  catkin_command() {
    dir=$PWD
    cd $AEROSTACK_WORKSPACE
    $@
    source devel/setup.zsh
    cd $dir
  }

  ckm() {
    catkin_command catkin_make $CM_FLAGS $@
  }

  ckmh() {
    AEROSTACK_WORKSPACE=$(pwd) AEROSTACK_STACK="$AEROSTACK_WORKSPACE/src/aerostack_stack" catkin_command catkin_make $CM_FLAGS $@
  }

  alias ckmp="ckm --pkg"

  ct() {
    if [[ $1 =~ '.*process.*' ]]; then
      catkin_command catkin_make $1_test && rostest $1 $1.launch
    else
      catkin_command catkin_make run_tests_$1_gtest_$1_test
    fi
  }

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
  mkdir -p "$HOME/.zsh/completions"
  echo -e '#compdef cdw \n  _path_files -W $AEROSTACK_WORKSPACE -/' > $HOME/.zsh/completions/_cdw
  echo -e '#compdef cds cki ckni \n  _path_files -W $AEROSTACK_STACK -/' > $HOME/.zsh/completions/_cds

  fpath=(~/.zsh/completions $fpath)
  autoload -U _cds _cdw

  # Source aerostack
  source $AEROSTACK_WORKSPACE/devel/setup.zsh

  # Add launchers to path
  export PATH="$PATH:$AEROSTACK_STACK/launchers"
  compdef _gnu_generic aerostack
fi


# Ubuntu aliases
antigen bundle GuilleDF/zsh-ubuntualiases

# Spacemacs alias
alias spacemacs='HOME=$HOME/spacemacs emacs'

# tail -f alias
alias tf='tail -n 500 -f'

export PATH="$PATH:$HOME/miniconda2/bin"

antigen apply
