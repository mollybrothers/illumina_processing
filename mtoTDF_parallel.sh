#converts all bedgraph files in a directory into tdf files viewable by IGV
#Assumes that all begdraph files are in the same folder and all end with ".bedgraph"

#Change directory to that provided as argument

cd "$1"
genome="$2"

#Iterates through all bedgraph files in folder
for file in *.bedgraph
do
        output=${file%.bedgraph}.tdf
        bash /home/mbrothers/IGVTools_2.4.19/igvtools toTDF "$file" "$output" "$genome"
done
