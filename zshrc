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

export EDITOR='vim'

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

  chst() {
    _pwd=$PWD
    if [[ "${1:0:1}" = "/" ]] || [[ "${1:0:1}" = "~" ]]; then
      _dir=""
    else
      _dir="$PWD/"
    fi
    cd $AEROSTACK_WORKSPACE
    rm -rf build devel
    cd src
    rm aerostack_stack
    ln -s ${_dir}$1 aerostack_stack
    cd ${_pwd}
  }

  # Completions for these commands
  mkdir -p "$HOME/.zsh/completions"
  echo -e '#compdef cdw \n  _path_files -W $AEROSTACK_WORKSPACE -/' > $HOME/.zsh/completions/_cdw
  echo -e '#compdef cds cki ckni \n  _path_files -W $AEROSTACK_STACK -/' > $HOME/.zsh/completions/_cds

  fpath=($HOME/.zsh/completions $fpath)

  # Source aerostack
  source $AEROSTACK_WORKSPACE/devel/setup.zsh

  # Add launchers to path
  export PATH="$PATH:$AEROSTACK_STACK/launchers"
  echo -e '#compdef aerostack \n  _gnu_generic' > $HOME/.zsh/completions/_aerostack
fi


# Ubuntu aliases
antigen bundle GuilleDF/zsh-ubuntualiases

# Spacemacs alias
alias spacemacs='HOME=$HOME/spacemacs emacs'

# tail -f alias
alias tf='tail -n 500 -f'

antigen apply
unsetopt share_history

PROXY_SERVER=$(host proxygw01.mymhp.net | awk '{print $4}')
PROXY_PORT=3128

proxy_configure() {
  if [[ -a /etc/apt/apt.conf.d/98-proxy ]]; then
    export http_proxy="http://$PROXY_SERVER:$PROXY_PORT/"
    export https_proxy="http://$PROXY_SERVER:$PROXY_PORT/"
    export ftp_proxy="http://$PROXY_SERVER:$PROXY_PORT/"
    export no_proxy="\"localhost,127.0.0.1,localaddress,.localdomain.com\""
    export HTTP_PROXY="http://$PROXY_SERVER:$PROXY_PORT/"
    export HTTPS_PROXY="http://$PROXY_SERVER:$PROXY_PORT/"
    export FTP_PROXY="http://$PROXY_SERVER:$PROXY_PORT/"
    export NO_PROXY="\"localhost,127.0.0.1,localaddress,.localdomain.com\""
    touch $HOME/.proxy_on
  else
    export http_proxy=""
    export https_proxy=""
    export ftp_proxy=""
    export no_proxy=""
    export HTTP_PROXY=""
    export HTTPS_PROXY=""
    export FTP_PROXY=""
    export NO_PROXY=""
    rm -f $HOME/.proxy_on
  fi
}

p() {
  echo "Acquire::http::Proxy \"http://$SERVER:$PORT\";" | sudo tee /etc/apt/apt.conf.d/98-proxy >/dev/null
  gsettings set org.gnome.system.proxy mode 'auto'
  echo "[Service]\nEnvironment=\"HTTP_PROXY=http://$SERVER:$PORT/\" \"HTTPS_PROXY=http://$SERVER:$PORT/\" \"NO_PROXY=localhost,127.0.0.1\"" | sudo tee /etc/systemd/system/docker.service.d/proxy.conf >/dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  proxy_configure
}

np() {
  sudo rm /etc/apt/apt.conf.d/98-proxy
  gsettings set org.gnome.system.proxy mode 'none'
  sudo rm /etc/systemd/system/docker.service.d/proxy.conf
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  proxy_configure
}

proxy_prompt() {
  if [[ -a $HOME/.proxy_on ]]; then
    echo -n "[%{$fg_bold[green]%}proxy%{$reset_color%}] "
  else
    echo -n ''
  fi
}

# custom prompt
export prompt='$(proxy_prompt)%{$fg_bold[blue]%}%2~%{$reset_color%} $(my_git_prompt_info)%{$reset_color%}%B»%b '

