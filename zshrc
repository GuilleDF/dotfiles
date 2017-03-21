HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch share_history
bindkey -e

autoload -Uz compinit
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
antigen apply

bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

export EDITOR=emacs

# Only run work-related code if ros is installed
if [ -d '/opt/ros/jade' ]; then
  antigen bundle GuilleDF/zsh-rosaliases

  source /opt/ros/jade/setup.zsh
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

  # Add launchers to path
  export PATH="$PATH:$AEROSTACK_STACK/launchers"
fi


# Ubuntu aliases
alias ai='sudo apt-get install'
alias au='sudo apt-get update'
alias aup='sudo apt-get upgrade'
alias ar='sudo apt-get remove'
alias aar='sudo apt-ǵet autoremove'
alias af='apt-file'
alias afu='sudo apt-file update'
alias afs='apt-file search'
alias afl='apt-file list'
alias as='apt-cache search'
alias appa='sudo add-apt-repository'
COLOR_GREEN='\033[0m\033[1m\033[32m'
COLOR_YELLOW='\033[0m\033[1m\033[33m'
COLOR_BLUE='\033[0m\033[1m\033[34m'
COLOR_RESET='\033[0m'
asi () {
  _search=$(apt-cache search $1)
  echo -e ${_search} $COLOR_GREEN $(dpkg-query -f " [Installed]\n" --show alsa-utils 2>/dev/null) $COLOR_RESET | \
    awk -v yl="$COLOR_YELLOW" -v bl="$COLOR_BLUE" -v rst="$COLOR_RESET" '{printf("%s%d) %s%s%s\n", yl, NR, bl, $0, rst)}'
  echo -n "Choose package: " && read _pkg_num
  if [[ ${_pkg_num} =~ [[:digit:]]+ ]]; then
    sudo apt-get install $(echo ${_search} | sed -n ${_pkg_num}p | awk '{print $1}')
  fi
}


# Spacemacs alias
alias spacemacs='HOME=$HOME/spacemacs emacs'

# tail -f alias
alias tf='tail -n 500 -f'
alias todo='emacs TODO.org'
