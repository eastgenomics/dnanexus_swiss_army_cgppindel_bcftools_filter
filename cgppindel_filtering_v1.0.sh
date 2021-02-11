#!/bin/bash

# Filter cgpPindel VCF files
# Started: CC11Feb2021

# Description: Filters cgpPindel output vcfs using bcftools (v1.11) within the Swiss Army Knife app (v4.0.1) on DNAnexus
# Requires bed file input and vcf
# Outputs filtered VCF file keeping indels with length > 2 bp

# Reference(s): 
# https://platform.dnanexus.com/app/swiss-army-knife
# https://github.com/samtools/bcftools 

# Start message
echo "Filter cgpPindel VCF file"
date
echo ""

#get BED file
bed_file=*.bed 
echo $bed_file

#process vcf file 
for vcf in *.vcf.gz; do
    vcf_filename="$(echo $vcf | cut -d '.' -f1)"
    echo $vcf_filename
    # Keep only indels that intersect with the exons of interest present in the bed file 
    bcftools view -R $bed_file $vcf > $vcf_filename.temp1.vcf
    echo "creating restricted vcf"
    # Keep only indels with length creater than 2, this will remove the number 1 bp false positives insertions
    bcftools view -i 'INFO/LEN > 2' $vcf_filename.temp1.vcf > $vcf_filename.filtered.vcf
    echo "VCF with INDELS with length greater than 2 bp"
    #bgzip and create an index file for vcf
    bgzip $vcf_filename.filtered.vcf
    echo "creating index for vcf"
    tabix -f -p vcf $vcf_filename.filtered.vcf.gz
    #Remove all *temp* files
    rm *temp*
done
