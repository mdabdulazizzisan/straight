#!/bin/bash

# Package name mappings for different package managers
# Format: declare -A PACKAGE_MAP_<normalized_software_name>=(
#   [apt]="package_name"
#   [dnf]="package_name"
#   [pacman]="package_name"
#   [flatpak]="package_name"
#   [snap]="package_name"
# )

# LibreOffice
declare -A PACKAGE_MAP_libreoffice=(
    [apt]="libreoffice"
    [dnf]="libreoffice"
    [pacman]="libreoffice-fresh"
    [flatpak]="org.libreoffice.LibreOffice"
    [snap]="libreoffice"
)

# GIMP
declare -A PACKAGE_MAP_gimp=(
    [apt]="gimp"
    [dnf]="gimp"
    [pacman]="gimp"
    [flatpak]="org.gimp.GIMP"
    [snap]="gimp"
)

# VLC
declare -A PACKAGE_MAP_vlc=(
    [apt]="vlc"
    [dnf]="vlc"
    [pacman]="vlc"
    [flatpak]="org.videolan.VLC"
    [snap]="vlc"
)

# Firefox
declare -A PACKAGE_MAP_firefox=(
    [apt]="firefox"
    [dnf]="firefox"
    [pacman]="firefox"
    [flatpak]="org.mozilla.firefox"
    [snap]="firefox"
)

# Visual Studio Code
declare -A PACKAGE_MAP_vscode=(
    [apt]="code"
    [dnf]="code"
    [pacman]="code"
    [flatpak]="com.visualstudio.code"
    [snap]="code"
)

# Steam
declare -A PACKAGE_MAP_steam=(
    [apt]="steam"
    [dnf]="steam"
    [pacman]="steam"
    [flatpak]="com.valvesoftware.Steam"
    [snap]="steam"
)

# OBS Studio
declare -A PACKAGE_MAP_obs=(
    [apt]="obs-studio"
    [dnf]="obs-studio"
    [pacman]="obs-studio"
    [flatpak]="com.obsproject.Studio"
    [snap]="obs-studio"
)

# Spotify
declare -A PACKAGE_MAP_spotify=(
    [apt]="spotify-client"
    [dnf]="spotify-client"
    [flatpak]="com.spotify.Client"
    [snap]="spotify"
)

# Git
declare -A PACKAGE_MAP_git=(
    [apt]="git"
    [dnf]="git"
    [pacman]="git"
    [snap]="git"
)

# Blender
declare -A PACKAGE_MAP_blender=(
    [apt]="blender"
    [dnf]="blender"
    [pacman]="blender"
    [flatpak]="org.blender.Blender"
    [snap]="blender"
)

# VirtualBox
declare -A PACKAGE_MAP_virtualbox=(
    [apt]="virtualbox"
    [dnf]="VirtualBox"
    [pacman]="virtualbox"
)

# Inkscape
declare -A PACKAGE_MAP_inkscape=(
    [apt]="inkscape"
    [dnf]="inkscape"
    [pacman]="inkscape"
    [flatpak]="org.inkscape.Inkscape"
    [snap]="inkscape"
)

# Krita
declare -A PACKAGE_MAP_krita=(
    [apt]="krita"
    [dnf]="krita"
    [pacman]="krita"
    [flatpak]="org.kde.krita"
    [snap]="krita"
)

# Shotcut
declare -A PACKAGE_MAP_shotcut=(
    [apt]="shotcut"
    [dnf]="shotcut"
    [pacman]="shotcut"
    [flatpak]="org.shotcut.Shotcut"
    [snap]="shotcut"
)

# Dropbox
declare -A PACKAGE_MAP_dropbox=(
    [apt]="dropbox"
    [dnf]="dropbox"
    [pacman]="dropbox"
    [snap]="dropbox"
)

# Sublime Text
declare -A PACKAGE_MAP_sublimetext=(
    [apt]="sublime-text"
    [dnf]="sublime-text"
    [pacman]="sublime-text"
    [snap]="sublime-text"
)

# Kdenlive
declare -A PACKAGE_MAP_kdenlive=(
    [apt]="kdenlive"
    [dnf]="kdenlive"
    [pacman]="kdenlive"
    [flatpak]="org.kde.kdenlive"
    [snap]="kdenlive"
)

