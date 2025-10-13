
#SRR ID or simulated read ID. If using simulated reads, READID should match PREFIX.
READID="SRR1972958"

#NCBI genome accession number
GENOME=AF086833

#paired or single-end reads; set to true for paired-end, false for single-end
PAIRED=true

#directory for qc reports
QC=reports

#read file names
R1=reads/${READID}_1.fastq
R2=reads/${READID}_2.fastq

#trimmed read file names
TRIM1=reads/${READID}_1.trimmed.fastq
TRIM2=reads/${READID}_2.trimmed.fastq

#reference genome file name
REF=genome/${GENOME}.fasta

#GFF file name
GFF=genome/${GENOME}.gff

#BAM file name
BAM=alignments/${READID}.bam

#temporary bedgraph file name
BG=alignments/${READID}.bg

#BW wiggle file name
BW=alignments/${READID}.bw

#number of reads to download
NREADS=9500

#adapter sequence
ADAPTER="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"

# The number of reads to simulate
DEPTH=1

# Length of simulated reads
L=100

# The prefix for the simulated reads
PREFIX=art_reads_

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

help:
	@echo "Makefile for downloading/simulating reads, performing QC, trimming, aligning to a reference genome, and generating alignment statistics."
	@echo ""
	@echo "Variables to set:"
	@echo "  READID      : SRR ID for reads from SRA or PREFIX for simulated reads (default: ${READID})"
	@echo "  GENOME      : NCBI accession number for the reference genome (default: ${GENOME})"
	@echo "  PAIRED      : true for paired-end reads, false for single-end reads (default: ${PAIRED})"
	@echo "  NREADS      : Number of reads to download (default: ${NREADS})"
	@echo "  ADAPTER     : Adapter sequence to trim (default: ${ADAPTER})"
	@echo "  DEPTH       : Depth of coverage for simulated reads (default: ${DEPTH})"
	@echo "  L           : Length of simulated reads (default: ${L})"
	@echo "  PREFIX      : Prefix for simulated read files (default: ${PREFIX})"
	@echo "  MODEL       : ART model for read simulation (default: ${MODEL})"
	@echo ""
	@echo "Targets:"
	@echo "  all         : Run all steps (genome, reads, qc, align, stats)"
	@echo "  genome      : Download and index the reference genome"
	@echo "  simulate    : Simulate reads from the reference genome"
	@echo "  reads       : Download the reads"
	@echo "  qc          : Perform quality control and trimming on the reads"
	@echo "  align       : Align the trimmed reads to the reference genome"
	@echo "  stats       : Generate alignment statistics"

#download and index the reference genome
genome:
	#make directory for genome
	mkdir -p $(dir ${REF})
	#download genome
	efetch -db nuccore -format fasta -id ${GENOME} > ${REF}
	#show genome stats
	seqkit stats ${REF}
	bwa index ${REF}
	#download gff
	efetch -db nuccore -format gff3 -id ${GENOME} > ${GFF}



#simulate reads from the reference genome
simulate:
	#make directory for reads
	mkdir -p $(dir ${R1})
	#make simulated reads
	art_illumina -ss ${MODEL} -i ${GENDIR}/${REF} \
	-p -l ${L} -f ${DEPTH} \
	-m 200 -s 10 -o ${READSDIR}/${PREFIX}
	#change file extension to fastq
	mv ${READSDIR}/${PREFIX}1.fq ${READSDIR}/${PREFIX}1.fastq
	mv ${READSDIR}/${PREFIX}2.fq ${READSDIR}/${PREFIX}2.fastq

#download the reads
reads:
	#make directory for reads
	mkdir -p $(dir ${R1})
	#download reads and split if paired-end
	if [ "${PAIRED}" = true ] ; then \
		fastq-dump -X ${NREADS} -F --outdir $(dir ${R1}) --split-files ${READID} ; \
	else \
		fastq-dump -X ${NREADS} -F --outdir $(dir ${R1}) ${READID} && mv $(dir ${R1})/${READID}.fastq $(dir ${R1})/${READID}_1.fastq
	fi
	#generate read stats
	if [ "${PAIRED}" = true ] ; then \
		seqkit stats ${R1} ${R2} ; \
	else \
		seqkit stats ${R1} ; \
	fi


#perform quality control and trimming on the reads
qc: 
	#make directory for qc reports
	mkdir -p ${QC}
	#generate qc reports
	fastqc reads/${READID}*.fastq --outdir ${QC}
	#trim reads
	if [ "${PAIRED}" = true ] ; then \
		fastp --adapter_sequence=${ADAPTER} --cut_tail -i ${R1} -I ${R2} -o ${TRIM1} -O ${TRIM2} ; \
	else \
		fastp --adapter_sequence=${ADAPTER} --cut_tail -i ${R1} -o ${TRIM1}
	fi
	#generate fastqc report for trimmed reads
	fastqc ${TRIM1} ${TRIM2} --outdir ${QC}
	if [ "${PAIRED}" = true ] ; then \
		fastqc ${TRIM2} --outdir ${QC} ; \
	fi
	#generate read stats for trimmed reads
	seqkit stats ${TRIM1}
	if [ "${PAIRED}" = true ] ; then \
		seqkit stats ${TRIM2} ; \
	fi

#align the reads to the reference genome
align:
	#make directory for alignments
	mkdir -p $(dir ${BAM})
	#align reads and convert to sorted BAM
	if [ "${PAIRED}" = true ] ; then \
		bwa mem ${REF} ${TRIM1} ${TRIM2} | samtools sort > ${BAM} ; \
	else \
		bwa mem ${REF} ${TRIM1} | samtools sort > ${BAM} ; \
	fi
	#index the BAM file
	samtools index ${BAM}

#generate alignment statistics and create wiggle file for visualization
stats:
	#generate basic alignment statistics
	samtools flagstat ${BAM}
	#index the reference genome
	samtools faidx ${REF}
	#generate temporary bedgraph file
	LC_ALL=C; bedtools genomecov -ibam  ${BAM} -split -bg | \
	sort -k1,1 -k2,2n > ${BG}
	#convert bedgraph to bigwig
	bedGraphToBigWig ${BG} ${REF}.fai ${BW}





#all steps
all: genome reads qc align stats