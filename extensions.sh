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
        $2 > $3 2> $3;
    fi
    return $?;
}



#----------------------------------------------> Variables
if [ "$1" = "-d" ]; then DEBUG=true; else DEBUG=false; fi
TEMPFOLDER=$PWD"/temp/"
mkdir -p $TEMPFOLDER;



#----------------------------------------------> Orchis-Theme
echo -e "\033[1;33m> Applying Orchis-Theme\033[0m";
logfile=$TEMPFOLDER"orchis-theme.log";
execute $DEBUG "gsettings set org.gnome.desktop.interface gtk-theme Orchis-Dark-Compact" $logfile;
if [ $? -eq 0 ]
then
    print $DEBUG "\033[0;32m> Orchis-Theme: Applied\033[0m";
    rm $logfile;
else
    print $DEBUG "\033[0;31m> Orchis-Theme: Apply failed. Check $logfile\033[0m";
fi



#----------------------------------------------> Orchis-Icons
echo -e "\033[1;33m> Applying Orchis-Icons\033[0m";
logfile=$TEMPFOLDER"orchis-icons.log";
execute $DEBUG "gsettings set org.gnome.desktop.interface icon-theme Tela-circle-orange" $logfile;
if [ $? -eq 0 ]
then
    print $DEBUG "\033[0;32m> Orchis-Icons: Applied\033[0m";
    rm $logfile;
else
    print $DEBUG "\033[0;31m> Orchis-Icons: Apply failed. Check $logfile\033[0m";
fi



#----------------------------------------------> Dash to Panel
echo -e "\033[0;33m> Enabling Dash to Panel\033[0m";
logfile=$TEMPFOLDER"dash-to-panel.log";
execute $DEBUG "gnome-extensions enable dash-to-panel@jderose9.github.com" $logfile;
if [ "$?" -eq 0 ]
then
    print $DEBUG "\033[0;32m> Dash to Panel enabled\033[0m";
    rm $logfile;
else
    print $DEBUG "\033[0;31m> Dash to Panel enabling failed. Check $logfile\033[0m";
fi



#----------------------------------------------> ArcMenu
echo -e "\033[0;33m> Enabling ArcMenu\033[0m";
logfile=$TEMPFOLDER"arcmenu.log";
execute $DEBUG "gnome-extensions enable arcmenu@arcmenu.com" $logfile;
if [ "$?" -eq 0 ]
then
    print $DEBUG "\033[0;32m> ArcMenu enabled\033[0m";
    rm $logfile;
else
    print $DEBUG "\033[0;31m> ArcMenu enabling failed. Check $logfile\033[0m";
fi



#----------------------------------------------> End
echo -e "> If nothing changed, go to Extensions and enable it. Also, you need to \033[0;36mimport ArcMenu and Dash to Panel settings in Extension Settings\033[0m";

touch ~/Desktop/TODO.txt && echo "Import ArcMenu and Dash to Panel settings in Extension Settings" > ~/Desktop/TODO.txt;

echo -e "> Press \033[0;36mENTER\033[0m to close...";
read -r;
echo -e "\033[1;33m> Closing\033[0m";