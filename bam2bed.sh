#!/bin/bash

#to access conda within script
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh

#arguments
bamfile=$1
output_dir=$2

echo "The BAM file to be converted to BED is: $bamfile"
echo "The output directory is: $output_dir"

#create output directory
mkdir -p "$output_dir"

#create and activate conda environment
conda create -n bam2bed -c conda-forge bedtools -y
conda activate bam2bed

#creating variables to store files
base_name=$(basename "$bamfile" .bam)
bed_file="$output_dir/${base_name}.bed"
chr1_bed_file="$output_dir/${base_name}_chr1.bed"
number_of_lines_file="$output_dir/bam2bed_number_of_rows.txt"

echo "$base_name"
echo "$bed_file"
echo "$chr1_bed_file"
echo "$number_of_lines_file"

#converting BAM file to BED file
bedtools bamtobed -i "$bamfile" > "$bed_file"

echo "The file is converted to BED file and is stored in $output_dir"

#filter BED file for chromosome 1
grep -P "^Chr?1[[:space:]]" "$bed_file" > "$chr1_bed_file"

#count number of lines of filtered BED file
wc -l "$chr1_bed_file" > "$number_of_lines_file"

echo "Number of rows in the filtered BED file is: $(cat "$number_of_lines_file")"

echo "Kim Bosman"
