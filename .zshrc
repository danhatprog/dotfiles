autoload -U colors && colors

export TERM="xterm-256color"

ZSH_THEME="my_theme"

plugins=(git)

source ~/.oh-my-zsh/oh-my-zsh.sh

export LANG=en_US.UTF-8
export PATH="$HOME/.cargo/bin:$PATH"

alias ls="eza --color=always --long --sort=name --no-filesize --icons=always --all --no-time --no-user --no-permissions --group-directories-first"
alias lstree="eza --all --tree"
alias icat="kitten icat"
alias zrc="cd ~ && nvim .zshrc"
alias zsrc="source ~/.zshrc"
alias ztheme="cd ~/.oh-my-zsh/themes"
alias grc="cd ~/.config/ghostty && nvim ."
alias vrc="cd ~/.config/nvim && nvim ."
alias hrc="cd ~/.config/hypr && nvim ."
alias logo="clear && fastfetch"

eval "$(zoxide init zsh)"
# alias cd="z"

eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#808080"
export FZF_TMUX_OPTS=" -p90%,70% "

export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

DISABLE_AUTO_TITLE="true"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export XCURSOR_THEME="macos-cursors"
export XCURSOR_SIZE=30
