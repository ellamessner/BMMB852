# Week 12 Assignment - Cancer Genome in a Bottle

For this assignment, I compared variants called in the gene SMAD4 from normal and tumor cells. SMAD4 is a tumor suppressor gene that is inactivated in about 55% of pancreatic cancers (Tascilar et al, 2001).

## Download the reference genome and extract SMAD4's chromosome
```bash
make ref REF_FULL=refs/GRCh38.fasta CHR=chr18 REF_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz
```
## Download the BAM file for a normal sample
The code below downloads the BAM file for the sample HG008-N-D, with reads generated using AVITI whole genome sequencing.

```bash
make bam GENE=SMAD4 TREATMENT=N REGION=chr18:51,028,528-51,085,045 BAM_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-N-D_Element-StdInsert_77x_GRCh38-GIABv3.bam
```

## Download the BAM file for a tumor sample
The code below downloads the BAM file for the sample HG008-T, with reads generated using AVITI whole genome sequencing.

```bash
make bam GENE=SMAD4 TREATMEN=T REGION=chr18:51,028,528-51,085,045 BAM_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-T_Element-StdInsert_111x_GRCh38-GIABv3.bam

```
## Call variants using bcftools
```bash
make variants GENE=SMAD4 TREATMENT=N
make variants GENE=SMAD4 TREATMENT=T
```


Tascilar, Metin, Halcyon G. Skinner, Christophe Rosty, et al. “The SMAD4 Protein and Prognosis of Pancreatic Ductal Adenocarcinoma.” Clinical Cancer Research 7, no. 12 (2001): 4115–21.
