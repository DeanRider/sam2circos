# sam2circos
Each of these scripts will scan a folder to create a list of input sam files.
It will then use each file in the list it created
and evaluate field 2 to separate primary mappings.
Each primary mapping represents a match.  
awk grep and sed with sort and uniq will determine the length of reads
in the with-lengths version, and in both versions will make
counts of translocations. The starting and ending information 
and the count will then be printed out on a per line basis.

Requires a custom karyotype file to be used with Circos.

Names of References must match those in the karyotype file, therefore,
Manual correction is recommended after processing of the sam file.

use: bash Sam2Circos_with_Counts.sh

use: bash sam2circos_with_lengths.sh

written July 2022 by S. Dean Rider Jr. based on the following:
https://www.unix.com/unix-for-dummies-questions-and-answers/179555-count-different-characters-one-column.html
answer by scrutinizer
and
https://www.xmodulo.com/read-column-data-text-file-bash.html
