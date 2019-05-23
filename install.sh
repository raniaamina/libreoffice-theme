#!/bin/bash

clear

# welcome text
echo "Welcome to LibreOffice Theme Changer"
echo


# functions
function warning {
    read -r -p "This action will replace default theme with your selected theme.
Make sure no LibreOffice task running at this moment. Continue? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
    echo "done"
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

function apply_theme {
    read -r -p "Apply your new theme right now? [y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
    sed -i 's|.*PersonaSettings.*|'"<item oor:path=\"/org.openoffice.Office.Common/Misc\"><prop oor:name=\"PersonaSettings\" oor:op=\"fuse\"><value>$opt;$opt;$opt/preview.png;$opt/header.png;$opt/footer.png;#ffffff;#000000</value></prop></item>"'|'  ~/.config/libreoffice/4/user/registrymodifications.xcu
    echo "done"
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

# select theme
echo "Select your prefered theme:"
PS3='Enter the number: '
options=("kuuga-themes" "ambiance" "women-days" "cancel")
select opt in "${options[@]}"
do
    case $opt in
        "kuuga-themes")
            echo "Kuuga Theme Selected"
            echo -en '\n'
            warning
            apply_theme
            break
            ;;
        "ambiance")
            echo "Ambiance Theme Selected"
            break
            ;;
        "women-days")
            echo "Women Days Theme Selected"
            break
            ;;
        "Quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done;

# installing theme by moving default files and copying new files (Need Root Password)
OPTDIR=(`ls /opt | grep libreoffice`)
if [[ -n $OPTDIR ]]
then
    for ITEM in ${OPTDIR[@]}
    do
        echo "installing splash theme"
        sudo mv /opt/$ITEM/program/intro.png /opt/$ITEM/program/intro.png.backup
        sudo cp themes/$opt/program/intro.png /opt/$ITEM/program/intro.png
        sudo mv /opt/$ITEM/program/sofficerc /opt/$ITEM/program/sofficerc.backup
        sudo cp themes/$opt/program/sofficerc /opt/$ITEM/program/sofficerc
        sudo cp -r themes/$opt/share/gallery/personas/$opt /opt/$ITEM/share/gallery/personas/
        echo "splash installed"
        echo -en '\n'
        echo "installing $opt Theme"
        sudo sed -i -e "1i$opt;$opt;$opt/preview.png;$opt/header.png;$opt/footer.png;;#ffffff;#000000" /opt/$ITEM/share/gallery/personas/personas_list.txt
        break
    done
else
        mkdir -p "$ITEM/Libre-default"
fi
