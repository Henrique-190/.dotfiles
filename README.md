# My DotFiles

## Screenshot
![Screenshot](https://github.com/Henrique-190/.dotfiles/blob/main/Personal/Desktop.png "Desktop")


## Getting Started
Steps:
- Clone the repository or download the zip file and extract its contents;
- Navigate to the .dotfiles directory by running the command `cd .dotfiles` in your terminal;
- Make the main.sh script executable by running the command `chmod +x main.sh`;
- Run the script by executing `./main.sh`, or `./main.sh -d` if you want to run it in debug mode;

When you run the script, two folders named logs and temp will be created. The logs folder is used to help you diagnose any issues that may arise during the execution of the script, while the temp folder is used to temporarily store files that are downloaded and then deleted after use.

In addition to these steps, running the script will refresh the gnome-shell to apply any gnome extensions that are specified in the script. Also, a `.desktop` file will be created in order to apply those extensions. If `Ubuntu dash` doesn't disappear, you need to **Enable Extensions** in `Extensions`.

Next:
- Run `Extensions.desktop` located in `$HOME/Desktop`;
- Go to `Extensions` > `ArcMenu` > `Settings` > `About` > `Load`;
- Select `ArcMenu.txt` located in `.dotfiles/Extensions/`;
- Close `ArcMenu Settings`;
- In `Extensions` > `Dash to Panel` > `Settings` > `About`, click in `Import from file`;
- Select `DashToPanel.txt` located in `.dotfiles/Extensions/`;

## Extensions:
1. [DashToPanel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
2. [ArcMenu](https://extensions.gnome.org/extension/3628/arcmenu/)

## Info:
- OS: Ubuntu
- Wallpaper: [Here](https://github.com/Henrique-190/.dotfiles/blob/main/Personal/Pictures/YHLQMDLG.png)
- Editor: Sublime-Text
- Taskbar: Dash to Panel
- Browser: Chrome
