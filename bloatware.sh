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
}



#----------------------------------------------> Sudo check
if [ "$EUID" -ne 0 ]
then 
    echo "Please enter your password to run this script.";
    sudo -s $0 $1;
    exit 
fi



#----------------------------------------------> Variables
if [ "$1" == "-d" ]; then DEBUG=true; else DEBUG=false; fi
COLUMNS=$(tput cols) 

bloat=(account-plugin* aisleriot brltty duplicity empathy empathy-common example-content firefox* gimp 
gnome-accessibility-themes gnome-contacts gnome-mahjongg gnome-mines gnome-orca gnome-screensaver gnome-sudoku 
gnome-video-effects gnomine landscape-common libreoffice* libsane libsane-common mcp-account-manager-uoa mozilla* 
openjdk* printer-driver*  rhythmbox* rhythmbox* sane-utils shotwell shotwell-common telepathy* thunderbird* totem*)

header=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Purging bloatware <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
footer=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Purging completed <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"



#----------------------------------------------> Purge
if [ "$DEBUG" == false ]; then clear; fi
printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"; 

for i in "${bloat[@]}"
do
    echo -e "\033[1;33m> Purging $i\033[0m";
    execute $DEBUG "sudo apt purge $i -y" /dev/null;
    if [ $? -eq 0 ]; then print $DEBUG "\033[0;32m> $i: Purged\033[0m"; else print $DEBUG "\033[0;31m> $i: Not Purged\033[0m"; fi
done

echo -e "\033[1;33m> Purging Firefox\033[0m";
execute $DEBUG "sudo snap remove --purge firefox" /dev/null;
if [ $? -eq 0 ]; then print $DEBUG "\033[0;32m> Firefox: Purged\033[0m"; else print $DEBUG "\033[0;31m> Firefox: Not Purged\033[0m"; fi


printf "%*s\n" $(((${#footer}+$COLUMNS)/2)) "$footer";