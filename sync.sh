#!/bin/bash

# "bash strict mode"
set -uo pipefail

# give user feedback
scriptFeedback() {
    case $1 in
        prompt)
            printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "3" "?" " $2" 
            ;;
        error)
            printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "1" "✗" " $2" 
            ;;
        success)
            printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " $2" 
            ;;
        proc)
            printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "3" ".." " $2" 
            ;;
        normExit)
            printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "1" "/" " $2" 
            ;;
    esac
}

binExt="./other/bin"
combExt="./combined"

combinedLIST=(
    "$combExt/kitty"
    "$combExt/ncspot"
    "$combExt/nano"
    "$combExt/picom"
    "$combExt/zathura"
    "$combExt/paru"
    "$combExt/easyeffects"
    "$combExt/starship.toml"
    "$combExt/electron-flags.conf"
    "$combExt/electron16-flags.conf"
    "$combExt/electron17-flags.conf"
    "$combExt/Thunar"
)

binLIST=(
    "$binExt/mntExt"
    "$binExt/mntSMB"
    "$binExt/sharePwnagotchy"
    "$binExt/barrierLayout"
    "$binExt/kvmLayout"
    "$binExt/rsyncToShare"
    "$binExt/clnJnk"
)

scriptFeedback proc "Syncing combined configs"
/bin/rsync -aq --delete $(echo "${combinedLIST[@]}") /home/$USER/.config/
/bin/rsync -aq --delete ./combined/.bashrc /home/$USER/
scriptFeedback success "Done"

scriptFeedback proc "Syncing ~/.local/bin/ scripts"
/bin/rsync -aq --delete $(echo "${binLIST[@]}") /home/$USER/.local/bin/
scriptFeedback success "Done"

exit 0
