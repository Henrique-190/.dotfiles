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
        $2 > /dev/null 2> /dev/null;
    fi
    return $?;

}



#----------------------------------------------> Executable
chmod +x $PWD"bloatware.sh";
chmod +x $PWD"extensions.sh";
chmod +x $PWD"install.sh";



#----------------------------------------------> Sudo check
if [ "$EUID" -ne 0 ]
then 
    echo -e "Please enter your password to run this script.";
    sudo -s $0 $1;
    exit 
fi

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
  print $DEBUG "\"\033[1;33mPreparing to install in "$i"\033[0m";
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
execute $DEBUG "cp -R Personal/* ~";
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Folders not moved.\033[0m"; else print $DEBUG "\033[0;32m> Folders moved.\033[0m"; fi



#----------------------------------------------> Wallpaper
echo -e "\033[1;33m> Setting wallpaper.\033[0m";
WPPPATH='file://'$PWD'Personal/Pictures/YHLQMDLG.png';
print $DEBUG gsettings set org.gnome.desktop.background picture-uri $WPPPATH;
if [ $? -ne 0 ]; then print $DEBUG "\033[0;31m> Wallpaper not set.\033[0m"; else print $DEBUG "\033[0;32m> Wallpaper set.\033[0m"; fi



#----------------------------------------------> Autoremove
echo -e "\033[1;33mRemoving unnecessary packages.\033[0m";
execute $DEBUG "sudo apt autoremove -y";
if [$? -ne 0]; then print $DEBUG "\033[0;31mPackages not removed.\033[0m"; else print $DEBUG "\033[0;32mPackages removed.\033[0m"; fi



echo -e "Need to reboot. Then, do \033[0;36m"$PWD"extensions.sh\033[0m";

echo "Execute "$PWD"extensions.sh" > ~/Desktop/TODO.txt;

echo "Reboot? (y/n)";
read -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot;
fi