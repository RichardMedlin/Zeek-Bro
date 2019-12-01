#! /bin/bash

#  to run the script:  ./install.sh /source_folder/ /destination_folder/
#  example:  ./install.sh /home/iwcdev/Downloads/Zeek-Bro/site/ /opt/zeek/share/zeek/
#  Will move the entire contents of the site folder to the specified folder.  In this case Zeek Site folder.  
#  Replace the Destination with your folder holds the Zeek sites folder when running the script.
#  This file was created by Richard Medlin.  
if [ ! $# -eq 2 ]; then 
    echo -e "\nERROR: Script needs 2 arguments:\n$0 source/directory/ target/directory/\n"
    exit
fi

function recursiveDuplication {
    for files in `ls $1`; do
            cp -avr $1/$file $2/$file
    done
}

if [ ! -d $1 ]; then 
    echo -e "\nERROR: $1 does not exist\n"
    exit
elif [ -d $2 ] && [ ! -w $2 ]; then
    echo -e "\nERROR: You do not have permission to write to $2\n"
    exit
elif [ ! -d $2 ]; then
    echo -e "\nSUCCESS: $2 has been created"
    mkdir $2
fi

recursiveDuplication $1 $2
