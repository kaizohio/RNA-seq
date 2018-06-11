#!/bin/bash 
#SBATCH --mem=1G

while read line; do

    grep -i -e $line GCF_000240135.3_ASM24013v3_protein.fasta

done <list2.txt