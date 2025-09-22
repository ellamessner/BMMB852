Download fasta and gff for KJ660346, the genome an ebolavirus sample from Guinea in 2024. In the paper, all other genomes are compared to this one to identify mutations.

``` bash
#download fasta
efetch -db nuccore -format fasta -id KJ660346 > guinea.fa

#download gff
efetch -db nuccore -format gff3 -id KJ660346 > guinea.gff
```
Determine sequence length
``` bash
seqkit stats guinea.fa
```
output:
```
file       format  type  num_seqs  sum_len  min_len  avg_len  max_len
guinea.fa  FASTA   DNA          1   18,959   18,959   18,959   18,959
```

Determine features 
``` bash
cat guinea.gff | grep -v '#' | cut -f 3 | sort-uniq-count-rank
```
output:
```
16	region
11	CDS
7	exon
7	gene
7	mRNA
2	long_terminal_repeat
2	primer_binding_site
1	sequence_feature
```

The longest gene in the genome is called L and it is an RNA-dependent RNA polymerase, meaning that it synthesizes RNA using and RNA template (Volchkov et al., 1999).

An additional gene is GP, which encodes ebolavirus glycoprotein. GP is located on the surface of the virion and binds host cell receptors, mediating entry into host cells (Palleson et al., 2017). Due to its importance to infection, GP has been studied extensively and is used in ebola vaccines (Hoenen et al., 2010).

This genome is short and compact, with minimal intergenomic space. Approximately 75% of the genome is protein-coding.

## References ##
