#! /bin/zsh

source "$ZDOTDIR/exports"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"

# Colors (see: https://github.com/sharkdp/vivid)
export LS_COLORS="$(vivid generate solarized-dark)"

# History Settings
export HISTFILE="$HOME/.local/share/zsh/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY                                           # Immediately append history instead of overwriting
setopt HIST_FIND_NO_DUPS                                        # Do not display duplicates of a line previously found when searching
setopt HIST_IGNORE_ALL_DUPS                                     # If a new command is a duplicate, remove the older one
setopt HIST_IGNORE_DUPS                                         # Do not enter command lines into the history list if they are duplicates of the previous event. 
setopt HIST_IGNORE_SPACE                                        # Don't save commands that start with space
setopt HIST_SAVE_NO_DUPS                                        # When writing out the history file, older commands that duplicate newer ones are omitted. 
setopt INC_APPEND_HISTORY                                       # save commands are added to the history immediately, otherwise only when shell exits.

# Directory Navigation Settings
setopt AUTO_CD                                                  # automatically cd if folder name and no command found
setopt AUTO_LIST                                                # automatically list choices on ambiguous completion
setopt AUTO_MENU                                                # automatically use menu completion
setopt ALWAYS_TO_END                                            # move cursor to end if word had one match
setopt CORRECT                                                  # Auto correct mistakes
zstyle ':completion:*' menu select                              # select completions with arrow keys
zstyle ':completion:*' group-name ''                            # group results by category
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

autoload -U compinit
zmodload zsh/complist
compinit -d "$ZSH_CACHE_DIR/zcompdump"

# GLOB Options
setopt EXTENDED_GLOB                                            # Extended globbing. Allows using regular expressions with *
setopt NO_CASE_GLOB                                             # Case insensitive globbing
setopt NUMERIC_GLOB_SORT                                        # Sort filenames numerically when it makes sense

# Other Options
setopt RC_EXPAND_PARAM                                          # Array expension with parameters
setopt NO_CHECK_JOBS                                            # Don't warn about running processes when exiting
setopt NO_BEEP                                                  # No beep

WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

export EDITOR='nvim'

# Aliases & functions
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/functions"

# Keybindings
zmodload zsh/terminfo
bindkey -e
bindkey '^[[7~' beginning-of-line                               # [Home] - Go to beginning of line
bindkey '^[[H' beginning-of-line                                # [Home] - Go to beginning of line
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # [End] - Go to end of line
bindkey '^[[F' end-of-line                                      # [End] - Go to end of line
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key
bindkey "$terminfo[kcuu1]" history-substring-search-up          # bind UP and DOWN arrow keys to history substring search
bindkey "$terminfo[kcud1]" history-substring-search-down        # bind UP and DOWN arrow keys to history substring search
bindkey '^[[A' history-substring-search-up			                # bind UP and DOWN arrow keys to history substring search
bindkey '^[[B' history-substring-search-down                    # bind UP and DOWN arrow keys to history substring search
bindkey '^[Oc' forward-word                                     # Navigate words with ctrl+arrow keys
bindkey '^[Od' backward-word                                    # Navigate words with ctrl+arrow keys
bindkey '^[[1;5D' backward-word                                 # Navigate words with ctrl+arrow keys
bindkey '^[[1;5C' forward-word                                  # Navigate words with ctrl+arrow keys
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

# Auto ls after cd
list_all() {
  emulate -L zsh
  ls
}
if [[ ${chpwd_functions[(r)list_all]} != "list_all" ]];then
  chpwd_functions=(${chpwd_functions[@]} "list_all")
fi

# Enable calculator
autoload -U zcalc

# Prompt Theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source "$ZDOTDIR/p10k"

# pyenv
eval "$(pyenv init -)"