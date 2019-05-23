#!/usr/bin/env bash

LIBREOFFICE_PATH=""

# main function
function installation_path_check {
    PS3='Please enter your choice: '
    options=("Default From Distro" "Download DEB/RPM from Web" "Install From Flatpak" "Install From Snap" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Default From Distro")
                check_distro
                break
                ;;
            "Download DEB/RPM from Web")
                check_download_install
                break
                ;;
            "Install From Flatpak")
                check_flatpak_install
                break
                ;;
            "Install From Snap")
                check_snap_install
                break
                ;;
            "Quit")
                exit
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done;
    echo "LibreOffice installation path: $LIBREOFFICE_PATH"

}

# check distro
function check_distro {
    local distro_detect=`lsb_release -si`
    case "${distro_detect}" in
        "Debian"|"Kali"|"Ubuntu")
            check_debian_install
            ;;
        "openSUSE"|"openSUSE project"|"SUSE LINUX" | "SUSE")
            check_opensuse_install
            ;;
        *)
            echo "Your Distro is not supported yet for running this script,"
            exit
            ;;
    esac
}

# check debian
function check_debian_install {
    echo "Verifying installation path ..."
    LIBREOFFICE_PATH="$(dpkg -L libreoffice-common | grep program/sofficerc | head -c -18)"
    LIBREOFFICE_CONFIG_DIR="~/.config/libreoffice/4/user"
    if [[ $LIBREOFFICE_PATH == "" ]]; then
        echo "[dpkg] LibreOffice was not installed, exiting ..."
    fi
}

# check opensuse
function check_opensuse_install {
    echo "Verifying installation path ..."
    LIBREOFFICE_PATH="$(rpm -ql libreoffice | grep program/sofficerc | head -c -18)"
    LIBREOFFICE_CONFIG_DIR="~/.config/libreoffice/4/user"
    if [[ $LIBREOFFICE_PATH == "" ]]; then
        echo "[zypper] LibreOffice was not installed, exiting ..."
        exit
    fi
}

# check flatpak
function check_flatpak_install {
    echo "Verifying installation path ..."
    if [[ -d /var/lib/flatpak/app/org.libreoffice.LibreOffice/x86_64/stable/active/files/libreoffice ]]; then
        LIBREOFFICE_PATH="/var/lib/flatpak/app/org.libreoffice.LibreOffice/x86_64/stable/active/files/libreoffice"
        LIBREOFFICE_CONFIG_DIR="~/.var/app/org.libreoffice.LibreOffice/config/libreoffice/4/user"
    else
        echo "[Flatpak] LibreOffice installation path not found, exiting ..."
        exit
    fi
}

# check download deb/rpm from web
function check_download_install {
    echo "Verifying installation path ..."
    local optdir=($(ls -d /opt/* | grep libreoffice))
    if [[ -n optdir ]]; then
        LIBREOFFICE_PATH=$optdir
        LIBREOFFICE_CONFIG_DIR="~/.config/libreoffice/4/user"
    else
        echo "[Web Install] LibreOffice installation path not found, exiting ..."
        exit
    fi
}

# check snap
function check_snap_install {
    echo "Verifying installation path ..."
    if [[ -d /snap/libreoffice/current/lib/libreoffice ]]; then
        LIBREOFFICE_PATH="/snap/libreoffice/current/lib/libreoffice"
        LIBREOFFICE_CONFIG_DIR="~/snap/libreoffice/current/.config/libreoffice/4/user"
    else
        echo "[Snap] LibreOffice installation path not found, exiting ..."
    fi
}

