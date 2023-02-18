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
        $2 > /dev/null 2> /dev/null;
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

snaps=("--classic code" "clion --classic" discord dbus-x11 "intellij-idea-ultimate --classic" 
mysql-workbench-community "pycharm-professional --classic" snapd spotify "sublime-text --classic" vlc)

apts=(chrome-gnome-shell gettext gir1.2-gmenu-3.0 git gnome-control-center gnome-menus 
gnome-shell-extensions gnome-tweaks libgettextpo-dev make mysql-server wget)

COLUMNS=$(tput cols) 

header=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Installing pkgs  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
footer=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Install completed <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"



#----------------------------------------------> Sudo check
if [ "$EUID" -ne 0 ]
then 
    echo "Please enter your password to run this script.";
    sudo -s $0 $1 $2;
    exit 
fi
if [ "$DEBUG" == false ]; then clear; fi



#----------------------------------------------> Update and Upgrade
echo -e "\033[1;33m> Updating\033[0m";
execute $DEBUG "sudo apt update -y";
print $DEBUG "\033[0;32m> Updated\033[0m";
echo -e "\033[1;33m> Upgrading\033[0m";
execute $DEBUG "sudo apt upgrade -y";
print $DEBUG "\033[0;32m> Upgraded\033[0m";



#----------------------------------------------> Log and Temp Folder
mkdir -p $LOGFOLDER;
mkdir -p $TEMPFOLDER;

printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header";



#----------------------------------------------> Install APT
for i in "${apts[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    echo -e "\033[1;33m> Installing "$i"\033[0m";
    if [ "$DEBUG" == true ]
    then
        sudo apt install $i -y;
    else
        sudo apt install $i -y > $logfile 2>$logfile;
    fi
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> "$i": The command failed, log in "$logfile"\033[0m";
    else
        print $DEBUG "\033[0;32m> "$i": Installed\033[0m";
        rm $logfile
    fi
done



#----------------------------------------------> Install SNAP
for i in "${snaps[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    echo -e "\033[1;33m> Installing "$i"\033[0m";
    if [ "$DEBUG" == true ]
    then
        sudo snap install $i
    else
        sudo snap install $i > $logfile 2>$logfile
    fi
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> "$i": The command failed, log in "$logfile"\033[0m";
    else
        print $DEBUG "\033[0;32m> "$i": Installed\033[0m";
        rm $logfile
    fi
done


cd temp;



#----------------------------------------------> Install Chrome
echo -e "\033[1;33m> Downloading Chrome\033[0m";
execute $DEBUG "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb";
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> Chrome: Download failed\033[0m";
else
    print $DEBUG "\033[0;32m> Chrome: Downloaded\033[0m";
    echo -e "\033[1;33m> Installing Chrome\033[0m";
    execute $DEBUG "sudo dpkg -i google-chrome-stable_current_amd64.deb";
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> Chrome: Installation failed\033[0m";
    else
        print $DEBUG "\033[0;32m> Chrome: Installed\033[0m";
        rm google-chrome-stable_current_amd64.deb;
    fi
fi



#----------------------------------------------> Install JDK 19
echo -e "\033[1;33m> Downloading JDK 19\033[0m";
execute $DEBUG "wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb";
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> JDK 19: Download failed\033[0m";
else
    print $DEBUG "\033[0;32m> JDK 19: Downloaded\033[0m";
    echo -e "\033[1;33m> Installing JDK 19\033[0m";
    execute $DEBUG "sudo apt-get -qqy install ./jdk-19_linux-x64_bin.deb";
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> JDK 19: Installation failed\033[0m";
    else
        print $DEBUG "\033[0;32m> JDK 19: Installed\033[0m";
        execute $DEBUG "sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19/bin/java 1919";
        rm jdk-19_linux-x64_bin.deb;
    fi
fi



#----------------------------------------------> Install and apply Orchis-Theme
echo -e "\033[1;33m> Cloning Orchis-Theme\033[0m";
execute $DEBUG "git clone https://github.com/vinceliuice/Orchis-theme.git";
print $DEBUG "\033[0;32m> Orchis-Theme: Cloned\033[0m";
echo -e "\033[1;33m> Installing Orchis-Theme\033[0m";
cd Orchis-theme;
execute $DEBUG "./install.sh -l -c light";
if [ $? -eq 0 ]
then
    print $DEBUG "\033[0;32m> Orchis-Theme: Installed\033[0m";
    echo -e "\033[1;33m> Applying Orchis-Theme\033[0m";
    execute $DEBUG "gsettings set org.gnome.desktop.interface gtk-theme Orchis-Light";
    if [ $? -eq 0 ]
    then
        print $DEBUG "\033[0;32m> Orchis-Theme: Applied\033[0m";
    else
        print $DEBUG "\033[0;31m> Orchis-Theme: Apply failed\033[0m";
    fi
else
    print $DEBUG "\033[0;31m> Orchis-Theme: Installation failed\033[0m";
fi
cd ..;




#----------------------------------------------> Install and apply Orchis-Icons
echo -e "\033[1;33m> Cloning Orchis-Icons\033[0m";
execute $DEBUG "git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git";
cd Tela-circle-icon-theme;
execute $DEBUG "./install.sh -a";

if [ $? -eq 0 ]
then
    execute $DEBUG "gsettings set org.gnome.desktop.interface icon-theme Tela-circle-orange";
    print $DEBUG "\033[0;32m> Orchis-Icons: Installed\033[0m";
else
    print $DEBUG "\033[0;31m> Orchis-Icons: Installation failed\033[0m";
fi
cd ..;


cd ..;
sudo rm -rf temp;

printf "%*s\n" $(((${#footer}+$COLUMNS)/2)) "$footer";