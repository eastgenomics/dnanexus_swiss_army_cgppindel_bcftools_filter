#!/bin/bash

# Filter cgpPindel VCF files
# Started: CC11Feb2021

# Description: Filters cgpPindel output vcfs using bcftools (v1.11) within the Swiss Army Knife app (v4.0.1) on DNAnexus
# Inputs: .bed file defining target regions and .vcf.gz file(s) containing variants to filter
# Outputs: filtered .vcf.gz file and associated .tbi file

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
    vcf_basename="$(echo $vcf | cut -d '.' -f1)"
    echo $vcf_basename
    # Keep only indels that intersect with the exons of interest bed file 
    echo "Creating restricted vcf"
    bcftools view -R $bed_file $vcf > $vcf_basename.temp1.vcf
    # Keep only insertions with length greater than 2. This will remove the 1 bp false positive insertions
    echo "Creating VCF with insertions with length greater than 2 bp"
    bcftools view -i 'INFO/LEN > 2' $vcf_basename.temp1.vcf > $vcf_basename.filtered.vcf
    #bgzip and create an index file for filtered vcf
    bgzip $vcf_basename.filtered.vcf
    echo "creating index for filtered vcf"
    tabix -f -p vcf $vcf_basename.filtered.vcf.gz
done

# Remove temp and input vcfs to avoid including in output
echo "Removing temp and input vcf files"
rm *temp*
rm *pindel*
