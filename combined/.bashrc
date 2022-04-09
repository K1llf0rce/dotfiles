#       __               __                    __  ___________
#      / /_  ____ ______/ /_  __________      / /_<  / __/ __ \
#     / __ \/ __ `/ ___/ __ \/ ___/ ___/_____/ //_/ / /_/ / / /
#  _ / /_/ / /_/ (__  ) / / / /  / /__/_____/ ,< / / __/ /_/ /
# (_)_.___/\__,_/____/_/ /_/_/   \___/     /_/|_/_/_/  \____/

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# exports
export TERM="xterm-256color"
export PATH="$PATH:/home/k1f0/.local/bin"

# archive extraction
ex () {
  if [ -z "$1" ] ; then
    echo "No input"
  elif [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"    && echo "done" ;;
      *.tar.gz)    tar xzf "$1"    && echo "done" ;;
      *.bz2)       bunzip2 "$1"    && echo "done" ;;
      *.rar)       unrar x "$1"    && echo "done" ;;
      *.gz)        gunzip "$1"     && echo "done" ;;
      *.tar)       tar xf "$1"     && echo "done" ;;
      *.tbz2)      tar xjf "$1"    && echo "done" ;;
      *.tgz)       tar xzf "$1"    && echo "done" ;;
      *.zip)       unzip "$1"      && echo "done" ;;
      *.Z)         uncompress "$1" && echo "done" ;;
      *.7z)        7z x "$1"       && echo "done" ;;
      *.deb)       ar x "$1"       && echo "done" ;;
      *.tar.xz)    tar xf "$1"     && echo "done" ;;
      *.tar.zst)   unzstd "$1"     && echo "done" ;;
      *)           echo "'$1': unsupported filetype" ;;
    esac
  else
    echo "'$1': is invalid"
  fi
}

# to encr-archive
ncryptArch() {
  if [ -n "$1" ]; then
    read -esp "Enter Passphrase: " pass
    tar -czf - $1 | gpg -c --cipher-algo AES256 --s2k-digest-algo SHA512 \
    --s2k-count 100000 --no-symkey-cache \
    --passphrase $pass --batch > $(echo $1 | tr -d '/').tar.gz.gpg
  else
    echo "No Input"
  fi
}

# encr-archive decryption
dcryptArch() {
  if [ -n "$1" ]; then
    read -esp "Enter Passphrase: " pass
    gpg -d --no-symkey-cache --passphrase $pass --batch $1 | tar -xzf -
  else
    echo "No Input"
  fi
}

# base replacement aliases
alias ps="procs"
alias tree="exa -Tg@"
alias ls="exa -1g@ --icons"
alias ll="exa -g@lhUm"
alias la="exa -1g@a --icons"
alias lla="exa -g@lahUm"
alias cat="bat --plain --style grid"
alias find="fd -p"
alias du="dust"

# update aliases
alias mirup="doas reflector -f 10 -l 10 -c ch,at -n 10 --verbose --save /etc/pacman.d/mirrorlist"
alias cup='doas pacman -Rs $(pacman -Qtdq)'
alias aurup='paru -aSyu'
alias flatup='flatpak update'
alias gpgup='gpg --refresh-keys --keyserver hkps://keys.openpgp.org'

# typos
alias pdw="pwd"
alias chwon="chown"

# git aliases
alias gts="git status"
alias gta="git add"
alias gtc="git commit"
alias gtp="git push"
alias gtu="git pull"
alias gtcl="git clone"

# more aliases (req youtube-dl, nmap)
alias yt2audio="youtube-dl -f bestaudio"
alias pingscan="nmap -sP"
alias whatislove='echo "baby don\`t hurt me"'

# prompt
CURSIVE="\[\e[3m\]"
BOLD="\[\e[1m\]"
COLOR="\[\e[35m\]"
END="\[\e[0m\]"
#PS1="${BOLD}${CURSIVE}${COLOR}\W${END} > "
eval "$(starship init bash)"