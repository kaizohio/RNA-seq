### Download Blast database, NCBI update dailly.
#### Download software Blast+ , install properly 

<pre> update_blastdb.pl htgs
(for f in *.tar.gz; do tar zxvf $f; done)</pre>
#### Unzip downloaded database
<pre> tar zxvf htgs.00.tar.gz</pre>
<pre>blastn -perc_identity 100 -db taxdb/htgs -query unmmap1.fa -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle'  -out blast_besthit.out -max_target_seqs 1<pre>


###########################################################################################################################
tblastn -query cut.fasta -subject  Ensembl_database/Fusarium_graminearum.RR1.cdna.all.fa -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle' -out blast_besthit.out -max_target_seqs 1
###########################################################################################################################


# blastn -db nt -query rb.fasta -out results.out -remote -num_alignments 1 -num_descriptions 1

#  blastn -perc_identity 100 -db nr -query test.fasta -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle' -remote -out blast_besthit.	out -max_target_seqs 1

#	Download NCBI database 

wget -b "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.??.tar.gz" 

# 	Unzip *.tar.gz

for f in *.tar.gz; do tar zxvf $f; done

# blast locally

blastn -perc_identity 100 -db nt/nt -query test.fasta -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle'  -out blast_besthit.out -max_target_seqs 1


#########
 Trinity
#########

https://github.com/trinityrnaseq/trinityrnaseq/wiki
