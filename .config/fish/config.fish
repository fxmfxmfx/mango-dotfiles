if status is-interactive
# Commands to run in interactive sessions can go here
end
set fish_greeting

alias clock='tty-clock -crC 7'
alias etu='doas etc-update --automode -5'
alias cat='bat'
alias ls='eza'
alias grep='rg'
alias find='fd'
alias du='dust'

function __restore_cursor_on_preexec --on-event fish_postexec
    printf '\e[5 q'
end

# Locale
set -gx LANG en_US.UTF-8
set -e LC_ALL

# Pallete
set -g fish_color_normal normal
set -g fish_color_command brcyan
set -g fish_color_keyword brmagenta
set -g fish_color_quote brgreen
set -g fish_color_redirection bryellow --bold
set -g fish_color_end brblue
set -g fish_color_error brred --bold
set -g fish_color_param white
set -g fish_color_option bryellow
set -g fish_color_comment brblack
set -g fish_color_selection black --bold --background=brcyan
set -g fish_color_search_match black --background=bryellow
set -g fish_color_operator brmagenta
set -g fish_color_escape brblue
set -g fish_color_autosuggestion brblack
set -g fish_color_cancel brred
set -g fish_color_valid_path --underline

