#!/bin/bash

########################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
#########################

#Assumes that fastq files are all in the same folder and all end with ".fastq.gz"

#Assumes fastq file names are in format LibraryName_SampleName_..., where SampleName includes no underscores
#Assumes all forward read file names include "_R1_" somewhere and that all
#reverse read file names are identical to forward reads except R1 is subbed to R2.

#Change to directory provided as argument from command line
cd "$1"

#Change alignment options here
genome="$2" #genome file to align to
threads="16" #number of processors to use
options="--local --soft-clipped-unmapped-tlen --no-unal --no-mixed --no-discordant" #include any extra bowtie2 arguments here
stats_file="alignment_stats.txt"

#Iterates through all forward read files in folder
for file in *_R1_*.fastq.gz
do
        forward="$file"
        
        #Reverse file is same name as forward file, with R1 turned into R2
        reverse=${file/_R1_/_R2_}

        #trims everything after SampleName from output file name
        output=${file%_S*}.sam

        #Adds header with information on files used for each alignment
        date >> "$stats_file"
        echo "Read 1: $forward" >> "$stats_file"
        echo "Read 2: $reverse" >> "$stats_file"
        echo "Output: $output" >> "$stats_file"

        #Actually runs alignment with bowtie using specifications from top
        bowtie2 -p "$threads" "$options" -x "$genome" -1 "$forward" -2 "$reverse" -S "$output" 2>> "$stats_file"
        echo "" >> "$stats_file"
	echo "$output created"
done
