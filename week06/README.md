
# Assignment 6 - Ebolavirus reads

My makefile contains the following targets:\
-genome: downloads a reference genome from NCBI.\
-index: indexes the reference genome\
-simulate: creates simulated reads using ART\
-reads: downloads reads from SRA and generates read statistics\
-qc: trims reads and generates a fastqc report before and after trimming\
-align: aligns trimmed reads to the reference genome\
-stats: generates alignment statistics

## Testing pipeline using simulated reads
I set the following variables in the makefile in order to create 100-base simulated reads with 1x coverage for the ebolavirus reference genome AF086833:

```
READSDIR=reads
GENDIR=genome
ALDIR=alignments
QC=qc_reports
R1=${READSDIR}/${READID}_1.fq
R2=${READSDIR}/${READID}_2.fq
TRIM1=${READSDIR}/${READID}_1.trimmed.fq
TRIM2=${READSDIR}/${READID}_2.trimmed.fq
REF=${GENOME}.fasta
BAM=${ALDIR}/${READID}.bam
READID="art_reads"
GENOME=AF086833.2
NREADS=9500
ADAPTER="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
DEPTH=1
L=100
PREFIX=reads/art_reads_
MODEL=HS25
```
To download the reference genome and generate simulated reads, I ran the following:
```
make genome index simulate qc
```

The basic statistics of the reads after qc, shown below, indicate that no filtering or trimming needed to occur, as expected.
```
file                          format  type  num_seqs  sum_len  min_len  avg_len  max_len
reads/art_reads_1.trimmed.fq  FASTQ   DNA         95    9,500      100      100      100
reads/art_reads_2.trimmed.fq  FASTQ   DNA         95    9,500      100      100      100
```

I then aligned the simulated reads to the genome:
```
make align stats
```

**output:**
```
190 + 0 in total (QC-passed reads + QC-failed reads)
190 + 0 primary
0 + 0 secondary
0 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
190 + 0 mapped (100.00% : N/A)
190 + 0 primary mapped (100.00% : N/A)
190 + 0 paired in sequencing
95 + 0 read1
95 + 0 read2
190 + 0 properly paired (100.00% : N/A)
190 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

100% of reads were properly paired and mapped to the genome.The alignment is visualized below.

![alt text](simulated.png)

# Aligning reads from SRA to a reference genome
All variables remained the same as , except for the following:
```
SRR=SRR1972958
```

Running all targets except for simulate results in the following alignment statistics:
```
13710 + 0 in total (QC-passed reads + QC-failed reads)
13694 + 0 primary
0 + 0 secondary
16 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
540 + 0 mapped (3.94% : N/A)
524 + 0 primary mapped (3.83% : N/A)
13694 + 0 paired in sequencing
6847 + 0 read1
6847 + 0 read2
452 + 0 properly paired (3.30% : N/A)
458 + 0 with itself and mate mapped
66 + 0 singletons (0.48% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

Only 3.94% of reads mapped to the genome. The expected coverage was 10x, but after trimming, the average read length was 83.65. 540 reads were mapped to the reference genome, which is 18959 bases long, so 540 * 83.65/18959 = 2.38x coverage. 

The coverage is very inconsistent across the genome, ranging from 0 to 83x. The end of the genome has the greatest coverage, as visualized below.

![alt text](srr.png)