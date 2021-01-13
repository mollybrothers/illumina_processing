#!/bin/bash

#SBATCH --job-name=ChIP-process
#SBATCH --account=fc_nanosir
#SBATCH --partition=savio
#SBATCH --output=ChIP-process.out
#SBATCH --error=ChIP-process.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=molly_brothers@berkeley.edu
#SBATCH --time=10:00:00

##running this program requires that a your fastq.gz files are in a directory called "fastq_files" in your specified "data_directory" directory below
##at the end, you'll have a normalized bedGraph file. I can't get igvtools to work on Savio, so you'll
##have to convert to tdf files on your own computer for now.


##load required software
module load samtools
module load bowtie2
module load gnu-parallel

code_directory="/global/home/users/molly_brothers/illumina_processing"
data_directory="/global/scratch/molly_brothers/illumina/210111_Resolution"
genome="/global/scratch/molly_brothers/genomes/genome_mat_to_N"
fragment_size_min=100
fragment_size_max=1000
threads=$SLURM_CPUS_ON_NODE

##step 1: align reads to genome using bowtie2. This will convert fastq files into sam files.
bash $code_directory/malign_parallel.sh $data_directory/fastq_files $genome $threads

##step 2: move new sam files into their own directory in parent of fastq_files directory
mkdir $data_directory/sam_files
mv $data_directory/fastq_files/*sam $data_directory/sam_files

##step 3: convert sam files into bedgraph files
##Input directs the shell to directory containing bam files
ls $data_directory/sam_files/*.sam | parallel -u -I{} python $code_directory/mcoverage.py {} {.}.bedGraph $fragment_size_min $fragment_size_max

##step 4: move begraph files into their own directory in a parent of fastq_files directory
mkdir $data_directory/bedGraph_files
mv $data_directory/sam_files/*bedGraph ../bedGraph_files

##step 5: normalize bedgraph files to genome-wide median
ls $data_directory/bedGraph_files/*.bedGraph | parallel -u -I{} python $code_directory/mnormalize_median.py {}
