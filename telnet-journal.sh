#!/bin/bash

dir="/var/gemini/journal"

# functions
getentry() {
echo -e "\n\nType number you'd like to read or press return to exit"
read -r  "num"
# remove \r added by telnet client
num="$(echo "$num"  | sed -e "s/\\r//")"
showentry "$num"
}
showentry() {
case "$1" in
    ''|*[!0-9]*) 
# echo message if variable is not a number otherwise
notreal "$1"
;;
    *)

if [ -f /var/gemini/journal/$1.txt ]; then
# clear screen through ANSI escape
echo -e "\u001B[2J"
# count lines of file, loop through contents to create less/more-like scrolling
# wrap at 80 columns, furthermore assume 24 rows
lines="$(cat $dir/$1.txt | fold -w 80 -s | wc -l)"
for (( i = 0; i < "$lines" ;k=i)); do
echo -e "$(cat $dir/$1.txt | fold -w 80 -s)" | head -n "$(( i + 21 ))" | tail  -n "$(( i + 21 ))" 
echo -e "\nPress enter to continue. Type q to quit" 
# inputs to give user control scrolling down
scroll
	if [[ "$enter" = "q" ]]; then
 	return
 	fi
i=$(( i + 21 ))
done

else
echo -e "\n\nSorry, future man, woman or child. Entry $num has not been written yet. \nReturn to the land of tomorrow to read it"
fi;;
esac
}

scroll() {
read "enter"
enter="$(echo "$enter"  | sed -e "s/\\r//")"
}

getlist() {
# ANSI stuff erases "Press enter" message, replacing with Index and setting test style back to normal
echo -e "\033[1A\033[2KIndex\033[0m:"
# starting at 1, get first line of files named 1.txt, 2.txt ...
## (the first line containing the title of the file)
# include counter so user knows the number as well
k=1
while
echo -ne "$k: " && echo -e "$(cat $dir/$k.txt)" | head -1 
(( k++ ))
# exit if file does not exist
[ -f /var/gemini/journal/$k.txt ]
do true; done
}

notreal() {
# these are valid exit commands that get a nice message in response
if ! [ -n "$1" ] || [[ "$1" = "exit" ]] || [[ "$1" = "q" ]]; then


echo -e "  +       .    ö       ,      .   *   ,     .
       o           .
                       .       .   ,       
    ,           \033[95;1mG O O D B Y E\033[0m
+     .       have   a  strange    +        * 
               but  nice  life           ,  o
       ,
 *    -o-               .         .     '    +
                 ,         *       o        -<>
   .                                  ,"

else
# take care of everything we don't understand by blowing up
echo "Sorry, that's not a defined input. The computer will now explode!"
fi
exit 0
}


# START HERE
echo -e "\033[95;1m  _____   _             _        _                 
 |  __ \ ( )|    __  | ( )      | |     __    __   
 | |__) | | |   /  \_|_ \/__    | |    /  \  /  \  
 |  ___/  | |  | () ||   /__    | |   | () || () | 
 | |      | |   \__/ |    __/   | |____\__/  \__/  
 |_|     (_)|        |_         |______|        |  
            |__|\033[0m   __   .,\033[95;1m                   \__/  \033[0m
   .        /  \. ( .)./\'      + 	'    ,     
           /     /[\`´]./   ,      -o-	        
       +  [    .- .-o-               *    .       
o-        /     '/ /\ \		.  ' 	  o
         /      [_]  [_]
      .~

Welcome to my simple journal about my ordinary life.
Best viewed in 80 x 24 terminal windows

"
echo -ne "\033[95;1mPress enter"
scroll 
getlist

while
getentry
# ASCII art includes some blinking stars
echo -e "                   __   .,"
echo -e "   .            . ( .)./\'      \033[5m+\033[0m 	'    ,     "
echo -e "           '     /[\`´]./   ,      -o-	        "
echo -e "       \033[6m+\033[0m       .- .-o-               \033[5m*\033[0m    .       "
echo -e "   ,            '/ /\ \		.  ' 	  o"
echo -e "       -o-      [_]  [_]"
echo -e "      .                      \033[6m~\033[0m"

getlist
# if input is empty, close session. otherwise keep prompting for input
[ -n "$num" ] 
do true; done
