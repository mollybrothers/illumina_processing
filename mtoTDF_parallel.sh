#!/bin/bash

#############################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/15/2021
#############################

#converts all bedgraph files in a directory into tdf files viewable by IGV
#Assumes that all begdraph files are in the same folder and all end with ".bedgraph"

#Change directory to that provided as argument


cd "$1"
genome="$2"
IGV="/Users/mollybrothers/sequencing/IGV_2.8.13"

#Iterates through all bedgraph files in folder
for file in *.bedGraph
do
        output=${file%.bedgraph}.tdf
        bash $IGV/igvtools toTDF "$file" "$output" "$genome"
done
