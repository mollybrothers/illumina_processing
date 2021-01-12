#!/bin/python3

###########################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
###########################

#This program is used to generate a .bedgraph file of genomic coordinates with the number of times a base is covered in the 4th column
#The input .sam file and output .bedgraph file are provided as command-line arguments
#The program assumes that the only mapping locations are yeast chromosomes, labeled "I", "II", ..., "XIV", "MT"
#Will only work with paired-end reads
#Example call: python mcoverage.py /path/to/sam/file /path/to/bedgraph/file 130 180

import sys

file_in=open(sys.argv[1], 'r')
file_out=open(sys.argv[2], 'w')
min_length=int(sys.argv[3])
max_length=int(sys.argv[4])

lines = file_in.readlines()

chromosome_lengths = {"I":230218,"II":813184,"III":316620,"IV":1531933,"V":576874,"VI":270161,"VII":1090940,"VIII":562643,"IX":439888,
"X":745751,"XI":666816,"XII":1078177,"XIII":924431,"XIV":784333,"XV":1091291,"XVI":948066,"MT":85779}

output_dictionary = {"I":{},"II":{},"III":{},"IV":{},"V":{},"VI":{},"VII":{},"VIII":{},"IX":{},
              "X":{},"XI":{},"XII":{},"XIII":{},"XIV":{},"XV":{},"XVI":{},"MT":{}}

#fill in output_dictionary with a range between 1 and the value in chromosome_length
#starts each value in output_dictionary[chrom] at 0
for chrom in output_dictionary:
	for base in range(1,chromosome_lengths[chrom]+1):
		output_dictionary[chrom][base]=0

#reads in the .sam file one line at a time
for line in lines:
	#Only reads lines after top material (start with @) and whose length is within the range specified above by min_length and max_length
	if not(line.split()[0].startswith("@")) and abs(int(line.split()[8]))>min_length and abs(int(line.split()[8]))<max_length:
		chrom = line.split()[2]
		start = int(line.split()[3])
		mate_start = int(line.split()[7])
		length = abs(int(line.split()[8]))
		end = min(start,mate_start)+length
		#Assumes paired-end reads--finds lower genomic coordinate and sets as starting point
		#for adding 1 to the pileup and adds 1 at each point between the lower genomic coordinate
		#and the lower genomic coordinate + the length of the insert. Only adds 0.5 at each line
		#of the sam file since it will read both mates individually
		for i in range(min(start,mate_start),end):
			output_dictionary[chrom][i]=output_dictionary[chrom][i]+0.5

#The only feature in the output file besides the data is a specification that the type of file is "bedGraph"
file_out.write("type=bedGraph\n")
#Reads each item in the sorted main dictionary (of chromosomes) and then the sorted subdictionary (of coordinates)
for x in sorted(output_dictionary):
    for y in sorted(output_dictionary[x]):
	#creates a tab-delimited line with four columns: chromosome, location, location+1 (i.e. 0-width), and number of times that location is covered
        lineout = x + "\t" + str(y)+ "\t" + str(y+1) + "\t" + str(output_dictionary[x][y]) + "\n"
        file_out.write(lineout)
file_in.close()
file_out.close()
