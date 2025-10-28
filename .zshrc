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
alias p="pnpm"
alias i="pnpm install"
alias dev="bun dev"
alias add="git add"
alias branch="git branch"
alias checkout="git checkout"
alias commit="git commit"
alias main="git checkout main && pull"
alias merge="git merge"
alias pull="git pull"
alias push="git push"
alias status="git status"
alias ca="curosr-agent"

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
export PATH="$PATH:$HOME/.nvim/bin"

# golang
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# zig
export ZIG_VERSION="0.11.0"
export ZIG_INSTALL="$HOME/.zig/zig-$ZIG_VERSION"
export PATH="$PATH:$ZIG_INSTALL"

# node
export NODE_VERSION="22.18.0"
export NODE_INSTALL="$HOME/.node/node-$NODE_VERSION"
export PATH="$PATH:$NODE_INSTALL/bin"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"

# dprint
export DPRINT_INSTALL="$HOME/.dprint"
export PATH="$PATH:$DPRINT_INSTALL/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"
# bun completions
[ -s "/Users/x/.bun/_bun" ] && source "/Users/x/.bun/_bun"

# other tools
export PATH="$PATH:$HOME/.fd"
export PATH="$PATH:$HOME/.ripgrep"
export PATH="$PATH:$HOME/.gh/gh_2.74.2/bin"
export PATH="$PATH:$HOME/.binaryen/binaryen_123/bin"
export PATH="$PATH:$HOME/.wabt/wabt-1.0.35/bin"
