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
chmod +x $FOLDER"bloatware.sh";
chmod +x $FOLDER"extensions.sh";
chmod +x $FOLDER"install.sh";



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
for i in {5..1}
do
  echo -e "\033[1;33mPreparing to install in "$i;
  sleep 1s;
done

if [ "$DEBUG" == false ]; then clear; fi
echo -e "\033[0m";




#----------------------------------------------> Install
if $PWD"install.sh" $1 $PWD;
then 
    echo -e "\033[0;32mInstallation completed successfully.";
else
    echo -e "\033[0;31mInstallation failed.";
    exit
fi
echo -e '\033[0m';


#----------------------------------------------> Wait
for i in {5..1}
do
  echo -e "\033[1;33mPreparing to apply extensions in "$i;
  sleep 1s;
done
echo -e "\033[0m";

if [ "$DEBUG" == false ]; then clear; fi



#----------------------------------------------> Personal
echo -e "\033[1;33mMoving personal files.";
execute $DEBUG "cp -R Personal/* ~";
if [$? -ne 0]; then echo -e"\033[0;31mFolders not moved."; fi
echo -e "\033[0m";



#----------------------------------------------> Wallpaper
WPPPATH='file://'$FOLDER'Personal/Pictures/YHLQMDLG.png';
gsettings set org.gnome.desktop.background picture-uri $WPPPATH;



echo -e "Need to reboot. Then, do \033[0;36m\"sh $FOLDER\"extensions.sh\"";
echo -e "\033[0m";



#----------------------------------------------> Autoremove
execute $DEBUG "sudo apt autoremove -y";