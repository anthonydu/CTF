#!/bin/bash

function forensic {
    if [ "$#" -eq 1 ]
    then
        file "$1" &&
        echo &&
        exiftool "$1" &&
        binwalk "$1" &&
        read -p "Would you like to carve this file? (y/n) " carve &&
        case "$carve" in
            [yY] )
                local DIR_NAME="$1"_$(date +%s)_carved &&
                mkdir "$DIR_NAME" &&
                scalpel -c ~/scalpel.conf -o "$DIR_NAME"/scalpel "$1" &&
                foremost -o "$DIR_NAME"/foremost "$1";;
            * )
                echo "File not carved.";;
        esac &&
        read -p "Would you like to extract strings from this file? (y/n) " strings &&
        case "$strings" in
            [yY] )
                strings -n 5 "$1";;
            * )
                echo "Strings not extracted.";;
        esac &&
        read -p "Would you like to check out this file's header? (y/n) " head &&
        case "$head" in 
            [yY] )
                xxd "$1" | head;;
            * )
                echo "Header not displayed.";;
        esac
    else
        echo -e "Usage: forensic \e[3mFILE\e[0m"
    fi
}

forensic "$@";