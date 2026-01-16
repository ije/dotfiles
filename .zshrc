# ZSH
ZSH_THEME="x"
plugins=(git)
export ZSH="/Users/x/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
alias dl="cd ~/Downloads"
alias zshrc="nvim ~/.zshrc"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias publish="npm publish --access public"
alias dev="bun dev"
alias main="git checkout main && pull"
alias merge="git merge"
alias pull="git pull"
alias push="git push"

function repos() {
  cd ~/.repos/$1
}

function wip() {
  if [ -z "$1" ]; then
    if [ -z "$WIP_BRANCH" ]; then
      echo "Usage: wip [OPTIONS] <branch-name>"
      echo "  OPTIONS:"
      echo "    -b  Create a new branch"
      return 1
    else
      git checkout "$WIP_BRANCH"
    fi
  else
    git checkout $1 $2
    if [ $? -ne 0 ]; then
      return $?
    fi
    if [ "$1" = "-b" ]; then
      export WIP_BRANCH=$2
    else 
      export WIP_BRANCH=$1
    fi
  fi
}

# nvim
export PATH="$HOME/.nvim/bin:$PATH"

# golang
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# zig
export ZIG_VERSION="0.15.2"
export ZIG_INSTALL="$HOME/.zig/zig-$ZIG_VERSION"
export PATH="$ZIG_INSTALL:$PATH"

# node
export NODE_VERSION="24.12.0"
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
# bun completions
[ -s "/Users/x/.bun/_bun" ] && source "/Users/x/.bun/_bun"

# other tools
export PATH="$HOME/.fd:$PATH"
export PATH="$HOME/.ripgrep:$PATH"
export PATH="$HOME/.gh/gh_2.74.2/bin:$PATH"
export PATH="$HOME/.binaryen/binaryen_123/bin:$PATH"
export PATH="$HOME/.rar:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
