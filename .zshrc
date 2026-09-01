### Aliases
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
alias snapshot="doas btrfs subvolume snapshot -r / /.snapshots/root-$(date +%d%m%Y)"

### Path`s
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/llama.cpp/build/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

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
