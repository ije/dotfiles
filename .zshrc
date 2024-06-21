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
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# zig
export ZIG_VERSION="0.13.0"
export ZIG_INSTALL="$HOME/.zig/zig-$ZIG_VERSION"
export PATH="$ZIG_INSTALL:$PATH"

# node
export NODE_VERSION="22.1.0"
export NODE_INSTALL="$HOME/.node/node-$NODE_VERSION"
export PATH="$NODE_INSTALL/bin:$PATH"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# dprint
export DPRINT_INSTALL="$HOME/.dprint"
export PATH="$DPRINT_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# tools
export PATH="$HOME/.nvim/bin:$PATH"
export PATH="$HOME/.lazygit:$PATH"
export PATH="$HOME/.ripgrep:$PATH"
export PATH="$HOME/.fd:$PATH"
export PATH="$HOME/.binaryen-117/bin:$PATH"
