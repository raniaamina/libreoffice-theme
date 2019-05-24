#!/usr/bin/env bash

# banner
echo "Welcome to LibreOffice Theme Uninstaller"
echo

# select libreoffice installation method
source lib/libreoffice_finder.bash
echo "Select yout LibreOffice installation type:"
installation_path_check

# load installed theme from installation path
source lib/theme_uninstaller.bash
populate_installed_theme

# select theme to uninstall
echo "Select theme to uninstall:"
PS3='Enter the number: '
select answer in "${INSTALLED_THEMES[@]}" Quit;
do
    for item in "{INSTALLED_THEMES[@]}" Quit; do
        if [[ $item == $answer ]]; then
            if [[ $item == "Quit" ]]; then
                exit
            fi
            PREFERED_THEME=$item
            break 2
        fi
    done;
done;


# display warning messages
source lib/theme_installer.bash
display_warning_banner

# do uninstall stuff
uninstall_installed_theme
