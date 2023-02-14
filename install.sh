#!/bin/bash

DIRNAME="$( dirname -- "$0"; )/"
if [ "$DIRNAME" = "./" ]; then
    DIRNAME=""
fi
PWD=$( pwd; )"/"$DIRNAME

sh $PWD"bloatware.sh";

sudo apt update -y
sudo apt upgrade -y

#Snap
sudo apt get update
sudo apt install snapd

#Gnome Tweak Tool
sudo apt install gnome-tweaks

#Chrome
sudo apt install wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

#Spotify
sudo snap install spotify

#Discord
sudo snap install discord

#VLC
sudo snap install vlc

#Git
sudo apt install git

#JDK 19
wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb
sudo dpkg -i jdk-19_linux-x64_bin.deb
rm jdk-19_linux-x64_bin.deb

#VSCode
sudo snap install --classic code

#Sublime Text
sudo snap install sublime-text --classic

#MySQL Server and Workbench
sudo apt install mysql-server
sudo snap install mysql-workbench-community

#Flameshot
sudo apt install flameshot

#Personal
mv Personal/openvpn ~
mv Personal/*.desktop ~/Desktop

#Wallpaper
WPPPATH='file://'$PWD'Wallpaper/YHLQMDLG.png'
gsettings set org.gnome.desktop.background picture-uri $WPPPATH


#Install and Apply Orchis-Theme
git clone https://github.com/vinceliuice/Orchis-theme.git
./Orchis-theme/install.sh -l -c light


#Install and apply Tela-Icon
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
./Tela-circle-icon-theme/install.sh -c

