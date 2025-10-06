
#directory for reads
READSDIR=reads

#directory for genome
GENDIR=genome

#directory for alignment files
ALDIR=alignments

#directory for qc reports
QC=qc_reports

#read file names
R1=${READSDIR}/${READID}_1.fastq
R2=${READSDIR}/${READID}_2.fastq

#trimmed read file names
TRIM1=${READSDIR}/${READID}_1.trimmed.fastq
TRIM2=${READSDIR}/${READID}_2.trimmed.fastq

#reference genome file name
REF=${GENOME}.fasta

#BAM file name
BAM=${ALDIR}/${READID}.bam

#SRR ID or simulated read ID
READID="SRR1972958"

#NCBI genome accession number
GENOME=AF086833.2

#number of reads to download
NREADS=9500

#adapter sequence
ADAPTER="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"

# The number of reads to simulate
DEPTH=1

# Length of simulated reads
L=100

# The prefix for the simulated reads
PREFIX=reads/art_reads_

# Model for ART read simulation
MODEL=HS25

#---------------------no changes needed below this line--------------------------
#set defaults
# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules

#download the reference genome
genome:
#make directory for genome
	mkdir -p ${GENDIR}
#download genome
	efetch -db nuccore -format fasta -id ${GENOME} > ${GENDIR}/${REF}
#show genome stats
	seqkit stats ${GENDIR}/${REF}

#index the reference genome
index:
	bwa index ${GENDIR}/${REF}

#simulate reads from the reference genome
simulate:
#make directory for reads
	mkdir -p ${READSDIR}
#make simulated reads
	art_illumina -ss ${MODEL} -i ${GENDIR}/${REF} \
	-p -l ${L} -f ${DEPTH} \
	-m 200 -s 10 -o ${PREFIX}
#change file extension to fastq
	mv ${PREFIX}1.fq ${PREFIX}1.fastq
	mv ${PREFIX}2.fq ${PREFIX}2.fastq

#download the reads
reads:
#make directory for reads
	mkdir -p ${READSDIR}
#download reads
	fastq-dump -X ${NREADS} -F --outdir ${READSDIR} --split-files ${READID}
#generate read stats
	seqkit stats ${R1} ${R2}

qc:
#make directory for qc reports
	mkdir -p ${QC}
#generate qc reports
	fastqc reads/${READID}*.fastq --outdir ${QC}
#trim reads
	fastp --adapter_sequence=${ADAPTER} --cut_tail -i ${R1} -I ${R2} -o ${TRIM1} -O ${TRIM2}
#generate fastqc report for trimmed reads
	fastqc ${TRIM1} ${TRIM2} --outdir ${QC}
#generate read stats for trimmed reads
	seqkit stats ${TRIM1} ${TRIM2}

#align the reads to the reference genome
align:
#make directory for alignments
	mkdir -p ${ALDIR}
#align reads and convert to sorted BAM
	bwa mem ${GENDIR}/${GENOME}.fasta ${TRIM1} ${TRIM2} | samtools sort > ${BAM}
#index the BAM file
	samtools index ${BAM}

#generate alignment statistics
stats:
	samtools flagstat ${BAM}