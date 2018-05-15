# From RNA-seq raw data to analysis DE gene.

### Mapping to contaminate genomic and got the unmapped.bam files

<pre> tophat -r 200 -o $LIBRARY/top_hat $GENOME $LIBRARY/Filter/$LIBRARY\_trim_R1.fastq $LIBRARY/Filter/$LIBRARY\_trim_R2.fastq </pre>


### sorted and transfer unmapped files to fq file type
<pre> 
source samtools-0.1.19
samtools sort $LIBRARY/top_hat/unmapped.bam $LIBRARY/BAM_files/unmapped_sorted.bam
source bedtools-2.27.1
bedtools bamtofastq -i $LIBRARY/BAM_files2/unmapped_sorted.bam -fq $LIBRARY/$LIBRARY\_unmmap.fq </pre>

### Conver fa to fa
<pre> awk 'NR % 4 == 1 {print ">" $0 } NR % 4 == 2 {print $0}' unmapped.fq > unmapped.fa </pre>

### Run blastn get the best hit

<pre> blastn -perc_identity 100 -db nr -query unmapped.fa -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle' -remote -out blast_besthit.	out -max_target_seqs 1 </pre>

### Get only species names in output

<pre> sed 's/PREDICTED://g' blast_besthit.out > blast_unmapped.	out
awk '{print $10, $11}' blast_unmapped.out > 	blast_unmapped_only_names.out
sed 's/ /_/g' blast_unmapped_only_names.out > 	blast_unmapped_only_names_.txt </pre>

###Plot bar chart in R using blast_output_barchart.R

###Get gene description for a particular subgroup (Theileria genre)

<pre> grep "Theileria" blast_besthit.out | awk '{print $10, $11, $12, $13, $14, $15, $16}' - > Theileria_unmapped.out </pre>

###Get file with counts using R

<pre>data <- read.table("Theileria_unmapped.out")
counts <- table(data)
t<- data.frame(table(data))
order <- t[order(t$Freq),] 
df2 <- data.frame(order$data, order$Freq)
write.csv(df2, "blast.csv", quote=FALSE)</pre>

### Run  <a href=https://github.com/kaizohio/RNA-seq/blob/master/count_unmapped.rb > count_unmapped.rb <a/>to get a final csv file with counts for the unmapped genes in several samples
