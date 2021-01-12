#indexes all bam files in a folder
cd "$1"

for file in *sorted.bam
do
        input=$file
        samtools index -@ 16 "$input"
        echo "$file sorted"
done

