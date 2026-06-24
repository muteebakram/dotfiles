# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

autoload -Uz add-zsh-hook
setopt prompt_subst

_git_prompt_part() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

    local branch stats
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    [[ -n "${branch}" ]] || branch=$(git rev-parse --short HEAD 2>/dev/null)

    # Escape % so branch names cannot be interpreted as zsh prompt escapes.
    branch=${branch//\%/%%}

    stats=$(git --no-pager status --porcelain=v1 2>/dev/null | awk '
  /^\?\?/ {a++; next}
  {
    x=substr($0,1,1); y=substr($0,2,1)
    if (x=="A" || y=="A") a++
    else if (x=="D" || y=="D") d++
    else if (x=="M" || y=="M" || x=="R" || y=="R" || x=="C" || y=="C" || x=="T" || y=="T") m++
  }
  END {
    sep=""
    if (a) {printf "%s+%d", sep, a; sep=" "}
    if (d) {printf "%s-%d", sep, d; sep=" "}
    if (m) {printf "%s±%d", sep, m; sep=" "}
  }')

    print -r -- "󰊢 $branch${stats:+ $stats}"
}

_update_prompt_git() {
    local part=$(_git_prompt_part)
    if [[ -n "${part}" ]]; then
        GIT_PROMPT="%F{cyan}${part}%f"
    else
        GIT_PROMPT=
    fi
}

add-zsh-hook precmd _update_prompt_git
# Avoid spurious "%" lines with a leading-newline prompt.
unsetopt prompt_cr prompt_sp
NEWLINE=$'\n'
PROMPT='${NEWLINE}%D{%a/%d %H:%M}${GIT_PROMPT:+ ${GIT_PROMPT}}%F{magenta} ❯%f '

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias t="~/Desktop/Muteeb/Code/Timer/run.sh"
alias ts="~/Desktop/Muteeb/Code/Timer/run.sh -s"
alias tk="~/Desktop/Muteeb/Code/Timer/run.sh -k"
alias tl="~/Desktop/Muteeb/Code/Timer/run.sh -l"
alias tp="~/Desktop/Muteeb/Code/Timer/run.sh -p"
alias tc="~/Desktop/Muteeb/Code/Timer/run.sh -c"
alias twp="while true; do tp; sleep 6; done"
alias m="tmux"
alias f="fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}'"
if command -v codex &>/dev/null; then
    alias ai="codex exec --ephemeral"
fi

# fzf Global UI and Look & Feel
export FZF_DEFAULT_OPTS=" --multi --layout reverse --border rounded --preview-window=right:65%"
# fzf File Search Preview (Ctrl + T)
export FZF_CTRL_T_OPTS="--preview='bat --style=numbers,changes --color=always --line-range :500 {} 2>/dev/null || cat {}' --preview-window right:70%:wrap"
# fzf Directory Search Preview (Alt + C)
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50 2>/dev/null || ls -la {}'"
# fzf Shell History Window (Ctrl + R)
# export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window"

export GOPATH=/opt/homebrew//Cellar/go@1.20/1.20.13/libexec/bin/go

# Start timer outside of tmux.
ts

# Start tmux if not already
if [[ "${TMUX}" == "" ]]; then
    if tmux has-session 2>/dev/null; then
        echo "Attaching tmux ${TMUX}"
        tmux a;
    else
        echo "Starting tmux..."
        tmux
    fi
fi
