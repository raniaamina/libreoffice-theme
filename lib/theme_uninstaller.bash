#!/usr/bin/env bash

# populate user installed theme
function populate_installed_theme {
    source libreoffice_finder.bash
    installation_path_check

    $INSTALLED_THEMES=($(ls $LIBREOFFICE_PATH/share/gallery/personas/ --ignore={dark,gray,green,pink,sand,white,personas_list.txt*}))
}

function uninstall_installed_theme {
    echo "Uninstalling $PREFERED_THEME..."
    remove_theme_folder
    echo "Uninstalling $PREFERED_THEME...(33%)"
    remove_personas_list
    echo "Uninstalling $PREFERED_THEME...(67%)"
    remove_user_config
    echo "Uninstalling $PREFERED_THEME...(100%)"
    echo "Done"
}

function remove_theme_folder {
    if [[ -d $LIBREOFFICE_PATH/share/gallery/personas/$PREFERED_THEME ]]; then
        sudo rm -rf $LIBREOFFICE_PATH/share/gallery/personas/$PREFERED_THEME
    fi
}

function remove_personas_list {
    if [[ -e $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt.backup ]] && [[ -e $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt ]]; then
        sudo rm $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt
        sudo mv $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt.backup $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt
    elif [[ ! -e $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt.backup ]] && [[ -e $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt ]]; then
        sudo sed -i '/'"$PREFERED_THEME"'/d' $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt
    fi
}

function remove_user_config {
    if [[ -s $LIBREOFFICE_CONFIG_DIR/registrymodifications.xcu ]]; then
        sed -i 's|.*Persona".*|'"<item oor:path=\"/org.openoffice.Office.Common/Misc\"><prop oor:name=\"Persona\" oor:op=\"fuse\"><value>no</value></prop></item>"'|' $LIBREOFFICE_CONFIG_DIR/registrymodifications.xcu
        sed -i 's|.*PersonaSettings.*|'"<item oor:path=\"/org.openoffice.Office.Common/Misc\"><prop oor:name=\"PersonaSettings\" oor:op=\"fuse\"><value></value></prop></item>"'|' $LIBREOFFICE_CONFIG_DIR/registrymodifications.xcu
    fi
}
