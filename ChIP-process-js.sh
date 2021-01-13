#/bin/bash

#SBATCH --job_name=ChIP-process
#SBATCH --account=fc_nanosir
#SBATCH --partition=savio
#SBATCH --output=ChIP-process.out
#SBATCH --error=ChIP-process.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=molly_brothers@berkeley.edu
#SBATCH --time=10:00:00

#running this program requires that a directory containing your fastq files is the
#daughter of a directory you want all your other files to end up in

#load required software
module load samtools
module load bowtie2
module load java

code_directory= "/global/home/users/molly_brothers/illumina_processing" #directory containing the scripts below
fastq_directory= "/global/scratch/molly_brothers/illumina/210111_Resolution" #directory containing fastq files
genome= "/global/scratch/molly_brothers/genomes/genome_mat_to_N" #file with genome to align to, no file extension
fragment_size_min=100 #minimum fragment size to consider
fragment_size_max=1000 #maximum fragment size to consider
threads=$SLURM_CPUS_ON_NODE
igv_directory= "/global/home/users/molly_brothers/IGV_2.8.13"

cd $fastq_directory

#step 1: align reads to genome using bowtie2. This will convert fastq files into sam files.
bash $code_directory/malign_parallel.sh $fastq_directory $genome $threads

#step 2: move new sam files into their own directory in parent of fastq_files directory
mkdir ../sam_files
mv $fastq_directory/*sam ../sam_files

#step 3: convert sam files into bedgraph files
#Input directs the shell to directory containing bam files
bash $code_directory/mcoverage_parallel.sh $code_directory ../sam_files $fragment_size_min $fragment_size_max

#step 4: move begraph files into their own directory in a parent of fastq_files directory
mkdir ../bedgraph_files
mv ../sam_files/*bedgraph ../bedgraph_files

#step 5: normalize bedgraph files to genome-wide median
bash $code_directory/mnormalize_parallel.sh $code_directory ../bedgraph_files

#step 6: convert bedgraph to tdf using igvtools toTDF. This file is now readable by IGV genome browser.
bash $code_directory/mtoTDF_parallel.sh $igv_directory ../bedgraph_files "$genome".genome
