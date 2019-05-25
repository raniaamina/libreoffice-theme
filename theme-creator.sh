#!/bin/bash

# welcome text
echo "========== WELCOME TO: ==========
 _     ___            _____ ____
| |   / _ \          |_   _/ ___|
| |  | | | |  _____    | || |    
| |__| |_| | |_____|   | || |___ 
|_____\___/            |_| \____|
========= THEME CREATOR ========="
echo
echo "This tool will help you to create your own theme directory under themes folder"
echo
read -p "Please type your new theme name: " NAME
mkdir -p themes/$NAME/program/
mkdir -p themes/$NAME/share/gallery/personas/$NAME/
echo 
echo "$NAME directory created"
echo "Happy working!"
