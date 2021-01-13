#############################
#INCOMPLETE AND UNTESTED
############################

#Example call: bash home/mbrothers/code/mbedgraphs_parallel.sh /path/to/bam_files

#Assumes that all sorted bam files are in the same folder and end with sorted.bam

#Change directory to that provided as argument
cd $1

#Iterates through all sam files in folder
for file in *sorted.bam
do
	input=$file
	output=${file%-sorted.bam}.bedgraph
	#bedtools genomecov -ibam "$input" -bga >> "$output"

#options wanted:
# -ibam to tell genomecov that the input is a bam file
# -bga outputs into a bedgraph file and includes everything including 0 coverage
# potentially -fs if I want a particular fragment size
# -pc calculates paired-end coverage, fills in gaps between paired-end reads but
# the version of bedtools we have right now doesn't have this option...
done

