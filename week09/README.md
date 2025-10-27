# Week 9 - Automated alignment pipeline revised

## Makefile summary
My makefile contains the following code:\
**help:** explains usage\
**genome:** downloads and indexes a reference genome from NCBI and downloads the gff file\
**reads:** downloads reads from SRA and generates read statistics\
**qc:** trims reads and generates a fastqc report both before and after trimming\
**align:** aligns trimmed reads to the reference genome\
**stats:** generates simple alignment statistics and generates a wiggle file

## Design file summary
The design file contains the following columns:
- **srr**: the SRA run ID for each sample
- **sampleid**: an identification number for each library prep, assigned by authors of Gire et al

My default design file contains ten samples from PRJNA257197, which is the bioproject from Gire et al and used Illumina sequencing (paired-end) and two samples from PRJNA393748 which used ion torrent sequencing (single-end).

Since some samples were sequenced multiple times, I used library prep IDs rather than original sample IDs to avoid duplicate file names. Each library prep ID begins with the original sample ID. (ex. EM096_r1.ADXX and EM096.FCH9 are two different runs from EM096)

## Code to run pipeline

Download and index the reference genome
```bash
make genome GENOME=AF086833
```

The reads can be downloaded, trimmed, and aligned in parallel using the following code:
```bash
cat design.csv |\
parallel -j 6 --colsep , --header : \
make reads qc align stats SRR={srr} SAMPLEID={sampleid} \
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

## Interesting notes from aligning reads
- Alignment rates differ dramatically between samples, ranging from 0% to >99%.
- Regions between genes tend to have lower coverage than genic regions. As visualized below, most samples have dips in coverage around 3kb, 4.5kb, and 11kb, corresponding to the small intergenic regions.


![alt text](igv-1.png)