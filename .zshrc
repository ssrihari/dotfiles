# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
if [ -s $HOME/.oh-my-zsh-custom ]; then
    ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [ -n $ZSH_CUSTOM ] && [ -f $ZSH_CUSTOM/`whoami`.zsh-theme ]; then
    ZSH_THEME="whoami"
else
    ZSH_THEME="kitallis-darkblood"
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git rbenv ruby gem brew)

DISABLE_UPDATE_PROMPT=true # will auto update without prompt
#DISABLE_AUTO_UPDATE="true" # will disable auto updates entirely

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

# general
alias la="ls -lach"
alias lsd="ls | grep ^d"
which ack >> /dev/null || alias ack=ack-grep

alias v="vagrant"
alias i="brew install"
alias up="brew upgrade"

export HISTFILE=~/.zhistory

# git aliases
alias gst='git st'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias glg='git lg'
alias z='j'
# directory options
setopt auto_cd
setopt auto_pushd
alias emacs="open -na /Applications/Emacs.app/Contents/MacOS/Emacs ."

# paths -------------------------------------------------------
export PATH="$HOME/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home)"
export PROTOBUF_HOME="/Users/sriharisriraman/work/stapleslabs/protobuf-2.5.0"

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# rbenv -------------------------------------------------------
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
