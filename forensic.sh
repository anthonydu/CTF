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
                scalpel -c ~/scalpel.conf -o scalpel_"$1"_$(date +%s) "$1";
                foremost -o foremost_"$1"_$(date +%s) "$1";;
            * )
                echo "File carving aborted.";;
        esac &&
        read -p "Would you like to string this file? (y/n) " strings &&
        case "$strings" in
            [yY] )
                strings "$1";;
            * )
                echo "Strings command aborted.";;
        esac
    else
        echo "Usage: forensic [filename]"
    fi
}

forensic "$@";