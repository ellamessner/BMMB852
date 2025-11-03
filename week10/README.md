# Week 10 - Variant calling

## Makefile summary
My makefile contains the following code:\
**help:** explains usage\
**genome:** downloads and indexes a reference genome from NCBI and downloads the gff file\
**reads:** downloads reads from SRA and generates read statistics\
**qc:** trims reads and generates a fastqc report both before and after trimming\
**align:** aligns trimmed reads to the reference genome\
**stats:** generates simple alignment statistics and generates a wiggle file\
**variants:** calls variants using bcftools


## Design file summary
The design file contains the following columns:
- **srr**: the SRA run ID for each sample
- **sampleid**: an identification number for each library prep, assigned by authors of Gire et al
- **paired**: whether the reads are paired-end (true) or single-end (false)

My default design file contains ten samples from PRJNA257197, which is the bioproject from Gire et al and used Illumina sequencing (paired-end) and two samples from PRJNA393748 which used ion torrent sequencing (single-end).

Since some samples were sequenced multiple times, I used library prep IDs rather than original sample IDs to avoid duplicate file names. Each library prep ID begins with the original sample ID. (ex. EM096_r1.ADXX and EM096.FCH9 are two different runs from EM096)

## Code to run pipeline

Download and index the reference genome
```bash
make genome GENOME=AF086833
```

To run the pipeline for a single sample, the following code can be used:
```bash
make reads qc align stats variants SRR=SRR1553422 SAMPLEID=EM104.FCH9 \
GENOME=AF086833 PAIRED=true NREADS=10000
```

The reads can be downloaded, trimmed, aligned, and variants called in parallel using the following code:
```bash
cat design.csv |\
parallel -j 6 --eta --lb --colsep , --header : \
make reads qc align stats variants SRR={srr} SAMPLEID={sampleid} \
GENOME=AF086833 PAIRED={paired} NREADS=10000
```
This results in the following output:
- **genome**:
  - indexed reference genome
  - gff file for the reference genome
- **reads**:
  - fastq files for each sample both before and after trimming
- **reports**:
  - fastqc reports for each sample both before and after trimming
  - alignment statistics for all samples in a single text file
- **alignments**:
  - sorted and indexed bam file for each sample
  - wiggle file for each sample for visualization

- **variants**:
  - vcf file for each sample containing called variants

## Merge vcf files
```bash
bcftools merge -O z variants/*.vcf.gz > variants/all_variants.vcf.gz
```

## Notes from variant calling
-shows two variants (SNPs but whatever he likes to call them instead) for which all samples differ from the reference genome and one variant for which only some samples differ from the reference genome.

![alt text](<Screenshot 2025-11-02 at 7.38.54 PM.png>)