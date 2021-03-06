#!/bin/bash -ve

# request memory for job (default 6G, max 72G)
#$ -l mem=6G
#$ -l rmem=6G
# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
#$ -l h_rt=02:50:00
# -P molecol
# -q molecol.q
#$ -t 1000-16828
#$ -tc 30
#$ -cwd
#$ -V

module load apps/python/conda
module load apps/python/anaconda3-4.2.0
source activate short-variants

taskid=${SGE_TASK_ID}

for site in CZA CZB CZD; do
  # make one file per location; keep only SNPs used in ANG analysis
  # /home/bo1awx/programs/vcftools_0.1.13/bin/vcftools --keep individuals_$site.txt --vcf CZ.raw.vcf$taskid \
  # --positions ANG13b_positions_to_keep.txt --recode --out CZCLI01_$site.filt1-$taskid

  # minor allele freq filter, variant quality filter, keep biallelic SNPs only, remove SNPs where < 150 inds have data
  vcftools --gzvcf filtered/CZCLI01_${site}.HF.INDEL-${taskid}.vcf.gz --maf 0.01 --minQ 20 \
  --min-alleles 2 --max-alleles 2 --max-missing-count 150 --recode --out filtered/CZCLI01_${site}_INDEL.filt2-${taskid}

done

source deactivate
