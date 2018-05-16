### Download Blast database, NCBI update dailly.
#### Download software Blast+ , install properly 

<pre>update_blastdb.pl htgs</pre>

<pre>blastn -perc_identity 100 -db taxdb/htgs -query unmmap1.fa -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle'  -out blast_besthit.out -max_target_seqs 1<pre>
