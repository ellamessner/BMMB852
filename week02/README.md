# Week 2 Assignment

## Download gff file for *Takifugu rubripes* ##
wget https://ftp.ensembl.org/pub/current_gff3/takifugu_rubripes/Takifugu_rubripes.fTakRub1.2.115.abinitio.gff3.gz
gunzip Takifugu_rubripes.fTakRub1.2.115.gff3.gz

## 1. Tell us a bit about the organism ##
____fdksaof jkdsa jfkdasl jfkdsaljf 

## 2. How many sequence regions (chromosomes) does the file contain? Does that match with the expectation for this organism? ##
This assembly contains both full, named chromosomes that are identified by only a number and unplaced scaffolds with IDs in the form CAAJGN020000001.1
### Count unplaced scaffolds ###
```
cat Takifugu_rubripes.fTakRub1.2.115.gff3 | grep sequence-region | grep CAAJ | wc -l
```
There are 105 unplaced scaffolds

### Count chromosomes ###
```
cat Takifugu_rubripes.fTakRub1.2.115.gff3 | grep sequence-region | grep -v 'CAAJ' | wc -l
```
There are 22 chromosomes. This is the expected number of chromosomes.

## 3. How many features does the file contain? ##

```
#remove lines with comments
cat Takifugu_rubripes.fTakRub1.2.115.gff3 | grep -v '#' > takifugu_cleaned

# count features
cat takifugu_cleaned | wc -l
```
The file contains 1521820 features

## 4. How many genes are listed for this organism? ##
```
#count lines that contain the word "gene" surrounded by tabs to avoid counting other features that contain the word gene
cat takifugu_cleaned | grep '\tgene\t' | wc -l
```
There are 21411 genes

## 5. Is there a feature type that you may have not heard about before? What is the feature and how is it defined? ##
```
#list feature types
cat takifugu_cleaned | cut -f 3 | sort-uniq-count

#output
	43238	biological_region
	645647	CDS
	684302	exon
	37603	five_prime_UTR
	21411	gene
	1	J_gene_segment
	1690	lnc_RNA
	152	miRNA
	52215	mRNA
	2179	ncRNA_gene
	816	pseudogene
	816	pseudogenic_transcript
	127	region
	255	rRNA
	4	scRNA
	163	snoRNA
	410	snRNA
	30757	three_prime_UTR
	6	transcript
	27	V_gene_segment
	1	Y_RNA
```
I am unfamiliar with _______. It is ______.

## 6. What are the top-ten most annotated feature types (column 3) across the genome? ##
```
cat takifugu_cleaned | cut -f 3 | sort-uniq-count-rank | head -10

#output
	684302	exon
	645647	CDS
	52215	mRNA
	43238	biological_region
	37603	five_prime_UTR
	30757	three_prime_UTR
	21411	gene
	2179	ncRNA_gene
	1690	lnc_RNA
	816	pseudogene
```
