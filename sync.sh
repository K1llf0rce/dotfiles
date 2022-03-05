#!/bin/bash

# "bash strict mode"
set -uo pipefail

# modified version of https://askubuntu.com/a/1386907
choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e")
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "?" " $prompt"
    while true
    do
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e "> \e[1m\e[92m$o\e[0m"
            else echo -e "  \e[90m$o\e[0m"
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key
        if [[ $key == $esc[A ]]
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]]
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]]
        then break
        fi
        echo -en "\e[${count}A"
    done
    printf -v $outvar "${options[$cur]}"
}

exiting() {
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "1" ".." " Exiting..."
    exit 0
}

binExt="./other/bin"
combExt="./combined"

combinedLIST=(
    "$combExt/kitty"
    "$combExt/ncspot"
    "$combExt/pacwall"
    "$combExt/nano"
    "$combExt/picom"
    "$combExt/zathura"
)

binLIST=(
    "$binExt/mntExt"
    "$binExt/sharePwnagotchy"
)

printf "\e[3m\e[1m%s\e[0m\n" "sync.sh"
sleep 1

printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" ".." " Syncing combined configs"
rsync -aq --delete $(echo "${combinedLIST[@]}") /home/$USER/.config/
rsync -aq --delete ./combined/.bashrc /home/$USER/
printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " Done"

printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" ".." " Syncing ~/.local/bin/ scripts"
rsync -aq --delete $(echo "${binLIST[@]}") /home/$USER/.local/bin/
printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " Done"

exiting
