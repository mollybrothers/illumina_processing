#!/bin/bash

#############################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
#############################

#converts all bedgraph files in a directory into tdf files viewable by IGV
#Assumes that all begdraph files are in the same folder and all end with ".bedgraph"

#Change directory to that provided as argument

cd "$2"
genome="$3"

#Iterates through all bedgraph files in folder
for file in *.bedgraph
do
        output=${file%.bedgraph}.tdf
        bash $1/igvtools toTDF "$file" "$output" "$genome"
done
