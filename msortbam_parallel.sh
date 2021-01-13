#!/bin/bash

###########################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
##########################

#sorts all bam files in a folder
cd "$1"

for file in *.bam
do
	input=$file
	output=${file%.bam}-sorted.bam
	samtools sort -@ 16 -o "$output" "$input"
	echo "$file sorted"
done
