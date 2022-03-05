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

syncCombined() {
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "3" ".." " Syncing combined configs"
    rsync -aq --delete --exclude '*.cbor' $(echo "${combinedLIST[@]}") ./combined/
}

syncBin() {
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "3" ".." " Syncing ~/.local/bin/ scripts"
    rsync -aq --delete $(echo "${binLIST[@]}") ./other/bin/
}

syncNormal() {
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "3" ".." " Syncing configs for $1"
    rsync -aq --delete $(echo "${normalLIST[@]}") ./$1/
}

handleYesNo() {
    selections=(
        "no"
        "yes"
    )
    choose_from_menu "$1" selected_choice "${selections[@]}"
    if [ "$selected_choice" == "yes" ]; then
        return 0
    else
        return 1
    fi
}

binExt="/home/$USER/.local/bin"
homeCfgExt="/home/$USER/.config"
homeExt="/home/$USER"

combinedLIST=(
    "$homeCfgExt/kitty"
    "$homeCfgExt/ncspot"
    "$homeCfgExt/pacwall"
    "$homeCfgExt/nano"
    "$homeCfgExt/picom"
    "$homeCfgExt/zathura"
    "$homeExt/.bashrc"
)

normalLIST=(
    "$homeCfgExt/dunst"
    "$homeCfgExt/herbstluftwm"
    "$homeCfgExt/qtile"
    "$homeCfgExt/polybar"
    "$homeCfgExt/rofi"
    "$homeCfgExt/leftwm"
    "$homeCfgExt/scripts"
)

binLIST=(
    "$binExt/mntExt"
    "$binExt/sharePwnagotchy"
)

selections=(
    "pc"
    "laptop"
)

clear
choose_from_menu "What device are you on?" selected_choice "${selections[@]}"

platform="$selected_choice"

if handleYesNo "Include normal?"; then
    syncNormal $platform
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " Done"
fi

if handleYesNo "Include combined?"; then
    syncCombined
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " Done"
fi

if handleYesNo "Include ~/.local/bin/ scripts?"; then
    syncBin
    printf "[\e[1m\e[9%sm%s\e[0m]%s\n" "2" "✓" " Done"
fi

exiting
