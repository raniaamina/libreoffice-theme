#!/usr/bin/env bash

# populate theme from themes folder
function populate_themes {
    if [[ -z $THEMES ]]; then
        THEMES="$(ls themes/)"
    fi
}

# check required theme components
function check_theme_components {
    populate_themes
    for ITEM in ${THEMES[@]}
    do
        # check screenshot
        if [[ ! -e themes/$ITEM/screenshot.png ]]; then
            echo "[$ITEM] screenshot.png not found, exiting ..."
            exit
        fi

        # check intro.png
        if [[ ! -e themes/$ITEM/program/intro.png ]]; then
            echo "[$ITEM] themes/$ITEM/program/intro.png not found, exiting ..."
            exit
        fi
        
        # check sofficerc
        if [[ ! -e themes/$ITEM/program/sofficerc ]]; then
            echo "[$ITEM] themes/$ITEM/program/sofficerc not found, exiting ..."
            exit
        fi
        
        # check persona
        if [[ -d themes/$ITEM/share/gallery/personas/$ITEM ]]; then
            pushd themes/$ITEM/share/gallery/personas/$ITEM > /dev/null
            # check personas_list.txt
            if [[ ! -s $PWD/../perso333nas_list.txt ]]; then
                echo "[$ITEM] $PWD/../personas_list.txt not found, exiting ..."
                exit
            fi
            # check footer
            if [[ ! -s $PWD/footer.png ]]; then
                echo "[$ITEM] $PWD/footer.png not found, exiting ..."
                exit
            fi
            # check header
            if [[ ! -s $PWD/header.png ]]; then
                echo "[$ITEM] $PWD/header.png not found, exiting ..."
                exit
            fi
            # check preview
            if [[ ! -s $PWD/preview.png ]]; then
                echo "[$ITEM] $PWD/preview.png not found, exiting ..."
                exit
            fi
            popd > /dev/null
        else
            echo "[$ITEM] themes/$ITEM/share/gallery/personas/$ITEM not found, exiting..."
        fi

        echo "[$ITEM] OK!"
    done
}

