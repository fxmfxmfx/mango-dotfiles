### Aliases
opencode() {
    HTTP_PROXY=http://127.0.0.1:8080 HTTPS_PROXY=http://127.0.0.1:8080 /usr/bin/opencode "$@"
}

alias neo="neo -D --charset=BIN --speed=5 --colormode=16"
alias etu='doas etc-update --automode -5'
alias ls='eza'
alias l='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree'
alias lta='eza -la --tree'
alias сдуфк='clear'
alias vim='nvim'
alias snapshot='doas btrfs subvolume snapshot -r / /.snapshots/root-$(date +%d%m%Y)'

doas() {
    if [[ $1 == nvim ]]; then
        shift
        command doas env \
            XDG_CONFIG_HOME="$HOME/.config" \
            XDG_DATA_HOME="$HOME/.local/share" \
            XDG_STATE_HOME="$HOME/.local/state" \
            XDG_CACHE_HOME="$HOME/.cache" \
            /usr/bin/nvim "$@"
    else
        command doas "$@"
    fi
}

### Path`s
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/llama.cpp/build/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

### Open directories and text files by path
setopt AUTO_CD

_open_text_file_accept_line() {
    local -a words
    local target encoding
    words=("${(@z)BUFFER}")

    if (( ${#words} == 1 )); then
        target=${(Q)words[1]}
        if [[ $target == '~/'* ]]; then
            target=$HOME/${target#\~/}
        fi

        # Keep existing commands, aliases and functions working normally.
        if [[ -f $target && -r $target ]] &&
            (( ! $+commands[$target] && ! $+builtins[$target] &&
               ! $+functions[$target] && ! $+aliases[$target] )); then
            encoding=$(command file -b --mime-encoding -- "$target" 2>/dev/null)
            if [[ -n $encoding && $encoding != binary ]] || [[ ! -s $target ]]; then
                BUFFER="nvim -- ${(q)target}"
            fi
        fi
    fi

    zle .accept-line
}
zle -N accept-line _open_text_file_accept_line

### Bind-keys
bindkey ';5D' backward-word
bindkey ';5C' forward-word

### Paths
source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
source ~/.zsh/prompt.zsh

### BTRFS Snapshot delete
delsnap() {
    if [ -z "$1" ]; then
        echo "Снапшоты в /.snapshots:"
        ls /.snapshots
        return 1
    fi
    doas btrfs subvolume delete /.snapshots/root-"$1"
}

alias skeet-cfg='cd ~/.steam/steam/steamapps/compatdata/730/pfx/drive_c/users/steamuser/AppData/Local/skeet'
alias skeet-pfx='cd ~/.steam/steam/steamapps/compatdata/730/pfx/drive_c'
