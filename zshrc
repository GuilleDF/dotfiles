# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory beep extendedglob notify
unsetopt autocd nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/gdefermin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit colors
promptinit
colors

source ~/.zsh/antigen/antigen.zsh

antigen bundle git
antigen use oh-my-zsh
antigen theme lukerandall


bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export EDITOR=emacs

source /opt/ros/jade/setup.zsh
export AEROSTACK_WORKSPACE=/home/guillermo/workspace/ros/quadrotor_stack_catkin_ws
export AEROSTACK_STACK=/home/guillermo/workspace/ros/quadrotor_stack_catkin_ws/src/quadrotor_stack
export DRONE_STACK=/home/guillermo/workspace/ros/quadrotor_stack_catkin_ws/src/quadrotor_stack
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'

alias cm='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias ckm='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias ckmp='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --pkg'
