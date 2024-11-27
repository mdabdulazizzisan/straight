#!/bin/bash

# list of supported softwares:
declare -A SOFTWARE_LIST=(
    ["office"]="libreoffice"       # "office" -> LibreOffice package
    ["brave"]="brave-browser"     # "brave" -> Brave Browser package
    ["vlc"]="vlc"                 # "vlc" -> VLC Media Player
    ["gimp"]="gimp"               # "gimp" -> GIMP Image Editor
)
