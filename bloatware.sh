#----------------------------------------------> Functions
print (){
    if [ "$1" == true ]
    then
        echo -e $2
    else
        echo -e "\e[1A\e[K"$2
    fi
}

execute (){
    if [ "$1" == true ]
    then
        $2
    else
        $2 > /dev/null 2> /dev/null
    fi
}



#----------------------------------------------> Sudo check
if [ "$EUID" -ne 0 ]
then 
    echo "Please enter your password to run this script."
    sudo -s $0 $1
    exit 
fi



#----------------------------------------------> Variables
if [ "$1" == "-d" ]; then DEBUG=true; else DEBUG=false; fi
COLUMNS=$(tput cols) 

bloat=(firefox* gimp libreoffice* rhythmbox* openjdk* mozilla* thunderbird* account-plugin* aisleriot brltty duplicity 
empathy empathy-common example-content gnome-accessibility-themes gnome-contacts gnome-mahjongg gnome-mines gnome-orca 
gnome-screensaver gnome-sudoku gnome-video-effects gnomine landscape-common libsane libsane-common 
mcp-account-manager-uoa rhythmbox* sane-utils shotwell shotwell-common telepathy* totem* printer-driver* )

header=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Purging bloatware <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
footer=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Purging completed <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"



#----------------------------------------------> Purge
if [ "$DEBUG" == false ]; then clear; fi
printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header" 

for i in "${bloat[@]}"
do
    echo -e "\033[1;33m> Purging "$i
    execute $DEBUG "sudo apt purge $i -y"
    print $DEBUG "\033[0;32m> Purged "$i
done

echo -e "\033[0m"
printf "%*s\n" $(((${#footer}+$COLUMNS)/2)) "$footer"