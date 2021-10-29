#!/bin/python3

###########################
# Name: Molly Brothers
# Github: mollybrothers
# Date: 10/26/2021
###########################

#You provide the size range that you want to align in the argument
#Example call: bash /home/mbrothers/code/mbedgraphs_parallel.sh ~/path/to/sam_files 120 180

#Assumes that all sam files are in the same folder and all end with ".sam"

#Change directory to that provided as argument
cd "$2"

#Iterates through all sam files in folder
for file in *.sam
do
	input=$file
        output=${file%.sam}_$3_$4.bedgraph
        min_length="$3"
        max_length="$4"
        python $1/mcoverage-modlength.py "$input" "$output" "$min_length" "$max_length"
done
