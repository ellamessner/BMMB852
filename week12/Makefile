# Reference genome URL
REF_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz

#Reference genome file name
REF_FULL=refs/GRCh38.fasta

#Chromosome to download
CHR=chr18

#Reference genome for specific chromosome
REF_SUB=refs/${CHR}.fasta

#Gene of interest
GENE=SMAD4

#Treatment, N for normal, T for tumor
TREATMENT=T

#VCF file name
VCF=vcf/${CHR}.vcf.gz

#BAM file URL
BAM_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-N-D_Element-StdInsert_77x_GRCh38-GIABv3.bam

#BAM file name
BAM=bam/${GENE}_${TREATMENT}.bam

#region of interest
REGION=chr18:51,028,528-51,085,045

#VCF file name
VCF=vcf/${GENE}.vcf.gz

.PHONY: ref bam variants

#Download reference genome and extract chromosome of interest
ref:
	#make directory for reference genome
	mkdir -p $(dir ${REF_FULL})
	#download reference genome
	curl -L ${REF_URL} > ${REF_FULL}.gz
	#unzip reference genome
	gunzip ${REF_FULL}.gz
	#extract specific chromosome
	samtools faidx ${REF_FULL} ${CHR} > ${REF_SUB}
	#index the reference genome
	samtools faidx ${REF_SUB}

#Download BAM file and extract reads for region of interest
bam:
	#make directory for bam files
	mkdir -p $(dir ${BAM})
	#extract reads for region of interest
	samtools view -b ${BAM_URL} ${REGION} > ${BAM}
	#index bam file
	samtools index ${BAM}
	#generate alignment statistics
	samtools flagstat ${BAM}

#Call variants
variants:
	#make directory for vcf files
	mkdir -p $(dir ${VCF})

	# Call variants using bcftools
	bcftools mpileup ${F1} -O u -f ${REF} ${BAM} | \
	bcftools call ${F2} -mv -O u | \
	bcftools norm -f ${REF} -d all -O u | \
	bcftools sort -O z > ${VCF}

	#index the vcf file
	bcftools index ${VCF}

#Merge VCF files from all samples
merge:
	bcftools merge -O z $(dir ${VCF})*vcf.gz > $(dir ${VCF})all_variants.vcf.gz

index_gff:
	#sort and compress GFF file
	cat ${GFF} | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | awk 'NF' | bgzip -c > ${GFF}.gz
	#Index the GFF file
	tabix -p gff ${GFF}.gz

vep:
	#make directory for annotation output
	mkdir -p $(dir ${ANN})
	#Run VEP
	micromamba run -n vep \
		${VEP_DIR} \
		-i ${VCF} \
		-o ${ANN} \
		--gff ${GFF}.gz \
		--fasta ${REF} \
		--force_overwrite
