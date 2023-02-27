#----------------------------------------------> Variables
DIRNAME="$( dirname -- "$0"; )/"
if [ "$DIRNAME" = "./" ]; then
    DIRNAME="";
fi
PWD=$( pwd; )"/"$DIRNAME;


if [ "$1" = "-d" ]; then DEBUG=true; else DEBUG=false; fi


#----------------------------------------------> Functions
execute (){
    if [ "$1" == true ]
    then
        $2;
    else
        $2 > $3 2> $3;
    fi
}

print (){
    if [ "$1" == true ]
    then
        echo -e $2;
    else
        echo -e "\e[1A\e[K"$2;
    fi
}

desktopFile(){
    echo "[Desktop Entry]" >> $1
    echo "Version=1.0"  >> $1
    echo "Type=Application"  >> $1
    echo "Name=Extensions"  >> $1
    echo "Terminal=true"  >> $1
    echo "Exec=bash -c $2"  >> $1
    echo "Name=Extensions"  >> $1
    echo "Comment=Apply Extensions"  >> $1
}


#----------------------------------------------> Executable
chmod +x $PWD"bloatware.sh";
chmod +x $PWD"extensions.sh";
chmod +x $PWD"install.sh";



if [ "$DEBUG" == false ]; then clear; fi



#----------------------------------------------> Log and Temp Folder
mkdir -p $PWD"logs/";
mkdir -p $PWD"temp/";



#----------------------------------------------> Bloatware
$PWD"bloatware.sh" $1;



#----------------------------------------------> Wait
echo -e "\033[1;33mPreparing to install in 5\033[0m";
for i in {4..1}
do
  print $DEBUG "\033[1;33mPreparing to install in $i\033[0m";
  sleep 1s;
done

if [ "$DEBUG" == false ]; then clear; fi



#----------------------------------------------> Install
if $PWD"install.sh" $1;
then 
    echo -e "\033[0;32m> Installation completed successfully.\033[0m";
else
    echo -e "\033[0;31m> Installation failed.\033[0m";
    exit
fi



#----------------------------------------------> Personal
echo -e "\033[1;33m> Moving personal files.\033[0m";
mv -v Personal/* $HOME;
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Folders not moved.\033[0m"; else print $DEBUG "\033[0;32m> Folders moved.\033[0m"; fi



#----------------------------------------------> Wallpaper
echo -e "\033[1;33m> Setting wallpaper.\033[0m";
gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/YHLQMDLG.png;
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Wallpaper not set.\033[0m"; else print $DEBUG "\033[0;32m> Wallpaper set.\033[0m"; fi



#----------------------------------------------> Sounds
gsettings set org.gnome.desktop.sound event-sounds false
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Sounds disabled.\033[0m"; else print $DEBUG "\033[0;32m> Sounds disabled.\033[0m"; fi



#----------------------------------------------> Autoremove
echo -e "\033[1;33m> Removing unnecessary packages.\033[0m";
execute $DEBUG "sudo apt autoremove -y" /dev/null;
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Packages not removed.\033[0m"; else print $DEBUG "\033[0;32mPackages removed.\033[0m"; fi



touch ~/Desktop/Extensions.desktop;
> ~/Desktop/Extensions.desktop;
desktopFile ~/Desktop/Extensions.desktop $PWD"/extensions.sh";
if [ $? -ne 0 ]
then 
    print $DEBUG "\033[0;31m> Desktop file not created. Do ./extensions.sh to apply\033[0m";
else 
    print $DEBUG "\033[0;32m> Desktop file created.\033[0m";
    gio set ~/Desktop/Extensions.desktop metadata::trusted true;
    chmod a+x ~/Desktop/Extensions.desktop;

    echo -e "> Need to reboot. Then click in \033[0;36m~/Desktop/Extensions\033[0m";

    #----------------------------------------------> Wait
    echo -e "\033[1;33m> Preparing to restart gnome-shell in 10\033[0m";
    for i in {9..1}
    do
        print $DEBUG "\033[1;33m> Preparing to restart gnome-shell in $i\033[0m";
        sleep 1s;
    done

    killall -SIGQUIT gnome-shell
fi
