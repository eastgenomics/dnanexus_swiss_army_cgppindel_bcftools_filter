# dnanexus_swiss_army_cgppindel_bcftools_filter
This repository contains the commands executed by the swiss army knife app (v4.0.1) to filter the cgpPindel output VCF files 

## Input
The input files for this app includes a bash script(cgppindel_filtering_v*.sh) and vcf.gz files produced by cgpPindel.

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

## How the app works
- keeps indels only in exons of interest (bcftools view -i)
- keeps INDELS only if the length is larger than 2bp (bcftools view -i 'INFO/SVLEN > 2')
- creates a gz and index for filtered VCF (bgzip and tabix)

## Output
Filtered VCFs have a suffix of filtered.vcf.gz. The final filtered VCF is a compressed vcf (.vcf.gz).
