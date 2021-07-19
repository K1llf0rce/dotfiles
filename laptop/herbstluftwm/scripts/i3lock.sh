#!/usr/bin/env bash

B='#00000000'
C='#ffffff11'
D='#ffffffff'
W='#ffffffff'
E='#ff0000ff'
F='#444444ff'

i3lock \
--insidever-color=$B \
--ringver-color=$D \
\
--insidewrong-color=$B \
--ringwrong-color=$E \
\
--inside-color=$B \
--ring-color=$D \
--line-color=$B \
--separator-color=$D \
\
--verif-color=$W \
--wrong-color=$E \
--time-color=$W \
--date-color=$W \
--layout-color=$W \
--keyhl-color=$F \
--bshl-color=$F \
\
--blur 8 \
--clock \
--time-str="%H:%M:%S" \
--date-str="%d.%m.%Y" \
