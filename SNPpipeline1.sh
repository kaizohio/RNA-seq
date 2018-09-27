#!/bin/bash
#SBATCH -J alignment
#SBATCH --mem=50G

#Usage: bash SNPpipeline.sh LIB100
#you need to be in the parental folder that contains the folder with the data to be analysed. For example, if the data is called 'LIB100' and is found within 'Dir/RNAseq' folder (~HOME/Dir/RNAseq/LIB100), the starting folder should be RNAseq.
#The folder with the data should contain the raw reads (paired end) with R1.fastq AND R2.fastq suffix (Example: LIB100/Data_R1.fastq; LIB100/Data_R2.fastq) 
 

LENGTH_READS=150 #Default value for the length of the reads.

while [[ $# -gt 1 ]]
do
	key="$1"
	
	case $key in
	    -n|--NameofLibrary) #Name of the directory, for example: LIBOakley
	    LIBRARY="$2"
	    shift # past argument
	    ;;
	    -g|--genome) #Give the directory where the indexed reference genome is.
	    GENOME="$2"
	    shift # past argument
	    ;;
	    -l|--LengthofReads) #Give the length of the reads. This is 101 by default.
	    LENGTH_READS="$2" 
	    shift # past argument
	    ;;
	    *) echo "Usage: SNPpipeline.sh -n LIBname -g Path/to/Genome -l length_reads. Unkown option: $1 " >&2 ; exit 1
	            # unknown option
	    ;;
	esac
	shift # past argument or value
done

if [ -z $LIBRARY ]; then  echo "No library directory given! Usage: SNPpipeline.sh -n LIBname -g Path/to/Genome -l length_reads"; exit 1; fi
if [ -z $GENOME ]; then   echo "No reference genome given! Usage: SNPpipeline.sh -n LIBname -g Path/to/Genome -l length_reads"; exit 1 ; fi

echo LIBRARY  = "${LIBRARY}"
echo GENOME   = "${GENOME}"
echo LENGTH OF READS  = "${LENGTH_READS}"


#First step will be identify the raw reads accordingly. Change this to match the name of your data files.

fasR=$(ls $LIBRARY/*_1.fastq)
fasL=$(ls $LIBRARY/*_2.fastq)

if [ ! -f $fasR ] || [ ! -f $fasL ]	#If Reference Genome is not defined, exit.
then
        echo Reads could not be found inside of the given directory: "${LIBRARY}"; exit 1
fi




#Align against the reference genome (previously indexed).

source /tgac/software/testing/bin/tophat-2.0.11
source /tgac/software/testing/bin/bowtie-2.2.1
source /tgac/software/production/bin/samtools-0.1.19; 

tophat -r 200 -o $LIBRARY/top_hat $GENOME $LIBRARY/Filter/$LIBRARY\_trim_R1.fastq $LIBRARY/Filter/$LIBRARY\_trim_R2.fastq
                
#Once the alignment is done, proceed to sort and index the output file (the one that contains the aligned reads)
                
mkdir $LIBRARY/BAM_files
samtools sort $LIBRARY/top_hat/accepted_hits.bam $LIBRARY/BAM_files/accepted_hits_sorted.bam
samtools index $LIBRARY/BAM_files/accepted_hits_sorted.bam.bam

