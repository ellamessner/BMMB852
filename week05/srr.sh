#set error handling
set -eux pipefail

#SRR ID for sample from paper
SRR="SRR1972953"

#SRR ID for genome sequenced with oxford nanopore
OXNAN="ERR1014225"

#directory for reads
READS=reads

#directory for qc reports
QC=qc_reports

#output read file names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

#trimmed read file names
TRIM1=reads/${SRR}_1.trimmed.fastq
TRIM2=reads/${SRR}_2.trimmed.fastq

#adapter sequence
ADAPTER="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"

#----------------No changes below line-------------------------------------------------

#get metadata for SRR
bio search ${SRR}

#make directory for reads
mkdir -p ${READS}

#make directory for qc reports
mkdir -p ${QC}

#download subset of reads and rename the output files
fastq-dump -X 9500 -F --outdir ${READS} --split-files ${SRR}

#generate sequence stats
seqkit stats reads/${SRR}*.fastq

#run quality check
fastqc reads/${SRR}*.fastq --outdir ${QC}

#trim reads
fastp --adapter_sequence=${ADAPTER} --cut_tail -i ${R1} -I ${R2} -o ${TRIM1} -O ${TRIM2}

#run fastqc on trimmed reads
fastqc ${TRIM1} ${TRIM2} --outdir ${QC}

#download subset of oxford nanopore reads
fastq-dump -X 1000 -F --outdir reads ${OXNAN}

#generate sequence stats
seqkit stats reads/${OXNAN}*.fastq

fastqc reads/${OXNAN}*.fastq --outdir ${QC}
