# ZSH
ZSH_THEME="x"
plugins=(git)
export ZSH="/Users/x/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
alias dl="cd ~/Downloads"
alias td="torrent download"
alias zshrc="nvim ~/.zshrc"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias publish="npm publish --access public"
alias p="pnpm"
alias i="pnpm install"
alias dev="bun dev"
alias add="git add"
alias branch="git branch"
alias checkout="git checkout"
alias commit="git commit"
alias main="git checkout main"
alias merge="git merge"
alias pull="git pull"
alias push="git push"
alias status="git status"

function repos() {
  cd ~/.repos/$1
}

function work() {
  if [ -z "$WORK_BRANCH" ]; then
    if [ -z "$1" ]; then
      echo "Usage: work <branch-name>"
      return 1
    fi
    if [ "$1" = "-b" ]; then
      export WORK_BRANCH=$2
    else 
      export WORK_BRANCH=$1
    fi
    git checkout $1 $2
  else 
    git checkout "$WORK_BRANCH"
  fi
}

# nvim
export PATH="$HOME/.nvim/bin:$PATH"
export PATH="$HOME/.ripgrep:$PATH"
export PATH="$HOME/.fd:$PATH"

# golang
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# zig
export ZIG_VERSION="0.13.0"
export ZIG_INSTALL="$HOME/.zig/zig-$ZIG_VERSION"
export PATH="$ZIG_INSTALL:$PATH"

# node
export NODE_VERSION="20.19.2"
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

# other tools
export PATH="$HOME/.binaryen/binaryen_123/bin:$PATH"
export PATH="$HOME/.wabt/wabt-1.0.35/bin:$PATH"
