#running this program requires that a directory containing your fastq files is the
#daughter of a directory you want all your other files to end up in

if [ ! $# == 4 ] ; then
	echo "Incorrect number of arguments"
	echo "Usage: bash mprocess path/to/fastq path/to/genome minimum-fragment-size maximum-fragment-size"
	exit
fi

fastq_directory=$1 #directory containing fastq files
genome=$2 #file with genome to align to, no file extension
fragment_size_min=$3 #minimum fragment size to consider
fragment_size_max=$4 #maximum fragment size to consider

if [ -a $fastq_directory ] ; then
	echo "$fastq_directory exists"
else
	echo "$fastq_directory does not exist"
	exit
fi

cd $fastq_directory

#step 1: align reads to genome using bowtie2. This will convert fastq files into sam files.
bash /home/mbrothers/code/malign_parallel.sh $fastq_directory $genome

#step 2: move new sam files into their own directory in parent of fastq_files directory
mkdir ../sam_files
mv $fastq_directory/*sam ../sam_files

#step 3: convert sam files into bedgraph files
#Input directs the shell to directory containing bam files
bash /home/mbrothers/code/mcoverage_parallel.sh ../sam_files $fragment_size_min $fragment_size_max

#step 4: move begraph files into their own directory in a parent of fastq_files directory
mkdir ../bedgraph_files
mv ../sam_files/*bedgraph ../bedgraph_files

#step 5: normalize bedgraph files to genome-wide median
bash /home/mbrothers/code/mnormalize_parallel.sh ../bedgraph_files

#step 6: convert bedgraph to tdf using igvtools toTDF. This file is now readable by IGV genome browser.
bash /home/mbrothers/code/mtoTDF_parallel.sh ../bedgraph_files "$genome".genome
