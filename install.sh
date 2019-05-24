#!/usr/bin/env bash

# load theme resources
source lib/theme_loader.bash
check_theme_components

clear

# welcome text
echo "========== WELCOME TO: ==========
 _     ___            _____ ____
| |   / _ \          |_   _/ ___|
| |  | | | |  _____    | || |    
| |__| |_| | |_____|   | || |___ 
|_____\___/            |_| \____|
================================="
echo


# select LibreOffice installation type
source lib/libreoffice_finder.bash
echo "Select your LibreOffice installation type:"
installation_path_check

# select theme
echo "Select your prefered theme:"
PS3='Enter the number: '
select answer in "${THEMES[@]}" Quit;
do
    for item in "${THEMES[@]}" Quit; do
        if [[ $item == $answer ]]; then
            if [[ $item == "Quit" ]]; then
                exit
            fi
            PREFERED_THEME=$item
            break 2
        fi
    done;
done;

# display warning banner before installing theme
source lib/theme_installer.bash
display_warning_banner

# installing theme by moving default files and copying new files (Need Root Password)
install_theme

# apply installed theme
apply_installed_theme
