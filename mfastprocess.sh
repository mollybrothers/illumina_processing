#!/bin/bash

######################
# Author: Molly Brothers
# Github: mollybrothers
# Date: 01/12/2021
######################

#running this program requires that a directory containing your fastq files is the
#daughter of a directory you want all your other files to end up in

#this is a quick and dirty way to analyze ChIP-seq data. It is not normalized and is pretty
#slow in IGV

fastq_directory=$1 #directory containing fastq files
genome=$2 #directory containing genome to align to

cd $fastq_directory

#step 1: align reads to genome using bowtie2. This will convert fastq files into sam files.
bash /global/users/molly_brothers/illumina_processing/malign.sh $fastq_directory $genome

#step 2: move new sam files into their own directory in parent of fastq_files directory
mkdir ../sam_files
mv $fastq_directory/*sam ../sam_files

#step 3: convert sam files to bam files using samtools.
#Input directs the shell to directory containing sam files.
bash /global/users/molly_brothers/illumina_processing/msamtobam_parallel.sh ../sam_files

#step 4: sort bam files using samtools.
#Input directs the shell to directory containing sam files
bash /global/users/molly_brothers/illumina_processing/msortbam_parallel.sh ../sam_files

#move all bam and sorted bam files into a new directory
mkdir ../bam_files
mv ../sam_files/*bam ../bam_files

#Input directs the shell to directory containing bam files
bash /global/users/molly_brothers/illumina_processing/mindexbam_parallel.sh ../bam_files

#files are now ready to view in IGV
