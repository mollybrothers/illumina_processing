#!/bin/bash

###########################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
###########################

#feed in all bedgraph files in a directory to normalize them to genome-wide median
#example call /home/mbrothers/code/mnormalize_parallel /path/to/bedgraph/files
#after this is done running, you should have files that end in *normalized.bedgraph

#assumes that all bedgraph files are in a directory and end in ".bedgraph"

#change directory to that provided as argument
cd $2

for file in *.bedgraph
do
	input=$file
	python $1/mnormalize_median.py "$input"
done
