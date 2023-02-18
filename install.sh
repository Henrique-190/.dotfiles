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

if [ "$#" -eq 2 ]
then 
    PWD=$2;
    if [ "$1"="-d" ]
    then
        DEBUG=true;
    else 
        DEBUG=false;
    fi
else
    DEBUG=false;
    if [ "$#" -eq 1 ]
    then
        PWD=$1;
    else 
        echo -e "\033[0;31mInvalid arguments.";
        exit -1;
    fi
fi
echo -e "\033[0m";

if [ "${PWD: -1}" != "/" ]
then
    PWD=$PWD"/";
fi

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
echo -e "\033[1;33m> Updating and upgrading";
execute $DEBUG "sudo apt update -y";
execute $DEBUG "sudo apt upgrade -y";
echo -e "\033[0;32m> Upgraded";



#----------------------------------------------> Log and Temp Folder
mkdir -p $LOGFOLDER;
mkdir -p $TEMPFOLDER;


echo -e "\033[0m";

printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header";



#----------------------------------------------> Install APT
for i in "${apts[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    echo -e "\033[1;33m> Installing "$i;
    if [ "$DEBUG" == true ]
    then
        sudo apt install $i -y;
    else
        sudo apt install $i -y > $logfile 2>$logfile;
    fi
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> "$i": The command failed, log in "$logfile;
    else
        print $DEBUG "\033[0;32m> "$i": Installed";
        rm $logfile
    fi
    echo -e "\033[0m";
done
echo -e "\033[0m";



#----------------------------------------------> Install SNAP
for i in "${snaps[@]}"
do
    logfile=$LOGFOLDER$(echo $i  | head -n1 | cut -d " " -f1)".log";
    echo -e "\033[1;33m> Installing "$i;
    if [ "$DEBUG" == true ]
    then
        sudo snap install $i -y
    else
        sudo snap install $i -y > $logfile 2>$logfile
    fi
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> "$i": The command failed, log in "$logfile;
    else
        print $DEBUG "\033[0;32m> "$i": Installed";
        rm $logfile
    fi
    echo -e "\033[0m";
done
echo -e "\033[0m";


cd temp;

#----------------------------------------------> Install Chrome
echo -e "\033[1;33m> Installing Chrome";
execute $DEBUG "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb";
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> Chrome: Download failed";
else
    execute $DEBUG "sudo dpkg -i google-chrome-stable_current_amd64.deb";
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> Chrome: Installation failed";
    else
        print $DEBUG "\033[0;32m> Chrome: Installed";
        rm google-chrome-stable_current_amd64.deb;
    fi
fi
echo -e "\033[0m";



#----------------------------------------------> Install JDK 19
echo -e "\033[1;33m> Installing JDK 19";
execute $DEBUG "wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb";
if [[ $? > 0 ]]
then
    print $DEBUG "\033[0;31m> JDK 19: Download failed";
else
    execute $DEBUG "sudo apt-get -qqy install ./jdk-19_linux-x64_bin.deb";
    if [[ $? > 0 ]]
    then
        print $DEBUG "\033[0;31m> JDK 19: Installation failed";
    else
        print $DEBUG "\033[0;32m> JDK 19: Installed";
        execute $DEBUG "sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19/bin/java 1919";
        rm jdk-19_linux-x64_bin.deb;
    fi
fi
echo -e "\033[0m";



#----------------------------------------------> Install and apply Orchis-Theme
echo -e "\033[1;33m> Installing Orchis-Theme";
execute $DEBUG "git clone https://github.com/vinceliuice/Orchis-theme.git";
execute $DEBUG "./Orchis-theme/install.sh -l -c light";

if [ $? -eq 0 ]
then
    gsettings set org.gnome.desktop.interface gtk-theme Orchis-Light;
    print $DEBUG "\033[0;32m> Orchis-Theme: Installed";
else
    print $DEBUG "\033[0;31m> Orchis-Theme: Installation failed";
fi
echo -e "\033[0m";



#----------------------------------------------> Install and apply Orchis-Icons
echo -e "\033[1;33m> Installing Orchis-Icons";
execute $DEBUG "git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git";
execute $DEBUG ./Tela-circle-icon-theme/install.sh -a;

if [ $? -eq 0 ]
then
    execute $DEBUG "gsettings set org.gnome.desktop.interface icon-theme Tela-circle-orange";
    print $DEBUG "\033[0;32m> Orchis-Icons: Installed";
else
    print $DEBUG "\033[0;31m> Orchis-Icons: Installation failed";
fi
echo -e "\033[0m";



cd ..;
sudo rm -rf temp;

printf "%*s\n" $(((${#footer}+$COLUMNS)/2)) "$footer";