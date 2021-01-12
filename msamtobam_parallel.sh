#!/bin/bash

###########################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
###########################

#converts sam files to bam files for all sam files in a folder

#Assumes that sam files are all in the same folder and all end with ".sam"

#Change to directory provided as argument from command line
cd "$1"

#Iterates through all sam files in directory to conver them from sam to bam
for file in *sam
do      
        input=$file
        output=${file%.sam}.bam
        samtools view -@ 16 -b -S -o "$output" "$input"
	echo "$file converted from sam to bam"
done

