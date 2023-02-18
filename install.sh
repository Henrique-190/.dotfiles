#----------------------------------------------> Functions
print (){
    if [ "$1" == true ]
    then
        echo -e $2;
    else
        echo -e "\e[1A\e[K"$2;
    fi
}

execute (){
    if [ "$1" == true ]
    then
        $2;
    else
        $2 >> $3 2>> $3;
    fi
    return $?;
}



#----------------------------------------------> Variables
DIRNAME="$( dirname -- "$0"; )/"
if [ "$DIRNAME" = "./" ]; then
    DIRNAME="";
fi
PWD=$( pwd; )"/"$DIRNAME;

if [ "$1" = "-d" ]; then DEBUG=true; else DEBUG=false; fi

LOGFOLDER=$PWD"logs/"
TEMPFOLDER=$PWD"temp/"

apts=(chrome-gnome-shell dbus-x11 gettext gir1.2-gmenu-3.0 git gnome-control-center gnome-menus 
gnome-shell-extensions gnome-tweaks libgettextpo-dev make mysql-server sassc wget)

snaps=("--classic code" "clion --classic" discord "intellij-idea-ultimate --classic" 
mysql-workbench-community "pycharm-professional --classic" snapd spotify "sublime-text --classic" vlc)

COLUMNS=$(tput cols) 

header=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Installing pkgs  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
footer=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Install completed <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"


if [ "$DEBUG" == false ]; then clear; fi



