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
    sudo mv $LIBREOFFICE_PATH/program/intro.png $LIBREOFFICE_PATH/program/intro.png.backup
    sudo cp themes/$PREFERED_THEME/program/intro.png $LIBREOFFICE_PATH/program/intro.png
}

# install sofficerc
function install_sofficerc {
    sudo mv $LIBREOFFICE_PATH/program/sofficerc $LIBREOFFICE_PATH/program/sofficerc.backup
    sudo cp themes/$PREFERED_THEME/program/sofficerc $LIBREOFFICE_PATH/program/sofficerc.backup
}

# install personas file
function install_personas {
    sudo mv $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt $LIBREOFFICE_PATH/share/gallery/personas/personas_list.txt.backup
    sudo cp -r themes/$PREFERED_THEME/share/gallery/personas/$PREFERED_THEME $LIBREOFFICE_PATH/share/gallery/personas/
    pushd $LIBREOFFICE_PATH/share/gallery/personas/ > /dev/null
    sudo bash -c "cat personas_list.txt.backup >> personas_list.txt"
    popd > /dev/null
}
