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
    return $?

}



#----------------------------------------------> Variables
if [ "$#" -eq 2 ]
then 
    PWD=$2
    if [ "$1"=="-d" ]
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
echo -e "\033[0m"

if [ "${PWD: -1}" != "/" ]
then
    PWD=$PWD"/";
fi

TEMPFOLDER=$PWD"temp/";



#----------------------------------------------> Temp Folder
mkdir -p $TEMPFOLDER;
cd $TEMPFOLDER;



#----------------------------------------------> Dash to Panel

echo -e "\033[1;33m>Installing Dash to Panel";
execute $DEBUG "git clone https://github.com/home-sweet-gnome/dash-to-panel.git";
if [ "$?" -eq 0 ]
then
    cd dash-to-panel;
    execute $DEBUG "make install";
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32mDash to Panel installed";
        gnome-extensions enable "dash-to-panel@jderose9.github.com";
        execute $DEBUG "busctl --user call \"org.gnome.Shell\" \"/org/gnome/Shell\" \"org.gnome.Shell\" \"Eval\" \"s\" \'Meta.restart(\"Restarting…\")\'";
        print $DEBUG "\033[0;32mDash to Panel enabled";
    else
        print $DEBUG "\033[0;31mDash to Panel installation failed";
    fi
else
    print $DEBUG "\033[0;31mDash to Panel cloning failed";
fi
cd ..;
echo -e "\033[0m";



#----------------------------------------------> ArcMenu
echo -e "\033[1;33m>Installing ArcMenu";
execute $DEBUG "git clone https://gitlab.com/arcmenu/ArcMenu.git";
if [ "$?" -eq 0 ]
then
    cd ArcMenu;
    execute $DEBUG "make install";
    if [ "$?" -eq 0 ]
    then
        print $DEBUG "\033[0;32m>ArcMenu installed";
        gnome-extensions enable "arcmenu@arcmenu.com";
        execute $DEBUG "busctl --user call \"org.gnome.Shell\" \"/org/gnome/Shell\" \"org.gnome.Shell\" \"Eval\" \"s\" \'Meta.restart(\"Restarting…\")\'";
        print $DEBUG "\033[0;32mDash to Panel enabled";
    else
        print $DEBUG "\033[0;31m>ArcMenu installation failed";
    fi
else
    print $DEBUG "\033[0;31m>ArcMenu cloning failed"
fi
echo -e "\033[0m"



cd ../..;
sudo rm -rf $TEMPFOLDER;