#----------------------------------------------> Update and Upgrade
echo -e "\033[1;33m> Updating\033[0m";
touch $LOGFOLDER"update.log";
execute $DEBUG "sudo apt update -y" $LOGFOLDER"update.log";
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> Update: The command failed. Check "$LOGFOLDER"update.log\033[0m";
    
    echo -e "\033[1;33m> Upgrading\033[0m";
    touch $LOGFOLDER"upgrade.log";
    execute $DEBUG "sudo apt upgrade -y" $LOGFOLDER"upgrade.log";
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> Upgrade: The command failed. Check "$LOGFOLDER"upgrade.log\033[0m";
    else
        print $DEBUG "\033[0;32m> Upgrade: Upgraded\033[0m";
        rm $LOGFOLDER"upgrade.log";
    fi
else
    print $DEBUG "\033[0;32m> Update: Updated\033[0m";
    rm $LOGFOLDER"update.log";
fi



#----------------------------------------------> Log and Temp Folder
mkdir -p $LOGFOLDER;
mkdir -p $TEMPFOLDER;

printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header";



#----------------------------------------------> Install APT
for i in "${apts[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    touch $logfile;
    echo -e "\033[1;33m> Installing $i\033[0m";
    execute $DEBUG "sudo apt install $i -y" $logfile;
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> $i: The command failed. Check "$logfile"\033[0m";
    else
        print $DEBUG "\033[0;32m> $i: Installed\033[0m";
        rm $logfile
    fi
done



#----------------------------------------------> Install SNAP
for i in "${snaps[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    touch $logfile;
    echo -e "\033[1;33m> Installing $i\033[0m";
    execute $DEBUG "sudo snap install $i" $logfile;
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> $i: The command failed. Check "$logfile"\033[0m";
    else
        print $DEBUG "\033[0;32m> $i: Installed\033[0m";
        rm $logfile
    fi
done


cd temp;



#----------------------------------------------> Install Chrome
echo -e "\033[1;33m> Downloading Chrome\033[0m";
logfile=$LOGFOLDER"chrome.log";
touch $logfile;
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > $logfile 2>$logfile;
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> Chrome: Download failed. Check $logfile\033[0m";
else
    print $DEBUG "\033[0;32m> Chrome: Downloaded\033[0m";
    echo -e "\033[1;33m> Installing Chrome\033[0m";
    execute $DEBUG "sudo dpkg -i google-chrome-stable_current_amd64.deb" $logfile;
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> Chrome: Installation failed. Check $logfile\033[0m";
    else
        print $DEBUG "\033[0;32m> Chrome: Installed\033[0m";
        rm $logfile
    fi
    rm google-chrome-stable_current_amd64.deb;
fi



#----------------------------------------------> Install JDK 19
echo -e "\033[1;33m> Downloading JDK 19\033[0m";
logfile=$LOGFOLDER"jkd19.log";
touch $logfile;
execute $DEBUG "wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb" $logfile;
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> JDK 19: Download failed. Check $logfile\033[0m";
else
    print $DEBUG "\033[0;32m> JDK 19: Downloaded\033[0m";
    echo -e "\033[1;33m> Installing JDK 19\033[0m";
    sudo apt-get -qqy install ./jdk-19_linux-x64_bin.deb > $logfile 2>$logfile;
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> JDK 19: Installation failed. Check $logfile\033[0m";
    else
        print $DEBUG "\033[0;32m> JDK 19: Installed\033[0m";
        execute $DEBUG "sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19/bin/java 1919";
        rm $logfile
    fi
    rm jdk-19_linux-x64_bin.deb;
fi



#----------------------------------------------> Install and apply Orchis-Theme
echo -e "\033[1;33m> Cloning Orchis-Theme\033[0m";
logfile=$LOGFOLDER"orchisTheme.log";
touch $logfile;
execute $DEBUG "git clone https://github.com/vinceliuice/Orchis-theme.git" $logfile;
if [ $? -eq 0 ]
then
    print $DEBUG "\033[0;32m> Orchis-Theme: Cloned\033[0m";
    echo -e "\033[1;33m> Installing Orchis-Theme\033[0m";
    cd Orchis-theme;
    execute $DEBUG "./install.sh -l -c dark" $logfile;
    if [ $? -eq 0 ]
    then
        print $DEBUG "\033[0;32m> Orchis-Theme: Installed\033[0m";
    else
        print $DEBUG "\033[0;31m> Orchis-Theme: Installation failed. Check $logfile\033[0m";
    fi
    cd ..;
else
    print $DEBUG "\033[0;31m> Orchis-Theme: Clone failed. Check $logfile\033[0m";
fi




#----------------------------------------------> Install and apply Orchis-Icons
echo -e "\033[1;33m> Cloning Orchis-Icons\033[0m";
logfile=$LOGFOLDER"OrchisIcons.log";
touch $logfile;
execute $DEBUG "git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git" $logfile;
if [ $? -eq 0 ]
then
    print $DEBUG "\033[0;32m> Orchis-Icons: Cloned\033[0m";
    echo -e "\033[1;33m> Installing Orchis-Icons\033[0m";
    cd Tela-circle-icon-theme;
    execute $DEBUG "./install.sh -c orange" $logfile;
    if [ $? -eq 0 ]
    then
        print $DEBUG "\033[0;32m> Orchis-Icons: Installed\033[0m";
    else
        print $DEBUG "\033[0;31m> Orchis-Icons: Installation failed. Check $logfile\033[0m";
    fi
    cd ..;
else
    print $DEBUG "\033[0;31m> Orchis-Icons: Clone failed. Check $logfile\033[0m";
fi


echo -e "\033[1;33m> Cloning Dash to Panel\033[0m";
logfile=$LOGFOLDER"dash-to-panel.log";
touch $logfile;
execute $DEBUG "git clone https://github.com/home-sweet-gnome/dash-to-panel.git" $logfile;
if [ "$?" -eq 0 ]
then
    cd dash-to-panel;
    print $DEBUG "\033[1;33m> Installing Dash to Panel\033[0m";
    execute $DEBUG "make install" $logfile;
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32m> Dash to Panel installed\033[0m";
    else
        print $DEBUG "\033[0;31m> Dash to Panel installation failed. Check $logfile\033[0m";
        exit 1;
    fi
    cd ..;
else
    print $DEBUG "\033[0;31m> Dash to Panel cloning failed. Check $logfile\033[0m";
    exit 1;
fi



#----------------------------------------------> ArcMenu
echo -e "\033[1;33m> Cloning ArcMenu\033[0m";
logfile=$LOGFOLDER"arcmenu.log";
touch $logfile;
execute $DEBUG "git clone https://gitlab.com/arcmenu/ArcMenu.git" $logfile;
if [ "$?" -eq 0 ]
then
    cd ArcMenu;
    print $DEBUG "\033[1;33m> Installing ArcMenu\033[0m";
    execute $DEBUG "make install" $logfile;
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32m> ArcMenu installed\033[0m";
    else
        print $DEBUG "\033[0;31m> ArcMenu installation failed. Check $logfile\033[0m";
        exit 1;
    fi
    cd ..;
else
    print $DEBUG "\033[0;31m> ArcMenu cloning failed. Check $logfile\033[0m";
    exit 1;
fi



cd ..;
sudo rm -rf temp;

printf "%*s\n" $(((${#footer}+$COLUMNS)/2)) "$footer";