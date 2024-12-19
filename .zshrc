# ZSH
ZSH_THEME="x"
plugins=(git)
export ZSH="/Users/x/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
alias home="cd ~" 
alias dl="cd ~/Downloads"
alias zshrc="nvim ~/.zshrc"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias p="pnpm"
alias i="pnpm install"
alias publish="npm publish --access public"
alias g="git"
alias main="git checkout main"
alias merge="git merge"
alias pull="git pull"
alias push="git push"

function branch() {
  git checkout $1 2> /dev/null
  if [ $? -eq 0 ]; then
    echo "Switched to branch '$1'"
  else
    git checkout -b $1
  fi
}

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
export NODE_VERSION="22.10.0"
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
export PATH="$HOME/.binaryen/binaryen_119/bin:$PATH"
export PATH="$HOME/.wabt/wabt-1.0.35/bin:$PATH"
