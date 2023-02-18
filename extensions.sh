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



#----------------------------------------------> Sudo check
if [ "$EUID" -ne 0 ]
then 
    echo -e "Please enter your password to run this script.";
    sudo -s $0 $1;
    exit 
fi


#----------------------------------------------> Variables
DIRNAME="$( dirname -- "$0"; )/"
if [ "$DIRNAME" = "./" ]; then
    DIRNAME="";
fi
PWD=$( pwd; )"/"$DIRNAME;

if [ "$1" = "-d" ]; then DEBUG=true; else DEBUG=false; fi

TEMPFOLDER=$PWD"temp/";



#----------------------------------------------> Temp Folder
mkdir -p $TEMPFOLDER;
cd $TEMPFOLDER;



#----------------------------------------------> Dash to Panel

echo -e "\033[1;33m>Cloning Dash to Panel\033[0m";
execute $DEBUG "git clone https://github.com/home-sweet-gnome/dash-to-panel.git";
if [ "$?" -eq 0 ]
then
    cd dash-to-panel;
    print $DEBUG "\033[1;33m>Installing Dash to Panel\033[0m";
    execute $DEBUG "make install";
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32mDash to Panel installed\033[0m";
        echo -e "\033[0;33m>Enabling Dash to Panel\033[0m";
        execute $DEBUG "gnome-extensions enable \"dash-to-panel@jderose9.github.com\"";
        if [ "$?" -eq 0 ]
        then
            print $DEBUG "\033[0;32mDash to Panel enabled\033[0m";
        else
            print $DEBUG "\033[0;31mDash to Panel enabling failed\033[0m";
        fi
        execute $DEBUG "busctl --user call \"org.gnome.Shell\" \"/org/gnome/Shell\" \"org.gnome.Shell\" \"Eval\" \"s\" \'Meta.restart(\"Restarting…\")\'";
    else
        print $DEBUG "\033[0;31mDash to Panel installation failed\033[0m";
    fi
else
    print $DEBUG "\033[0;31mDash to Panel cloning failed\033[0m";
fi
cd ..;




#----------------------------------------------> ArcMenu
echo -e "\033[1;33m>Cloning ArcMenu\033[0m";
execute $DEBUG "git clone https://gitlab.com/arcmenu/ArcMenu.git";
if [ "$?" -eq 0 ]
then
    cd ArcMenu;
    print $DEBUG "\033[1;33m>Installing ArcMenu\033[0m";
    execute $DEBUG "make install";
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32m>ArcMenu installed\033[0m";
        echo -e "\033[0;33m>Enabling ArcMenu\033[0m";
        execute $DEBUG "gnome-extensions enable \"arcmenu@arcmenu.com\"";
        if [ "$?" -eq 0 ]
        then
            print $DEBUG "\033[0;32m>ArcMenu enabled\033[0m";
        else
            print $DEBUG "\033[0;31m>ArcMenu enabling failed\033[0m";
        fi
        execute $DEBUG "busctl --user call \"org.gnome.Shell\" \"/org/gnome/Shell\" \"org.gnome.Shell\" \"Eval\" \"s\" \'Meta.restart(\"Restarting…\")\'";
        print $DEBUG "\033[0;32mDash to Panel enabled\033[0m";
    else
        print $DEBUG "\033[0;31m>ArcMenu installation failed\033[0m";
    fi
else
    print $DEBUG "\033[0;31m>ArcMenu cloning failed\033[0m"
fi



cd ../..;
sudo rm -rf $TEMPFOLDER;



#----------------------------------------------> Reboot
echo -e ">>>> Need to reboot. Then, \033[0;36mimport ArcMenu and Dash to Panel settings in Extension Settings\033[0m";

echo "Import ArcMenu and Dash to Panel settings in Extension Settings" > ~/Desktop/TODO.txt;

echo ">>>> Reboot? (y/n)";
read -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot;
fi