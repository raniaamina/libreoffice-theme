#!/usr/bin/env bash

# install theme to LIBREOFFICE_PATH
function install_theme {
    echo "Installing $PREFERED_THEME"
    install_intro
    echo "Installing $PREFERED_THEME Personas"
    install_personas
    echo "Done"
}

# install intro
function install_intro {
    echo "Installing Splash Theme"
    install_splash
    echo "Installing Splash Theme (50%) ..."
    install_sofficerc
    echo "Installing Splash Theme (100%) ... Completed"
}

# install splash
function install_splash {
    # check backup file, restore if exists to provide original intro.png
    if [[ -e $LIBREOFFICE_PATH/program/intro.png.backup ]]; then
        sudo mv $LIBREOFFICE_PATH/program/intro.png.backup $LIBREOFFICE_PATH/program/intro.png
    fi
    # then do install intro.png provided by prefered theme
    sudo mv $LIBREOFFICE_PATH/program/intro.png $LIBREOFFICE_PATH/program/intro.png.backup
    sudo cp themes/$PREFERED_THEME/program/intro.png $LIBREOFFICE_PATH/program/intro.png
}

# install sofficerc
function install_sofficerc {
    # check backup file, restore if exists to provide original sofficerc
    if [[ -e $LIBREOFFICE_PATH/program/sofficerc.backup ]]; then
        sudo mv $LIBREOFFICE_PATH/program/sofficerc.backup $LIBREOFFICE_PATH/program/sofficerc
    fi
    # then do install sofficerc provided by prefered theme
    sudo mv $LIBREOFFICE_PATH/program/sofficerc $LIBREOFFICE_PATH/program/sofficerc.backup
    sudo cp themes/$PREFERED_THEME/program/sofficerc $LIBREOFFICE_PATH/program/sofficerc
}

# install personas file
function install_personas {
    sudo mv $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt.backup
    sudo cp -r themes/$PREFERED_THEME/share/gallery/personas/$PREFERED_THEME $LIBREOFFICE_PATH/share/gallery/personas/
    sudo cp themes/$PREFERED_THEME/share/gallery/personas/personas_list.txt $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt
    pushd $LIBREOFFICE_PATH/share/gallery/personas/ > /dev/null
    sudo bash -c "cat personas_list.txt.backup >> personas_list.txt"
    popd > /dev/null
}

# apply theme for user
function apply_installed_theme {
    read -r -p "Apply your new theme right now? [y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
            sed -i 's|.*PersonaSettings.*|'"<item oor:path=\"/org.openoffice.Office.Common/Misc\"><prop oor:name=\"PersonaSettings\" oor:op=\"fuse\"><value>$PREFERED_THEME;$PREFERED_THEME;$PREFERED_THEME/preview.png;$PREFERED_THEME/header.png;$PREFERED_THEME/footer.png;#ffffff;#000000</value></prop></item>"'|'  $LIBREOFFICE_CONFIG_DIR/registrymodifications.xcu
            sed -i 's|.*Persona" oor.*|'"<item oor:path=\"/org.openoffice.Office.Common/Misc\"><prop oor:name=\"Persona\" oor:op=\"fuse\"><value>default</value></prop></item>"'|'  $LIBREOFFICE_CONFIG_DIR/registrymodifications.xcu
            echo "done"
            exit
            ;;
        [nN][oO]|[nN])
            exit
            ;;
        *)
            echo "Invalid input..."
            exit 1
            ;;
    esac
}

# warning banner
function display_warning_banner {
    read -r -p "This action will replace default theme with your selected theme.
Make sure no LibreOffice task running at this moment. Continue? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
            ;;
        [nN][oO]|[nN])
            exit
            ;;
        *)
            echo "Invalid input..."
            exit 1
            ;;
    esac
}

# check theme installed before
function check_is_theme_installed_before {
    if [[ -d $LIBREOFFICE_PATH/share/gallery/personas/$PREFERED_THEME ]]; then
        read -r -p "$PREFERED_THEME has been installed before. Overwrite? [Y/n]" answer
        case $answer in
            [yY][eE][sS]|[yY])
                echo "Overwriting $PREFERED_THEME..."
                # delete personas_list before continue
                sudo sed -i '/'"$PREFERED_THEME"'/d' $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt
                ;;
            [nN][oO]|[nN])
                exit
                ;;
            *)
                echo "Invalid input..."
                exit 1
                ;;
        esac
    fi
}
