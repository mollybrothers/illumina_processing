import sys
import os
import string

#This program normalizes a bedgraph to the genome-wide median excluding heterochromatin (subtelomeres and chrIII)
#It assumes that your bedgraph file includes the bases with 0 coverage
#It takes x.bedgraph as an argument from the command line and generates a file called x_normalized.bedgraph.
#Bedgraphs should be passed as absolute paths to ensure that the normalized bedgraph is saved in the same folder as the original.

chromosome_lengths = {"I":230218,"II":813184,"III":316620,"IV":1531933,"V":576874,"VI":270161,"VII":1090940,"VIII":562643,"IX":439888,
"X":745751,"XI":666816,"XII":1078177,"XIII":924431,"XIV":784333,"XV":1091291,"XVI":948066}

def get_median(file_in_string):
        file_in = open(file_in_string, "r")
        total_bases = 12071326 - 316620 - (20000 * 2 * 15)
        #total_bases = total chromosomal genome size - chrIII size - subtelomeres on all non-chrIII chromosomes
        file_in.readline()
        lines = file_in.readlines()
        list_of_coverages=[]

        for line in lines:
                chrom = line.split()[0]
                base = int(line.split()[1])
                coverage = float(line.split()[3])
                if not(chrom == "III") and not(chrom == "MT") and base > 20000 and base < chromosome_lengths[chrom]-20000:
                        list_of_coverages.append(coverage)
        list_of_coverages.sort()
        median =list_of_coverages[len(list_of_coverages)/2]
        return median

def write_norm(file_in_string, file_out_string, median):
	file_in = open(file_in_string, "r")
	file_out = open(file_out_string, "w")
	
	#Keeps first line of input bedgraph file
	file_out.write(file_in.readline()+ "\n")
	file_out.write("#" + "Median" + "Genome coverage:" + str(median) + "\n")
	lines = file_in.readlines()
	for line in lines:
		line_out_median=float(line.split()[3])/median
		line_out=line.split()[0] + "\t" + line.split()[1] + "\t" + line.split()[2] + "\t" + str(line_out_median) + "\n"
		file_out.write(line_out)
	file_out.close()
	file_in.close()

#len counts the number of arguments here
#creates a list between 1 and the number of files
for i in range(1,len(sys.argv)):
	file_in_string = sys.argv[i]
	file_out_string = sys.argv[i].split(".bedgraph")[0] + "_median_normalized.bedgraph"
	median = get_median(file_in_string)
	write_norm(file_in_string, file_out_string, median)
	print sys.argv[i] + " done"