# Transmission
declare -A PACKAGE_MAP_transmission=(
    [apt]="transmission-gtk"
    [dnf]="transmission-gtk"
    [pacman]="transmission-gtk"
    [flatpak]="com.transmissionbt.Transmission"
)

# MPlayer
declare -A PACKAGE_MAP_mplayer=(
    [apt]="mplayer"
    [dnf]="mplayer"
    [pacman]="mplayer"
)

# TeamViewer
declare -A PACKAGE_MAP_teamviewer=(
    [apt]="teamviewer"
    [dnf]="teamviewer"
    [pacman]="teamviewer"
)

# GParted
declare -A PACKAGE_MAP_gparted=(
    [apt]="gparted"
    [dnf]="gparted"
    [pacman]="gparted"
    [flatpak]="org.gnome.gparted"
)

# Uget
declare -A PACKAGE_MAP_uget=(
    [apt]="uget"
    [dnf]="uget"
    [pacman]="uget"
)

# Calibre
declare -A PACKAGE_MAP_calibre=(
    [apt]="calibre"
    [dnf]="calibre"
    [pacman]="calibre"
    [flatpak]="com.calibre_ebook.calibre"
)

# Wine
declare -A PACKAGE_MAP_wine=(
    [apt]="wine"
    [dnf]="wine"
    [pacman]="wine"
)

# Slack
declare -A PACKAGE_MAP_slack=(
    [apt]="slack"
    [dnf]="slack"
    [flatpak]="com.slack.Slack"
    [snap]="slack"
)

# Zoom
declare -A PACKAGE_MAP_zoom=(
    [apt]="zoom"
    [dnf]="zoom"
    [flatpak]="us.zoom.Zoom"
    [snap]="zoom-client"
)

# FileZilla
declare -A PACKAGE_MAP_filezilla=(
    [apt]="filezilla"
    [dnf]="filezilla"
    [pacman]="filezilla"
)

# BleachBit
declare -A PACKAGE_MAP_bleachbit=(
    [apt]="bleachbit"
    [dnf]="bleachbit"
    [pacman]="bleachbit"
)

# Neovim
declare -A PACKAGE_MAP_neovim=(
    [apt]="neovim"
    [dnf]="neovim"
    [pacman]="neovim"
    [snap]="nvim"
)

# Timeshift
declare -A PACKAGE_MAP_timeshift=(
    [apt]="timeshift"
    [dnf]="timeshift"
    [pacman]="timeshift"
)

# Clementine
declare -A PACKAGE_MAP_clementine=(
    [apt]="clementine"
    [dnf]="clementine"
    [pacman]="clementine"
)

# UFW
declare -A PACKAGE_MAP_ufw=(
    [apt]="ufw"
    [dnf]="ufw"
    [pacman]="ufw"
)

# Nmap
declare -A PACKAGE_MAP_nmap=(
    [apt]="nmap"
    [dnf]="nmap"
    [pacman]="nmap"
)

# htop
declare -A PACKAGE_MAP_htop=(
    [apt]="htop"
    [dnf]="htop"
    [pacman]="htop"
)

# ClamAV
declare -A PACKAGE_MAP_clamav=(
    [apt]="clamav"
    [dnf]="clamav"
    [pacman]="clamav"
)

# Guake
declare -A PACKAGE_MAP_guake=(
    [apt]="guake"
    [dnf]="guake"
    [pacman]="guake"
)

# Redshift
declare -A PACKAGE_MAP_redshift=(
    [apt]="redshift"
    [dnf]="redshift"
    [pacman]="redshift"
)

# Mumble
declare -A PACKAGE_MAP_mumble=(
    [apt]="mumble"
    [dnf]="mumble"
    [pacman]="mumble"
)

# RClone
declare -A PACKAGE_MAP_rclone=(
    [apt]="rclone"
    [dnf]="rclone"
    [pacman]="rclone"
)

# Neofetch
declare -A PACKAGE_MAP_neofetch=(
    [apt]="neofetch"
    [dnf]="neofetch"
    [pacman]="neofetch"
) 