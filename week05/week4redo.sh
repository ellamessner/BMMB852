#set error handling
set -eux pipefail

#set genome ID
GENOME="KJ660346"


#----------------No changes below line-------------------------------------------------

#download fasta
efetch -db nuccore -format fasta -id ${GENOME} > guinea.fa

#download gff
efetch -db nuccore -format gff3 -id ${GENOME} > guinea.gff

# Determine sequence length
seqkit stats guinea.fa

### Count features
cat guinea.gff | grep -v '#' | cut -f 3 | sort-uniq-count-rank

