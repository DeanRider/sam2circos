#!/bin/bash
#######################################################################
# 
# This script will scan a folder to create a list of input sam files 
# It will then use each file in the list it created
# and evaluate field 2 to separate primary mappings.
# Each primary mapping represents a match  
# awk grep and sed with sort and uniq will determine the length of reads  
# and counts of translocations. The starting and ending information 
# and the count will then be printed out on a per line basis.
# Requires a custom karyotype file to be used with Circos.
# Some data lines will be messed up and manual curation is required.
# note: this may have been fixed with added FS in awk
# use: bash Sam2Circos_with_lengths.sh
# written July 15, 2022 by S. Dean Rider Jr. based on the following:
# https://www.unix.com/unix-for-dummies-questions-and-answers/179555-count-different-characters-one-column.html
# answer by scrutinizer
# and
# https://www.xmodulo.com/read-column-data-text-file-bash.html
# 
#######################################################################

# scan directory structure for sam results and store as a list
find . -name "*.sam" -type file -exec echo '{}' >> CircosParseList.txt \;

#loop through list in the file and parse data for circos
while read parseref; do

echo $parseref

awk -F "\t" '{if($2=="0" || $2=="16") print $3,$4,length($10),$16}' $parseref | grep -F "SA:Z:" | awk -F' |,' 'BEGIN{OFS="\t";} {print $1, $2, $2, $4, $5, $5, $3}' | sed 's/NC_00000/chr/g ; s/NC_0000/chr/g ; s/SA:Z://g ; s/\.9//g ; s/\.10//g ; s/\.11//g ; s/\.12//g ; s/\.14//g' | sort | uniq -c | awk 'BEGIN{OFS="\t";} {print $2,$3,$4,$5,$6,$7,$8,$1}'  > $parseref.CircosWithLengths.tsv || true

echo -e "\033[1;34m -. .-.   .-. .-.   .-. .-.   .-. .-.   .-. .-.   .-. .-.   .\033[0m";
echo -e "\033[1;30m ||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|\033[0m";
echo -e "\033[1;30m |/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\||\033[0m";
echo -e "\033[1;31m ~   \`-~ \`-\`   \`-~ \`-\`   \`-~ \`-~   \`-~ \`-\`   \`-~ \`-\`   \`-~ \`-\033[0m";

done < "CircosParseList.txt"


echo
echo
echo
echo -e "\033[1;31m ▄▄▄▄▄▄▄▄     ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄ \033[0m";
echo -e "\033[1;31m▐░░░░░░░░▌   ▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌\033[0m";
echo -e "\033[1;31m▐░█▀▀▀▀▀█░▌  ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ \033[0m";
echo -e "\033[1;31m▐░▌      ▐░▌ ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌          \033[0m";
echo -e "\033[1;31m▐░▌       ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ \033[0m";
echo -e "\033[1;31m▐░▌       ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌\033[0m";
echo -e "\033[1;31m▐░▌       ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ \033[0m";
echo -e "\033[1;31m▐░▌      ▐░▌ ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌          \033[0m";
echo -e "\033[1;31m▐░█▄▄▄▄▄█░▌  ▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ \033[0m";
echo -e "\033[1;31m▐░░░░░░░░▌   ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░░▌\033[0m";
echo -e "\033[1;31m ▀▀▀▀▀▀▀▀     ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀ \033[0m";
echo -e "\033[1;31m                                                    \033[0m";



exit 0
