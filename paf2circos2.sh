#!/bin/bash

#######################################################################
# 
# This script will scan a folder to create a list of input .paf files 
# It will then use each file in the list it created.
# 
# So, since I don't know how to handle row-column stuff in awk, but 
# I do know how to deal with columns, I will merge pairs of lines 
# together and deal with the resulting columns. 
# from: https://stackoverflow.com/questions/3194534/joining-two-consecutive-lines-using-awk-or-sed
#
# Generates tabular list of all linkages present in the .paf file
#
# Requires a custom karyotype file to be used with Circos.
#
# Best file to use ends with ".newRenamed.tsv".
# Other files are more for information than graphing
#
# use: bash paf2sircos2.sh
#
# written December 10, 2022 by S. Dean Rider Jr. 
# 
#######################################################################

# scan directory structure for sam results and store as a list
find . -name "*.paf" -type file -exec echo '{}' >> CircosPafList.txt \;

#loop through list in the file and parse data for circos
while read parseref; do

echo $parseref

##### working scripts  ##########

# ################
# need to sort likes based on read name and order of chunks based on starting position as a number
# need to keep only useful columns

sort -k 1,1 -k 3,3n $parseref | awk '{print $1, $3, $4, $6, $8, $9}' > $parseref.Sorted.cropped.tmp

# ok for now 
# ################


# ################
# want to merge lines together so columns can be compared from adjacent lines

awk 'BEGIN{i=1}{line[i++]=$0}END{j=1; while (j<i) {print line[j], line[j+1]; j+=1}}' $parseref.Sorted.cropped.tmp > $parseref.Sorted.cropped.merged.tmp

# merges each line with the next as desired
# ################


# ################
# need to check if col 1 and 7 are the same and that col 2 is less than col 8
# if above is true, print col 4,5,6 and col 10,11,12

# awk ' $1 = $7 && $2 <= $8 { print $4,$ 5, $6, $10, $11, $12 ; } '  $parseref.Sorted.cropped.merged.tmp

# Seems to work as expected
# ################


# ################
# Now to add a sort and count and make thickness

awk ' $1 = $7 && $2 <= $8 { print $4,$ 5, $6, $10, $11, $12 ; } '  $parseref.Sorted.cropped.merged.tmp | sort | uniq -c | awk ' BEGIN{OFS="\t";}{print $2,$3,$4,$5,$6,$7,"count = " $1}' > $parseref.Circos.newCounts.tsv || true


awk ' $1 = $7 && $2 <= $8 { print $4,$ 5, $6, $10, $11, $12 ; } '  $parseref.Sorted.cropped.merged.tmp | sort | uniq -c | awk '{
if($1 >= 10000)
	thick="16";
else if($1 >= 1000)
	thick="8";
else if($1 >= 100)
	thick="4";
else if($1 >= 10)
	thick="2";
else
	thick="1";
}
BEGIN{OFS="\t";} {print $2,$3,$4,$5,$6,$7,"thickness="thick}' > $parseref.Circos.newThickness.tsv || true

# Seems to work as expected
# ################

# ################
# Now to remove tmp files

rm $parseref.Sorted.cropped.tmp
rm $parseref.Sorted.cropped.merged.tmp

# ################

# ################
# Now Rename different ectopic sites to ECT
# insert new ones as needed with format 
# space semicolon space s/NameOfSiteToReplace/ECT/g
# the final one has no space or semicolon after it

cat $parseref.newCircos.Thickness.tsv | sed 's/chr23/chrX/g; s/chr24/chrY/g; s/HyTK_406/HyTK/g ; s/A35_EctopicKpnIHouston/ECT/g ; s/A35_Uncut/ECT/g ; s/B38_EctopicKpnIHouston/ECT/g ; s/B38_Uncut/ECT/g ; s/C12_EctopicKpnIHouston/ECT/g ; s/C12_Uncut/ECT/g ; s/Dean_iPCR/ECT/g ; s/EctopicHindIIIdeltaY6/ECT/g ; s/DeltaY6_ATTCT48/ECT/g ; s/N3_EctopicKpnIHouston/ECT/g ; s/N3_Uncut/ECT/g ; s/CAG102RSUNCUT/ECT/g ; s/CAG102RS1/ECT/g ; s/CAG102RS2/ECT/g ; s/CAG102RS_integrated/ECT/g' > $parseref.Circos.newRenamed.tsv

#
# ################


echo -e "\033[1;34m -. .-.   .-. .-.   .-. .-.   .-. .-.   .-. .-.   .-. .-.   .\033[0m";
echo -e "\033[1;30m ||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|||\|||\ /|\033[0m";
echo -e "\033[1;30m |/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\|||/ \|||\||\033[0m";
echo -e "\033[1;31m ~   \`-~ \`-\`   \`-~ \`-\`   \`-~ \`-~   \`-~ \`-\`   \`-~ \`-\`   \`-~ \`-\033[0m";

done < "CircosPafList.txt"

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