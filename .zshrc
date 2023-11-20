# ZSH
ZSH_THEME="x"
plugins=(git)
export ZSH="/Users/x/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
alias home="cd ~" 
alias dl="cd ~/Downloads"
alias zshrc="nvim ~/.zshrc"
alias nvimconf="nvim ~/.config/nvim/init.lua"

function repos() {
  cd ~/.repos/$1
}

# docker
export PATH="$HOME/.docker/bin:$PATH"

# golang
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH="$HOME/.go"
export PATH="$HOME/.go/bin:$PATH"

# zig
export ZIG_INSTALL="$HOME/.zig/zig-0.11.0"
export PATH="$ZIG_INSTALL:$PATH"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# VOLTA
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# tools
export PATH="$HOME/.lazygit:$PATH"
export PATH="$HOME/.ripgrep:$PATH"
export PATH="$HOME/.fd:$PATH"
export PATH="$HOME/.nvim/bin:$PATH"
export PATH="$HOME/.helix:$PATH"
# export PATH="$HOME/.binaryen-113/bin:$PATH"

# completions
[ -s "/Users/x/.bun/_bun" ] && source "/Users/x/.bun/_bun"
